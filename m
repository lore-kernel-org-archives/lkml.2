Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab0ENRly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 13:41:54 -0400
Received: from lazybastard.de ([212.112.238.170]:46720 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab0ENRlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 13:41:52 -0400
Date: Fri, 14 May 2010 19:41:43 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kirjanov@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] lib/btree: Fix possible NULL pointer dereference
Message-ID: <20100514174143.GB32417@logfs.org>
References: <20100512212026.GA5513@coldcone> <20100513131907.a3373db2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100513131907.a3373db2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010 13:19:07 -0700, Andrew Morton wrote:
> On Thu, 13 May 2010 01:20:27 +0400
> "Denis Kirjanov <kirjanov@gmail.com" <kirjanov@gmail.com> wrote:
> 
> > mempool_alloc can return null in atomic case.
> > 
> > Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
> > ---
> > diff --git a/lib/btree.c b/lib/btree.c
> > index 41859a8..542c904 100644
> > --- a/lib/btree.c
> > +++ b/lib/btree.c
> > @@ -95,7 +94,8 @@ static unsigned long *btree_node_alloc(struct btree_head *head, gfp_t gfp)
> >  	unsigned long *node;
> >  
> >  	node = mempool_alloc(head->mempool, gfp);
> > -	memset(node, 0, NODESIZE);
> > +	if (likely(node))
> > +		memset(node, 0, NODESIZE);
> >  	return node;
> >  }
> 
> hm, why is btree.c using mempools?  mempools are only appropriate when
> it is known that objects will become available if the allocating task
> simply waits for a while.  Typically, things like BIOs and
> request-structs.  Simply waiting for the disk to complete some IO will
> cause some objects to be returned to the mempool.

For the current caller (logfs), that is a fairly accurate description.

> If waiting-and-doing-nothing fails to cause objects to be returned to
> the pool then the mempool code can lock up.

True.  And I am not 100% sure logfs is bug-free in that respect.  One
item on my todo list is to add some sort of mempool_prefill() that
either ensures pool->curr_nr == pool->min_nr or returns -ENOMEM.  That
would allow logfs start some writeback and wait for the flash, when
necessary.

Jörn

-- 
When in doubt, punt.  When somebody actually complains, go back and fix it...
The 90% solution is a good thing.
-- Rob Landley
