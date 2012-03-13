Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab2CMPtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 11:49:52 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:59951 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab2CMPtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 11:49:51 -0400
Date: Tue, 13 Mar 2012 08:49:45 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>
Subject: Re: [PATCH v2] block: fix ioc leak in put_io_context
Message-ID: <20120313154945.GA7349@google.com>
References: <20120312142226.GD17288@redhat.com>
 <1331659266-21940-1-git-send-email-xtfeng@gmail.com>
 <20120313142820.GF29169@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313142820.GF29169@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 10:28:20AM -0400, Vivek Goyal wrote:
> On Tue, Mar 13, 2012 at 01:21:06PM -0400, Xiaotian Feng wrote:
> > diff --git a/block/blk-ioc.c b/block/blk-ioc.c
> > index 8b782a6..9690f27 100644
> > --- a/block/blk-ioc.c
> > +++ b/block/blk-ioc.c
> > @@ -145,6 +145,7 @@ static void ioc_release_fn(struct work_struct *work)
> >  void put_io_context(struct io_context *ioc)
> >  {
> >  	unsigned long flags;
> > +	bool free_ioc = false;
> >  
> >  	if (ioc == NULL)
> >  		return;
> > @@ -159,8 +160,13 @@ void put_io_context(struct io_context *ioc)
> >  		spin_lock_irqsave(&ioc->lock, flags);
> >  		if (!hlist_empty(&ioc->icq_list))
> >  			schedule_work(&ioc->release_work);
> > +		else
> > +			free_ioc = true;

Calling kmem_cache_free() here directly is probably better.

> >  		spin_unlock_irqrestore(&ioc->lock, flags);
> >  	}
> > +
> > +	if (free_ioc)
> > +		kmem_cache_free(iocontext_cachep, ioc);
> >  }
> >  EXPORT_SYMBOL(put_io_context);
> 
> This one looks good to me. Tejun?
> 
> Acked-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
