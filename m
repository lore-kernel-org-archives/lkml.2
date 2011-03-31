Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab1CaCNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 22:13:40 -0400
Received: from caiajhbdccac.dreamhost.com ([208.97.132.202]:58919 "EHLO
	homiemail-a5.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755418Ab1CaCNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 22:13:39 -0400
Subject: [PATCH] mce: fix RCU lockdep from mce_poll()
From: Davidlohr Bueso <dave@gnu.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
In-Reply-To: <20110331013750.GJ21838@one.firstfloor.org>
References: <1288993499.2065.4.camel@cowboy>
	 <20101106185350.GA23824@basil.fritz.box>
	 <20101107133950.GV15561@linux.vnet.ibm.com>
	 <1289215819.2318.3.camel@cowboy> <20101108131708.GC2580@linux.vnet.ibm.com>
	 <AANLkTikkQ6TdNzkBb6cusFTek7_y=bM1N=+X5zmp3eYY@mail.gmail.com>
	 <1301534041.2140.3.camel@offworld>
	 <20110331013750.GJ21838@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Mar 2011 23:13:24 -0300
Message-ID: <1301537604.2140.21.camel@offworld>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the following message

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
arch/x86/kernel/cpu/mcheck/mce.c:1628 invoked rcu_dereference_check() without protection!

other info that might help us debug this:

rcu_scheduler_active = 1, debug_locks = 1
no locks held by mcelog/2350.

stack backtrace:
Pid: 2350, comm: mcelog Tainted: G        W   2.6.37-rc1+ #7
Call Trace:
 [<ffffffff8108e6d4>] lockdep_rcu_dereference+0xa4/0xc0
 [<ffffffff810189e9>] mce_poll+0xa9/0xd0
 [<ffffffff81160585>] do_sys_poll+0x275/0x550
 [<ffffffff8115f0e0>] ? __pollwait+0x0/0xf0
 [<ffffffff8115f1d0>] ? pollwake+0x0/0x60
 [<ffffffff8115f1d0>] ? pollwake+0x0/0x60
 [<ffffffff8130431c>] ? rcu_read_lock_held+0x2c/0x30
 [<ffffffff8130549a>] ? radix_tree_lookup_element+0xda/0x100
 [<ffffffff81121f08>] ? __do_fault+0x128/0x470
 [<ffffffff81100bdb>] ? filemap_fault+0xdb/0x4e0
 [<ffffffff810ffe75>] ? unlock_page+0x25/0x30
 [<ffffffff81069ddf>] ? sigprocmask+0x3f/0x100
 [<ffffffff8183672b>] ? _raw_spin_unlock_irq+0x2b/0x60
 [<ffffffff8108fefd>] ? trace_hardirqs_on_caller+0x13d/0x180
 [<ffffffff8108ff4d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8183672b>] ? _raw_spin_unlock_irq+0x2b/0x60
 [<ffffffff811608a7>] sys_ppoll+0x47/0x190
 [<ffffffff8108fefd>] ? trace_hardirqs_on_caller+0x13d/0x180
 [<ffffffff81835d39>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff810030eb>] system_call_fastpath+0x16/0x1b

This code is simply checking the value of the pointer, and therefore need not protect any actual dereferences.
Replace rcu_dereference_check_mce() with rcu_dereference_index_check().

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
This patch reflects the summary of the activity in https://lkml.org/lkml/2010/11/5/236

 arch/x86/kernel/cpu/mcheck/mce.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 5a05ef6..6cad5dc 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1626,7 +1626,8 @@ out:
 static unsigned int mce_poll(struct file *file, poll_table *wait)
 {
 	poll_wait(file, &mce_wait, wait);
-	if (rcu_dereference_check_mce(mcelog.next))
+	if (rcu_dereference_index_check(mcelog.next,
+					rcu_read_lock_sched_held()))
 		return POLLIN | POLLRDNORM;
 	if (!mce_apei_read_done && apei_check_mce())
 		return POLLIN | POLLRDNORM;
-- 
1.7.1



