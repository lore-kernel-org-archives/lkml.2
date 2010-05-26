Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab0EZTjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:39:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755541Ab0EZTjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:39:02 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergey Temerkhanov <temerkhanov@yandex.ru>,
       "linux-aio" <linux-aio@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Benjamin LaHaise <bcrl@kvack.org>, Zach Brown <zach.brown@oracle.com>,
       Suparna Bhattacharya <suparna@in.ibm.com>
Subject: Re: [PATCH][RFC] AIO: always reinitialize iocb->ki_run_list at the end of aio_run_iocb()
References: <201004280251.43430.temerkhanov@yandex.ru>
	<20100428113149.b912a3e8.akpm@linux-foundation.org>
	<201004300256.58207.temerkhanov@yandex.ru>
	<20100521144739.56c1ce0b.akpm@linux-foundation.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 26 May 2010 15:38:35 -0400
In-Reply-To: <20100521144739.56c1ce0b.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 21 May 2010 14:47:39 -0700")
Message-ID: <x49k4qqa1xg.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 30 Apr 2010 02:56:58 +0400
> Sergey Temerkhanov <temerkhanov@yandex.ru> wrote:
>
>> On Wednesday 28 April 2010 22:31:49 Andrew Morton wrote:
>> > On Wed, 28 Apr 2010 02:51:43 +0400
>> > 
>> > Sergey Temerkhanov <temerkhanov@yandex.ru> wrote:
>> > > This patch makes aio_run_iocb() to always reinitialize iocb->ki_run_list
>> > > (not only when iocb->ki_retry() function returns -EIOCBRETRY) so that
>> > > subsequent call of kick_iocb() will succeed.
>> > >
>> > > Regards, Sergey Temerkhanov,
>> > > Cifronic ZAO.
>> > >
>> > >
>> > > [reinit-ki_run_list.patch  text/x-patch (657B)]
>> > > diff -r 97344a0f62c9 fs/aio.c
>> > > --- a/fs/aio.c	Tue Apr 27 21:18:14 2010 +0400
>> > > +++ b/fs/aio.c	Tue Apr 27 21:30:23 2010 +0400
>> > > @@ -748,6 +748,9 @@
>> > >  out:
>> > >  	spin_lock_irq(&ctx->ctx_lock);
>> > >
>> > > +	/* will make __queue_kicked_iocb succeed from here on */
>> > > +	INIT_LIST_HEAD(&iocb->ki_run_list);
>> > > +
>> > >  	if (-EIOCBRETRY == ret) {
>> > >  		/*
>> > >  		 * OK, now that we are done with this iteration
>> > > @@ -756,8 +759,6 @@
>> > >  		 * "kick" can start the next iteration
>> > >  		 */
>> > >
>> > > -		/* will make __queue_kicked_iocb succeed from here on */
>> > > -		INIT_LIST_HEAD(&iocb->ki_run_list);
>> > >  		/* we must queue the next iteration ourselves, if it
>> > >  		 * has already been kicked */
>> > >  		if (kiocbIsKicked(iocb)) {
>> > 
>> > I assume that this fixes some runtime problem which you observed?
>> > 
>> > Can you please describe that problem?  This code is pretty old - what
>> > was your application doing that nobody else's application has thus far
>> > done?
>> 
>> I've written the driver code which implements a zero-copy DMA char device. It 
>> has aio_read() and aio_write() methods which return -EIOCBQUEUED after the 
>> successful preparation of the buffers described by kiocb and posting it to the 
>> descriptor chain. When the descriptors are processed, the DMA engine raises 
>> the interrupt and the cleanup work is done in the handler, including 
>> aio_complete() for the completed kiocbs.
>> 
>> This works fine, however, there is a problem with canceling the queued 
>> requests, espesially on io_destroy() syscall. Since there is no simple way to 
>> remove single kiocb from the descriptor chain, I'm removing all of them from 
>> the queue using aio_complete() or aio_put_req() in the ki_cancel() callback 
>> routine of my driver. The main problem is the reference counting in 
>> aio_cancel_all():
>> 
>> 		if (cancel) {
>> 			iocb->ki_users++;
>> 			spin_unlock_irq(&ctx->ctx_lock);
>> 			cancel(iocb, &res);
>> 			spin_lock_irq(&ctx->ctx_lock);
>> 		}
>> 
>> Here the iocb->ki_users gets incremented which already has the value 1 at this 
>> point (after the io_submit_one() completion) and it's never released (). So I 
>> have to call aio_put_req() twice for the given kiocb (this seems to be the 
>> hack to me) or I'll end up with the unkillable process stuck in 
>> wait_for_all_aios() at the io_schedule(). I've posted the patches where I've 
>> added aio_put_req() but I think it needs more testing.

I can vaguely recall discussion surrounding the reference counting of
cancel methods, but I have no idea what the actual contents of those
discussions were.  Sorry, my memory has failed me.  Either Zach or
Suparna might remember better.

Sergey, the cancellation path, unfortunately, is not well exercised as
I'm sure you are aware.  As you pointed out, the only implementation of
a cancel method is the usb gadget interface.  Now, given that they've
worked fine with the extra put in their cancel method, I'm not sure why
you can't do the same.  It sure is easier to validate than what you
propose below:

>> So, I've tried another 
>> approach (hack) - requeue the kiocb with kick_iocb() before calling 
>> aio_put_req() in the ki_cancel() callback (that's because aio_run_iocb() takes 
>> some special actions for the canceled kiocbs). And I've found out that 
>> kick_iocb() fails because aio_run_iocb() does this:
>> 	iocb->ki_run_list.next = iocb->ki_run_list.prev = NULL;
>> and only reinitializes iocb->ki_run_list when iocb->ki_retry() returns 
>> -EIOCBRETRY but kick_iocb() is exported and looks like intended for usage 
>> (though not recommended).
>> 
>> The only place where I've found the similar approach to AIO in the device 
>> driver is drivers/usb/gadget/inode.c.
>
> Looking up a few lines in aio_run_iocb() I see the helpful comment:
>
> 	/*
> 	 * This is so that aio_complete knows it doesn't need to
> 	 * pull the iocb off the run list (We can't just call
> 	 * INIT_LIST_HEAD because we don't want a kick_iocb to
> 	 * queue this on the run list yet)
> 	 */
> 	iocb->ki_run_list.next = iocb->ki_run_list.prev = NULL;
>
> and I wonder whether your change broke that.					
>
> Given that we've already run aoi_complete(), I assume it's OK, but it
> would be good if some of the more recently-involved aio guys could haev
> a think, please.

I'd rather not muddy these waters even further.  Unless there is a
compelling reason why the patch author cannot do an extra put in his
cancel method, I'd say that is the best way forward.

Cheers,
Jeff
