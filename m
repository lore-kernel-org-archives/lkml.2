Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab2FEUkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 16:40:40 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55294 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab2FEUkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 16:40:39 -0400
Message-ID: <1338928906.3292.45.camel@lappy>
Subject: Re: [PATCH] zcache: don't limit number of pools per client
From: Sasha Levin <levinsasha928@gmail.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: gregkh@linuxfoundation.org, dan.magenheimer@oracle.com,
        konrad.wilk@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Tue, 05 Jun 2012 22:41:46 +0200
In-Reply-To: <4FCE69BC.6060300@linux.vnet.ibm.com>
References: <1338894352-23054-1-git-send-email-levinsasha928@gmail.com>
	 <4FCE69BC.6060300@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 15:19 -0500, Seth Jennings wrote:
> > +	pool = idr_find(&cli->tmem_pools, poolid);
> > +	if (pool != NULL)
> > +		atomic_inc(&pool->refcount);
> 
> 
> This is called on the main path, so it needs to be fast.  There is so much
> contention elsewhere in the stack I don't think it'll be an issue. It looks
> like idr_find() is fast, even though it contains a loop.  Just needs to be
> considered.

Agreed. idr actually uses something which looks like a hash table, so it
should be fast enough for this case.

> > +retry:
> > +	r = idr_pre_get(&cli->tmem_pools, GFP_ATOMIC);
> 
> > +	if (r != 1) {
> > +		kfree(pool);
> > +		pr_info("zcache: pool creation failed: out of memory\n");
> > +		goto out;
> > +	}
> > +	r = idr_get_new(&cli->tmem_pools, pool, &poolid);
> > +	switch (r) {
> > +	case 0:
> > +		break;
> > +	case -EAGAIN:
> > +		goto retry;
> > +	default:
> > +		pr_info("zcache: pool creation failed: error %d\n", r);
> >  		kfree(pool);
> > -		poolid = -1;
> >  		goto out;
> >  	}
> > +
> 
> 
> how about:
> =====
> do {
> 	r = idr_pre_get(&cli->tmem_pools, GFP_ATOMIC);
> 	if (r != 1) {
> 		kfree(pool);
> 		pr_info("zcache: pool creation failed: out of memory\n");
> 		goto out;
> 	}
> 	r = idr_get_new(&cli->tmem_pools, pool, &poolid);
> }
> while (r == -EAGAIN)
> 
> if (r) {
> 	pr_info("zcache: pool creation failed: error %d\n", r);
> 	kfree(pool);
> 	goto out;
> }
> =====
> so we can lose the label/goto.
> 
> Also, do we want GFP_ATOMIC?  Why not GFP_KERNEL?

I wasn't sure about the context this code runs at, and assumed it's
atomic one due to the kmalloc allocating with GFP_ATOMIC just couple of
lines above the idr_pre_get. If that's wrong, we can switch that kmalloc
as well.

