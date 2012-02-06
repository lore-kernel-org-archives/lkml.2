Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab2BFDMa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 22:12:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53938 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab2BFDM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 22:12:28 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=4xDcOe4IjvRdPVVETi+CqA==:17 a=TRgVYD6ZyiEA:10 a=kbqjixIPYdAA:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=Br9LfDWDAAAA:8 a=yQdBAQUQAAAA:8 a=oYVDii8IDF10_8bP_8sA:9 a=1cI3ame_4mkq-Gqf8FUA:7 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=4xDcOe4IjvRdPVVETi+CqA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 75.81.36.228
Date: Sun, 05 Feb 2012 21:12:26 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: r8712u: Use asynchronous firmware loading
Message-ID: <4f2f451a.AnH+RlPPXaDyP8Hn%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In https://bugs.archlinux.org/task/27996, failure of driver r8712u is
reported, with a timeout during module loading due to synchronous loading
of the firmware. The code now uses request_firmware_nowait().

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Greg,

This patch probably should go to stable, but I want you to judge whether
it is too invasive for that.

Thanks,

Larry
---
 drv_types.h   |    7 ++++++
 hal_init.c    |   62 ++++++++++++++++++++++++++++++++++++++++------------------
 os_intfs.c    |   14 ++++++++++---
 rtl8712_hal.h |    1 
 usb_intf.c    |    9 +++++---
 5 files changed, 68 insertions(+), 25 deletions(-)
---

Index: wireless-testing-new/drivers/staging/rtl8712/drv_types.h
===================================================================
--- wireless-testing-new.orig/drivers/staging/rtl8712/drv_types.h
+++ wireless-testing-new/drivers/staging/rtl8712/drv_types.h
@@ -37,6 +37,8 @@ struct _adapter;
 #include "wlan_bssdef.h"
 #include "rtl8712_spec.h"
 #include "rtl8712_hal.h"
