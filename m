Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab2AADyQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 22:54:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52779 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab2AADyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 22:54:14 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=TRgVYD6ZyiEA:10 a=XKtToDvn1-UA:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=VPW9pYw8AAAA:8 a=20KFwNOVAAAA:8 a=T5Ni6VkXAAAA:8 a=yQdBAQUQAAAA:8 a=Z4Rwk6OoAAAA:8 a=VwQbUJbxAAAA:8 a=u6fr5OkSEGQ6e3wnee0A:9 a=qf2uTM4yIDNLZJiE8RUA:7 a=CjuIK1q_8ugA:10 a=y2xWDDzaQp4A:10 a=1vY5q33nLKwA:10 a=jEp0ucaQiEUA:10 a=IcxpeKGZWnEA:10 a=jbrJJM5MRmoA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Sat, 31 Dec 2011 21:54:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>, torvalds@linux-foundation.org
Cc: chaoming_li@realsil.com.cn, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192ce: rtl8192cu: Delay firmware file read
 until needed to fix at drivers/base/firmware_class.c:537
Message-ID: <4effd8e3.n1quWeZQBSRwqFJt%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent LKML thread (http://lkml.indiana.edu/hypermail/linux/kernel/1112.3/00965.html)
discusses the the WARNING listed below, which occurs after a suspend/resume cycle. For
rtl8192cu, the problem was fixed by delaying the firmware loading until the interface is
brought up. By this time, the userspace support is available.

Dec 30 18:58:25 larrylap kernel: [186060.505125] ------------[ cut here ]------------
Dec 30 18:58:25 larrylap kernel: [186060.505133] WARNING: at drivers/base/firmware_class.c:537 _request_firmware+0x3f6/0x420()
Dec 30 18:58:25 larrylap kernel: [186060.505135] Hardware name: HP Pavilion dv2700 Notebook PC
Dec 30 18:58:25 larrylap kernel: [186060.505137] Modules linked in: rtl8192cu rtl8192c_common rtl8192se rtlwifi mac80211 cfg80211 rfkill xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables fuse aes_x86_64 aes_generic nfs lockd auth_rpcgss nfs_acl sunrpc vboxpci(O) vboxnetadp(O) af_packet vboxnetflt(O) vboxdrv(O) cpufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8 mperf ide_cd_mod cdrom ext3 jbd snd_hda_codec_conexant arc4 ide_pci_generic snd_hda_intel snd_hda_codec snd_pcm amd74xx snd_timer snd soundcore snd_page_alloc k8temp i2c_nforce2 ide_core battery ac joydev button forcedeth serio_raw i2c_core hwmon sg video ipv6 autofs4 ext4 mbcache jbd2 crc16 sd_mod ohci_hcd ahci libahci libata scsi_mod ehci_hcd usbcore usb_common fan processor thermal [last unloaded: rtlwifi]
Dec 30 18:58:25 larrylap kernel: [186060.505206] Pid: 20502, comm: s2ram Tainted: G        W  O 3.2.0-rc7-wl+ #161
Dec 30 18:58:25 larrylap kernel: [186060.505209] Call Trace:
Dec 30 18:58:25 larrylap kernel: [186060.505214]  [<ffffffff81048aea>] warn_slowpath_common+0x7a/0xb0
Dec 30 18:58:25 larrylap kernel: [186060.505218]  [<ffffffff81048b35>] warn_slowpath_null+0x15/0x20
Dec 30 18:58:25 larrylap kernel: [186060.505223]  [<ffffffff81288396>] _request_firmware+0x3f6/0x420
Dec 30 18:58:25 larrylap kernel: [186060.505226]  [<ffffffff812883d1>] request_firmware+0x11/0x20
Dec 30 18:58:25 larrylap kernel: [186060.505234]  [<ffffffffa0400cfe>] rtl92cu_init_sw_vars+0x6e/0x210 [rtl8192cu]
Dec 30 18:58:25 larrylap kernel: [186060.505243]  [<ffffffffa01189a6>] rtl_usb_probe+0x1cd/0x7b6 [rtlwifi]
Dec 30 18:58:25 larrylap kernel: [186060.505263]  [<ffffffffa002a595>] usb_probe_interface+0xb5/0x160 [usbcore]
Dec 30 18:58:25 larrylap kernel: [186060.505268]  [<ffffffff8127f2a3>] driver_probe_device+0x73/0x190
Dec 30 18:58:25 larrylap kernel: [186060.505272]  [<ffffffff8127f4bb>] __device_attach+0x4b/0x60
Dec 30 18:58:25 larrylap kernel: [186060.505276]  [<ffffffff8127f470>] ? __driver_attach+0xb0/0xb0
Dec 30 18:58:25 larrylap kernel: [186060.505280]  [<ffffffff8127df4c>] bus_for_each_drv+0x5c/0x90
Dec 30 18:58:25 larrylap kernel: [186060.505283]  [<ffffffff8127f201>] device_attach+0xa1/0xb0
Dec 30 18:58:25 larrylap kernel: [186060.505294]  [<ffffffffa002a6c0>] usb_rebind_intf+0x50/0x70 [usbcore]
Dec 30 18:58:25 larrylap kernel: [186060.505305]  [<ffffffffa002a755>] do_unbind_rebind.isra.20+0x75/0xa0 [usbcore]
Dec 30 18:58:25 larrylap kernel: [186060.505316]  [<ffffffffa002ab44>] usb_resume+0xf4/0x1b0 [usbcore]
Dec 30 18:58:25 larrylap kernel: [186060.505325]  [<ffffffffa001e10b>] usb_dev_complete+0xb/0x10 [usbcore]
Dec 30 18:58:25 larrylap kernel: [186060.505329]  [<ffffffff81285b6e>] dpm_complete+0x4e/0x180
Dec 30 18:58:25 larrylap kernel: [186060.505333]  [<ffffffff81285cb7>] dpm_resume_end+0x17/0x20
Dec 30 18:58:25 larrylap kernel: [186060.505338]  [<ffffffff8109331c>] suspend_devices_and_enter+0x11c/0x2a0
Dec 30 18:58:25 larrylap kernel: [186060.505341]  [<ffffffff810935b8>] enter_state+0x118/0x140
Dec 30 18:58:25 larrylap kernel: [186060.505345]  [<ffffffff81092087>] state_store+0xb7/0x130
Dec 30 18:58:25 larrylap kernel: [186060.505350]  [<ffffffff811ceebf>] kobj_attr_store+0xf/0x30
Dec 30 18:58:25 larrylap kernel: [186060.505354]  [<ffffffff8118d7c1>] sysfs_write_file+0xe1/0x160
Dec 30 18:58:25 larrylap kernel: [186060.505360]  [<ffffffff8112595a>] vfs_write+0xaa/0x160
Dec 30 18:58:25 larrylap kernel: [186060.505363]  [<ffffffff81125c45>] sys_write+0x45/0x90
Dec 30 18:58:25 larrylap kernel: [186060.505368]  [<ffffffff81383a7b>] system_call_fastpath+0x16/0x1b
Dec 30 18:58:25 larrylap kernel: [186060.505371] ---[ end trace 85fa03fa1f39c036 ]---

These patches should fix the bug reported in https://bugzilla.redhat.com/show_bug.cgi?id=771002.

Reported-by: Mohammed Arafa <bugzilla@in-egypt.net>
Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stable <stable@vger.kernel.org>
---

John,

Tecnically, this patch should be applied to V3.2, but it is late in the cycle,
and the patch is pretty intrusive. There is almost new code, but a lot was
relocated. You and Linus should decide at what stage the fix should be applied.

Larry
---


Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -54,38 +54,12 @@ MODULE_FIRMWARE("rtlwifi/rtl8192cufw.bin
 static int rtl92cu_init_sw_vars(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	const struct firmware *firmware;
-	int err;
 
 	rtlpriv->dm.dm_initialgain_enable = 1;
 	rtlpriv->dm.dm_flag = 0;
 	rtlpriv->dm.disable_framebursting = 0;
 	rtlpriv->dm.thermalvalue = 0;
 	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
-	rtlpriv->rtlhal.pfirmware = vmalloc(0x4000);
-	if (!rtlpriv->rtlhal.pfirmware) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 ("Can't alloc buffer for fw.\n"));
-		return 1;
-	}
-	/* request fw */
-	err = request_firmware(&firmware, rtlpriv->cfg->fw_name,
-			rtlpriv->io.dev);
-	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 ("Failed to request firmware!\n"));
-		return 1;
-	}
-	if (firmware->size > 0x4000) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 ("Firmware is too big!\n"));
-		release_firmware(firmware);
-		return 1;
-	}
-	memcpy(rtlpriv->rtlhal.pfirmware, firmware->data, firmware->size);
-	rtlpriv->rtlhal.fwsize = firmware->size;
-	release_firmware(firmware);
-
 	return 0;
 }
 
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
@@ -1043,6 +1043,7 @@ struct rtl_hal {
 	u8 *pfirmware;
 	u16 fw_version;
 	u16 fw_subversion;
+	bool firmware_loaded;
 	bool h2c_setinprogress;
 	u8 last_hmeboxnum;
 	bool fw_ready;
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/usb.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
@@ -1038,6 +1038,7 @@ EXPORT_SYMBOL(rtl_usb_disconnect);
 
 int rtl_usb_suspend(struct usb_interface *pusb_intf, pm_message_t message)
 {
+	rtl_usb_disconnect(pusb_intf);
 	return 0;
 }
 EXPORT_SYMBOL(rtl_usb_suspend);
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -258,12 +258,39 @@ int rtl92c_download_fw(struct ieee80211_
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl92c_firmware_header *pfwheader;
+	const struct firmware *firmware;
 	u8 *pfwdata;
 	u32 fwsize;
 	enum version_8192c version = rtlhal->version;
+	int err;
 
-	if (!rtlhal->pfirmware)
+	/* If previously loaded, exit now */
+	if (rtlpriv->rtlhal.pfirmware)
+		return 0;
+	rtlpriv->rtlhal.pfirmware = vmalloc(0x4000);
+	if (!rtlpriv->rtlhal.pfirmware) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 ("Can't alloc buffer for fw.\n"));
 		return 1;
+	}
+	/* request fw */
+	err = request_firmware(&firmware, rtlpriv->cfg->fw_name,
+			rtlpriv->io.dev);
+	if (err) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 ("Failed to request firmware!\n"));
+		return 1;
+	}
+	if (firmware->size > 0x4000) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 ("Firmware is too big!\n"));
+		release_firmware(firmware);
+		return 1;
+	}
+	memcpy(rtlpriv->rtlhal.pfirmware, firmware->data, firmware->size);
+	rtlpriv->rtlhal.fwsize = firmware->size;
+	release_firmware(firmware);
+	rtlpriv->rtlhal.firmware_loaded = true;
 
 	pr_info("Loading firmware file %s\n", rtlpriv->cfg->fw_name);
 	pfwheader = (struct rtl92c_firmware_header *)rtlhal->pfirmware;
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -89,10 +89,8 @@ static void rtl92c_init_aspm_vars(struct
 
 int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
 {
-	int err;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	const struct firmware *firmware;
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	char *fw_name = NULL;
 
@@ -171,21 +169,6 @@ int rtl92c_init_sw_vars(struct ieee80211
 		fw_name = "rtlwifi/rtl8192cfwU_B.bin";
 	else
 		fw_name = rtlpriv->cfg->fw_name;
-	err = request_firmware(&firmware, fw_name, rtlpriv->io.dev);
-	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 ("Failed to request firmware!\n"));
-		return 1;
-	}
-	if (firmware->size > 0x4000) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 ("Firmware is too big!\n"));
-		release_firmware(firmware);
-		return 1;
-	}
-	memcpy(rtlpriv->rtlhal.pfirmware, firmware->data, firmware->size);
-	rtlpriv->rtlhal.fwsize = firmware->size;
-	release_firmware(firmware);
 
 	return 0;
 }
