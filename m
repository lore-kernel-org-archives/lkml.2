Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab2HPH4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 03:56:25 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42687 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507Ab2HPH4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 03:56:23 -0400
Message-ID: <1345103778.3259.12.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH RESEND] remove the queue unlock in scsi_requset_fn
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Chanho Min <chanho0207@gmail.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>
Date: Thu, 16 Aug 2012 08:56:18 +0100
In-Reply-To: <CAOAMb1COJbAF=ys7ZcpTuJNP6QzbQzuqz7gS4qPqSc1rfbnHTw@mail.gmail.com>
References: <CAOAMb1Dd5_KWQme+EzXdpnABk=A50+vXuLMoS+r5et6=o0605g@mail.gmail.com>
	 <CAOAMb1Dp=E6fjMhdh6ze6Hq48qUixTpsqHZf3z742AUAqhU5Ug@mail.gmail.com>
	 <1344946071.3117.26.camel@dabdike.int.hansenpartnership.com>
	 <CAOAMb1COJbAF=ys7ZcpTuJNP6QzbQzuqz7gS4qPqSc1rfbnHTw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 10:35 +0900, Chanho Min wrote:
> > functions will occur in line.  I also don't see why the sdev reference
> > couldn't drop to zero here.
> scsi_request_fn is called under the lock of request_queue->queue_lock.
> If we drop the sdev reference to zero here,
> scsi_device_dev_release_usercontext is
> invoked and make request_queue to NULL. When caller of scsi_request_fn try to
> unlock request_queue->queue_lock, the oops is occurred.

I don't understand this explanation.

sdev->request_queue goes to NULL if the sdev refcount goes to zero (and
blk.  We have a copy though in the q variable, which is what we unlock.
That q variable only goes invalid if the queue ref count goes to zero.
If that happens, the queue release function will try to take the lock to
free the elevator and your patch will cause a deadlock.

There are only two possibilities here:

     1. The queue refcount can never reach zero within a request
        function because block ensures that it can unlock the queue lock
        on exit.  We could then remove this lock drop and acquire on the
        grounds that it is superfluous.
     2. The queue refcount does indeed go to zero and the queue gets
        released.  This would mean that all our lock; request_fn; unlock
        patterns do a use after free (in the block layer).  Your
        proposed patch doesn't fix this (and indeed would cause a
        deadlock on the release path).

I've cc'd Jens, because I don't entirely see why our

lock; request_fn; unlock

is safe against a racing blk_cleanup_queue().

James


