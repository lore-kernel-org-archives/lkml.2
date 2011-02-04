Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1BDIYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 03:24:05 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45526 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab1BDIXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 03:23:22 -0500
From: pavan_savoy@ti.com
To: linux-kernel@vger.kernel.org, gregkh@suse.de
Cc: Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 2/7] drivers:misc: ti-st: move from rfkill to sysfs
Date: Fri,  4 Feb 2011 02:23:10 -0600
Message-Id: <1296807795-5408-3-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1296807795-5408-2-git-send-email-pavan_savoy@ti.com>
References: <1296807795-5408-1-git-send-email-pavan_savoy@ti.com>
 <1296807795-5408-2-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

The communication between ST KIM and UIM was interfaced
over the /dev/rfkill device node.
Move the interface to a simpler less abusive sysfs entry
mechanism and document it in Documentation/ABI/testing/
under sysfs-platform-kim.

Shared transport driver would now read the UART details
originally received by bootloader or firmware as platform
data.
The data read will be shared over sysfs entries for the user-space
UIM or other n/w manager/plugins to be read, and assist the driver
by opening up the UART, setting the baud-rate and installing the
line discipline.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 Documentation/ABI/testing/sysfs-platform-kim |   48 +++++
 drivers/misc/ti-st/st_kim.c                  |  244 +++++++++++++-------------
 include/linux/ti_wilink_st.h                 |   19 ++-
 3 files changed, 186 insertions(+), 125 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-kim

diff --git a/Documentation/ABI/testing/sysfs-platform-kim b/Documentation/ABI/testing/sysfs-platform-kim
new file mode 100644
index 0000000..c165327
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-platform-kim
@@ -0,0 +1,48 @@
+What:		/sys/devices/platform/kim/dev_name
+Date:		January 2010
+KernelVersion:	2.6.38
+Contact:	"Pavan Savoy" <pavan_savoy@ti.com>
+Description:
+		Name of the UART device at which the WL128x chip
+		is connected. example: "/dev/ttyS0".
+		The device name flows down to architecture specific board
+		initialization file from the SFI/ATAGS bootloader
+		firmware. The name exposed is read from the user-space
+		dameon and opens the device when install is requested.
+
+What:		/sys/devices/platform/kim/baud_rate
+Date:		January 2010
+KernelVersion:	2.6.38
+Contact:	"Pavan Savoy" <pavan_savoy@ti.com>
+Description:
+		The maximum reliable baud-rate the host can support.
+		Different platforms tend to have different high-speed
+		UART configurations, so the baud-rate needs to be set
+		locally and also sent across to the WL128x via a HCI-VS
+		command. The entry is read and made use by the user-space
+		daemon when the ldisc install is requested.
+
+What:		/sys/devices/platform/kim/flow_cntrl
+Date:		January 2010
+KernelVersion:	2.6.38
+Contact:	"Pavan Savoy" <pavan_savoy@ti.com>
+Description:
+		The WL128x makes use of flow control mechanism, and this
+		entry most often should be 1, the host's UART is required
+		to have the capability of flow-control, or else this
+		entry can be made use of for exceptions.
+
+What:		/sys/devices/platform/kim/install
+Date:		January 2010
+KernelVersion:	2.6.38
+Contact:	"Pavan Savoy" <pavan_savoy@ti.com>
+Description:
+		When one of the protocols Bluetooth, FM or GPS wants to make
+		use of the shared UART transport, it registers to the shared
+		transport driver, which will signal the user-space for opening,
+		configuring baud and install line discipline via this sysfs
+		entry. This entry would be polled upon by the user-space
+		daemon managing the UART, and is notified about the change
+		by the sysfs_notify. The value would be '1' when UART needs
+		to be opened/ldisc installed, and would be '0' when UART
+		is no more required and needs to be closed.
diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 707c858..a7fda81 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -30,46 +30,12 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/sched.h>
-#include <linux/rfkill.h>
+#include <linux/tty.h>
 
 #include <linux/skbuff.h>
 #include <linux/ti_wilink_st.h>
 
 
