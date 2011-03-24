Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab1CXJl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:41:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56629 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743Ab1CXJl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:41:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SXefWbrMuULKAa6WfQQTDcJc4LDmaX4eSuQpO6ytXg+F7WnRjbpkWvRZEzHERmC8aY
         nku5kfsJjbkn5P0M446JueGVpoECz2cbTr51mSZ/jvg5i6buyLtdv0oD/6Y1WhGH4TQV
         zDjNqk7TInygR7mVA2Z5xu0vt5cIgqqQXlKbs=
Date: Thu, 24 Mar 2011 10:41:51 +0100
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
Message-ID: <20110324094151.GE12038@htj.dyndns.org>
References: <20110323153727.GB12003@htj.dyndns.org>
 <20110324094119.GD12038@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324094119.GD12038@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adaptive owner spinning used to be applied only to mutex_lock().  This
patch applies it also to mutex_trylock().

btrfs has developed custom locking to avoid excessive context switches
in its btree implementation.  Generally, doing away with the custom
implementation and just using the mutex shows better behavior;
however, there's an interesting distinction in the custom implemention
of trylock.  It distinguishes between simple trylock and tryspin,
where the former just tries once and then fail while the latter does
some spinning before giving up.

Currently, mutex_trylock() doesn't use adaptive spinning.  It tries
just once.  I got curious whether using adaptive spinning on
mutex_trylock() would be beneficial and it seems so, for btrfs anyway.

The following results are from "dbench 50" run on an opteron two
socket eight core machine with 4GiB of memory and an OCZ vertex SSD.
During the run, disk stays mostly idle and all CPUs are fully occupied
and the difference in locking performance becomes quite visible.

SIMPLE is with the locking simplification patch[1] applied.  i.e. it
basically just uses mutex.  SPIN is with this patch applied on top -
mutex_trylock() uses adaptive spinning.

        USER   SYSTEM   SIRQ    CXTSW  THROUGHPUT
 SIMPLE 61107  354977    217  8099529  845.100 MB/sec
 SPIN   63140  364888    214  6840527  879.077 MB/sec

On various runs, the adaptive spinning trylock consistently posts
higher throughput.  The amount of difference varies but it outperforms
consistently.

In general, using adaptive spinning on trylock makes sense as trylock
failure usually leads to costly unlock-relock sequence.

[1] http://article.gmane.org/gmane.comp.file-systems.btrfs/9658

Signed-off-by: Tejun Heo <tj@kernel.org>
LKML-Reference: <20110323153727.GB12003@htj.dyndns.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>
---
 kernel/mutex.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: work/kernel/mutex.c
===================================================================
--- work.orig/kernel/mutex.c
+++ work/kernel/mutex.c
@@ -443,6 +443,15 @@ static inline int __mutex_trylock_slowpa
 	unsigned long flags;
 	int prev;
 
+	preempt_disable();
+
+	if (mutex_spin(lock)) {
+		mutex_set_owner(lock);
+		mutex_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		preempt_enable();
+		return 1;
+	}
+
 	spin_lock_mutex(&lock->wait_lock, flags);
 
 	prev = atomic_xchg(&lock->count, -1);
@@ -456,6 +465,7 @@ static inline int __mutex_trylock_slowpa
 		atomic_set(&lock->count, 0);
 
 	spin_unlock_mutex(&lock->wait_lock, flags);
+	preempt_enable();
 
 	return prev == 1;
 }
