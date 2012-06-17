Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab2FQUZy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 16:25:54 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:46786 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757988Ab2FQUZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 16:25:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: platform-driver-x86@vger.kernel.org
Subject: [PATCH 2/5] thinkpad_acpi: Use struct dev_pm_ops instead of legacy PM routines
Date: Sun, 17 Jun 2012 22:27:56 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Joey Lee <jlee@novell.com>
References: <201206172226.42729.rjw@sisk.pl>
In-Reply-To: <201206172226.42729.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206172227.57189.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the thinkpad_acpi driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct platform_driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/platform/x86/thinkpad_acpi.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux/drivers/platform/x86/thinkpad_acpi.c
===================================================================
--- linux.orig/drivers/platform/x86/thinkpad_acpi.c
+++ linux/drivers/platform/x86/thinkpad_acpi.c
@@ -922,8 +922,7 @@ static struct input_dev *tpacpi_inputdev
 static struct mutex tpacpi_inputdev_send_mutex;
 static LIST_HEAD(tpacpi_all_drivers);
 
-static int tpacpi_suspend_handler(struct platform_device *pdev,
-				  pm_message_t state)
+static int tpacpi_suspend_handler(struct device *dev)
 {
 	struct ibm_struct *ibm, *itmp;
 
@@ -937,7 +936,7 @@ static int tpacpi_suspend_handler(struct
 	return 0;
 }
 
-static int tpacpi_resume_handler(struct platform_device *pdev)
+static int tpacpi_resume_handler(struct device *dev)
 {
 	struct ibm_struct *ibm, *itmp;
 
@@ -951,6 +950,9 @@ static int tpacpi_resume_handler(struct
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(tpacpi_pm,
+			 tpacpi_suspend_handler, tpacpi_resume_handler);
+
 static void tpacpi_shutdown_handler(struct platform_device *pdev)
 {
 	struct ibm_struct *ibm, *itmp;
@@ -967,9 +969,8 @@ static struct platform_driver tpacpi_pdr
 	.driver = {
 		.name = TPACPI_DRVR_NAME,
 		.owner = THIS_MODULE,
+		.pm = &tpacpi_pm,
 	},
-	.suspend = tpacpi_suspend_handler,
-	.resume = tpacpi_resume_handler,
 	.shutdown = tpacpi_shutdown_handler,
 };
 

