Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab1HWJ55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 05:57:57 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:63250 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982Ab1HWJ5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 05:57:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkDAOl3U055LIxDgWdsb2JhbABBqBsVAQEWJiWBQAEBBAEnExwjEAgDDgouFCUDIROHcbdVDoVbXwSkJQ
Date: Tue, 23 Aug 2011 19:57:52 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, khlebnikov@openvz.org
Subject: Re: [PATCH 12/13] dcache: remove dentries from LRU before putting on
 dispose list
Message-ID: <20110823095752.GB3162@dastard>
References: <1314089786-20535-1-git-send-email-david@fromorbit.com>
 <1314089786-20535-13-git-send-email-david@fromorbit.com>
 <20110823093520.GA4938@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823093520.GA4938@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 05:35:20AM -0400, Christoph Hellwig wrote:
> > diff --git a/fs/dcache.c b/fs/dcache.c
> > index b931415..79bf47c 100644
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -269,10 +269,10 @@ static void dentry_lru_move_list(struct dentry *dentry, struct list_head *list)
> >  	spin_lock(&dentry->d_sb->s_dentry_lru_lock);
> >  	if (list_empty(&dentry->d_lru)) {
> >  		list_add_tail(&dentry->d_lru, list);
> > -		dentry->d_sb->s_nr_dentry_unused++;
> > -		this_cpu_inc(nr_dentry_unused);
> >  	} else {
> >  		list_move_tail(&dentry->d_lru, list);
> > +		dentry->d_sb->s_nr_dentry_unused--;
> > +		this_cpu_dec(nr_dentry_unused);
> >  	}
> >  	spin_unlock(&dentry->d_sb->s_dentry_lru_lock);
> 
> I suspect at this point it might be more obvious to simply remove
> dentry_lru_move_list.  Just call dentry_lru_del to remove it from the
> lru, and then we can add it to the local dispose list without the need
> of any locking, similar to how it is done for inodes already.

Yeah, that is what is done in the next patch when converting to the
generic LRU list code. I can probably pull this back into this patch
and just remove dentry_lru_move_list(0 right here.

> 
> >  		if (dentry->d_count) {
> > -			dentry_lru_del(dentry);
> >  			spin_unlock(&dentry->d_lock);
> >  			continue;
> >  		}
> > @@ -789,6 +794,8 @@ relock:
> >  			spin_unlock(&dentry->d_lock);
> >  		} else {
> >  			list_move_tail(&dentry->d_lru, &tmp);
> > +			this_cpu_dec(nr_dentry_unused);
> > +			sb->s_nr_dentry_unused--;
> 
> It might be more obvious to use __dentry_lru_del + an opencoded list_add
> here.

This goes away completely in the next patch, so I don't think it
matters that much...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
