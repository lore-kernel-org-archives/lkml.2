Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1AFAEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:04:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:60668 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407Ab1AFAES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:04:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,280,1291622400"; 
   d="scan'208";a="874833931"
From: Russ Gorby <russ.gorby@intel.com>
To: Greg@vger.kernel.org, Kroah-Hartman@vger.kernel.org, <gregkh@suse.de>,
        Vasiliy@vger.kernel.org, Kulikov@vger.kernel.org,
        <segoon@openwall.com>, Alan@vger.kernel.org, Cox@vger.kernel.org,
        <alan@linux.intel.com>, Russ@vger.kernel.org, Gorby@vger.kernel.org,
        <richardx.r.gorby@intel.com>, linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com
Subject: [PATCH 6/7] serial: ifx6x60: fix modem names to ones recognized by firmware
Date: Wed,  5 Jan 2011 16:05:12 -0800
Message-Id: <1294272313-15899-7-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <[PATCH 0/7] IFX6X60 patchset: 01/05/2011>
References: <[PATCH 0/7] IFX6X60 patchset: 01/05/2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current strings used in ID table are not correct and prevent
protocol driver connecting to controller driver.
Also, the indication of which modem h/w is present is not
currently provided by the platform data.

Changed ifx_id_table[] to use strings recognized by platform firmware

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
---
 drivers/serial/ifx6x60.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/ifx6x60.c b/drivers/serial/ifx6x60.c
index 6dfb47a..5a0321a 100644
--- a/drivers/serial/ifx6x60.c
+++ b/drivers/serial/ifx6x60.c
@@ -81,6 +81,10 @@ static int spi_bpw = 16;		/* 8, 16 or 32 bit word length */
 static struct tty_driver *tty_drv;
 static struct ifx_spi_device *saved_ifx_dev;
 static struct lock_class_key ifx_spi_key;
+enum ifx_mdm {
+	IFX_6160 = 1,
+	IFX_6260,
+};
 
 /* GPIO/GPE settings */
 
@@ -984,7 +988,10 @@ static int ifx_spi_spi_probe(struct spi_device *spi)
 	init_timer(&ifx_dev->spi_timer);
 	ifx_dev->spi_timer.function = ifx_spi_timeout;
 	ifx_dev->spi_timer.data = (unsigned long)ifx_dev;
+	/* FIXME: platform data does not currently supply this information
 	ifx_dev->is_6160 = pl_data->is_6160;
+	*/
+	ifx_dev->is_6160 = (spi_get_device_id(spi)->driver_data == IFX_6160);
 	/* initialize spi mode, etc */
 	if (ifx_dev->is_6160)
 		spi->max_speed_hz = 12500000;
@@ -1328,8 +1335,8 @@ static const struct dev_pm_ops ifx_spi_pm = {
 };
 
 static const struct spi_device_id ifx_id_table[] = {
-	{"ifx6160", 0},
-	{"ifx6260", 0},
+	{ "spi_6160_modem", IFX_6160 },
+	{ "spi_6260_modem", IFX_6260 },
 	{ }
 };
 MODULE_DEVICE_TABLE(spi, ifx_id_table);
-- 
1.7.2.3

