Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab0JTChv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 22:37:51 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:31922 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753738Ab0JTChu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 22:37:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALvxvUx5LdoF/2dsb2JhbAChVXLCfoVKBA
Date: Wed, 20 Oct 2010 13:37:47 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: npiggin@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch 23/35] fs: icache use per-CPU lists and locks for sb
 inode lists
Message-ID: <20101020023747.GD3740@amd>
References: <20101019034216.319085068@kernel.dk>
 <20101019034657.896022051@kernel.dk>
 <E1P8ECI-0006iU-3h@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1P8ECI-0006iU-3h@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 05:33:54PM +0200, Miklos Szeredi wrote:
> On Tue, 19 Oct 2010, npiggin@kernel.d wrote:
> > +/**
> > + * inode_sb_list_add - add an inode to the sb's file list
> > + * @inode: inode to add
> > + * @sb: sb to add it to
> > + *
> > + * Use this function to associate an with the superblock it belongs to.
> 
>                                        ^^^inode

Yes, thanks.


> > @@ -1270,6 +1316,7 @@
> >  			continue;
> >  		if (!spin_trylock(&old->i_lock)) {
> >  			spin_unlock_bucket(b);
> > +			cpu_relax();
> 
> Doesn't this logically belong to a previous patch?

Yes, I had a couple of them leak out. I'll try to fix them
up... most trylocks get resolved with RCU later.

 
> > Index: linux-2.6/fs/super.c
> > ===================================================================
> > --- linux-2.6.orig/fs/super.c	2010-10-19 14:17:17.000000000 +1100
> > +++ linux-2.6/fs/super.c	2010-10-19 14:18:59.000000000 +1100
> > @@ -67,12 +67,25 @@
> >  			for_each_possible_cpu(i)
> >  				INIT_LIST_HEAD(per_cpu_ptr(s->s_files, i));
> >  		}
> > +		s->s_inodes = alloc_percpu(struct list_head);
> > +		if (!s->s_inodes) {
> > +			free_percpu(s->s_files);
> > +			security_sb_free(s);
> > +			kfree(s);
> > +			s = NULL;
> > +			goto out;
> 
> Factor out error cleanups to separate out labels?

OK... probably makes sense at this point.

