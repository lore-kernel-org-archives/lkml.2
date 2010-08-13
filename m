Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761462Ab0HMKWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 06:22:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44178 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761431Ab0HMKWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 06:22:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Ynm1Gv5fjcbbZXizkHhBer6SUC4vvRsQsQOJRYqh0d3efAvDbC16qnPEZKakZDGR57
         KBtJ84jxdgpoCV6/mrEsciibgvFOypvGK/c/PsQLVqokT1bDvOicftFeFUE5CcGqgJC9
         uEDMtNPyn5+fcZD4nippVGgxeKJO5Z3LXLy/0=
Date: Fri, 13 Aug 2010 13:21:58 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: fix BUG: using smp_processor_id() in touch_nmi_watchdog and
 touch_softlockup_watchdog
Message-ID: <20100813102158.GA5434@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Got this traces today:

[   67.703556] BUG: using smp_processor_id() in preemptible [00000000] code: s2disk/5139
[   67.703563] caller is touch_nmi_watchdog+0x15/0x2c
[   67.703566] Pid: 5139, comm: s2disk Not tainted 2.6.36-rc0-git12-07921-g60bf26a-dirty #116
[   67.703568] Call Trace:
[   67.703575]  [<ffffffff811f6bf1>] debug_smp_processor_id+0xc9/0xe4
[   67.703578]  [<ffffffff81092766>] touch_nmi_watchdog+0x15/0x2c
[   67.703584]  [<ffffffff81222950>] acpi_os_stall+0x34/0x40
[   67.703589]  [<ffffffff812398d2>] acpi_ex_system_do_stall+0x34/0x38
[   67.703591]  [<ffffffff81238396>] acpi_ex_opcode_1A_0T_0R+0x6d/0xa1
[   67.703595]  [<ffffffff8122e280>] acpi_ds_exec_end_op+0xf8/0x578
[   67.703598]  [<ffffffff812457f9>] acpi_ps_parse_loop+0x88a/0xa55
[   67.703604]  [<ffffffff81244a00>] acpi_ps_parse_aml+0x104/0x3c4
[   67.703607]  [<ffffffff81246198>] acpi_ps_execute_method+0x20f/0x2f3
[   67.703610]  [<ffffffff8124021f>] acpi_ns_evaluate+0x18b/0x2d2
[   67.703614]  [<ffffffff8123fad0>] acpi_evaluate_object+0x1b8/0x2fc
[   67.703617]  [<ffffffff8123e020>] ? acpi_get_sleep_type_data+0x21c/0x236
[   67.703620]  [<ffffffff8123d9fb>] acpi_enter_sleep_state_prep+0x61/0xd9
[   67.703623]  [<ffffffff81224205>] acpi_sleep_prepare+0x4f/0x56
[   67.703626]  [<ffffffff81224268>] __acpi_pm_prepare+0x13/0x2e
[   67.703629]  [<ffffffff81224448>] acpi_pm_prepare+0xe/0x1f
[   67.703632]  [<ffffffff81224466>] acpi_hibernation_pre_snapshot+0xd/0x1e
[   67.703637]  [<ffffffff81071b80>] hibernation_snapshot+0xaf/0x258
[   67.703641]  [<ffffffff81074dca>] snapshot_ioctl+0x25c/0x547
[   67.703645]  [<ffffffff81056efc>] ? __srcu_read_unlock+0x3b/0x57
[   67.703649]  [<ffffffff810e7f7d>] vfs_ioctl+0x31/0xa2
[   67.703652]  [<ffffffff810e88dc>] do_vfs_ioctl+0x47c/0x4af
[   67.703655]  [<ffffffff8125ee3c>] ? n_tty_write+0x0/0x35e
[   67.703659]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   67.703662]  [<ffffffff810e8960>] sys_ioctl+0x51/0x75
[   67.703665]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b


