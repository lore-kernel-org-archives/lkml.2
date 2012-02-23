Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab2BWU6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:58:19 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54869 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757016Ab2BWU6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:58:16 -0500
Date: Thu, 23 Feb 2012 12:58:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: deepthi@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH RFC] acpi: Fix unprotected smp_processor_id() in
 acpi_processor_cst_has_changed()
Message-ID: <20120223205805.GA31838@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022320-7182-0000-0000-000000E07EF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The acpi_processor_cst_has_changed() function is invoked from a
CPU_ONLINE or CPU_DEAD function, which might well execute on CPU 0
even though the CPU being hotplugged is some other CPU.  In addition,
acpi_processor_cst_has_changed() invokes smp_processor_id() without
protection, resulting in splats when onlining CPUs.

This commit therefore changes the smp_processor_id() to pr->id, as is
used elsewhere in the code, for example, in acpi_processor_add().

This works for me, but I don't claim to understand ACPI.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 0e8e2de..9e57b06 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1159,8 +1159,7 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
 	 * to make the code that updates C-States be called once.
 	 */
 
-	if (smp_processor_id() == 0 &&
-			cpuidle_get_driver() == &acpi_idle_driver) {
+	if (pr->id == 0 && cpuidle_get_driver() == &acpi_idle_driver) {
 
 		cpuidle_pause_and_lock();
 		/* Protect against cpu-hotplug */

