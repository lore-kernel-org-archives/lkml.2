Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab1GLAeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 20:34:09 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:61839 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754307Ab1GLAeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 20:34:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgcEAOSTG055LCkBgWdsb2JhbABTpyUVAQEWJiXKGQ6GLASjLw
Date: Tue, 12 Jul 2011 10:34:03 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 08/14] inode: move to per-sb LRU locks
Message-ID: <20110712003403.GH23038@dastard>
References: <1310098486-6453-1-git-send-email-david@fromorbit.com>
 <1310098486-6453-9-git-send-email-david@fromorbit.com>
 <20110711192144.GA23723@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711192144.GA23723@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 03:21:44PM -0400, Christoph Hellwig wrote:
> On Fri, Jul 08, 2011 at 02:14:40PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > With the inode LRUs moving to per-sb structures, there is no longer
> > a need for a global inode_lru_lock. The locking can be made more
> > fine-grained by moving to a per-sb LRU lock, isolating the LRU
> > operations of different filesytsems completely from each other.
> 
> Btw, any reason this is not done for dcache_lru_lock?

I have a patch that does exactly that, but it causes random crashes
and oopsen in the dentry code due to corrupted lists and dentries
when running xfstests. Like the inode cache, it is a simple
translation of dcache_lru_lock to sb->s_dentry_lru_lock, so it
should not be changing what is protected by the LRU lock.

The patch used to work fine before the massive locking rework of the
dentry cache, so it appears that there is now something unknown that
dcache_lru_lock is implicitly protecting.  However, the locking is
now so complex I've been unable to debug the problems caused by the
patch, so I simply dropped the patch.

I might try again later to break up the dcache_lru_lock, but right
now it's not showing up as a badly contended lock in my tests and
I've got other things that are more important to do, so I've been
ignoring the problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