-static int kim_probe(struct platform_device *pdev);
-static int kim_remove(struct platform_device *pdev);
-
-/* KIM platform device driver structure */
-static struct platform_driver kim_platform_driver = {
-	.probe = kim_probe,
-	.remove = kim_remove,
-	/* TODO: ST driver power management during suspend/resume ?
-	 */
-#if 0
-	.suspend = kim_suspend,
-	.resume = kim_resume,
-#endif
-	.driver = {
-		   .name = "kim",
-		   .owner = THIS_MODULE,
-		   },
-};
-
-static int kim_toggle_radio(void*, bool);
-static const struct rfkill_ops kim_rfkill_ops = {
-	.set_block = kim_toggle_radio,
-};
-
-/* strings to be used for rfkill entries and by
- * ST Core to be used for sysfs debug entry
- */
-#define PROTO_ENTRY(type, name)	name
-const unsigned char *protocol_names[] = {
-	PROTO_ENTRY(ST_BT, "Bluetooth"),
-	PROTO_ENTRY(ST_FM, "FM"),
-	PROTO_ENTRY(ST_GPS, "GPS"),
-};
-
 #define MAX_ST_DEVICES	3	/* Imagine 1 on each UART for now */
 static struct platform_device *st_kim_devices[MAX_ST_DEVICES];
 
