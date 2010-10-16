Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab0JPRTx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 13:19:53 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:28916 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751946Ab0JPRTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 13:19:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmQEADd6uUx5LcB2gWdsb2JhbAChMBYBARYiIsAyhUkEhQw
Date: Sun, 17 Oct 2010 04:19:48 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/18] fs: split locking of inode writeback and LRU
 lists
Message-ID: <20101016171948.GD3240@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-14-git-send-email-david@fromorbit.com>
 <20101008074243.GB24089@infradead.org>
 <20101008080018.GV4681@dastard>
 <20101008081816.GA17577@infradead.org>
 <20101016075713.GQ19147@amd>
 <20101016162021.GE16861@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016162021.GE16861@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 12:20:21PM -0400, Christoph Hellwig wrote:
> On Sat, Oct 16, 2010 at 06:57:13PM +1100, Nick Piggin wrote:
> > > That needs some documentation both in the changelog and in the code
> > > I think.
> > 
> > This is another instance where the irregular i_lock locking is making
> > these little subtleties to the locking. I think that is actually much
> > worse for maintainence/complexity than a few trylocks which can be
> > mostly removed with rcu anyway (which are obvious because of the well
> > documented lock order).
> 
> Care to explain why?

OK.


>  The I_FREEING and co checks are how we do things
> all over the icache for a long time.

That's missing my point. My point is that the semantics of icache
concurrency here are changed from the old inode_lock model. With
my design, holding i_lock on an inode is equivalent (stronger,
actually) to holding inode_lock which is an important part of
making small correct steps.


>  They are perfectly easy to
> understand concept.

The concept is easy to understand, but catching all the changes
are not necessarily so easy. You said it yourself

 "What does this have to do with the rest of the patch?"

So, I repeat, I never objected to narrowing i_lock widths, but I
would like to do it as very small patches that would move i_lock
out of some data structure manipulation and add the required additions
like this hunk. I want to see what we gain by making the locking model
less regular.


