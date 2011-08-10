Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab1HJFgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 01:36:04 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:19247 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963Ab1HJFgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 01:36:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgDAMEWQk55LbABgWdsb2JhbABBp0QVAQEWJiWBQAEBBTocIxAIAxguFCUDIRPFUQ6GOASkCA
Date: Wed, 10 Aug 2011 15:35:56 +1000
From: Dave Chinner <david@fromorbit.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] dentry: move to per-sb LRU locks
Message-ID: <20110810053556.GY3162@dastard>
References: <1312787021-11324-1-git-send-email-david@fromorbit.com>
 <1312787021-11324-3-git-send-email-david@fromorbit.com>
 <1312808544.10488.31.camel@twins>
 <20110809110420.GT3162@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809110420.GT3162@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 09:04:21PM +1000, Dave Chinner wrote:
> On Mon, Aug 08, 2011 at 03:02:24PM +0200, Peter Zijlstra wrote:
> > On Mon, 2011-08-08 at 17:03 +1000, Dave Chinner wrote:
> > > +       /* s_dentry_lru_lock protects s_dentry_lru, s_nr_dentry_unused */
> > > +       spinlock_t              s_dentry_lru_lock ____cacheline_aligned_in_smp;
> > >         struct list_head        s_dentry_lru;   /* unused dentry lru */ 
> > 
> > Wouldn't it make sense to have both those on the same cacheline?
> 
> Um, they are, aren't they? The annotation moves s_dentry_lru_lock to
> the start of a new cacheline, and everything packs in after that?
> 
> $ pahole fs/dcache.o
> ....
>         /* --- cacheline 8 boundary (512 bytes) --- */
>         spinlock_t                 s_dentry_lru_lock;    /*   512    72 */
>         /* --- cacheline 9 boundary (576 bytes) was 8 bytes ago --- */
>         struct list_head           s_dentry_lru;         /*   584    16 */
>         int                        s_nr_dentry_unused;   /*   600     4 */
> 
> Oh, bloody hell. When did that change?

Actually, it hasn't. The problem here is that when you build with
lockdep and all the associated checking, a spinlock grows from 4
bytes to 72 bytes, pushing anything after it onto the next
cacheline. I didn't notice that until I just did a build with a
non-lockdep kernel and saw the structure change size significantly.
So the struct superblock looks like this without lockdep:

....
        struct list_head *         s_files;              /*   216     8 */

        /* XXX 32 bytes hole, try to pack */

        /* --- cacheline 4 boundary (256 bytes) --- */
        spinlock_t                 s_dentry_lru_lock;    /*   256     4 */

        /* XXX 4 bytes hole, try to pack */

        struct list_head           s_dentry_lru;         /*   264    16 */
        int                        s_nr_dentry_unused;   /*   280     4 */

        /* XXX 36 bytes hole, try to pack */

        /* --- cacheline 5 boundary (320 bytes) --- */
        spinlock_t                 s_inode_lru_lock;     /*   320     4 */

        /* XXX 4 bytes hole, try to pack */

        struct list_head           s_inode_lru;          /*   328    16 */
        int                        s_nr_inodes_unused;   /*   344     4 */

        /* XXX 4 bytes hole, try to pack */

        struct block_device *      s_bdev;               /*   352     8 */
        struct backing_dev_info *  s_bdi;                /*   360     8 */
        struct mtd_info *          s_mtd;                /*   368     8 */
        struct list_head           s_instances;          /*   376    16 */
        /* --- cacheline 6 boundary (384 bytes) was 8 bytes ago --- */
        struct quota_info          s_dquot;              /*   392   280 */
....

So we see the dentry LRU lock, list and counter on it's own cache
line, and the inode LRU lock, list and counter on the next cache
line.

But what is does point out is that we should actually also add a
____cacheline_aligned_in_smp annotation to the variable -after- the
variables we want on their own cacheline so that they don't get
packed tightly into the cacheline we want for the LRU variables.
That's not something I'm going to fix in this patch...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
