Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab2HGL5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:57:25 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59636 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754310Ab2HGL5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:57:24 -0400
Date: Tue, 7 Aug 2012 12:56:47 +0100
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <chris.mason@fusionio.com>,
        Nicolas Pitre <nico@fluxnic.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: RFC: mutex: hung tasks on SMP platforms with asm-generic/mutex-xchg.h
Message-ID: <20120807115647.GA12828@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

ARM recently moved to asm-generic/mutex-xchg.h for its mutex implementation
after our previous implementation was found to be missing some crucial
memory barriers. However, I'm seeing some problems running hackbench on
SMP platforms due to the way in which the MUTEX_SPIN_ON_OWNER code operates.

The symptoms are that a bunch of hackbench tasks are left waiting on an
unlocked mutex and therefore never get woken up to claim it. I think this
boils down to the following sequence:


        Task A        Task B        Task C        Lock value
0                                                     1
1       lock()                                        0
2                     lock()                          0
3                     spin(A)                         0
4       unlock()                                      1
5                                   lock()            0
6                     cmpxchg(1,0)                    0
7                     contended()                    -1
8       lock()                                        0
9       spin(C)                                       0
10                                  unlock()          1
11      cmpxchg(1,0)                                  0
12      unlock()                                      1


At this point, the lock is unlocked, but Task B is in an uninterruptible
sleep with nobody to wake it up.

The following patch fixes the problem by ensuring we put the lock into
the contended state if we acquire it from the spin loop on the slowpath
but I'd like to be sure that this won't cause problems with other mutex
implementations:


diff --git a/kernel/mutex.c b/kernel/mutex.c
index a307cc9..27b7887 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -170,7 +170,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
                if (owner && !mutex_spin_on_owner(lock, owner))
                        break;
 
-               if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
+               if (atomic_cmpxchg(&lock->count, 1, -1) == 1) {
                        lock_acquired(&lock->dep_map, ip);
                        mutex_set_owner(lock);
                        preempt_enable();


All comments welcome.

Cheers,

Will
