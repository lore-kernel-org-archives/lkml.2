Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab0D3Qts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:49:48 -0400
Received: from forward8.mail.yandex.net ([77.88.61.38]:58792 "EHLO
	forward8.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570Ab0D3Qto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:49:44 -0400
From: Sergey Temerkhanov <temerkhanov@yandex.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RFC] AIO: always reinitialize iocb->ki_run_list at the end of aio_run_iocb()
Date: Fri, 30 Apr 2010 02:56:58 +0400
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-desktop; KDE/4.3.5; x86_64; ; )
Cc: Sergey Temerkhanov <temerkhanov@yandex.ru>,
       "linux-aio" <linux-aio@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <201004280251.43430.temerkhanov@yandex.ru> <20100428113149.b912a3e8.akpm@linux-foundation.org>
In-Reply-To: <20100428113149.b912a3e8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004300256.58207.temerkhanov@yandex.ru>
X-Yandex-TimeMark: 1272581839
X-Yandex-Spam: 1
X-Yandex-Front: smtp8.mail.yandex.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 April 2010 22:31:49 Andrew Morton wrote:
> On Wed, 28 Apr 2010 02:51:43 +0400
> 
> Sergey Temerkhanov <temerkhanov@yandex.ru> wrote:
> > This patch makes aio_run_iocb() to always reinitialize iocb->ki_run_list
> > (not only when iocb->ki_retry() function returns -EIOCBRETRY) so that
> > subsequent call of kick_iocb() will succeed.
> >
> > Regards, Sergey Temerkhanov,
> > Cifronic ZAO.
> >
> >
> > [reinit-ki_run_list.patch  text/x-patch (657B)]
> > diff -r 97344a0f62c9 fs/aio.c
> > --- a/fs/aio.c	Tue Apr 27 21:18:14 2010 +0400
> > +++ b/fs/aio.c	Tue Apr 27 21:30:23 2010 +0400
> > @@ -748,6 +748,9 @@
> >  out:
> >  	spin_lock_irq(&ctx->ctx_lock);
> >
> > +	/* will make __queue_kicked_iocb succeed from here on */
> > +	INIT_LIST_HEAD(&iocb->ki_run_list);
> > +
> >  	if (-EIOCBRETRY == ret) {
> >  		/*
> >  		 * OK, now that we are done with this iteration
> > @@ -756,8 +759,6 @@
> >  		 * "kick" can start the next iteration
> >  		 */
> >
> > -		/* will make __queue_kicked_iocb succeed from here on */
> > -		INIT_LIST_HEAD(&iocb->ki_run_list);
> >  		/* we must queue the next iteration ourselves, if it
> >  		 * has already been kicked */
> >  		if (kiocbIsKicked(iocb)) {
> 
> I assume that this fixes some runtime problem which you observed?
> 
> Can you please describe that problem?  This code is pretty old - what
> was your application doing that nobody else's application has thus far
> done?

I've written the driver code which implements a zero-copy DMA char device. It 
has aio_read() and aio_write() methods which return -EIOCBQUEUED after the 
successful preparation of the buffers described by kiocb and posting it to the 
descriptor chain. When the descriptors are processed, the DMA engine raises 
the interrupt and the cleanup work is done in the handler, including 
aio_complete() for the completed kiocbs.

This works fine, however, there is a problem with canceling the queued 
requests, espesially on io_destroy() syscall. Since there is no simple way to 
remove single kiocb from the descriptor chain, I'm removing all of them from 
the queue using aio_complete() or aio_put_req() in the ki_cancel() callback 
routine of my driver. The main problem is the reference counting in 
aio_cancel_all():

		if (cancel) {
			iocb->ki_users++;
			spin_unlock_irq(&ctx->ctx_lock);
			cancel(iocb, &res);
			spin_lock_irq(&ctx->ctx_lock);
		}

Here the iocb->ki_users gets incremented which already has the value 1 at this 
point (after the io_submit_one() completion) and it's never released (). So I 
have to call aio_put_req() twice for the given kiocb (this seems to be the 
hack to me) or I'll end up with the unkillable process stuck in 
wait_for_all_aios() at the io_schedule(). I've posted the patches where I've 
added aio_put_req() but I think it needs more testing. So, I've tried another 
approach (hack) - requeue the kiocb with kick_iocb() before calling 
aio_put_req() in the ki_cancel() callback (that's because aio_run_iocb() takes 
some special actions for the canceled kiocbs). And I've found out that 
kick_iocb() fails because aio_run_iocb() does this:
	iocb->ki_run_list.next = iocb->ki_run_list.prev = NULL;
and only reinitializes iocb->ki_run_list when iocb->ki_retry() returns 
-EIOCBRETRY but kick_iocb() is exported and looks like intended for usage 
(though not recommended).

The only place where I've found the similar approach to AIO in the device 
driver is drivers/usb/gadget/inode.c.

> 
> Also, please send your Signed-off-by: for this patch, as per
> Documentation/Submittingpatches, thanks.
> 

Sorry, I've forgotten this.

Signed-off-by: Sergey Temerkhanov <temerkhanov@cifronik.ru>

Regards, Sergey Temerkhanov,
Cifronic ZAO