+#include <linux/mutex.h>
+#include <linux/completion.h>
 
 enum _NIC_VERSION {
 	RTL8711_NIC,
@@ -168,6 +170,7 @@ struct _adapter {
 	s32	bSurpriseRemoved;
 	u32	IsrContent;
 	u32	ImrContent;
+	bool	fw_found;
 	u8	EepromAddressSize;
 	u8	hw_init_completed;
 	struct task_struct *cmdThread;
@@ -184,6 +187,10 @@ struct _adapter {
 	_workitem wkFilterRxFF0;
 	u8 blnEnableRxFF0Filter;
 	spinlock_t lockRxFF0Filter;
+	const struct firmware *fw;
+	struct usb_interface *pusb_intf;
+	struct mutex mutex_start;
+	struct completion rtl8712_fw_ready;
 };
 
 static inline u8 *myid(struct eeprom_priv *peepriv)
Index: wireless-testing-new/drivers/staging/rtl8712/hal_init.c
===================================================================
--- wireless-testing-new.orig/drivers/staging/rtl8712/hal_init.c
+++ wireless-testing-new/drivers/staging/rtl8712/hal_init.c
@@ -42,29 +42,56 @@
 #define FWBUFF_ALIGN_SZ 512
 #define MAX_DUMP_FWSZ	49152 /*default = 49152 (48k)*/
 
-static u32 rtl871x_open_fw(struct _adapter *padapter, void **pphfwfile_hdl,
-		    const u8 **ppmappedfw)
+static void rtl871x_load_fw_cb(const struct firmware *firmware, void *context)
 {
+	struct _adapter *padapter = context;
+
+	complete(&padapter->rtl8712_fw_ready);
+	if (!firmware) {
+		struct usb_device *udev = padapter->dvobjpriv.pusbdev;
+		struct usb_interface *pusb_intf = padapter->pusb_intf;
+		printk(KERN_ERR "r8712u: Firmware request failed\n");
+		padapter->fw_found = false;
+		usb_put_dev(udev);
+		usb_set_intfdata(pusb_intf, NULL);
+		return;
+	}
+	padapter->fw = firmware;
+	padapter->fw_found = true;
+	/* firmware available - start netdev */
+	register_netdev(padapter->pnetdev);
+}
+
+static const char firmware_file[] = "rtlwifi/rtl8712u.bin";
+
+int rtl871x_load_fw(struct _adapter *padapter)
+{
+	struct device *dev = &padapter->dvobjpriv.pusbdev->dev;
 	int rc;
-	const char firmware_file[] = "rtlwifi/rtl8712u.bin";
-	const struct firmware **praw = (const struct firmware **)
-				       (pphfwfile_hdl);
-	struct dvobj_priv *pdvobjpriv = (struct dvobj_priv *)
-					(&padapter->dvobjpriv);
-	struct usb_device *pusbdev = pdvobjpriv->pusbdev;
 
+	init_completion(&padapter->rtl8712_fw_ready);
 	printk(KERN_INFO "r8712u: Loading firmware from \"%s\"\n",
 	       firmware_file);
-	rc = request_firmware(praw, firmware_file, &pusbdev->dev);
-	if (rc < 0) {
-		printk(KERN_ERR "r8712u: Unable to load firmware\n");
-		printk(KERN_ERR "r8712u: Install latest linux-firmware\n");
+	rc = request_firmware_nowait(THIS_MODULE, 1, firmware_file, dev,
+				     GFP_KERNEL, padapter, rtl871x_load_fw_cb);
+	if (rc)
+		printk(KERN_ERR "r8712u: Firmware request error %d\n", rc);
+	return rc;
+}
+MODULE_FIRMWARE("rtlwifi/rtl8712u.bin");
+
+static u32 rtl871x_open_fw(struct _adapter *padapter, const u8 **ppmappedfw)
+{
+	const struct firmware **praw = &padapter->fw;
+
+	if (padapter->fw->size > 200000) {
+		printk(KERN_ERR "r8172u: Badfw->size of %d\n",
+		       (int)padapter->fw->size);
 		return 0;
 	}
 	*ppmappedfw = (u8 *)((*praw)->data);
 	return (*praw)->size;
 }
-MODULE_FIRMWARE("rtlwifi/rtl8712u.bin");
 
 static void fill_fwpriv(struct _adapter *padapter, struct fw_priv *pfwpriv)
 {
@@ -142,18 +169,17 @@ static u8 rtl8712_dl_fw(struct _adapter
 	uint dump_imem_sz, imem_sz, dump_emem_sz, emem_sz; /* max = 49152; */
 	struct fw_hdr fwhdr;
 	u32 ulfilelength;	/* FW file size */
-	void *phfwfile_hdl = NULL;
 	const u8 *pmappedfw = NULL;
 	u8 *ptmpchar = NULL, *ppayload, *ptr;
 	struct tx_desc *ptx_desc;
 	u32 txdscp_sz = sizeof(struct tx_desc);
 	u8 ret = _FAIL;
 
-	ulfilelength = rtl871x_open_fw(padapter, &phfwfile_hdl, &pmappedfw);
+	ulfilelength = rtl871x_open_fw(padapter, &pmappedfw);
 	if (pmappedfw && (ulfilelength > 0)) {
 		update_fwhdr(&fwhdr, pmappedfw);
 		if (chk_fwhdr(&fwhdr, ulfilelength) == _FAIL)
-			goto firmware_rel;
+			return ret;
 		fill_fwpriv(padapter, &fwhdr.fwpriv);
 		/* firmware check ok */
 		maxlen = (fwhdr.img_IMEM_size > fwhdr.img_SRAM_size) ?
@@ -161,7 +187,7 @@ static u8 rtl8712_dl_fw(struct _adapter
 		maxlen += txdscp_sz;
 		ptmpchar = _malloc(maxlen + FWBUFF_ALIGN_SZ);
 		if (ptmpchar == NULL)
-			goto firmware_rel;
+			return ret;
 
 		ptx_desc = (struct tx_desc *)(ptmpchar + FWBUFF_ALIGN_SZ -
 			    ((addr_t)(ptmpchar) & (FWBUFF_ALIGN_SZ - 1)));
@@ -297,8 +323,6 @@ static u8 rtl8712_dl_fw(struct _adapter
 
 exit_fail:
 	kfree(ptmpchar);
-firmware_rel:
-	release_firmware((struct firmware *)phfwfile_hdl);
 	return ret;
 }
 
Index: wireless-testing-new/drivers/staging/rtl8712/rtl8712_hal.h
===================================================================
--- wireless-testing-new.orig/drivers/staging/rtl8712/rtl8712_hal.h
+++ wireless-testing-new/drivers/staging/rtl8712/rtl8712_hal.h
@@ -145,5 +145,6 @@ struct hal_priv {
 };
 
 uint	 rtl8712_hal_init(struct _adapter *padapter);
+int rtl871x_load_fw(struct _adapter *padapter);
 
 #endif
Index: wireless-testing-new/drivers/staging/rtl8712/usb_intf.c
===================================================================
--- wireless-testing-new.orig/drivers/staging/rtl8712/usb_intf.c
+++ wireless-testing-new/drivers/staging/rtl8712/usb_intf.c
@@ -389,6 +389,7 @@ static int r871xu_drv_init(struct usb_in
 	pdvobjpriv = &padapter->dvobjpriv;
 	pdvobjpriv->padapter = padapter;
 	padapter->dvobjpriv.pusbdev = udev;
+	padapter->pusb_intf = pusb_intf;
 	usb_set_intfdata(pusb_intf, pnetdev);
 	SET_NETDEV_DEV(pnetdev, &pusb_intf->dev);
 	/* step 2. */
@@ -595,10 +596,11 @@ static int r871xu_drv_init(struct usb_in
 			       "%pM\n", mac);
 		memcpy(pnetdev->dev_addr, mac, ETH_ALEN);
 	}
-	/* step 6. Tell the network stack we exist */
-	if (register_netdev(pnetdev) != 0)
+	/* step 6. Load the firmware asynchronously */
+	if (rtl871x_load_fw(padapter))
 		goto error;
 	spin_lock_init(&padapter->lockRxFF0Filter);
+	mutex_init(&padapter->mutex_start);
 	return 0;
 error:
 	usb_put_dev(udev);
@@ -629,7 +631,8 @@ static void r871xu_dev_remove(struct usb
 		flush_scheduled_work();
 		udelay(1);
 		/*Stop driver mlme relation timer */
-		r8712_stop_drv_timers(padapter);
+		if (padapter->fw_found)
+			r8712_stop_drv_timers(padapter);
 		r871x_dev_unload(padapter);
 		r8712_free_drv_sw(padapter);
 	}
Index: wireless-testing-new/drivers/staging/rtl8712/os_intfs.c
===================================================================
--- wireless-testing-new.orig/drivers/staging/rtl8712/os_intfs.c
+++ wireless-testing-new/drivers/staging/rtl8712/os_intfs.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kthread.h>
+#include <linux/firmware.h>
 #include "osdep_service.h"
 #include "drv_types.h"
 #include "xmit_osdep.h"
@@ -264,12 +265,12 @@ static void start_drv_timers(struct _ada
 void r8712_stop_drv_timers(struct _adapter *padapter)
 {
 	_cancel_timer_ex(&padapter->mlmepriv.assoc_timer);
-	_cancel_timer_ex(&padapter->mlmepriv.sitesurveyctrl.
-			 sitesurvey_ctrl_timer);
 	_cancel_timer_ex(&padapter->securitypriv.tkip_timer);
 	_cancel_timer_ex(&padapter->mlmepriv.scan_to_timer);
 	_cancel_timer_ex(&padapter->mlmepriv.dhcp_timer);
 	_cancel_timer_ex(&padapter->mlmepriv.wdg_timer);
+	_cancel_timer_ex(&padapter->mlmepriv.sitesurveyctrl.
+			 sitesurvey_ctrl_timer);
 }
 
 static u8 init_default_value(struct _adapter *padapter)
@@ -347,7 +348,8 @@ u8 r8712_free_drv_sw(struct _adapter *pa
 	r8712_free_mlme_priv(&padapter->mlmepriv);
 	r8712_free_io_queue(padapter);
 	_free_xmit_priv(&padapter->xmitpriv);
-	_r8712_free_sta_priv(&padapter->stapriv);
+	if (padapter->fw_found)
+		_r8712_free_sta_priv(&padapter->stapriv);
 	_r8712_free_recv_priv(&padapter->recvpriv);
 	mp871xdeinit(padapter);
 	if (pnetdev)
@@ -388,6 +390,7 @@ static int netdev_open(struct net_device
 {
 	struct _adapter *padapter = (struct _adapter *)netdev_priv(pnetdev);
 
+	mutex_lock(&padapter->mutex_start);
 	if (padapter->bup == false) {
 		padapter->bDriverStopped = false;
 		padapter->bSurpriseRemoved = false;
@@ -435,11 +438,13 @@ static int netdev_open(struct net_device
 	/* start driver mlme relation timer */
 	start_drv_timers(padapter);
 	padapter->ledpriv.LedControlHandler(padapter, LED_CTL_NO_LINK);
+	mutex_unlock(&padapter->mutex_start);
 	return 0;
 netdev_open_error:
 	padapter->bup = false;
 	netif_carrier_off(pnetdev);
 	netif_stop_queue(pnetdev);
+	mutex_unlock(&padapter->mutex_start);
 	return -1;
 }
 
@@ -473,6 +478,9 @@ static int netdev_close(struct net_devic
 	r8712_free_network_queue(padapter);
 	/* The interface is no longer Up: */
 	padapter->bup = false;
+	release_firmware(padapter->fw);
+	/* never exit with a firmware callback pending */
+	wait_for_completion(&padapter->rtl8712_fw_ready);
 	return 0;
 }
 
