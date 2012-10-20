Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab2JTEqe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 00:46:34 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:48955 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2JTEqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 00:46:32 -0400
Date: Sat, 20 Oct 2012 07:46:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: [patch] clocksource: clean up parse_pmtmr()
Message-ID: <20121020034948.GV5685@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I changed the strict_strtoul() to kstrtouint().  That has the check
for UINT_MAX built in to it so the ifdefs can be removed.  Also
I changed a printk() to pr_info().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index 6b5cf02..5d1b926 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -233,16 +233,15 @@ fs_initcall(init_acpi_pm_clocksource);
  */
 static int __init parse_pmtmr(char *arg)
 {
-	unsigned long base;
+	unsigned int base;
+	int ret;
 
-	if (strict_strtoul(arg, 16, &base))
-		return -EINVAL;
-#ifdef CONFIG_X86_64
-	if (base > UINT_MAX)
-		return -ERANGE;
-#endif
-	printk(KERN_INFO "PMTMR IOPort override: 0x%04x -> 0x%04lx\n",
-	       pmtmr_ioport, base);
+	ret = kstrtouint(arg, 16, &base);
+	if (ret)
+		return ret;
+
+	pr_info("PMTMR IOPort override: 0x%04x -> 0x%04x\n", pmtmr_ioport,
+		base);
 	pmtmr_ioport = base;
 
 	return 1;
