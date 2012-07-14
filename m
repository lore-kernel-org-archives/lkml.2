Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab2GNKOu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 06:14:50 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:57010 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751457Ab2GNKOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 06:14:48 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+BhqQEOHuBHqut+fFMHhNKFGlNTijyhiSBasO3dy
	dHYPEtrk7faUR3
Message-ID: <1342260883.7368.30.camel@marge.simpson.net>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM..  and a bonus rt_mutex
 deadlock report for absolutely free!
From: Mike Galbraith <efault@gmx.de>
To: Chris Mason <chris.mason@fusionio.com>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Sat, 14 Jul 2012 12:14:43 +0200
In-Reply-To: <20120713125043.GH30128@shiny>
References: <1342072060.7338.102.camel@marge.simpson.net>
	 <20120713125043.GH30128@shiny>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-13 at 08:50 -0400, Chris Mason wrote: 
> On Wed, Jul 11, 2012 at 11:47:40PM -0600, Mike Galbraith wrote:
> > Greetings,
> 
> [ deadlocks with btrfs and the recent RT kernels ]
> 
> I talked with Thomas about this and I think the problem is the
> single-reader nature of the RW rwlocks.  The lockdep report below
> mentions that btrfs is calling:
> 
> > [  692.963099]  [<ffffffff811fabd2>] btrfs_clear_path_blocking+0x32/0x70
> 
> In this case, the task has a number of blocking read locks on the btrfs buffers,
> and we're trying to turn them back into spinning read locks.  Even
> though btrfs is taking the read rwlock, it doesn't think of this as a new
> lock operation because we were blocking out new writers.
> 
> If the second task has taken the spinning read lock, it is going to
> prevent that clear_path_blocking operation from progressing, even though
> it would have worked on a non-RT kernel.
> 
> The solution should be to make the blocking read locks in btrfs honor the
> single-reader semantics.  This means not allowing more than one blocking
> reader and not allowing a spinning reader when there is a blocking
> reader.  Strictly speaking btrfs shouldn't need recursive readers on a
> single lock, so I wouldn't worry about that part.
> 
> There is also a chunk of code in btrfs_clear_path_blocking that makes
> sure to strictly honor top down locking order during the conversion.  It
> only does this when lockdep is enabled because in non-RT kernels we
> don't need to worry about it.  For RT we'll want to enable that as well.
> 
> I'll give this a shot later today.

I took a poke at it.  Did I do something similar to what you had in
mind, or just hide behind performance stealing paranoid trylock loops?
Box survived 1000 x xfstests 006 and dbench [-s] massive right off the
bat, so it gets posted despite skepticism.

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 4106264..ae47cc2 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -77,7 +77,7 @@ noinline void btrfs_clear_path_blocking(struct btrfs_path *p,
 {
 	int i;
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#if (defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_PREEMPT_RT_BASE))
 	/* lockdep really cares that we take all of these spinlocks
 	 * in the right order.  If any of the locks in the path are not
 	 * currently blocking, it is going to complain.  So, make really
@@ -104,7 +104,7 @@ noinline void btrfs_clear_path_blocking(struct btrfs_path *p,
 		}
 	}
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#if (defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_PREEMPT_RT_BASE))
 	if (held)
 		btrfs_clear_lock_blocking_rw(held, held_rw);
 #endif
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 272f911..4db7c14 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -19,6 +19,7 @@
 #include <linux/pagemap.h>
 #include <linux/spinlock.h>
 #include <linux/page-flags.h>
+#include <linux/delay.h>
 #include <asm/bug.h>
 #include "ctree.h"
 #include "extent_io.h"
@@ -97,7 +98,18 @@ void btrfs_clear_lock_blocking_rw(struct extent_buffer *eb, int rw)
 void btrfs_tree_read_lock(struct extent_buffer *eb)
 {
 again:
+#ifdef CONFIG_PREEMPT_RT_BASE
+	while (atomic_read(&eb->blocking_readers))
+		cpu_chill();
+	while(!read_trylock(&eb->lock))
+		cpu_chill();
+	if (atomic_read(&eb->blocking_readers)) {
+		read_unlock(&eb->lock);
+		goto again;
+	}
+#else
 	read_lock(&eb->lock);
+#endif
 	if (atomic_read(&eb->blocking_writers) &&
 	    current->pid == eb->lock_owner) {
 		/*
@@ -131,11 +143,26 @@ int btrfs_try_tree_read_lock(struct extent_buffer *eb)
 	if (atomic_read(&eb->blocking_writers))
 		return 0;
 
+#ifdef CONFIG_PREEMPT_RT_BASE
+	if (atomic_read(&eb->blocking_readers))
+		return 0;
+	while(!read_trylock(&eb->lock))
+		cpu_chill();
+#else
 	read_lock(&eb->lock);
+#endif
+
 	if (atomic_read(&eb->blocking_writers)) {
 		read_unlock(&eb->lock);
 		return 0;
 	}
+
+#ifdef CONFIG_PREEMPT_RT_BASE
+	if (atomic_read(&eb->blocking_readers)) {
+		read_unlock(&eb->lock);
+		return 0;
+	}
+#endif
 	atomic_inc(&eb->read_locks);
 	atomic_inc(&eb->spinning_readers);
 	return 1;


