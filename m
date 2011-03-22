Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab1CVUup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:50:45 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:58542 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219Ab1CVUuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:50:44 -0400
Date: Tue, 22 Mar 2011 13:50:39 -0700
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: dsd@laptop.org, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH] mfd: OLPC: clean up names to match what OLPC actually uses
Message-ID: <20110322135039.30abb244@queued.net>
In-Reply-To: <20110321191935.7ddf0a70@queued.net>
References: <20110321191935.7ddf0a70@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Daniel Drake <dsd@laptop.org>

The cs5535-pms cell doesn't actually need to be cloned, so we can drop that
and simply have the olpc-xo1.c driver use "cs5535-pms" directly.

Also, rename the cs5535-acpi clones to what we actually use for the (currently
out-of-tree) SCI driver.  In the process, that fixes a subtle bug in
olpc-xo1.c which broke powerdown on XO-1s.. olpc-xo1-ac-acpi was a typo, not
something that actually existed.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Andres Salomon <dilinger@queued.net>
---
This is on top of my prior mfd_clone_cell patch.  I'll leave it up to
Samuel to determine if it should be merged with it, or separate.

 arch/x86/platform/olpc/olpc-xo1.c |   12 ++++++------
 drivers/mfd/cs5535-mfd.c          |    4 +---
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/platform/olpc/olpc-xo1.c b/arch/x86/platform/olpc/olpc-xo1.c
index 386e3a1..ab81fb2 100644
--- a/arch/x86/platform/olpc/olpc-xo1.c
+++ b/arch/x86/platform/olpc/olpc-xo1.c
@@ -72,9 +72,9 @@ static int __devinit olpc_xo1_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "can't fetch device resource info\n");
 		return -EIO;
 	}
-	if (strcmp(pdev->name, "olpc-xo1-pms") == 0)
+	if (strcmp(pdev->name, "cs5535-pms") == 0)
 		pms_base = res->start;
-	else if (strcmp(pdev->name, "olpc-xo1-ac-acpi") == 0)
+	else if (strcmp(pdev->name, "olpc-xo1-pm-acpi") == 0)
 		acpi_base = res->start;
 
 	/* If we have both addresses, we can override the poweroff hook */
@@ -90,9 +90,9 @@ static int __devexit olpc_xo1_remove(struct platform_device *pdev)
 {
 	mfd_cell_disable(pdev);
 
-	if (strcmp(pdev->name, "olpc-xo1-pms") == 0)
+	if (strcmp(pdev->name, "cs5535-pms") == 0)
 		pms_base = 0;
-	else if (strcmp(pdev->name, "olpc-xo1-acpi") == 0)
+	else if (strcmp(pdev->name, "olpc-xo1-pm-acpi") == 0)
 		acpi_base = 0;
 
 	pm_power_off = NULL;
@@ -101,7 +101,7 @@ static int __devexit olpc_xo1_remove(struct platform_device *pdev)
 
 static struct platform_driver cs5535_pms_drv = {
 	.driver = {
-		.name = "olpc-xo1-pms",
+		.name = "cs5535-pms",
 		.owner = THIS_MODULE,
 	},
 	.probe = olpc_xo1_probe,
@@ -110,7 +110,7 @@ static struct platform_driver cs5535_pms_drv = {
 
 static struct platform_driver cs5535_acpi_drv = {
 	.driver = {
-		.name = "olpc-xo1-acpi",
+		.name = "olpc-xo1-pm-acpi",
 		.owner = THIS_MODULE,
 	},
 	.probe = olpc_xo1_probe,
diff --git a/drivers/mfd/cs5535-mfd.c b/drivers/mfd/cs5535-mfd.c
index 24959dd..155fa04 100644
--- a/drivers/mfd/cs5535-mfd.c
+++ b/drivers/mfd/cs5535-mfd.c
@@ -115,14 +115,12 @@ static __devinitdata struct mfd_cell cs5535_mfd_cells[] = {
 #ifdef CONFIG_OLPC
 static void __devinit cs5535_clone_olpc_cells(void)
 {
-	const char *acpi_clones[] = { "olpc-xo1-acpi" };
-	const char *pms_clones[] = { "olpc-xo1-pms" };
+	const char *acpi_clones[] = { "olpc-xo1-pm-acpi", "olpc-xo1-sci-acpi" };
 
 	if (!machine_is_olpc())
 		return;
 
 	mfd_clone_cell("cs5535-acpi", acpi_clones, ARRAY_SIZE(acpi_clones));
-	mfd_clone_cell("cs5535-pms", pms_clones, ARRAY_SIZE(pms_clones));
 }
 #else
 static void cs5535_clone_olpc_cells(void) { }
