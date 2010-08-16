Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0HPPow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 11:44:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615Ab0HPPov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 11:44:51 -0400
Date: Mon, 16 Aug 2010 11:44:43 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, unsik Kim <donari75@gmail.com>,
        Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>,
        Heiko Carstens <heicars2@linux.vnet.ibm.com>
Subject: Re: Switching block device elevators
Message-ID: <20100816154443.GA9860@redhat.com>
References: <4C6950B3.8020702@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6950B3.8020702@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16 2010 at 10:52am -0400,
Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:

> After commit 1abec4fdbb142e3ccb6ce99832fae42129134a96, "block: make
> blk_init_free_list and elevator_init idempotent", we're seeing
> kernel panics in our s390 tape block device driver. The panic is
> triggered because our driver tries to replace the default elevator
> with a noop elevator by calling elevator_exit() directly followed by
> elevator_init().

Maybe we should look to export elevator_switch() -- rather than
confining its use to the sysfs interface.

> Since the commit, elevator_init() returns 0 if
> request_queue->elevator is non-null, even though it does not install
> a new elevator. As a result, the next access to the elevator finds a
> pointer to the old one which was already freed and a panic is
> triggered. Our current fix consists of setting the elevator pointer
> to NULL after elevator_exit().

elevator_exit() triggers a call, via kobj, to elevator_release() which
doesn't have access to the request_queue to reset it.

Unfortunately, commit 1abec4fdbb imposes that the elevator_exit() caller
must take care to reset q->elevator to NULL -- like dasd_alloc_queue()
does.

Though I suppose we _could_ pass request_queue to elevator_exit.

> There is at least one other driver where the problem currently
> exists (drivers/block/mg_disk.c, author on cc) and another s390
> driver where the problem was only accidentally fixed before 2.6.35.
> I'm wondering if there's a better solution (apart from not forcing
> an elevator) and would like to hear everyone's opinion on this
> matter. How about declaring elevator_switch() non-static, for
> example?

Right, updating drivers/block/mg_disk.c and drivers/s390/block/dasd.c to
use elevator_switch would work.

Mike
