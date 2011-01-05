Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab1AEL2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 06:28:14 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60536 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab1AEL2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 06:28:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HdXlj40QJ4d++w/ZY/nkjK7aFxpt1sVMaUgLcyhy6wr/lSSa8Ru+B9x3f+jokdluEt
         v+Dx1z0Yi8yaaaL8FCf0/HzlJKFMkGfCBaTp91GNLKZY5iZRrDvTexKoF3zeVSIWH3H+
         FHOEt1crlbtRXIqW9Lz5fca+6XIfLudRVBKAY=
Date: Wed, 5 Jan 2011 03:28:02 -0800
From: Tejun Heo <tj@kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
        linux-aio@kvack.org
Subject: Re: [PATCH 21/32] fs/aio: aio_wq isn't used in memory reclaim path
Message-ID: <20110105112802.GA7669@mtj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-22-git-send-email-tj@kernel.org>
 <x49d3ocacij.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49d3ocacij.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jan 04, 2011 at 10:56:20AM -0500, Jeff Moyer wrote:
> > aio_wq isn't used during memory reclaim.  Convert to alloc_workqueue()
> > without WQ_MEM_RECLAIM.  It's possible to use system_wq but given that
> > the number of work items is determined from userland and the work item
> > may block, enforcing strict concurrency limit would be a good idea.
> 
> I would think that just given that it may block would be enough to keep
> it off of the system workqueue.

Oh, workqueue now can handle parallel execution.  Blocking on system
workqueue is no longer a problem.  One of the main reasons for this
whole series.

> > @@ -85,7 +85,7 @@ static int __init aio_setup(void)
> >  	kiocb_cachep = KMEM_CACHE(kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
> >  	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);
> >  
> > -	aio_wq = create_workqueue("aio");
> > +	aio_wq = alloc_workqueue("aio", 0, 1);	/* used to limit concurrency */
> 
> OK, the only difference here is the removal of the WQ_MEM_RECLAIM flag,
> as you noted.

Yeap.  Do you agree that the concurrency limit is necessary?  If not,
we can just put everything onto system_wq.

> > @@ -569,7 +569,7 @@ static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
> >  		spin_lock(&fput_lock);
> >  		list_add(&req->ki_list, &fput_head);
> >  		spin_unlock(&fput_lock);
> > -		queue_work(aio_wq, &fput_work);
> > +		schedule_work(&fput_work);
> 
> I'm not sure where this change fits into the patch description.  Why did
> you do this?

Yeah, that's me being forgetful.  Now that aio_wq is solely used to
throttle the max concurrency of aio work items, I thought it would be
better to push fput_work to system workqueue so that it doesn't
interact with aio work items.  I'll update the patch description.

Thanks.

-- 
tejun
