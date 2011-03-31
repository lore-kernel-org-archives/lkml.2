Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402Ab1CaJbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 05:31:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:40061 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933339Ab1CaJbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 05:31:40 -0400
Date: Thu, 31 Mar 2011 09:30:59 GMT
From: tip-bot for Davidlohr Bueso <dave@gnu.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andi@firstfloor.org, dave@gnu.org, paulmck@linux.vnet.ibm.com,
        zdenek.kabelac@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, dave@gnu.org, paulmck@linux.vnet.ibm.com,
        zdenek.kabelac@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1301537604.2140.21.camel@offworld>
References: <1301537604.2140.21.camel@offworld>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mce: Fix RCU lockdep from mce_poll()
Message-ID: <tip-706453b0d1fabf4dccbcffa29356d0dd6ab9afb9@git.kernel.org>
Git-Commit-ID: 706453b0d1fabf4dccbcffa29356d0dd6ab9afb9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 31 Mar 2011 09:31:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  706453b0d1fabf4dccbcffa29356d0dd6ab9afb9
Gitweb:     http://git.kernel.org/tip/706453b0d1fabf4dccbcffa29356d0dd6ab9afb9
Author:     Davidlohr Bueso <dave@gnu.org>
AuthorDate: Wed, 30 Mar 2011 23:13:24 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 31 Mar 2011 11:06:08 +0200

x86, mce: Fix RCU lockdep from mce_poll()

Based on the following message:

  ===================================================
  [ INFO: suspicious rcu_dereference_check() usage. ]
  ---------------------------------------------------
  arch/x86/kernel/cpu/mcheck/mce.c:1628 invoked
  rcu_dereference_check() without protection!

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

This code is simply checking the value of the pointer, and
therefore need not protect any actual dereferences. Replace
rcu_dereference_check_mce() with rcu_dereference_index_check().

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
LKML-Reference: <1301537604.2140.21.camel@offworld>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 5a05ef6..a2d664f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1626,7 +1626,7 @@ out:
 static unsigned int mce_poll(struct file *file, poll_table *wait)
 {
 	poll_wait(file, &mce_wait, wait);
-	if (rcu_dereference_check_mce(mcelog.next))
+	if (rcu_dereference_index_check(mcelog.next, rcu_read_lock_sched_held()))
 		return POLLIN | POLLRDNORM;
 	if (!mce_apei_read_done && apei_check_mce())
 		return POLLIN | POLLRDNORM;
