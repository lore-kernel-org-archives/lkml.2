Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab0GZMsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 08:48:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43900 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122Ab0GZMsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 08:48:06 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        pavan_savoy@sify.com, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH] RFC: drivers:staging:ti-st: netlink for kim/uim
Date: Mon, 26 Jul 2010 07:47:49 -0500
Message-Id: <1280148469-14886-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Greg, Alan,

(please do not merge
&
long mail warning, please have a look..)

I hope the driver is close to being good enough to be moved out of
staging, as one of the last major TODOs which was multiple device
support is being handled here.
However, please comment as to how desperately is this required to get
this out of staging, the reason is mentioned below..

The per-device context to driver is already provided however, there is
this small catch in support for multiple devices.
The kernel space needs to communicate to user-space about the device
which needs to be used.
say:-
	ST_O platform device is on ttyS0
	ST_1 platform device is on ttyS1
and
	ST_2 platform device is on ttySPI0

each protocol drivers such as BT, FM would be only able to tell which
platform device they want to bind to, but that device needs to be
opened/ldisc installtion needs to happen from user-space/UIM.

background :-
UIM is the user-space initialization manager for the TI WL7 chipsets
which is responsible for :-
	* opening the tty ONLY when absolutely necessary
	* set the baud-rate agreed upon between BT, FM and GPS
	(usually the max baud-rate)
	* installing/tiocsetd the N_TI_WL ldisc
	* un-installing ldisc
	* closing the device when not being used.

KIM is the kernel-space initialization manager for the TI WL7 chipsets
which is responsible for :-
	* enabling the chip-enable GPIO
	* communicate to UIM that the tty needs to be used
	(it gets to know via the one of the BT/FM/GPS drivers..)
	* wait for UIM to install ldisc
	* download firmware once tty context is available
	* communicate to UIM about the releasing the tty when no-one's
	using (again when protos_registered becomes 0)
	* disable the chip enable GPIO.

So, as of now these were being interfaced earlier over /sys/uim/pid and
signal mechanism, which was then changed to /dev/rfkill and
rfkill_events over it.

However,
Since with multiple device support is required the KIM somehow needs to
inform the UIM to open a particular tty interface - by sending an id or
the exact device name itself, this is what this patch does.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/ti-st/TODO     |    4 ++-
 drivers/staging/ti-st/st.h     |   28 +++++++++++++++++++++++
 drivers/staging/ti-st/st_kim.c |   47 ++++++++++++++++++++++++++++++++++++++-
 drivers/staging/ti-st/st_kim.h |    6 ++++-
 4 files changed, 81 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ti-st/TODO b/drivers/staging/ti-st/TODO
index 3f68ea1..94533fb 100644
--- a/drivers/staging/ti-st/TODO
+++ b/drivers/staging/ti-st/TODO
@@ -11,7 +11,9 @@ a st_register() would know whether the registration from BT/FM or GPS was intend
 2. Improve upon the way requirement of line discipline is communicated to
 user-space, The current user-space application which open/installs ldisc
 as and when required can be found at,
-http://git.omapzoom.org/?pÿatform/hardware/ti/omap3.git;aÿob;fÿ_st/uim/uim.c;ha16c2c2b5085eb54a1bbc7096d779d7594eb11;hbìlair
+git://dev.omapzoom.org/pub/scm/jsistla/L23-btfm.git
+branch: UIM
+sources at uim.c and uim.h.
 
 3. Re-view/Re-work on the locking.
 
diff --git a/drivers/staging/ti-st/st.h b/drivers/staging/ti-st/st.h
index 9952579..49fc4d5 100644
--- a/drivers/staging/ti-st/st.h
+++ b/drivers/staging/ti-st/st.h
@@ -31,6 +31,33 @@
 #define N_TI_WL	20	/* Ldisc for TI's WL BT, FM, GPS combo chips */
 
 /**
+ * enum action_e - action that needs to be executed from UIM when
+ *	requested by KIM.
+ * @INSTALL: this is to suggest UIM to open tty and install this ldisc
+ * @UN_INSTALL: this is to suggest UIM to close tty since no other
+ *	protocols use the ldisc.
+ */
+enum action_e {
+	INSTALL = 1,
+	UN_INSTALL
+};
+
+/**
+ * struct link_data_s - data exchanged between UIM and KIM
+ * @dev_name: the device name which needs to be opened by UIM
+ * @action: the action which needs to be performed open/install
+ *	or close/un-install
+ * @ldisc_num: an extra param - reserved for future use
+ */
+struct link_data_s {
+	unsigned char dev_name[10];
+	enum action_e action;
+	unsigned char ldisc_num;
+};
+
+
+#ifdef __KERNEL__
+/**
  * enum kim_gpio_state - Few protocols such as FM have ACTIVE LOW
  *	gpio states for their chip/core enable gpios
  */
@@ -81,4 +108,5 @@ extern long st_register(struct st_proto_s *);
 extern long st_unregister(enum proto_type);
 
 extern struct platform_device *st_get_plat_device(void);
+#endif	/* __KERNEL__ */
 #endif /* ST_H */
diff --git a/drivers/staging/ti-st/st_kim.c b/drivers/staging/ti-st/st_kim.c
index 7e34e4d..70563be 100644
--- a/drivers/staging/ti-st/st_kim.c
+++ b/drivers/staging/ti-st/st_kim.c
@@ -461,6 +461,7 @@ long st_kim_start(void *kim_data)
 	long err = 0;
 	long retry = POR_RETRY_COUNT;
 	struct kim_data_s	*kim_gdata = (struct kim_data_s *)kim_data;
+	struct sk_buff *skb;
 
 	pr_info(" %s", __func__);
 
