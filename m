Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab1HZUgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:36:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091Ab1HZUeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:34:19 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pavan Savoy <pavan_savoy@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/13] drivers:misc:ti-st: platform hooks for chip states
Date: Fri, 26 Aug 2011 13:33:48 -0700
Message-Id: <1314390834-3411-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314390834-3411-1-git-send-email-gregkh@suse.de>
References: <20110826191130.GA5557@kroah.com>
 <1314390834-3411-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Certain platform specific or Host-WiLink Interface specific actions would be
required to be taken when the chip is being enabled and after the chip is
disabled such as configuration of the mux modes for the GPIO of host connected
to the nshutdown of the chip or relinquishing UART after the chip is disabled.

Similar actions can also be taken when the chip is in deep sleep or when the
chip is awake. Performance enhancements such as configuring the host to run
faster when chip is awake and slower when chip is asleep can also be made
here.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/ti-st/st_kim.c  |   12 ++++++++++++
 drivers/misc/ti-st/st_ll.c   |   19 +++++++++++++++++++
 include/linux/ti_wilink_st.h |   27 ++++++++++++++++++++++++++-
 3 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 38fd2f0..6884dd1 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -434,11 +434,17 @@ long st_kim_start(void *kim_data)
 {
 	long err = 0;
 	long retry = POR_RETRY_COUNT;
+	struct ti_st_plat_data	*pdata;
 	struct kim_data_s	*kim_gdata = (struct kim_data_s *)kim_data;
 
 	pr_info(" %s", __func__);
+	pdata = kim_gdata->kim_pdev->dev.platform_data;
 
 	do {
+		/* platform specific enabling code here */
+		if (pdata->chip_enable)
+			pdata->chip_enable(kim_gdata);
+
 		/* Configure BT nShutdown to HIGH state */
 		gpio_set_value(kim_gdata->nshutdown, GPIO_LOW);
 		mdelay(5);	/* FIXME: a proper toggle */
@@ -489,6 +495,8 @@ long st_kim_stop(void *kim_data)
 {
 	long err = 0;
 	struct kim_data_s	*kim_gdata = (struct kim_data_s *)kim_data;
+	struct ti_st_plat_data	*pdata =
+		kim_gdata->kim_pdev->dev.platform_data;
 
 	INIT_COMPLETION(kim_gdata->ldisc_installed);
 
@@ -515,6 +523,10 @@ long st_kim_stop(void *kim_data)
 	gpio_set_value(kim_gdata->nshutdown, GPIO_HIGH);
 	mdelay(1);
 	gpio_set_value(kim_gdata->nshutdown, GPIO_LOW);
+
+	/* platform specific disable */
+	if (pdata->chip_disable)
+		pdata->chip_disable(kim_gdata);
 	return err;
 }
 
diff --git a/drivers/misc/ti-st/st_ll.c b/drivers/misc/ti-st/st_ll.c
index 3f24951..1ff460a 100644
--- a/drivers/misc/ti-st/st_ll.c
+++ b/drivers/misc/ti-st/st_ll.c
@@ -22,6 +22,7 @@
 #define pr_fmt(fmt) "(stll) :" fmt
 #include <linux/skbuff.h>
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/ti_wilink_st.h>
 
 /**********************************************************************/
@@ -37,6 +38,9 @@ static void send_ll_cmd(struct st_data_s *st_data,
 
 static void ll_device_want_to_sleep(struct st_data_s *st_data)
 {
+	struct kim_data_s	*kim_data;
+	struct ti_st_plat_data	*pdata;
+
 	pr_debug("%s", __func__);
 	/* sanity check */
 	if (st_data->ll_state != ST_LL_AWAKE)
@@ -46,10 +50,19 @@ static void ll_device_want_to_sleep(struct st_data_s *st_data)
 	send_ll_cmd(st_data, LL_SLEEP_ACK);
 	/* update state */
 	st_data->ll_state = ST_LL_ASLEEP;
+
+	/* communicate to platform about chip asleep */
+	kim_data = st_data->kim_data;
+	pdata = kim_data->kim_pdev->dev.platform_data;
+	if (pdata->chip_asleep)
+		pdata->chip_asleep(NULL);
 }
 
 static void ll_device_want_to_wakeup(struct st_data_s *st_data)
 {
+	struct kim_data_s	*kim_data;
+	struct ti_st_plat_data	*pdata;
+
 	/* diff actions in diff states */
 	switch (st_data->ll_state) {
 	case ST_LL_ASLEEP:
@@ -70,6 +83,12 @@ static void ll_device_want_to_wakeup(struct st_data_s *st_data)
 	}
 	/* update state */
 	st_data->ll_state = ST_LL_AWAKE;
+
+	/* communicate to platform about chip wakeup */
+	kim_data = st_data->kim_data;
+	pdata = kim_data->kim_pdev->dev.platform_data;
+	if (pdata->chip_asleep)
+		pdata->chip_awake(NULL);
 }
 
 /**********************************************************************/
diff --git a/include/linux/ti_wilink_st.h b/include/linux/ti_wilink_st.h
index b004e55..2ef4385 100644
--- a/include/linux/ti_wilink_st.h
+++ b/include/linux/ti_wilink_st.h
@@ -410,7 +410,28 @@ struct gps_event_hdr {
 	u16 plen;
 } __attribute__ ((packed));
 
-/* platform data */
+/**
+ * struct ti_st_plat_data - platform data shared between ST driver and
+ *	platform specific board file which adds the ST device.
+ * @nshutdown_gpio: Host's GPIO line to which chip's BT_EN is connected.
+ * @dev_name: The UART/TTY name to which chip is interfaced. (eg: /dev/ttyS1)
+ * @flow_cntrl: Should always be 1, since UART's CTS/RTS is used for PM
+ *	purposes.
+ * @baud_rate: The baud rate supported by the Host UART controller, this will
+ *	be shared across with the chip via a HCI VS command from User-Space Init
+ *	Mgr application.
+ * @suspend:
+ * @resume: legacy PM routines hooked to platform specific board file, so as
+ *	to take chip-host interface specific action.
+ * @chip_enable:
+ * @chip_disable: Platform/Interface specific mux mode setting, GPIO
+ *	configuring, Host side PM disabling etc.. can be done here.
+ * @chip_asleep:
+ * @chip_awake: Chip specific deep sleep states is communicated to Host
+ *	specific board-xx.c to take actions such as cut UART clocks when chip
+ *	asleep or run host faster when chip awake etc..
+ *
+ */
 struct ti_st_plat_data {
 	long nshutdown_gpio;
 	unsigned char dev_name[UART_DEV_NAME_LEN]; /* uart name */
@@ -418,6 +439,10 @@ struct ti_st_plat_data {
 	unsigned long baud_rate;
 	int (*suspend)(struct platform_device *, pm_message_t);
 	int (*resume)(struct platform_device *);
+	int (*chip_enable) (struct kim_data_s *);
+	int (*chip_disable) (struct kim_data_s *);
+	int (*chip_asleep) (struct kim_data_s *);
+	int (*chip_awake) (struct kim_data_s *);
 };
 
 #endif /* TI_WILINK_ST_H */
-- 
1.7.6.1

