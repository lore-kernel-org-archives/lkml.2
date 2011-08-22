Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab1HVXQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 19:16:53 -0400
Received: from claw.goop.org ([74.207.240.146]:48626 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241Ab1HVXP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 19:15:27 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 00/12] x86: Ticket lock cleanup
Date: Mon, 22 Aug 2011 16:14:56 -0700
Message-Id: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>


Hi all,

This is a repost of the ticketlock cleanup I posted for the last mergewindow.

The main differences are:
 - put "asm volatiles" into the locked unlock path
 - tidy up xadd helper to put it into a common place
 - clean up the rest of cmpxchg.h to remove most of the 32/64 duplication

The main downside of the 32/64 cmpxchg/xadd duplication is that passing a 64-bit param
to cmpxchg/xadd on a 32-bit system will generate a bad instruction rather than a link
error, but I don't think that's a huge issue.

As a bonus, I added some cmpxchg_flag() variants, which return a bool rather than
the old value, which saves the caller from having to do it (since cmpxchg itself
sets the flags).  This is useful since many callers of cmpxchg() only care whether
it worked without actually getting the old value.

Thanks,
	J

Jeremy Fitzhardinge (12):
  x86/ticketlock: clean up types and accessors
  x86/ticketlock: convert spin loop to C
  x86/ticketlock: Use C for __ticket_spin_unlock
  x86/ticketlock: make large and small ticket versions of spin_lock the
    same
  x86/ticketlock: make __ticket_spin_lock common
  x86/ticketlock: make __ticket_spin_trylock common
  x86: add xadd helper macro
  x86/ticketlock: use xadd helper
  x86/cmpxchg: linux/alternative.h has LOCK_PREFIX
  x86/cmpxchg: move 32-bit __cmpxchg_wrong_size to match 64 bit.
  x86/cmpxchg: move 64-bit set64_bit() to match 32-bit
  x86/cmpxchg: unify cmpxchg into cmpxchg.h

 arch/x86/include/asm/cmpxchg.h        |  165 +++++++++++++++++++++++++++++++++
 arch/x86/include/asm/cmpxchg_32.h     |  114 -----------------------
 arch/x86/include/asm/cmpxchg_64.h     |  131 --------------------------
 arch/x86/include/asm/spinlock.h       |  140 +++++++++------------------
 arch/x86/include/asm/spinlock_types.h |   22 ++++-
 5 files changed, 232 insertions(+), 340 deletions(-)

-- 
1.7.6

