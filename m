Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab0FAVPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:15:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117Ab0FAVPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:15:30 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Sergey Temerkhanov <temerkhanov@yandex.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-aio" <linux-aio@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Benjamin LaHaise <bcrl@kvack.org>, Zach Brown <zach.brown@oracle.com>,
       Suparna Bhattacharya <suparna@in.ibm.com>
Subject: Re: [PATCH][RFC] AIO: always reinitialize iocb->ki_run_list at the end of aio_run_iocb()
References: <201004280251.43430.temerkhanov@yandex.ru>
	<20100521144739.56c1ce0b.akpm@linux-foundation.org>
	<x49k4qqa1xg.fsf@segfault.boston.devel.redhat.com>
	<201005271406.36489.temerkhanov@yandex.ru>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 01 Jun 2010 17:14:48 -0400
In-Reply-To: <201005271406.36489.temerkhanov@yandex.ru> (Sergey Temerkhanov's
	message of "Thu, 27 May 2010 14:06:36 +0400")
Message-ID: <x49iq62lak7.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Temerkhanov <temerkhanov@yandex.ru> writes:

> On Wednesday 26 May 2010 23:38:35 Jeff Moyer wrote:
> ...
>> I can vaguely recall discussion surrounding the reference counting of
>> cancel methods, but I have no idea what the actual contents of those
>> discussions were.  Sorry, my memory has failed me.  Either Zach or
>> Suparna might remember better.
>> 
>> Sergey, the cancellation path, unfortunately, is not well exercised as
>> I'm sure you are aware.  As you pointed out, the only implementation of
>> a cancel method is the usb gadget interface.  Now, given that they've
>> worked fine with the extra put in their cancel method, I'm not sure why
>> you can't do the same. 
> Well, in fact, they have only one aio_put_req() in their cancel method. This 
> is the code from 2.6.34:

I was referring to the aio_put_req done deeper in the call chain by the
completion methods for the usb gadgetfs request.

> And adding extra aio_put_req() to the cancel method will not fix failing 
> kick_iocb() which is another problem and this patch is supposed to address it.

I guess I'm confused.  You wrote the following:

> I've written the driver code which implements a zero-copy DMA char device. It 
> has aio_read() and aio_write() methods which return -EIOCBQUEUED after the 
> successful preparation of the buffers described by kiocb and posting it to the 
> descriptor chain. When the descriptors are processed, the DMA engine raises 
> the interrupt and the cleanup work is done in the handler, including 
> aio_complete() for the completed kiocbs.
>
> This works fine, however, there is a problem with canceling the queued 
> requests, espesially on io_destroy() syscall. Since there is no simple way to 
> remove single kiocb from the descriptor chain, I'm removing all of them from 
> the queue using aio_complete() or aio_put_req() in the ki_cancel() callback 
> routine of my driver. The main problem is the reference counting in 
> aio_cancel_all():
>
> 		if (cancel) {
> 			iocb->ki_users++;
> 			spin_unlock_irq(&ctx->ctx_lock);
> 			cancel(iocb, &res);
> 			spin_lock_irq(&ctx->ctx_lock);
> 		}
>
> Here the iocb->ki_users gets incremented which already has the value 1 at this 
> point (after the io_submit_one() completion) and it's never released (). So I 
> have to call aio_put_req() twice for the given kiocb (this seems to be the 
> hack to me) or I'll end up with the unkillable process stuck in 
> wait_for_all_aios() at the io_schedule(). I've posted the patches where I've 
> added aio_put_req() but I think it needs more testing. 

OK, you tried two aio_put_req() calls, and it worked, but you thought
maybe it wasn't the right approach.  So:

> So, I've tried another approach (hack) - requeue the kiocb with
> kick_iocb() before calling aio_put_req() in the ki_cancel() callback
> (that's because aio_run_iocb() takes some special actions for the
> canceled kiocbs). And I've found out that kick_iocb() fails because
> aio_run_iocb() does this:
> 	iocb->ki_run_list.next = iocb->ki_run_list.prev = NULL;
> and only reinitializes iocb->ki_run_list when iocb->ki_retry() returns 
> -EIOCBRETRY but kick_iocb() is exported and looks like intended for usage 
> (though not recommended).

You implemented this other hack, and ran into troubles, so you're
modifying the aio core to fix it.  Am I wrong in concluding that if you
keep your first solution above, you no longer need this second?

You may also find the following an interesting read:

http://permalink.gmane.org/gmane.linux.kernel.aio.general/2571

Cheers,
Jeff
