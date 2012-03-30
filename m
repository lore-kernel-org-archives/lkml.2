Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760770Ab2C3MW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:22:29 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:48615 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760594Ab2C3MSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:18:24 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 69/76] ACPI: Fix unprotected smp_processor_id() in
 acpi_processor_cst_has_changed()
Date: Fri, 30 Mar 2012 06:14:12 -0400
Message-id: <9505626d7bfeb5bd4b85acb483831ac640b2a5e8.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The acpi_processor_cst_has_changed() function is invoked from a
CPU_ONLINE or CPU_DEAD function, which might well execute on CPU 0
even though the CPU being hotplugged is some other CPU.  In addition,
acpi_processor_cst_has_changed() invokes smp_processor_id() without
protection, resulting in splats when onlining CPUs.

This commit therefore changes the smp_processor_id() to pr->id, as is
used elsewhere in the code, for example, in acpi_processor_add().

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Tested-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/processor_idle.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

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
-- 
1.7.10.rc2.19.gfae9d

