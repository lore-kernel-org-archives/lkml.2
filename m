Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383Ab1AEOvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 09:51:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab1AEOvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 09:51:05 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
        linux-aio@kvack.org
Subject: Re: [PATCH 21/32] fs/aio: aio_wq isn't used in memory reclaim path
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
	<1294062595-30097-22-git-send-email-tj@kernel.org>
	<x49d3ocacij.fsf@segfault.boston.devel.redhat.com>
	<20110105112802.GA7669@mtj.dyndns.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 05 Jan 2011 09:50:57 -0500
In-Reply-To: <20110105112802.GA7669@mtj.dyndns.org> (Tejun Heo's message of
	"Wed, 5 Jan 2011 03:28:02 -0800")
Message-ID: <x49d3obqu9a.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> On Tue, Jan 04, 2011 at 10:56:20AM -0500, Jeff Moyer wrote:
>> > aio_wq isn't used during memory reclaim.  Convert to alloc_workqueue()
>> > without WQ_MEM_RECLAIM.  It's possible to use system_wq but given that
>> > the number of work items is determined from userland and the work item
>> > may block, enforcing strict concurrency limit would be a good idea.
>> 
>> I would think that just given that it may block would be enough to keep
>> it off of the system workqueue.
>
> Oh, workqueue now can handle parallel execution.  Blocking on system
> workqueue is no longer a problem.  One of the main reasons for this
> whole series.

OK, thanks for clarifying for me.

>> > @@ -85,7 +85,7 @@ static int __init aio_setup(void)
>> >  	kiocb_cachep = KMEM_CACHE(kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
>> >  	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);
>> >  
>> > -	aio_wq = create_workqueue("aio");
>> > +	aio_wq = alloc_workqueue("aio", 0, 1);	/* used to limit concurrency */
>> 
>> OK, the only difference here is the removal of the WQ_MEM_RECLAIM flag,
>> as you noted.
>
> Yeap.  Do you agree that the concurrency limit is necessary?  If not,
> we can just put everything onto system_wq.

I'm not sure whether it's strictly necessary (there may very well be a
need for this in the usb gadgetfs code), but keeping it the same at
least seems safe.

>> > @@ -569,7 +569,7 @@ static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
>> >  		spin_lock(&fput_lock);
>> >  		list_add(&req->ki_list, &fput_head);
>> >  		spin_unlock(&fput_lock);
>> > -		queue_work(aio_wq, &fput_work);
>> > +		schedule_work(&fput_work);
>> 
>> I'm not sure where this change fits into the patch description.  Why did
>> you do this?
>
> Yeah, that's me being forgetful.  Now that aio_wq is solely used to
> throttle the max concurrency of aio work items, I thought it would be
> better to push fput_work to system workqueue so that it doesn't
> interact with aio work items.  I'll update the patch description.

OK, thanks.

-Jeff
