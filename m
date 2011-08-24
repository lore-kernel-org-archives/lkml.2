Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab1HXRxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 13:53:18 -0400
Received: from claw.goop.org ([74.207.240.146]:52848 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab1HXRxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 13:53:15 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 00/18] x86: Ticket lock + cmpxchg cleanup
Date: Wed, 24 Aug 2011 10:52:54 -0700
Message-Id: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Hi all,

[ Change from last post: use PeterZ's idea to retain link-time
  reporting of bad sized arguments for xchg/cmpxchg/xadd. ]

This is a repost of the ticketlock cleanup I posted for the last mergewindow.

The main differences are:
 - put "asm volatiles" into the locked unlock path
 - tidy up xadd helper to put it into a common place
 - clean up the rest of cmpxchg.h to remove most of the 32/64 duplication

As a bonus, I added some cmpxchg_flag() variants, which return a bool
rather than the old value, which saves the caller from having to do a
comparison (since cmpxchg itself sets the flags).  This is useful
since many callers of cmpxchg() only care whether it worked without
actually getting the old value.

This is also available at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/ticketlock-cleanup

Thanks,
	J

Jeremy Fitzhardinge (18):
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
  x86: add cmpxchg_flag() variant
  x86/ticketlocks: use cmpxchg_flag for trylock
  x86: use cmpxchg_flag() where applicable
  x86: report xchg/cmpxchg/xadd usage errors consistently
  x86: add local and sync variants of xadd
  x86: use xadd helper more widely

 arch/x86/include/asm/atomic.h         |    4 +-
 arch/x86/include/asm/atomic64_64.h    |    4 +-
 arch/x86/include/asm/cacheflush.h     |    2 +-
 arch/x86/include/asm/cmpxchg.h        |  223 +++++++++++++++++++++++++++++++++
 arch/x86/include/asm/cmpxchg_32.h     |  128 ++-----------------
 arch/x86/include/asm/cmpxchg_64.h     |  131 -------------------
 arch/x86/include/asm/rwsem.h          |   11 +--
 arch/x86/include/asm/spinlock.h       |  140 +++++++--------------
 arch/x86/include/asm/spinlock_types.h |   22 +++-
 arch/x86/include/asm/uv/uv_bau.h      |    4 +-
 arch/x86/kernel/acpi/boot.c           |   10 +-
 arch/x86/kernel/cpu/mcheck/mce.c      |    2 +-
 arch/x86/xen/p2m.c                    |   10 +-
 13 files changed, 321 insertions(+), 370 deletions(-)

-- 
1.7.6

