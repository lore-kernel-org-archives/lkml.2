Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab1LLPPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:15:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56032 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1LLPPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:15:03 -0500
Message-ID: <1323702852.13285.25.camel@twins>
Subject: [RFC][PATCH] sparc64: remove __ARCH_WANT_UNLOCKED_CTXSW usage
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: sparclinux <sparclinux@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Mon, 12 Dec 2011 16:14:12 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

As mentioned a while ago, I was looking into why SPARC64 uses
__ARCH_WANT_UNLOCKED_CTXSW. You thought to remember some AB-BA deadlock
with the rq->lock so I went through the various sparc64 arch hooks but
came up empty.

switch_to()
  flush_tlb_pending()
    flush_tsb_user
      mm->context.lock

switch_mm()
  mm->context.lock
  get_new_mmu_context()
    ctx_alloc_lock()

I went through all sites where either mm->context.lock or ctx_alloc_lock
was used but could not find anything calling back into the scheduler --
this would have to be a wakeup because everything is ran with IRQs
disabled.

There's also activate_mm() that takes both these locks and is ran under
task_lock(), but there too I cannot see any problems with rq->lock.

This investigation has one assumption; that pure assembly functions are
'clean', ie. they don't take locks and don't go calling try_to_wake_up()
etc. This because my sparc64 asm is very much gone from memory (some 10+
years ago I could have maybe followed it).

The only thing resting me is asking you to simply test the below patch
and report what happens. Hopefully things will simply work.. if not I've
messed up and need to go look harder :/


---
 arch/sparc/include/asm/system_64.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/include/asm/system_64.h b/arch/sparc/include/asm/system_64.h
index 10bcabc..715fefa 100644
--- a/arch/sparc/include/asm/system_64.h
+++ b/arch/sparc/include/asm/system_64.h
@@ -123,8 +123,6 @@ extern void __flushw_user(void);
 #define flush_user_windows flushw_user
 #define flush_register_windows flushw_all
 
-/* Don't hold the runqueue lock over context switch */
-#define __ARCH_WANT_UNLOCKED_CTXSW
 #define prepare_arch_switch(next)		\
 do {						\
 	flushw_all();				\

