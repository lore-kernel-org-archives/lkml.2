Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab1FPVlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 17:41:25 -0400
Received: from claw.goop.org ([74.207.240.146]:53926 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933117Ab1FPVlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 17:41:15 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH RFC 0/7] x86: convert ticketlocks to C and remove duplicate code
Date: Thu, 16 Jun 2011 14:40:47 -0700
Message-Id: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Hi all,

I'm proposing this series for 3[.0].1.

This is a repost of a series to clean up the x86 ticket lock
code by converting it to a mostly C implementation and removing
lots of duplicate code relating to the ticket size.

The last time I posted this series, the only significant comments
were from Nick Piggin, specifically relating to:

 1. A wrongly placed barrier on unlock (which may have allowed the
    compiler to move things out of the locked region.  I went
    belt-and-suspenders by having two barriers to prevent motion
    into or out of the locked region.

 2. With NR_CPUS < 256 the ticket size is 8 bits.  The compiler doesn't
    use the same trick as the hand-coded asm to directly compare the high
    and low bytes in the word, but does a bit of extra shuffling around.
    However, the Intel optimisation guide and several x86 experts have
    opined that its best to avoid the high-byte operations anyway, since
    they will cause a partial word stall, and the gcc-generated code should
    be better.

    Overall the compiler-generated code is very similar to the hand-coded
    versions, with the partial byte operations being the only significant
    difference. (Curiously, gcc does generate a high-byte compare for me
    in trylock, so it can if it wants to.)

I've been running with this code in place for several months on 4 core
systems without any problems.

I couldn't measure a consistent performance difference between the two
implemenations; there seemed to be +/- ~1% +/-, which is the level of
variation I see from simply recompiling the kernel with slightly
different code alignment.

Overall, I think the large reduction in code size is a big win.

Thanks,
	J

Jeremy Fitzhardinge (7):
  x86/ticketlock: clean up types and accessors
  x86/ticketlock: convert spin loop to C
  x86/ticketlock: Use C for __ticket_spin_unlock
  x86/ticketlock: make large and small ticket versions of spin_lock the
    same
  x86/ticketlock: make __ticket_spin_lock common
  x86/ticketlock: make __ticket_spin_trylock common
  x86/ticketlock: prevent memory accesses from reordered out of lock
    region

 arch/x86/include/asm/spinlock.h       |  147 ++++++++++++---------------------
 arch/x86/include/asm/spinlock_types.h |   22 +++++-
 2 files changed, 74 insertions(+), 95 deletions(-)

-- 
1.7.5.4

