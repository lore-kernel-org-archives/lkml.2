Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab1HZKuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 06:50:32 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56357 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1HZKub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 06:50:31 -0400
Date: Fri, 26 Aug 2011 12:50:28 +0200
From: Borislav Petkov <bp@amd64.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/8] x86, mce: stop calling del_timer_sync() from
 interrupt
Message-ID: <20110826105028.GB9510@aftab>
References: <4DFB1242.90404@jp.fujitsu.com>
 <4DFB1304.10604@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFB1304.10604@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 04:40:36AM -0400, Hidetoshi Seto wrote:
> Function del_timer_sync() has WARN_ON(in_irq()) in it because
> calling it from interrupt context can cause deadlock if it
> interrupts the target timer running.
> 
> In MCE code, del_timer_sync() is used with on_each_cpu() in
> some parts for sysfs files:
>   bank*, check_interval, cmci_disabled and ignore_ce.
> 
> However use of on_each_cpu() results in calling the function
> passed as the argument in the interrupt context.  It means you
> can see a flood of warnings from del_timer_sync() by a simple
> file access, for example:
> 
>   echo 300 > /sys/devices/system/machinecheck/machinecheck0/check_interval
> 
> Fortunately these MCE specific files are rare-used and AFAIK
> only few MCE geeks experience this warning on write.
> 
> To remove the warning (for my happy hacking), move timer deletion
> outside of the interrupt context ;-)

I'm hitting this warning too in my testing here so I'd like to expedite
this patch going in. I'll send the version below upstream next week if
there are no objections:

--
>From 0e4fe50cd4ed6f5990173f4587ad07dd4782fa30 Mon Sep 17 00:00:00 2001
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Date: Fri, 17 Jun 2011 04:40:36 -0400
Subject: [PATCH] x86, mce: Do not call del_timer_sync() in IRQ context

del_timer_sync() can cause a deadlock when called in interrupt context.
It is used with on_each_cpu() in some parts for sysfs files like bank*,
check_interval, cmci_disabled and ignore_ce.

However, use of on_each_cpu() results in calling the function passed
as the argument in interrupt context. This causes a flood of nested
warnings from del_timer_sync() (it runs on each CPU) caused even by a
simple file access like:

$ echo 300 > /sys/devices/system/machinecheck/machinecheck0/check_interval

Fortunately, these MCE-specific files are rarely used and AFAIK only few
MCE geeks experience this warning.

To remove the warning, move timer deletion outside of the interrupt
context.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 08363b0..5b5ccee 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1140,6 +1140,15 @@ static void mce_start_timer(unsigned long data)
 	add_timer_on(t, smp_processor_id());
 }
 
+/* Must not be called in IRQ context where del_timer_sync() can deadlock */
+static void mce_timer_delete_all(void)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		del_timer_sync(&per_cpu(mce_timer, cpu));
+}
+
 static void mce_do_trigger(struct work_struct *work)
 {
 	call_usermodehelper(mce_helper, mce_helper_argv, NULL, UMH_NO_WAIT);
@@ -1750,7 +1759,6 @@ static struct syscore_ops mce_syscore_ops = {
 
 static void mce_cpu_restart(void *data)
 {
-	del_timer_sync(&__get_cpu_var(mce_timer));
 	if (!mce_available(__this_cpu_ptr(&cpu_info)))
 		return;
 	__mcheck_cpu_init_generic();
@@ -1760,16 +1768,15 @@ static void mce_cpu_restart(void *data)
 /* Reinit MCEs after user configuration changes */
 static void mce_restart(void)
 {
+	mce_timer_delete_all();
 	on_each_cpu(mce_cpu_restart, NULL, 1);
 }
 
 /* Toggle features for corrected errors */
-static void mce_disable_ce(void *all)
+static void mce_disable_cmci(void *data)
 {
 	if (!mce_available(__this_cpu_ptr(&cpu_info)))
 		return;
-	if (all)
-		del_timer_sync(&__get_cpu_var(mce_timer));
 	cmci_clear();
 }
 
@@ -1852,7 +1859,8 @@ static ssize_t set_ignore_ce(struct sys_device *s,
 	if (mce_ignore_ce ^ !!new) {
 		if (new) {
 			/* disable ce features */
-			on_each_cpu(mce_disable_ce, (void *)1, 1);
+			mce_timer_delete_all();
+			on_each_cpu(mce_disable_cmci, NULL, 1);
 			mce_ignore_ce = 1;
 		} else {
 			/* enable ce features */
@@ -1875,7 +1883,7 @@ static ssize_t set_cmci_disabled(struct sys_device *s,
 	if (mce_cmci_disabled ^ !!new) {
 		if (new) {
 			/* disable cmci */
-			on_each_cpu(mce_disable_ce, NULL, 1);
+			on_each_cpu(mce_disable_cmci, NULL, 1);
 			mce_cmci_disabled = 1;
 		} else {
 			/* enable cmci */
-- 
1.7.4.rc2


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