[   67.703668] BUG: using smp_processor_id() in preemptible [00000000] code: s2disk/5139
[   67.703670] caller is touch_softlockup_watchdog+0x15/0x2b
[   67.703672] Pid: 5139, comm: s2disk Not tainted 2.6.36-rc0-git12-07921-g60bf26a-dirty #116
[   67.703674] Call Trace:
[   67.703677]  [<ffffffff811f6bf1>] debug_smp_processor_id+0xc9/0xe4
[   67.703680]  [<ffffffff8109273b>] touch_softlockup_watchdog+0x15/0x2b
[   67.703682]  [<ffffffff81092779>] touch_nmi_watchdog+0x28/0x2c
[   67.703685]  [<ffffffff81222950>] acpi_os_stall+0x34/0x40
[   67.703688]  [<ffffffff812398d2>] acpi_ex_system_do_stall+0x34/0x38
[   67.703690]  [<ffffffff81238396>] acpi_ex_opcode_1A_0T_0R+0x6d/0xa1
[   67.703693]  [<ffffffff8122e280>] acpi_ds_exec_end_op+0xf8/0x578
[   67.703696]  [<ffffffff812457f9>] acpi_ps_parse_loop+0x88a/0xa55
[   67.703699]  [<ffffffff81244a00>] acpi_ps_parse_aml+0x104/0x3c4
[   67.703702]  [<ffffffff81246198>] acpi_ps_execute_method+0x20f/0x2f3
[   67.703705]  [<ffffffff8124021f>] acpi_ns_evaluate+0x18b/0x2d2
[   67.703708]  [<ffffffff8123fad0>] acpi_evaluate_object+0x1b8/0x2fc
[   67.703710]  [<ffffffff8123e020>] ? acpi_get_sleep_type_data+0x21c/0x236
[   67.703714]  [<ffffffff8123d9fb>] acpi_enter_sleep_state_prep+0x61/0xd9
[   67.703717]  [<ffffffff81224205>] acpi_sleep_prepare+0x4f/0x56
[   67.703719]  [<ffffffff81224268>] __acpi_pm_prepare+0x13/0x2e
[   67.703722]  [<ffffffff81224448>] acpi_pm_prepare+0xe/0x1f
[   67.703725]  [<ffffffff81224466>] acpi_hibernation_pre_snapshot+0xd/0x1e
[   67.703728]  [<ffffffff81071b80>] hibernation_snapshot+0xaf/0x258
[   67.703731]  [<ffffffff81074dca>] snapshot_ioctl+0x25c/0x547
[   67.703733]  [<ffffffff81056efc>] ? __srcu_read_unlock+0x3b/0x57
[   67.703736]  [<ffffffff810e7f7d>] vfs_ioctl+0x31/0xa2
[   67.703739]  [<ffffffff810e88dc>] do_vfs_ioctl+0x47c/0x4af
[   67.703741]  [<ffffffff8125ee3c>] ? n_tty_write+0x0/0x35e
[   67.703744]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   67.703747]  [<ffffffff810e8960>] sys_ioctl+0x51/0x75
[   67.703750]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b



Please kindly review the patch:

Avoid using smp_processor_id in touch_softlockup_watchdog and touch_nmi_watchdog.
Patch also "removes" second call to smp_processor_id in __touch_watchdog
(smp_processor_id itself and smp_processor_id in __get_cpu_var). 

---

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 613bc1f..8822f1e 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -116,13 +116,14 @@ static unsigned long get_sample_period(void)
 static void __touch_watchdog(void)
 {
 	int this_cpu = smp_processor_id();
-
-	__get_cpu_var(watchdog_touch_ts) = get_timestamp(this_cpu);
+	per_cpu(watchdog_touch_ts, this_cpu) = get_timestamp(this_cpu);
 }
 
 void touch_softlockup_watchdog(void)
 {
-	__get_cpu_var(watchdog_touch_ts) = 0;
+	int this_cpu = get_cpu();
+	per_cpu(watchdog_touch_ts, this_cpu) = 0;
+	put_cpu();
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
@@ -142,7 +143,9 @@ void touch_all_softlockup_watchdogs(void)
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 void touch_nmi_watchdog(void)
 {
-	__get_cpu_var(watchdog_nmi_touch) = true;
+	int this_cpu = get_cpu();
+	per_cpu(watchdog_nmi_touch, this_cpu) = true;
+	put_cpu();
 	touch_softlockup_watchdog();
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);

