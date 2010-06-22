Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab0FVRPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 13:15:09 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41097 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756535Ab0FVRPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:15:03 -0400
Date: Tue, 22 Jun 2010 10:14:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: manual merge of the tip tree with the block tree
Message-ID: <20100622171449.GG2290@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100621161623.3dfedc32.sfr@canb.auug.org.au>
 <20100621171300.GF2354@linux.vnet.ibm.com>
 <20100622094033.3becf09f.sfr@canb.auug.org.au>
 <20100622100423.205ae0a4.sfr@canb.auug.org.au>
 <20100622004030.GN2354@linux.vnet.ibm.com>
 <4C205779.20704@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C205779.20704@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 08:26:01AM +0200, Jens Axboe wrote:
> On 2010-06-22 02:40, Paul E. McKenney wrote:
> > On Tue, Jun 22, 2010 at 10:04:23AM +1000, Stephen Rothwell wrote:
> >> Hi Paul,
> >>
> >> On Tue, 22 Jun 2010 09:40:33 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >>>
> >>> On Mon, 21 Jun 2010 10:13:00 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> >>>>
> >>>> I took a look, and all of the changes from "fs: remove all rcu head
> >>>> initializations, except on_stack initializations" are reflected in -next.
> >>>
> >>> Thanks for checking.
> >>
> >> Is there some way that this commit can be merged via the block tree?  Or
> >> does later work in your tree depend on it?  There is considerable and
> >> ongoing work in the block tree on the same areas as your commit changes.
> >> Even today, this conflict is going to be much worse.
> > 
> > I have no problem with this patch being applied via the block tree, as
> > long as it doesn't take too many minor releases for it to hit mainline.  ;-)
> > 
> > How would everyone like to proceed?
> 
> The stuff in the block tree is either destined for the current release
> or the next one, the patches going into for-next are a merge of those
> two parts.
> 
> Is this rcu patch for .35 or .36?

.35 would be good.  ;-)  But I can make .36 work if need be.

Please see below for the patch.  Alternatively, feel free to grab commit
b97181f24212f4c29197890ce1b2b9100bcc184d from -tip or from
git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git

							Thanx, Paul

------------------------------------------------------------------------

commit b97181f24212f4c29197890ce1b2b9100bcc184d
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Mon May 10 17:09:25 2010 -0700

    fs: remove all rcu head initializations, except on_stack initializations
    
    Remove all rcu head inits. We don't care about the RCU head state before passing
    it to call_rcu() anyway. Only leave the "on_stack" variants so debugobjects can
    keep track of objects on stack.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    Cc: Alexander Viro <viro@zeniv.linux.org.uk>
    Cc: Andries Brouwer <aeb@cwi.nl>

diff --git a/fs/file.c b/fs/file.c
index 34bb7f7..cccaead 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -178,7 +178,6 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	fdt->open_fds = (fd_set *)data;
 	data += nr / BITS_PER_BYTE;
 	fdt->close_on_exec = (fd_set *)data;
-	INIT_RCU_HEAD(&fdt->rcu);
 	fdt->next = NULL;
 
 	return fdt;
@@ -312,7 +311,6 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 	new_fdt->close_on_exec = (fd_set *)&newf->close_on_exec_init;
 	new_fdt->open_fds = (fd_set *)&newf->open_fds_init;
 	new_fdt->fd = &newf->fd_array[0];
-	INIT_RCU_HEAD(&new_fdt->rcu);
 	new_fdt->next = NULL;
 
 	spin_lock(&oldf->file_lock);
@@ -430,7 +428,6 @@ struct files_struct init_files = {
 		.fd		= &init_files.fd_array[0],
 		.close_on_exec	= (fd_set *)&init_files.close_on_exec_init,
 		.open_fds	= (fd_set *)&init_files.open_fds_init,
-		.rcu		= RCU_HEAD_INIT,
 	},
 	.file_lock	= __SPIN_LOCK_UNLOCKED(init_task.file_lock),
 };
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 1d1088f..af92100 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -75,12 +75,33 @@ static inline bool bdi_work_on_stack(struct bdi_work *work)
 	return test_bit(WS_ONSTACK_B, &work->state);
 }
 
-static inline void bdi_work_init(struct bdi_work *work,
-				 struct wb_writeback_args *args)
+static inline void __bdi_work_init(struct bdi_work *work,
+				   struct wb_writeback_args *args,
+				   int on_stack)
 {
-	INIT_RCU_HEAD(&work->rcu_head);
 	work->args = *args;
 	work->state = WS_USED;
+	if (on_stack) {
+		work->state |= WS_ONSTACK;
+		init_rcu_head_on_stack(&work->rcu_head);
+	}
+}
+
+static inline void bdi_work_init(struct bdi_work *work,
+				 struct wb_writeback_args *args)
+{
+	__bdi_work_init(work, args, false);
+}
+
+static inline void bdi_work_init_on_stack(struct bdi_work *work,
+					  struct wb_writeback_args *args)
+{
+	__bdi_work_init(work, args, true);
+}
+
+static inline void bdi_destroy_work_on_stack(struct bdi_work *work)
+{
+	destroy_rcu_head_on_stack(&work->rcu_head);
 }
 
 /**
@@ -233,11 +254,11 @@ static void bdi_sync_writeback(struct backing_dev_info *bdi,
 	};
 	struct bdi_work work;
 
-	bdi_work_init(&work, &args);
-	work.state |= WS_ONSTACK;
+	bdi_work_init_on_stack(&work, &args);
 
 	bdi_queue_work(bdi, &work);
 	bdi_wait_on_work_clear(&work);
+	bdi_destroy_work_on_stack(&work);
 }
 
 /**
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 5dcd4b0..72c5265 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -459,7 +459,6 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	}
 
 	/* everything is up and running, commence */
-	INIT_RCU_HEAD(&p->rcu_head);
 	rcu_assign_pointer(ptbl->part[partno], p);
 
 	/* suppress uevent if the disk supresses it */
