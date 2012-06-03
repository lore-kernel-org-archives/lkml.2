Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab2FCSQP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 14:16:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992Ab2FCSQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 14:16:14 -0400
Date: Sun, 3 Jun 2012 14:15:48 -0400
From: Dave Jones <davej@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: WARNING: at mm/page-writeback.c:1990
 __set_page_dirty_nobuffers+0x13a/0x170()
Message-ID: <20120603181548.GA306@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
	Rik van Riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Cong Wang <amwang@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20120530163317.GA13189@redhat.com>
 <20120531005739.GA4532@redhat.com>
 <20120601023107.GA19445@redhat.com>
 <alpine.LSU.2.00.1206010030050.8462@eggly.anvils>
 <20120601161205.GA1918@redhat.com>
 <20120601171606.GA3794@redhat.com>
 <alpine.LSU.2.00.1206011511560.12839@eggly.anvils>
 <CA+55aFy2-X92EqpiuyvkBp_2-UaYDUpaC2c3XT3gXMN1O+T7sw@mail.gmail.com>
 <alpine.LSU.2.00.1206012108430.11308@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1206012108430.11308@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 09:40:35PM -0700, Hugh Dickins wrote:

 > In which case, yes, much better to follow your suggestion, and hold
 > the lock (with irqs disabled) for only half the time.
 > 
 > Similarly untested patch below.

Things aren't happy with that patch at all.

=============================================
[ INFO: possible recursive locking detected ]
3.5.0-rc1+ #50 Not tainted
---------------------------------------------
trinity-child1/31784 is trying to acquire lock:
 (&(&zone->lock)->rlock){-.-.-.}, at: [<ffffffff81165c5d>] suitable_migration_target.isra.15+0x19d/0x1e0

but task is already holding lock:
 (&(&zone->lock)->rlock){-.-.-.}, at: [<ffffffff811661fb>] compaction_alloc+0x21b/0x2f0

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(&zone->lock)->rlock);
  lock(&(&zone->lock)->rlock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by trinity-child1/31784:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff8115fc46>] vm_mmap_pgoff+0x66/0xb0
 #1:  (&(&zone->lock)->rlock){-.-.-.}, at: [<ffffffff811661fb>] compaction_alloc+0x21b/0x2f0

stack backtrace:
Pid: 31784, comm: trinity-child1 Not tainted 3.5.0-rc1+ #50
Call Trace:
 [<ffffffff810b6584>] __lock_acquire+0x1584/0x1aa0
 [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
 [<ffffffff8108cd47>] ? local_clock+0x47/0x60
 [<ffffffff810b7162>] lock_acquire+0x92/0x1f0
 [<ffffffff81165c5d>] ? suitable_migration_target.isra.15+0x19d/0x1e0
 [<ffffffff8164ce05>] ? _raw_spin_lock_irqsave+0x25/0x90
 [<ffffffff8164ce32>] _raw_spin_lock_irqsave+0x52/0x90
 [<ffffffff81165c5d>] ? suitable_migration_target.isra.15+0x19d/0x1e0
 [<ffffffff81165c5d>] suitable_migration_target.isra.15+0x19d/0x1e0
 [<ffffffff8116620e>] compaction_alloc+0x22e/0x2f0
 [<ffffffff81198547>] migrate_pages+0xc7/0x540
 [<ffffffff81165fe0>] ? isolate_freepages_block+0x260/0x260
 [<ffffffff81166e86>] compact_zone+0x216/0x480
 [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
 [<ffffffff811673cd>] compact_zone_order+0x8d/0xd0
 [<ffffffff811499e5>] ? get_page_from_freelist+0x565/0x970
 [<ffffffff811674d9>] try_to_compact_pages+0xc9/0x140
 [<ffffffff81642e01>] __alloc_pages_direct_compact+0xaa/0x1d0


Then a bunch of NMI backtraces, and a hard lockup.

	Dave 

