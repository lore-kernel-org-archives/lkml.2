Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab0GHNze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 09:55:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34259 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab0GHNzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 09:55:32 -0400
From: pavan_savoy@ti.com
To: alan@lxorguk.ukuu.org.uk, gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       pavan_savoy@yahoo.co.in, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 2/2] drivers:staging:ti-st: remove global references
Date: Thu,  8 Jul 2010 08:55:17 -0500
Message-Id: <1278597317-31389-3-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1278597317-31389-2-git-send-email-pavan_savoy@ti.com>
References: <1278597317-31389-1-git-send-email-pavan_savoy@ti.com>
 <1278597317-31389-2-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Providing a context which can be passed around the driver, the KIM's platform
driver's struct device to be used to dev_set_drvdata and dev_get_drvdata.
The ST core's data is passed around using tty's disc_data and in other
cases the ST KIM's platform device is exposed from the board-XX.c which
adds KIM platform device whose dev is used.

Thereby remove the need for the global reference struct kim_data_s *kim_gdata;

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/ti-st/st.h      |    5 ++-
 drivers/staging/ti-st/st_core.c |    8 ++--
 drivers/staging/ti-st/st_core.h |    2 +
 drivers/staging/ti-st/st_kim.c  |   77 +++++++++++++++++++++++++++------------
 drivers/staging/ti-st/st_kim.h  |    6 ++--
 5 files changed, 65 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/ti-st/st.h b/drivers/staging/ti-st/st.h
index e8fc97e..e6a8ffd 100644
--- a/drivers/staging/ti-st/st.h
+++ b/drivers/staging/ti-st/st.h
@@ -84,7 +84,8 @@ struct st_proto_s {
 	long (*write) (struct sk_buff *skb);
 };
 
-extern long st_register(struct st_proto_s *new_proto);
-extern long st_unregister(enum proto_type type);
+extern long st_register(struct st_proto_s *);
+extern long st_unregister(enum proto_type);
 
+extern struct platform_device *st_get_plat_device(void);
 #endif /* ST_H */
diff --git a/drivers/staging/ti-st/st_core.c b/drivers/staging/ti-st/st_core.c
index a492369..bf5049c 100644
--- a/drivers/staging/ti-st/st_core.c
+++ b/drivers/staging/ti-st/st_core.c
@@ -650,7 +650,7 @@ long st_register(struct st_proto_s *new_proto)
 		/* this may take a while to complete
 		 * since it involves BT fw download
 		 */
-		err = st_kim_start();
+		err = st_kim_start(st_gdata->kim_data);
 		if (err != ST_SUCCESS) {
 			clear_bit(ST_REG_IN_PROGRESS, &st_gdata->st_state);
 			if ((st_gdata->protos_registered != ST_EMPTY) &&
@@ -771,7 +771,7 @@ long st_unregister(enum proto_type type)
 		}
 
 		/* all protocols now unregistered */
-		st_kim_stop();
+		st_kim_stop(st_gdata->kim_data);
 		/* disable ST LL */
 		st_ll_disable(st_gdata);
 	}
@@ -858,7 +858,7 @@ static int st_tty_open(struct tty_struct *tty)
 	 * signal to UIM via KIM that -
 	 * installation of N_TI_WL ldisc is complete
 	 */
-	st_kim_complete();
+	st_kim_complete(st_gdata->kim_data);
 	pr_info("done %s", __func__);
 	return err;
 }
@@ -886,7 +886,7 @@ static void st_tty_close(struct tty_struct *tty)
 	 * signal to UIM via KIM that -
 	 * N_TI_WL ldisc is un-installed
 	 */
-	st_kim_complete();
+	st_kim_complete(st_gdata->kim_data);
 	st_gdata->tty = NULL;
 	/* Flush any pending characters in the driver and discipline. */
 	tty_ldisc_flush(tty);
diff --git a/drivers/staging/ti-st/st_core.h b/drivers/staging/ti-st/st_core.h
index f271c88..53369f2 100644
--- a/drivers/staging/ti-st/st_core.h
+++ b/drivers/staging/ti-st/st_core.h
@@ -69,6 +69,8 @@ struct st_data_s {
 	spinlock_t lock;	/* ST LL state lock  */
 	unsigned char	protos_registered;
 	unsigned long ll_state;	/* ST LL power state */
+/* device reference to kim data */
+	void *kim_data;
 };
 
 /* point this to tty->driver->write or tty->ops->write
diff --git a/drivers/staging/ti-st/st_kim.c b/drivers/staging/ti-st/st_kim.c
index d015ad3..d4fd2c2 100644
--- a/drivers/staging/ti-st/st_kim.c
+++ b/drivers/staging/ti-st/st_kim.c
@@ -100,7 +100,6 @@ const unsigned char *protocol_names[] = {
 	PROTO_ENTRY(ST_GPS, "GPS"),
 };
 
-struct kim_data_s	*kim_gdata;
 
 /**********************************************************************/
 /* internal functions */
