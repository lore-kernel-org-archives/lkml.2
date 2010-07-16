Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609Ab0GQAtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 20:49:25 -0400
Received: from claw.goop.org ([74.207.240.146]:40901 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759542Ab0GQAs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 20:48:57 -0400
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Fri, 16 Jul 2010 12:09:30 -0700
Subject: [PATCH RFC 00/12] X86 ticket lock cleanups and improvements
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Jan Beulich <JBeulich@novell.com>, Avi Kivity <avi@redhat.com>,
        Xen-devel <xen-devel@lists.xensource.com>
Message-Id: <20100717004855.A72A9A3C46@abulafia.goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

This series does three things:

 - A general cleanup of the ticketlock implementation, including
   moving most of it into C, removing a pile of inline asm and ifdefs.

 - Convert the PV spinlock mechanism (enabled with
   CONFIG_PARAVIRT_SPINLOCKS) to a PV ticketlock mechanism.  The old
   way completely replaced the spinlock implementation, changing all
   the spinlock calls into indirect ones via paravirt-ops.  This was
   overkill, and caused noticable performance regressions on some
   microarchitectures.

   The new scheme keeps the ticketlock algorithm, and uses the
   standard ticketlock code for both native and PV uses.  But it adds
   a couple of pvops hooks for the slow paths: one when we've been
   waiting a long time on a lock, and one when we're unlocking a lock
   which has people waiting on it.

 - A Xen implementation of these new pvop hooks, which shows how much
   simpler they make the backend code.

I've benchmarked these changes with lmbench lat_mmap, which shows that
- at worst - these changes have no detremental effect to performance
when run native.  In some cases there are surprising improvements
(running native with the pvop hooks enabled was noticably faster than
without, for example).  (I tried also using mmap-perf, but it seems to
hang indefinitely when I run it on 4 threads.)

The patches are against v2.6.33, but merge cleanly with current
linux-2.6.git.

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
  x86/spinlocks: replace pv spinlocks with pv ticketlocks
  x86/ticketlock: collapse a layer of functions
  xen/pvticketlock: Xen implementation for PV ticket locks
  x86/pvticketlock: keep count of blocked cpus
  x86/pvticketlock: use callee-save for lock_spinning
  x86/pvticketlock: use callee-save for unlock_kick as well

 arch/x86/include/asm/paravirt.h       |   30 +---
 arch/x86/include/asm/paravirt_types.h |    8 +-
 arch/x86/include/asm/spinlock.h       |  241 ++++++++++++++--------------
 arch/x86/include/asm/spinlock_types.h |   26 +++-
 arch/x86/kernel/paravirt-spinlocks.c  |   15 +--
 arch/x86/xen/spinlock.c               |  282 +++++----------------------------
 6 files changed, 192 insertions(+), 410 deletions(-)