@@ -371,8 +337,7 @@ void st_kim_chip_toggle(enum proto_type type, enum kim_gpio_state state)
 	kim_gdata = dev_get_drvdata(&kim_pdev->dev);
 
 	if (kim_gdata->gpios[type] == -1) {
-		pr_info(" gpio not requested for protocol %s",
-			   protocol_names[type]);
+		pr_info("gpio not requested for protocol %d", type);
 		return;
 	}
 	switch (type) {
@@ -450,11 +415,6 @@ long st_kim_start(void *kim_data)
 	pr_info(" %s", __func__);
 
 	do {
-		/* TODO: this is only because rfkill sub-system
-		 * doesn't send events to user-space if the state
-		 * isn't changed
-		 */
-		rfkill_set_hw_state(kim_gdata->rfkill[ST_BT], 1);
 		/* Configure BT nShutdown to HIGH state */
 		gpio_set_value(kim_gdata->gpios[ST_BT], GPIO_LOW);
 		mdelay(5);	/* FIXME: a proper toggle */
@@ -462,22 +422,20 @@ long st_kim_start(void *kim_data)
 		mdelay(100);
 		/* re-initialize the completion */
 		INIT_COMPLETION(kim_gdata->ldisc_installed);
-#if 0 /* older way of signalling user-space UIM */
-		/* send signal to UIM */
-		err = kill_pid(find_get_pid(kim_gdata->uim_pid), SIGUSR2, 0);
-		if (err != 0) {
-			pr_info(" sending SIGUSR2 to uim failed %ld", err);
-			err = -1;
-			continue;
-		}
-#endif
-		/* unblock and send event to UIM via /dev/rfkill */
-		rfkill_set_hw_state(kim_gdata->rfkill[ST_BT], 0);
+		/* send notification to UIM */
+		kim_gdata->ldisc_install = 1;
+		pr_info("ldisc_install = 1");
+		sysfs_notify(&kim_gdata->kim_pdev->dev.kobj,
+				NULL, "install");
 		/* wait for ldisc to be installed */
 		err = wait_for_completion_timeout(&kim_gdata->ldisc_installed,
 				msecs_to_jiffies(LDISC_TIME));
 		if (!err) {	/* timeout */
 			pr_err("line disc installation timed out ");
+			kim_gdata->ldisc_install = 0;
+			pr_info("ldisc_install = 0");
+			sysfs_notify(&kim_gdata->kim_pdev->dev.kobj,
+					NULL, "install");
 			err = -1;
 			continue;
 		} else {
@@ -486,6 +444,10 @@ long st_kim_start(void *kim_data)
 			err = download_firmware(kim_gdata);
 			if (err != 0) {
 				pr_err("download firmware failed");
+				kim_gdata->ldisc_install = 0;
+				pr_info("ldisc_install = 0");
+				sysfs_notify(&kim_gdata->kim_pdev->dev.kobj,
+						NULL, "install");
 				continue;
 			} else {	/* on success don't retry */
 				break;
@@ -505,16 +467,15 @@ long st_kim_stop(void *kim_data)
 	struct kim_data_s	*kim_gdata = (struct kim_data_s *)kim_data;
 
 	INIT_COMPLETION(kim_gdata->ldisc_installed);
-#if 0 /* older way of signalling user-space UIM */
-	/* send signal to UIM */
-	err = kill_pid(find_get_pid(kim_gdata->uim_pid), SIGUSR2, 1);
-	if (err != 0) {
-		pr_err("sending SIGUSR2 to uim failed %ld", err);
-		return -1;
-	}
-#endif
-	/* set BT rfkill to be blocked */
-	err = rfkill_set_hw_state(kim_gdata->rfkill[ST_BT], 1);
+
+	/* Flush any pending characters in the driver and discipline. */
+	tty_ldisc_flush(kim_gdata->core_data->tty);
+	tty_driver_flush_buffer(kim_gdata->core_data->tty);
+
+	/* send uninstall notification to UIM */
+	pr_info("ldisc_install = 0");
+	kim_gdata->ldisc_install = 0;
+	sysfs_notify(&kim_gdata->kim_pdev->dev.kobj, NULL, "install");
 
 	/* wait for ldisc to be un-installed */
 	err = wait_for_completion_timeout(&kim_gdata->ldisc_installed,
@@ -553,33 +514,59 @@ static int show_list(struct seq_file *s, void *unused)
 	return 0;
 }
 
-/* function called from rfkill subsystem, when someone from
- * user space would write 0/1 on the sysfs entry
- * /sys/class/rfkill/rfkill0,1,3/state
- */
-static int kim_toggle_radio(void *data, bool blocked)
+static ssize_t show_install(struct device *dev,
+		struct device_attribute *attr, char *buf)
 {
-	enum proto_type type = *((enum proto_type *)data);
-	pr_debug(" %s: %d ", __func__, type);
+	struct kim_data_s *kim_data = dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", kim_data->ldisc_install);
+}
 
-	switch (type) {
-	case ST_BT:
-		/* do nothing */
-	break;
-	case ST_FM:
-	case ST_GPS:
-		if (blocked)
-			st_kim_chip_toggle(type, KIM_GPIO_INACTIVE);
-		else
-			st_kim_chip_toggle(type, KIM_GPIO_ACTIVE);
-	break;
-	case ST_MAX_CHANNELS:
-		pr_err(" wrong proto type ");
-	break;
-	}
-	return 0;
+static ssize_t show_dev_name(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct kim_data_s *kim_data = dev_get_drvdata(dev);
+	return sprintf(buf, "%s\n", kim_data->dev_name);
+}
+
+static ssize_t show_baud_rate(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct kim_data_s *kim_data = dev_get_drvdata(dev);
+	return sprintf(buf, "%ld\n", kim_data->baud_rate);
+}
+
+static ssize_t show_flow_cntrl(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct kim_data_s *kim_data = dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", kim_data->flow_cntrl);
 }
 
+/* structures specific for sysfs entries */
+static struct kobj_attribute ldisc_install =
+__ATTR(install, 0444, (void *)show_install, NULL);
+
+static struct kobj_attribute uart_dev_name =
+__ATTR(dev_name, 0444, (void *)show_dev_name, NULL);
+
+static struct kobj_attribute uart_baud_rate =
+__ATTR(baud_rate, 0444, (void *)show_baud_rate, NULL);
+
+static struct kobj_attribute uart_flow_cntrl =
+__ATTR(flow_cntrl, 0444, (void *)show_flow_cntrl, NULL);
+
+static struct attribute *uim_attrs[] = {
+	&ldisc_install.attr,
+	&uart_dev_name.attr,
+	&uart_baud_rate.attr,
+	&uart_flow_cntrl.attr,
+	NULL,
+};
+
+static struct attribute_group uim_attr_grp = {
+	.attrs = uim_attrs,
+};
+
 /**
  * st_kim_ref - reference the core's data
  *	This references the per-ST platform device in the arch/xx/
@@ -633,8 +620,9 @@ static int kim_probe(struct platform_device *pdev)
 {
 	long status;
 	long proto;
-	long *gpios = pdev->dev.platform_data;
 	struct kim_data_s	*kim_gdata;
+	struct ti_st_plat_data	*pdata = pdev->dev.platform_data;
+	long *gpios = pdata->gpios;
 
 	if ((pdev->id != -1) && (pdev->id < MAX_ST_DEVICES)) {
 		/* multiple devices could exist */
@@ -700,30 +688,18 @@ static int kim_probe(struct platform_device *pdev)
 	init_completion(&kim_gdata->kim_rcvd);
 	init_completion(&kim_gdata->ldisc_installed);
 
-	for (proto = 0; (proto < ST_MAX_CHANNELS)
-			&& (gpios[proto] != -1); proto++) {
-		/* TODO: should all types be rfkill_type_bt ? */
-		kim_gdata->rf_protos[proto] = proto;
-		kim_gdata->rfkill[proto] = rfkill_alloc(protocol_names[proto],
-			&pdev->dev, RFKILL_TYPE_BLUETOOTH,
-			&kim_rfkill_ops, &kim_gdata->rf_protos[proto]);
-		if (kim_gdata->rfkill[proto] == NULL) {
-			pr_err("cannot create rfkill entry for gpio %ld",
-				   gpios[proto]);
-			continue;
-		}
-		/* block upon creation */
-		rfkill_init_sw_state(kim_gdata->rfkill[proto], 1);
-		status = rfkill_register(kim_gdata->rfkill[proto]);
-		if (unlikely(status)) {
-			pr_err("rfkill registration failed for gpio %ld",
-				   gpios[proto]);
-			rfkill_unregister(kim_gdata->rfkill[proto]);
-			continue;
-		}
-		pr_info("rfkill entry created for %ld", gpios[proto]);
+	status = sysfs_create_group(&pdev->dev.kobj, &uim_attr_grp);
+	if (status) {
+		pr_err("failed to create sysfs entries");
+		return status;
 	}
 
+	/* copying platform data */
+	strncpy(kim_gdata->dev_name, pdata->dev_name, UART_DEV_NAME_LEN);
+	kim_gdata->flow_cntrl = pdata->flow_cntrl;
+	kim_gdata->baud_rate = pdata->baud_rate;
+	pr_info("sysfs entries created\n");
+
 	kim_debugfs_dir = debugfs_create_dir("ti-st", NULL);
 	if (IS_ERR(kim_debugfs_dir)) {
 		pr_err(" debugfs entries creation failed ");
@@ -741,9 +717,9 @@ static int kim_probe(struct platform_device *pdev)
 
 static int kim_remove(struct platform_device *pdev)
 {
-	/* free the GPIOs requested
-	 */
-	long *gpios = pdev->dev.platform_data;
+	/* free the GPIOs requested */
+	struct ti_st_plat_data	*pdata = pdev->dev.platform_data;
+	long *gpios = pdata->gpios;
 	long proto;
 	struct kim_data_s	*kim_gdata;
 
@@ -755,12 +731,11 @@ static int kim_remove(struct platform_device *pdev)
 		 * nShutdown gpio from the system
 		 */
 		gpio_free(gpios[proto]);
-		rfkill_unregister(kim_gdata->rfkill[proto]);
-		rfkill_destroy(kim_gdata->rfkill[proto]);
-		kim_gdata->rfkill[proto] = NULL;
 	}
 	pr_info("kim: GPIO Freed");
 	debugfs_remove_recursive(kim_debugfs_dir);
+
+	sysfs_remove_group(&pdev->dev.kobj, &uim_attr_grp);
 	kim_gdata->kim_pdev = NULL;
 	st_core_exit(kim_gdata->core_data);
 
@@ -769,23 +744,46 @@ static int kim_remove(struct platform_device *pdev)
 	return 0;
 }
 
+int kim_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct ti_st_plat_data	*pdata = pdev->dev.platform_data;
+
+	if (pdata->suspend)
+		return pdata->suspend(pdev, state);
+
+	return -EOPNOTSUPP;
+}
+
+int kim_resume(struct platform_device *pdev)
+{
+	struct ti_st_plat_data	*pdata = pdev->dev.platform_data;
+
+	if (pdata->resume)
+		return pdata->resume(pdev);
+
+	return -EOPNOTSUPP;
+}
+
 /**********************************************************************/
 /* entry point for ST KIM module, called in from ST Core */
+static struct platform_driver kim_platform_driver = {
+	.probe = kim_probe,
+	.remove = kim_remove,
+	.suspend = kim_suspend,
+	.resume = kim_resume,
+	.driver = {
+		.name = "kim",
+		.owner = THIS_MODULE,
+	},
+};
 
 static int __init st_kim_init(void)
 {
-	long ret = 0;
-	ret = platform_driver_register(&kim_platform_driver);
-	if (ret != 0) {
-		pr_err("platform drv registration failed");
-		return -1;
-	}
-	return 0;
+	return platform_driver_register(&kim_platform_driver);
 }
 
 static void __exit st_kim_deinit(void)
 {
-	/* the following returns void */
 	platform_driver_unregister(&kim_platform_driver);
 }
 
diff --git a/include/linux/ti_wilink_st.h b/include/linux/ti_wilink_st.h
index 1674ca7..010cda7 100644
--- a/include/linux/ti_wilink_st.h
+++ b/include/linux/ti_wilink_st.h
@@ -206,8 +206,8 @@ void gps_chrdrv_stub_init(void);
 /* time in msec to wait for
  * line discipline to be installed
  */
-#define LDISC_TIME	500
-#define CMD_RESP_TIME	500
+#define LDISC_TIME	1000
+#define CMD_RESP_TIME	800
 #define MAKEWORD(a, b)  ((unsigned short)(((unsigned char)(a)) \
 	| ((unsigned short)((unsigned char)(b))) << 8))
 
@@ -230,6 +230,7 @@ struct chip_version {
 	unsigned short maj_ver;
 };
 
+#define UART_DEV_NAME_LEN 32
 /**
  * struct kim_data_s - the KIM internal data, embedded as the
  *	platform's drv data. One for each ST device in the system.
@@ -271,6 +272,10 @@ struct kim_data_s {
 	enum proto_type rf_protos[ST_MAX_CHANNELS];
 	struct st_data_s *core_data;
 	struct chip_version version;
+	unsigned char ldisc_install;
+	unsigned char dev_name[UART_DEV_NAME_LEN];
+	unsigned char flow_cntrl;
+	unsigned long baud_rate;
 };
 
 /**
@@ -413,4 +418,14 @@ struct gps_event_hdr {
 	u16 plen;
 } __attribute__ ((packed));
 
+/* platform data */
+struct ti_st_plat_data {
+	long gpios[ST_MAX_CHANNELS]; /* BT, FM and GPS */
+	unsigned char dev_name[UART_DEV_NAME_LEN]; /* uart name */
+	unsigned char flow_cntrl; /* flow control flag */
+	unsigned long baud_rate;
+	int (*suspend)(struct platform_device *, pm_message_t);
+	int (*resume)(struct platform_device *);
+};
+
 #endif /* TI_WILINK_ST_H */
-- 
1.6.3.3