@@ -110,8 +109,9 @@ struct kim_data_s	*kim_gdata;
  * in case of error don't complete so that waiting for proper
  * response times out
  */
-void validate_firmware_response(struct sk_buff *skb)
+void validate_firmware_response(struct kim_data_s *kim_gdata)
 {
+	struct sk_buff *skb = kim_gdata->rx_skb;
 	if (unlikely(skb->data[5] != 0)) {
 		pr_err("no proper response during fw download");
 		pr_err("data6 %x", skb->data[5]);
@@ -125,14 +125,14 @@ void validate_firmware_response(struct sk_buff *skb)
 /* check for data len received inside kim_int_recv
  * most often hit the last case to update state to waiting for data
  */
-static inline int kim_check_data_len(int len)
+static inline int kim_check_data_len(struct kim_data_s *kim_gdata, int len)
 {
 	register int room = skb_tailroom(kim_gdata->rx_skb);
 
 	pr_info("len %d room %d", len, room);
 
 	if (!len) {
-		validate_firmware_response(kim_gdata->rx_skb);
+		validate_firmware_response(kim_gdata);
 	} else if (len > room) {
 		/* Received packet's payload length is larger.
 		 * We can't accommodate it in created skb.
@@ -163,7 +163,8 @@ static inline int kim_check_data_len(int len)
  *   have been observed to come in bursts of different
  *   tty_receive and hence the logic
  */
-void kim_int_recv(const unsigned char *data, long count)
+void kim_int_recv(struct kim_data_s *kim_gdata,
+	const unsigned char *data, long count)
 {
 	register char *ptr;
 	struct hci_event_hdr *eh;
@@ -192,7 +193,7 @@ void kim_int_recv(const unsigned char *data, long count)
 				/* Waiting for complete packet ? */
 			case ST_BT_W4_DATA:
 				pr_info("Complete pkt received");
-				validate_firmware_response(kim_gdata->rx_skb);
+				validate_firmware_response(kim_gdata);
 				kim_gdata->rx_state = ST_W4_PACKET_TYPE;
 				kim_gdata->rx_skb = NULL;
 				continue;
@@ -202,7 +203,7 @@ void kim_int_recv(const unsigned char *data, long count)
 				    rx_skb->data;
 				pr_info("Event header: evt 0x%2.2x"
 					   "plen %d", eh->evt, eh->plen);
-				kim_check_data_len(eh->plen);
+				kim_check_data_len(kim_gdata, eh->plen);
 				continue;
 			}	/* end of switch */
 		}		/* end of if rx_state */
@@ -236,7 +237,7 @@ void kim_int_recv(const unsigned char *data, long count)
 	return;
 }
 
-static long read_local_version(char *bts_scr_name)
+static long read_local_version(struct kim_data_s *kim_gdata, char *bts_scr_name)
 {
 	unsigned short version = 0, chip = 0, min_ver = 0, maj_ver = 0;
 	char read_ver_cmd[] = { 0x01, 0x01, 0x10, 0x00 };
@@ -280,7 +281,7 @@ static long read_local_version(char *bts_scr_name)
 /* internal function which parses through the .bts firmware script file
  * intreprets SEND, DELAY actions only as of now
  */
-static long download_firmware(void)
+static long download_firmware(struct kim_data_s *kim_gdata)
 {
 	long err = ST_SUCCESS;
 	long len = 0;
@@ -290,7 +291,7 @@ static long download_firmware(void)
 
 	pr_info("%s", __func__);
 
-	err = read_local_version(bts_scr_name);
+	err = read_local_version(kim_gdata, bts_scr_name);
 	if (err != ST_SUCCESS) {
 		pr_err("kim: failed to read local ver");
 		return err;
@@ -369,14 +370,18 @@ static long download_firmware(void)
 
 /**********************************************************************/
 /* functions called from ST core */
-
 /* function to toggle the GPIO
  * needs to know whether the GPIO is active high or active low
  */
 void st_kim_chip_toggle(enum proto_type type, enum kim_gpio_state state)
 {
+	struct platform_device	*kim_pdev;
+	struct kim_data_s	*kim_gdata;
 	pr_info(" %s ", __func__);
 
+	kim_pdev = st_get_plat_device();
+	kim_gdata = dev_get_drvdata(&kim_pdev->dev);
+
 	if (kim_gdata->gpios[type] == -1) {
 		pr_info(" gpio not requested for protocol %s",
 			   protocol_names[type]);
@@ -416,6 +421,9 @@ void st_kim_chip_toggle(enum proto_type type, enum kim_gpio_state state)
  */
 void st_kim_recv(void *disc_data, const unsigned char *data, long count)
 {
+	struct st_data_s	*st_gdata = (struct st_data_s *)disc_data;
+	struct kim_data_s	*kim_gdata = st_gdata->kim_data;
+
 	pr_info(" %s ", __func__);
 	/* copy to local buffer */
 	if (unlikely(data[4] == 0x01 && data[5] == 0x10 && data[0] == 0x04)) {
@@ -424,7 +432,7 @@ void st_kim_recv(void *disc_data, const unsigned char *data, long count)
 		complete_all(&kim_gdata->kim_rcvd);
 		return;
 	} else {
-		kim_int_recv(data, count);
+		kim_int_recv(kim_gdata, data, count);
 		/* either completes or times out */
 	}
 	return;
@@ -433,17 +441,20 @@ void st_kim_recv(void *disc_data, const unsigned char *data, long count)
 /* to signal completion of line discipline installation
  * called from ST Core, upon tty_open
  */
-void st_kim_complete(void)
+void st_kim_complete(void *kim_data)
 {
+	struct kim_data_s	*kim_gdata = (struct kim_data_s *)kim_data;
 	complete(&kim_gdata->ldisc_installed);
 }
 
 /* called from ST Core upon 1st registration
 */
-long st_kim_start(void)
+long st_kim_start(void *kim_data)
 {
 	long err = ST_SUCCESS;
 	long retry = POR_RETRY_COUNT;
+	struct kim_data_s	*kim_gdata = (struct kim_data_s *)kim_data;
+
 	pr_info(" %s", __func__);
 
 	do {
@@ -480,7 +491,7 @@ long st_kim_start(void)
 		} else {
 			/* ldisc installed now */
 			pr_info(" line discipline installed ");
-			err = download_firmware();
+			err = download_firmware(kim_gdata);
 			if (err != ST_SUCCESS) {
 				pr_err("download firmware failed");
 				continue;
@@ -494,9 +505,10 @@ long st_kim_start(void)
 
 /* called from ST Core, on the last un-registration
 */
-long st_kim_stop(void)
+long st_kim_stop(void *kim_data)
 {
 	long err = ST_SUCCESS;
+	struct kim_data_s	*kim_gdata = (struct kim_data_s *)kim_data;
 
 	INIT_COMPLETION(kim_gdata->ldisc_installed);
 #if 0 /* older way of signalling user-space UIM */
@@ -534,6 +546,7 @@ long st_kim_stop(void)
 static ssize_t show_version(struct device *dev, struct device_attribute
 		*attr, char *buf)
 {
+	struct kim_data_s	*kim_gdata = dev_get_drvdata(dev);
 	sprintf(buf, "%04X %d.%d.%d", kim_gdata->version.full,
 			kim_gdata->version.chip, kim_gdata->version.maj_ver,
 			kim_gdata->version.min_ver);
@@ -544,6 +557,7 @@ static ssize_t show_version(struct device *dev, struct device_attribute
 static ssize_t store_pid(struct device *dev, struct device_attribute
 			 *devattr, char *buf, size_t count)
 {
+	struct kim_data_s	*kim_gdata = dev_get_drvdata(dev);
 	pr_info("%s: pid %s ", __func__, buf);
 	sscanf(buf, "%ld", &kim_gdata->uim_pid);
 	/* to be made use by kim_start to signal SIGUSR2
@@ -555,6 +569,7 @@ static ssize_t store_pid(struct device *dev, struct device_attribute
 static ssize_t show_pid(struct device *dev, struct device_attribute
 			*attr, char *buf)
 {
+	struct kim_data_s	*kim_gdata = dev_get_drvdata(dev);
 	sprintf(buf, "%ld", kim_gdata->uim_pid);
 	return strlen(buf);
 }
@@ -563,6 +578,7 @@ static ssize_t show_pid(struct device *dev, struct device_attribute
 static ssize_t show_list(struct device *dev, struct device_attribute
 			 *attr, char *buf)
 {
+	struct kim_data_s	*kim_gdata = dev_get_drvdata(dev);
 	kim_st_list_protocols(kim_gdata->core_data, buf);
 	return strlen(buf);
 }
@@ -596,6 +612,11 @@ static int kim_toggle_radio(void *data, bool blocked)
 
 void st_kim_ref(struct st_data_s **core_data)
 {
+	struct platform_device	*pdev;
+	struct kim_data_s	*kim_gdata;
+	/* get kim_gdata reference from platform device */
+	pdev = st_get_plat_device();
+	kim_gdata = dev_get_drvdata(&pdev->dev);
 	*core_data = kim_gdata->core_data;
 }
 
@@ -610,12 +631,22 @@ static int kim_probe(struct platform_device *pdev)
 	long status;
 	long proto;
 	long *gpios = pdev->dev.platform_data;
+	struct kim_data_s	*kim_gdata;
+
+	kim_gdata = kzalloc(sizeof(struct kim_data_s), GFP_ATOMIC);
+	if (!kim_gdata) {
+		pr_err("no mem to allocate");
+		return -ENOMEM;
+	}
+	dev_set_drvdata(&pdev->dev, kim_gdata);
 
 	status = st_core_init(&kim_gdata->core_data);
 	if (status != 0) {
 		pr_err(" ST core init failed");
 		return ST_ERR_FAILURE;
 	}
+	/* refer to itself */
+	kim_gdata->core_data->kim_data = kim_gdata;
 
 	for (proto = 0; proto < ST_MAX; proto++) {
 		kim_gdata->gpios[proto] = gpios[proto];
@@ -694,6 +725,9 @@ static int kim_remove(struct platform_device *pdev)
 	 */
 	long *gpios = pdev->dev.platform_data;
 	long proto;
+	struct kim_data_s	*kim_gdata;
+
+	kim_gdata = dev_get_drvdata(&pdev->dev);
 
 	for (proto = 0; (proto < ST_MAX) && (gpios[proto] != -1); proto++) {
 		/* Claim the Bluetooth/FM/GPIO
@@ -708,6 +742,9 @@ static int kim_remove(struct platform_device *pdev)
 	sysfs_remove_group(&pdev->dev.kobj, &uim_attr_grp);
 	kim_gdata->kim_pdev = NULL;
 	st_core_exit(kim_gdata->core_data);
+
+	kfree(kim_gdata);
+	kim_gdata = NULL;
 	return ST_SUCCESS;
 }
 
@@ -717,12 +754,6 @@ static int kim_remove(struct platform_device *pdev)
 static int __init st_kim_init(void)
 {
 	long ret = ST_SUCCESS;
-	kim_gdata = kzalloc(sizeof(struct kim_data_s), GFP_ATOMIC);
-	if (!kim_gdata) {
-		pr_err("no mem to allocate");
-		return -ENOMEM;
-	}
-
 	ret = platform_driver_register(&kim_platform_driver);
 	if (ret != 0) {
 		pr_err("platform drv registration failed");
@@ -735,8 +766,6 @@ static void __exit st_kim_deinit(void)
 {
 	/* the following returns void */
 	platform_driver_unregister(&kim_platform_driver);
-	kfree(kim_gdata);
-	kim_gdata = NULL;
 }
 
 
diff --git a/drivers/staging/ti-st/st_kim.h b/drivers/staging/ti-st/st_kim.h
index a5ea8d7..d5685f4 100644
--- a/drivers/staging/ti-st/st_kim.h
+++ b/drivers/staging/ti-st/st_kim.h
@@ -79,8 +79,8 @@ struct kim_data_s {
 	struct chip_version version;
 };
 
-long st_kim_start(void);
-long st_kim_stop(void);
+long st_kim_start(void *);
+long st_kim_stop(void *);
 /*
  * called from st_tty_receive to authenticate fw_download
  */
@@ -88,7 +88,7 @@ void st_kim_recv(void *, const unsigned char *, long count);
 
 void st_kim_chip_toggle(enum proto_type, enum kim_gpio_state);
 
-void st_kim_complete(void);
+void st_kim_complete(void *);
 
 /* function called from ST KIM to ST Core, to
  * list out the protocols registered
-- 
1.5.6.3

