Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab1FQIlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:41:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53256 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab1FQIlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:41:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DFB1304.10604@jp.fujitsu.com>
Date: Fri, 17 Jun 2011 17:40:36 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>
Subject: [PATCH 1/8] x86, mce: stop calling del_timer_sync() from interrupt
References: <4DFB1242.90404@jp.fujitsu.com>
In-Reply-To: <4DFB1242.90404@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function del_timer_sync() has WARN_ON(in_irq()) in it because
calling it from interrupt context can cause deadlock if it
interrupts the target timer running.

In MCE code, del_timer_sync() is used with on_each_cpu() in
some parts for sysfs files:
  bank*, check_interval, cmci_disabled and ignore_ce.

However use of on_each_cpu() results in calling the function
passed as the argument in the interrupt context.  It means you
can see a flood of warnings from del_timer_sync() by a simple
file access, for example:

  echo 300 > /sys/devices/system/machinecheck/machinecheck0/check_interval

Fortunately these MCE specific files are rare-used and AFAIK
only few MCE geeks experience this warning on write.

To remove the warning (for my happy hacking), move timer deletion
outside of the interrupt context ;-)

v2: update patch description

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 08363b0..42fc8d2 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1140,6 +1140,17 @@ static void mce_start_timer(unsigned long data)
 	add_timer_on(t, smp_processor_id());
 }
 
+/* Must not be called from interrupt where del_timer_sync() can deadlock */
+static void mce_timer_delete_all(void)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		if (mce_available(&per_cpu(cpu_info, cpu)))
+			del_timer_sync(&per_cpu(mce_timer, cpu));
+	}
+}
+
 static void mce_do_trigger(struct work_struct *work)
 {
 	call_usermodehelper(mce_helper, mce_helper_argv, NULL, UMH_NO_WAIT);
@@ -1750,7 +1761,6 @@ static struct syscore_ops mce_syscore_ops = {
 
 static void mce_cpu_restart(void *data)
 {
-	del_timer_sync(&__get_cpu_var(mce_timer));
 	if (!mce_available(__this_cpu_ptr(&cpu_info)))
 		return;
 	__mcheck_cpu_init_generic();
@@ -1760,16 +1770,15 @@ static void mce_cpu_restart(void *data)
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
 
@@ -1852,7 +1861,8 @@ static ssize_t set_ignore_ce(struct sys_device *s,
 	if (mce_ignore_ce ^ !!new) {
 		if (new) {
 			/* disable ce features */
-			on_each_cpu(mce_disable_ce, (void *)1, 1);
+			mce_timer_delete_all();
+			on_each_cpu(mce_disable_cmci, NULL, 1);
 			mce_ignore_ce = 1;
 		} else {
 			/* enable ce features */
@@ -1875,7 +1885,7 @@ static ssize_t set_cmci_disabled(struct sys_device *s,
 	if (mce_cmci_disabled ^ !!new) {
 		if (new) {
 			/* disable cmci */
-			on_each_cpu(mce_disable_ce, NULL, 1);
+			on_each_cpu(mce_disable_cmci, NULL, 1);
 			mce_cmci_disabled = 1;
 		} else {
 			/* enable cmci */
-- 
1.7.1


