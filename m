Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1HILE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 07:04:27 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:43023 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753122Ab1HILE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 07:04:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArkDAJ8SQU55LbABgWdsb2JhbABCpzcVAQEWJiWBQAEBBTocIxAIAxguFCUDIRPEQA6GOASkAg
Date: Tue, 9 Aug 2011 21:04:21 +1000
From: Dave Chinner <david@fromorbit.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] dentry: move to per-sb LRU locks
Message-ID: <20110809110420.GT3162@dastard>
References: <1312787021-11324-1-git-send-email-david@fromorbit.com>
 <1312787021-11324-3-git-send-email-david@fromorbit.com>
 <1312808544.10488.31.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312808544.10488.31.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 03:02:24PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-08 at 17:03 +1000, Dave Chinner wrote:
> > +       /* s_dentry_lru_lock protects s_dentry_lru, s_nr_dentry_unused */
> > +       spinlock_t              s_dentry_lru_lock ____cacheline_aligned_in_smp;
> >         struct list_head        s_dentry_lru;   /* unused dentry lru */ 
> 
> Wouldn't it make sense to have both those on the same cacheline?

Um, they are, aren't they? The annotation moves s_dentry_lru_lock to
the start of a new cacheline, and everything packs in after that?

$ pahole fs/dcache.o
....
        /* --- cacheline 8 boundary (512 bytes) --- */
        spinlock_t                 s_dentry_lru_lock;    /*   512    72 */
        /* --- cacheline 9 boundary (576 bytes) was 8 bytes ago --- */
        struct list_head           s_dentry_lru;         /*   584    16 */
        int                        s_nr_dentry_unused;   /*   600     4 */

Oh, bloody hell. When did that change? (let me guess - gcc changed
the implementation of attribute __aligned__ to affect the size of 
variables for packing as well as alignment at some point?)

Ok, so how do I it move the lock to the start of the next cache line
and have the following variables pack tightly against it so they are
all on the same cache line? And on a different cacheline to the
s_inode_lru* variables that also have the same
____cacheline_aligned_in_smp annotations....

/me sees a patch to other XFS structures in the not-to-distant future

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
