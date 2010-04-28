Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab0D1TGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 15:06:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:60231 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527Ab0D1TGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 15:06:13 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <chris.mason@oracle.com>, Zach Brown <zach.brown@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 0/3] ipc/sem.c: Optimization for reducing spinlock contention
Date: Wed, 28 Apr 2010 21:06:25 +0200
Message-Id: <1272481588-1941-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've cleaned up the patches I sent a week ago:
- they pass now checkpatch.pl
- some comments updated/added
- a bug with semctl(,,SETALL,) is fixed
- tested against LTP

Andrew: Could you add them the next -mm?

The following series of patches tries to fix the spinlock contention
reported by Chris Manson: His benchmark exposes problems of the current
code:

- In the worst case, the algorithm used by update_queue() is O(N^2).
  Bulk wake-up calls can enter this worst case.
  The patch series fix that.
  Note that the benchmark app doesn't expose the problem, it just should
  be fixed: Real world apps might do the wake-ups in another order
  than perfect FIFO.

- The part of the code that runs within the semaphore array spinlock
  is significantly larger than necessary.
  The patch series fixes that. This change is responsible for the
  main improvement.

- The cacheline with the spinlock is also used for a variable that
  is read in the hot path (sem_base) and for a variable that is
  unnecessarily written to multiple times (sem_otime).
  The last step of the series cacheline-aligns the spinlock.

--
	Manfred
