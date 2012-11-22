Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab2KVVjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:39:15 -0500
Received: from mail.kernel.org ([198.145.19.201]:49626 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072Ab2KVSk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mojiong Qiu <mjqiu@tencent.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 65/83] xen/events: fix RCU warning, or Call idle notifier after irq_enter()
Date: Wed, 21 Nov 2012 16:42:27 -0800
Message-Id: <20121122004219.716744494@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mojiong Qiu <qiumojiong@gmail.com>

commit 772aebcefeff310f80e32b874988af0076cb799d upstream.

exit_idle() should be called after irq_enter(), otherwise it throws:

[ INFO: suspicious RCU usage. ]
3.6.5 #1 Not tainted
-------------------------------
include/linux/rcupdate.h:725 rcu_read_lock() used illegally while idle!

other info that might help us debug this:

RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
1 lock held by swapper/0/0:
 #0:  (rcu_read_lock){......}, at: [<ffffffff810e9fe0>] __atomic_notifier_call_chain+0x0/0x140

stack backtrace:
Pid: 0, comm: swapper/0 Not tainted 3.6.5 #1
Call Trace:
 <IRQ>  [<ffffffff811259a2>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff810ea10c>] __atomic_notifier_call_chain+0x12c/0x140
 [<ffffffff810e9fe0>] ? atomic_notifier_chain_unregister+0x90/0x90
 [<ffffffff811216cd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff810ea136>] atomic_notifier_call_chain+0x16/0x20
 [<ffffffff810777c3>] exit_idle+0x43/0x50
 [<ffffffff81568865>] xen_evtchn_do_upcall+0x25/0x50
 [<ffffffff81aa690e>] xen_do_hypervisor_callback+0x1e/0x30
 <EOI>  [<ffffffff810013aa>] ? hypercall_page+0x3aa/0x1000
 [<ffffffff810013aa>] ? hypercall_page+0x3aa/0x1000
 [<ffffffff81061540>] ? xen_safe_halt+0x10/0x20
 [<ffffffff81075cfa>] ? default_idle+0xba/0x570
 [<ffffffff810778af>] ? cpu_idle+0xdf/0x140
 [<ffffffff81a4d881>] ? rest_init+0x135/0x144
 [<ffffffff81a4d74c>] ? csum_partial_copy_generic+0x16c/0x16c
 [<ffffffff82520c45>] ? start_kernel+0x3db/0x3e8
 [<ffffffff8252066a>] ? repair_env_string+0x5a/0x5a
 [<ffffffff82520356>] ? x86_64_start_reservations+0x131/0x135
 [<ffffffff82524aca>] ? xen_start_kernel+0x465/0x46

Git commit 98ad1cc14a5c4fd658f9d72c6ba5c86dfd3ce0d5
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Fri Oct 7 18:22:09 2011 +0200

    x86: Call idle notifier after irq_enter()

did this, but it missed the Xen code.

Signed-off-by: Mojiong Qiu <mjqiu@tencent.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/events.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1374,8 +1374,8 @@ void xen_evtchn_do_upcall(struct pt_regs
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
-	exit_idle();
 	irq_enter();
+	exit_idle();
 
 	__xen_evtchn_do_upcall();
 


