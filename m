Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab1HITll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:41:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53985 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab1HITjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:39:16 -0400
From: <pavan_savoy@ti.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <pavan_savoy@sify.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 2/8] drivers:misc:ti-st: platform hooks for chip states
Date: Tue, 9 Aug 2011 14:39:03 -0500
Message-ID: <1312918749-29627-12-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1312918749-29627-11-git-send-email-pavan_savoy@ti.com>
References: <1312918749-29627-1-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-2-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-3-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-4-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-5-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-6-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-7-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-8-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-9-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-10-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-11-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
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

Change-Id: I5baad900633e69740396bf1d6900feec4f2b596e
Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/ti-st/st_kim.c |   12 ++++++++++++
 drivers/misc/ti-st/st_ll.c  |   19 +++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

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
-- 
1.7.4.1

