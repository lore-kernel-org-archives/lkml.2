Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab0HWKLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 06:11:31 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58379 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab0HWKLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 06:11:30 -0400
Message-ID: <4C724952.3050002@kernel.dk>
Date: Mon, 23 Aug 2010 12:11:30 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Kevin Vigor <kevin@vigor.nu>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: PATCH: dangling pointer when switching to noop elevator in obscure
  block drivers.
References: <20100820212510.GB29022@jimi.int.fusionio.com>
In-Reply-To: <20100820212510.GB29022@jimi.int.fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-20 23:25, Kevin Vigor wrote:
> Linux 2.6.35 introduced a test in the beginning of elevator_init(), like
> so:
> 
>      if (unlikely(q->elevator))
>          return 0;
> 
> So the following code sequence, which appears in two (obscure) block
> drivers is now a serious error:
> 
>         elevator_exit(q);
>         elevator_init(q, "noop");
> 
> The intent is to cleanup the default system elevator and replace it with
> the noop elevator. Instead, elevator_exit() frees the existing elevator
> object, but leaves q->elevator pointing to it; elevator_init() then
> silently fails since q->elevator is non-NULL, and the queue is left with
> the elevator pointer invalid, This leads to untold woe and segfaults
> later.
> 
> The fix is trivial: zero the q->elevator pointer before calling
> elevator_init(). Note that drivers/s390/block/dasd.c already follows
> this pattern.
> 
> I do not have the hardware to actually test either of the two afflicted 
> drivers, but I believe the fix to be sufficiently obvious. The following
> patches are against the current version of Linus' tree.

Thanks, this was also posted last week. I think the best course of
action is to provide an API for switching the scheduler, instead of
having drivers rely on doing it manually.

-- 
Jens Axboe

