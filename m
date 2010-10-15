Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab0JOSCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 14:02:25 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:63377 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932180Ab0JOSCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 14:02:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAAE0uEx5Ld+3/2dsb2JhbAChJXLAF4VJBI9K
Date: Sat, 16 Oct 2010 05:02:19 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101015180219.GA11110@amd>
References: <20101015001443.GA3146@amd>
 <20101015031343.GG4681@dastard>
 <20101015033017.GA6750@amd>
 <20101015034451.GA6827@amd>
 <20101015064150.GB7511@amd>
 <20101015105943.GE32255@dastard>
 <20101015130259.GA3207@amd>
 <20101015132938.GA3936@amd>
 <20101015173345.GA10731@amd>
 <20101015175247.GA6737@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015175247.GA6737@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 01:52:47PM -0400, Christoph Hellwig wrote:
> Thanks for trying to get back to a technical discussion.  Maybe we
> can just move the technical comments to direct replies to the patches
> and leave this not very helpful subthread behind?

I had plenty of other technical comments which you ignored about
per-zone shrinkers and stragegy to merge the overall series. If you
are going to keep claiming these are show stoppers, please address
my comments there too.

 
> > rcu_read_lock();
> > list_for_each_entry(inode, list) {
> >     if (inode->blah ...) {
> >       spin_lock(&list_lock);
> >       if (unlikely(list_empty(&inode->i_list)))
> >         continue;
> >       do_something(inode);
> >    }
> > }
> 
> But that't not what we do for icache.  For the validity checking
> during lookup we check the I_FREEING bit, which is modified under
> i_lock and can be read without any locking.  So everything is just
> fine when moving on to RCU locking.

For those lookups where you are taking the i_lock anyway, they
will look the same, except the i_lock lock width reduction
loses the ability to lock all icache state of the inode (like
we can practically do today with inode_lock).

This was a key consideration for maintainability for me. I also
spelled out quite clearly the i_lock reduction approach for
future speedup if the single atomic in the slowpath is really
that important. But for those kinds of complications to the
locking rules I want to add as individual small patches to the
end of the series where the streamlining work is happening. If
they are not worth the gains, I much prefer to keep the locking
more regular.

