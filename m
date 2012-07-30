Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab2G3Inr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 04:43:47 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:62172 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab2G3Inp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 04:43:45 -0400
MIME-Version: 1.0
Date: Mon, 30 Jul 2012 16:43:44 +0800
Message-ID: <CA++bM2sg1Wj2y=9_9Hpz2-LBPJgz6_GA0Zh6JAH+zPsvKmuHuw@mail.gmail.com>
Subject: [Regression][Bisected] tick_broadcast_mask is not restored after a
 CPU is offline/onlined
From: Feng Tang <feng.79.tang@gmail.com>
To: linux-kernel@vger.kernel.org, "Paul E.McKenney" <paul.mckenney@linaro.org>,
        Len Brown <len.brown@intel.com>, "Rafael J.Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

[seems the email from my intel email address didn't hit the list,
resend with gmail, sorry for the noise]

When I debugged a suspend/resume bug, I found that tick_broadcast_mask is not
restored for a CPU after it is offline/onlined since kernel 3.4, while it's
fine for 3.3.

Further check show it is caused by the commit 9505626d7bfe
   ACPI: Fix unprotected smp_processor_id() in acpi_processor_cst_has_changed()
	
    The acpi_processor_cst_has_changed() function is invoked from a
    CPU_ONLINE or CPU_DEAD function, which might well execute on CPU 0
    even though the CPU being hotplugged is some other CPU.  In addition,
    acpi_processor_cst_has_changed() invokes smp_processor_id() without
    protection, resulting in splats when onlining CPUs.

    This commit therefore changes the smp_processor_id() to pr->id, as is
    used elsewhere in the code, for example, in acpi_processor_add().

    Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 0e8e2de..9e57b06 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1159,8 +1159,7 @@ int acpi_processor_cst_has_changed(struct
acpi_processor *pr)
         * to make the code that updates C-States be called once.
         */

-       if (smp_processor_id() == 0 &&
-                       cpuidle_get_driver() == &acpi_idle_driver) {
+       if (pr->id == 0 && cpuidle_get_driver() == &acpi_idle_driver) {

                cpuidle_pause_and_lock();
                /* Protect against cpu-hotplug */

The root cause is acpi_processor_cst_has_changed() will also be called when
cpu_up() is run on cpu 0 to boot up other cpu, this commit will prevent the
following code be run for that cpu, which triggers some side effect like the
broadcast_mask is not restored.

I raise this problem up and I don't if revert is a good solution here.

Thanks,
Feng
