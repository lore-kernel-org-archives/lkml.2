Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab2BFQri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:47:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52498 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab2BFQrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:47:37 -0500
Date: Mon, 6 Feb 2012 17:47:32 +0100
From: Jan Kara <jack@suse.cz>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, hare@suse.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] vfs: Avoid IPI storm due to bh LRU invalidation
Message-ID: <20120206164732.GH6890@quack.suse.cz>
References: <1328536531-19034-1-git-send-email-jack@suse.cz>
 <4F2FF4EC.1000104@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2FF4EC.1000104@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 06-02-12 21:12:36, Srivatsa S. Bhat wrote:
> On 02/06/2012 07:25 PM, Jan Kara wrote:
> 
> > When discovery of lots of disks happen in parallel, we call
> > invalidate_bh_lrus() once for each disk from partitioning code resulting in a
> > storm of IPIs and causing a softlockup detection to fire (it takes several
> > *minutes* for a machine to execute all the invalidate_bh_lrus() calls).
> > 
> > Fix the issue by allowing only single invalidation to run using a mutex and let
> > waiters for mutex figure out whether someone invalidated LRUs for them while
> > they were waiting.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/buffer.c |   23 ++++++++++++++++++++++-
> >  1 files changed, 22 insertions(+), 1 deletions(-)
> > 
> >   I feel this is slightly hacky approach but it works. If someone has better
> > idea, please speak up.
> > 
> 
> 
> Something related that you might be interested in:
> https://lkml.org/lkml/2012/2/5/109
> 
> (This is part of Gilad's patchset that tries to reduce cross-CPU IPI
> interference.)
  Thanks for the pointer. I didn't know about it. As Hannes wrote, this
need not be enough for our use case as there might indeed be some bhs in
the LRU. But I'd be interested how well the patchset works anyway. Maybe it
would be enough because after all when we invalidate LRUs subsequent
callers will see them empty and not issue IPI? Hannes, can you give a try
to the patches?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