@@ -475,6 +476,15 @@ long st_kim_start(void *kim_data)
 		mdelay(5);	/* FIXME: a proper toggle */
 		gpio_set_value(kim_gdata->gpios[ST_BT], GPIO_HIGH);
 		mdelay(100);
+
+		skb = alloc_skb(sizeof(struct link_data_s), GFP_KERNEL);
+		strncpy(kim_gdata->link_data.dev_name, "ttyS1",
+			strlen("ttyS1"));
+		kim_gdata->link_data.action = INSTALL;
+		kim_gdata->link_data.ldisc_num = N_TI_WL;
+		memcpy(skb_put(skb, sizeof(kim_gdata->link_data)),
+			&kim_gdata->link_data, sizeof(kim_gdata->link_data));
+
 		/* re-initialize the completion */
 		INIT_COMPLETION(kim_gdata->ldisc_installed);
 #if 0 /* older way of signalling user-space UIM */
@@ -485,9 +495,12 @@ long st_kim_start(void *kim_data)
 			err = -1;
 			continue;
 		}
-#endif
 		/* unblock and send event to UIM via /dev/rfkill */
 		rfkill_set_hw_state(kim_gdata->rfkill[ST_BT], 0);
+#endif
+
+		netlink_broadcast(kim_gdata->uim_nlink, skb, 0, 1, GFP_KERNEL);
+
 		/* wait for ldisc to be installed */
 		err = wait_for_completion_timeout(&kim_gdata->ldisc_installed,
 				msecs_to_jiffies(LDISC_TIME));
@@ -518,6 +531,15 @@ long st_kim_stop(void *kim_data)
 {
 	long err = 0;
 	struct kim_data_s	*kim_gdata = (struct kim_data_s *)kim_data;
+	struct sk_buff *skb;
+
+	skb = alloc_skb(sizeof(struct link_data_s), GFP_KERNEL);
+	strncpy(kim_gdata->link_data.dev_name, "ttyS1",
+		strlen("ttyS1"));
+	kim_gdata->link_data.action = UN_INSTALL;
+	kim_gdata->link_data.ldisc_num = N_TI_WL;
+	memcpy(skb_put(skb, sizeof(kim_gdata->link_data)),
+		&kim_gdata->link_data, sizeof(kim_gdata->link_data));
 
 	INIT_COMPLETION(kim_gdata->ldisc_installed);
 #if 0 /* older way of signalling user-space UIM */
@@ -527,9 +549,11 @@ long st_kim_stop(void *kim_data)
 		pr_err("sending SIGUSR2 to uim failed %ld", err);
 		return -1;
 	}
-#endif
 	/* set BT rfkill to be blocked */
 	err = rfkill_set_hw_state(kim_gdata->rfkill[ST_BT], 1);
+#endif
+
+	netlink_broadcast(kim_gdata->uim_nlink, skb, 0, 1, GFP_KERNEL);
 
 	/* wait for ldisc to be un-installed */
 	err = wait_for_completion_timeout(&kim_gdata->ldisc_installed,
@@ -545,6 +569,8 @@ long st_kim_stop(void *kim_data)
 	gpio_set_value(kim_gdata->gpios[ST_BT], GPIO_HIGH);
 	mdelay(1);
 	gpio_set_value(kim_gdata->gpios[ST_BT], GPIO_LOW);
+	kfree_skb(skb);
+
 	return err;
 }
 
@@ -635,6 +661,15 @@ void st_kim_ref(struct st_data_s **core_data)
 	*core_data = kim_gdata->core_data;
 }
 
+/**
+ * kim_nlink_callback - callback called when UIM sends comes calling
+ *	Don't do anything as of yet
+ */
+void kim_nlink_callback(struct sk_buff *skb)
+{
+	pr_info(" %s ", __func__);
+}
+
 /**********************************************************************/
 /* functions called from platform device driver subsystem
  * need to have a relevant platform device entry in the platform's
@@ -703,6 +738,14 @@ static int kim_probe(struct platform_device *pdev)
 	init_completion(&kim_gdata->kim_rcvd);
 	init_completion(&kim_gdata->ldisc_installed);
 
+	/* create netlink connection - reuse N_TI_WL for protocol */
+	kim_gdata->uim_nlink = netlink_kernel_create(&init_net, N_TI_WL, 0,
+				kim_nlink_callback, NULL, THIS_MODULE);
+	if (kim_gdata->uim_nlink == NULL) {
+		pr_err("can't setup netlink socket");
+		return -1;
+	}
+
 	for (proto = 0; (proto < ST_MAX) && (gpios[proto] != -1); proto++) {
 		/* TODO: should all types be rfkill_type_bt ? */
 		kim_gdata->rf_protos[proto] = proto;
diff --git a/drivers/staging/ti-st/st_kim.h b/drivers/staging/ti-st/st_kim.h
index 225cacd..8743ba4 100644
--- a/drivers/staging/ti-st/st_kim.h
+++ b/drivers/staging/ti-st/st_kim.h
@@ -79,7 +79,9 @@ struct chip_version {
  * @rf_protos: proto types of the data registered with rfkill sub-system.
  * @core_data: ST core's data, which mainly is the tty's disc_data
  * @version: chip version available via a sysfs entry.
- *
+ * @uim_nlink: the netlink connection between UIM and KIM.
+ * @link_data: the data to be exchanged between KIM and UIM via the netlink
+ *	socket.
  */
 struct kim_data_s {
 	long uim_pid;
@@ -95,6 +97,8 @@ struct kim_data_s {
 	enum proto_type rf_protos[ST_MAX];
 	struct st_data_s *core_data;
 	struct chip_version version;
+	struct sock *uim_nlink;
+	struct link_data_s link_data;
 };
 
 /**
-- 
1.5.6.3

