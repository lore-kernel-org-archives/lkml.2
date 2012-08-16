Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab2HPHwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 03:52:44 -0400
Received: from relay03ant.iops.be ([212.53.5.218]:59881 "EHLO
	relay03ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab2HPHwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 03:52:42 -0400
Message-ID: <502CA6C3.4040903@acm.org>
Date: Thu, 16 Aug 2012 07:52:35 +0000
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Chanho Min <chanho0207@gmail.com>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RESEND] remove the queue unlock in scsi_requset_fn
References: <CAOAMb1Dd5_KWQme+EzXdpnABk=A50+vXuLMoS+r5et6=o0605g@mail.gmail.com> <CAOAMb1Dp=E6fjMhdh6ze6Hq48qUixTpsqHZf3z742AUAqhU5Ug@mail.gmail.com> <1344946071.3117.26.camel@dabdike.int.hansenpartnership.com> <CAOAMb1COJbAF=ys7ZcpTuJNP6QzbQzuqz7gS4qPqSc1rfbnHTw@mail.gmail.com>
In-Reply-To: <CAOAMb1COJbAF=ys7ZcpTuJNP6QzbQzuqz7gS4qPqSc1rfbnHTw@mail.gmail.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/12 01:35, Chanho Min wrote:
>> functions will occur in line.  I also don't see why the sdev reference
>> couldn't drop to zero here.
> scsi_request_fn is called under the lock of request_queue->queue_lock.
> If we drop the sdev reference to zero here,
> scsi_device_dev_release_usercontext is
> invoked and make request_queue to NULL. When caller of scsi_request_fn try to
> unlock request_queue->queue_lock, the oops is occurred.

Whether or not your patch is applied, if the put_device() call in
scsi_request_fn() decreases the sdev reference count to zero, the
scsi_request_fn() caller will still try to unlock the queue lock after
scsi_request_fn() finished and hence will trigger a use-after-free. I'm
afraid the only real solution is to modify the SCSI and/or block layers
such that scsi_remove_device() can't finish while scsi_request_fn() is
in progress. And once that is guaranteed the get_device() / put_device()
pair can be left out from scsi_request_fn().

Bart.

