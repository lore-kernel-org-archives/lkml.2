Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab2KFIIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:08:23 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:54389 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab2KFIIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:08:21 -0500
From: Mojiong Qiu <qiumojiong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mojiong Qiu <qiumojiong@gmail.com>, Mojiong Qiu <mjqiu@tencent.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        stable@kernel.org (at least to 3.0.y)
Subject: [PATCH] xen/events: xen/events: fix RCU warning
Date: Tue,  6 Nov 2012 16:08:15 +0800
Message-Id: <1352189295-7111-1-git-send-email-qiumojiong@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exit_idle() should be called after irq_enter(), otherwise it throws:

[    2.513020] [ INFO: suspicious RCU usage. ]
[    2.513076] 3.6.5 #1 Not tainted
[    2.513128] -------------------------------
[    2.513183] include/linux/rcupdate.h:725 rcu_read_lock() used illegally while idle!
[    2.513271]
[    2.513271] other info that might help us debug this:
[    2.513271]
[    2.513388]
[    2.513388] RCU used illegally from idle CPU!
[    2.513388] rcu_scheduler_active = 1, debug_locks = 1
[    2.513511] RCU used illegally from extended quiescent state!
[    2.513572] 1 lock held by swapper/0/0:
[    2.513626]  #0:  (rcu_read_lock){......}, at: [<ffffffff810e9fe0>] __atomic_notifier_call_chain+0x0/0x140
[    2.513815]
[    2.513815] stack backtrace:
[    2.513897] Pid: 0, comm: swapper/0 Not tainted 3.6.5 #1
[    2.513954] Call Trace:
[    2.514005]  <IRQ>  [<ffffffff811259a2>] lockdep_rcu_suspicious+0xe2/0x130
[    2.514107]  [<ffffffff810ea10c>] __atomic_notifier_call_chain+0x12c/0x140
[    2.514169]  [<ffffffff810e9fe0>] ? atomic_notifier_chain_unregister+0x90/0x90
[    2.514258]  [<ffffffff811216cd>] ? trace_hardirqs_off+0xd/0x10
[    2.514318]  [<ffffffff810ea136>] atomic_notifier_call_chain+0x16/0x20
[    2.514381]  [<ffffffff810777c3>] exit_idle+0x43/0x50
[    2.514441]  [<ffffffff81568865>] xen_evtchn_do_upcall+0x25/0x50
[    2.514503]  [<ffffffff81aa690e>] xen_do_hypervisor_callback+0x1e/0x30
[    2.514562]  <EOI>  [<ffffffff810013aa>] ? hypercall_page+0x3aa/0x1000
[    2.514662]  [<ffffffff810013aa>] ? hypercall_page+0x3aa/0x1000
[    2.514722]  [<ffffffff81061540>] ? xen_safe_halt+0x10/0x20
[    2.514782]  [<ffffffff81075cfa>] ? default_idle+0xba/0x570
[    2.514841]  [<ffffffff810778af>] ? cpu_idle+0xdf/0x140
[    2.514900]  [<ffffffff81a4d881>] ? rest_init+0x135/0x144
[    2.514960]  [<ffffffff81a4d74c>] ? csum_partial_copy_generic+0x16c/0x16c
[    2.515022]  [<ffffffff82520c45>] ? start_kernel+0x3db/0x3e8
[    2.515081]  [<ffffffff8252066a>] ? repair_env_string+0x5a/0x5a
[    2.515141]  [<ffffffff82520356>] ? x86_64_start_reservations+0x131/0x135
[    2.515202]  [<ffffffff82524aca>] ? xen_start_kernel+0x465/0x46

Signed-off-by: Mojiong Qiu <mjqiu@tencent.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: xen-devel@lists.xensource.com
Cc: virtualization@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@kernel.org (at least to 3.0.y)
---
 drivers/xen/events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 912ac81..0be4df3 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1395,10 +1395,10 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
+	irq_enter();
 #ifdef CONFIG_X86
 	exit_idle();
 #endif
-	irq_enter();
 
 	__xen_evtchn_do_upcall();
 
-- 
1.6.3.2

