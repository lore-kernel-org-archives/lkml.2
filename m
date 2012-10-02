Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab2JBIwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:52:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab2JBIwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:52:13 -0400
Date: Tue, 2 Oct 2012 10:52:05 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lukas@localhost
To: Jeff Moyer <jmoyer@redhat.com>
cc: Lukas Czerner <lczerner@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH] loop: Limit the number of requests in the bio list
In-Reply-To: <x49ipaukud8.fsf@segfault.boston.devel.redhat.com>
Message-ID: <alpine.LFD.2.00.1210021042580.21903@localhost>
References: <1348767205-17230-1-git-send-email-lczerner@redhat.com> <x49ipaukud8.fsf@segfault.boston.devel.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2012, Jeff Moyer wrote:

> Date: Mon, 01 Oct 2012 12:52:19 -0400
> From: Jeff Moyer <jmoyer@redhat.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
>     Dave Chinner <dchinner@redhat.com>
> Subject: Re: [PATCH] loop: Limit the number of requests in the bio list
> 
> Lukas Czerner <lczerner@redhat.com> writes:
> 
> > Currently there is not limitation of number of requests in the loop bio
> > list. This can lead into some nasty situations when the caller spawns
> > tons of bio requests taking huge amount of memory. This is even more
> > obvious with discard where blkdev_issue_discard() will submit all bios
> > for the range and wait for them to finish afterwards. On really big loop
> > devices this can lead to OOM situation as reported by Dave Chinner.
> >
> > With this patch we will wait in loop_make_request() if the number of
> > bios in the loop bio list would exceed 'nr_requests' number of requests.
> > We'll wake up the process as we process the bios form the list.
> 
> I think you might want to do something similar to what is done for
> request_queues by implementing a congestion on and off threshold.  As
> Jens writes in this commit (predating the conversion to git):

Right, I've had the same idea. However my first proof-of-concept
worked quite well without this and my simple performance testing did
not show any regression.

I've basically done just fstrim, and blkdiscard on huge loop device
measuring time to finish and dd bs=4k throughput. None of those showed
any performance regression. I've chosen those for being quite simple
and supposedly issuing quite a lot of bios. Any better
recommendation to test this ?

Also I am still unable to reproduce the problem Dave originally
experienced and I was hoping that he can test whether this helps or
not.

Dave could you give it a try please ? By creating huge (500T, 1000T,
1500T) loop device on machine with 2GB memory I was not able to reproduce
that. Maybe it's that xfs punch hole implementation is so damn fast
:). Please let me know.

Thanks!
-Lukas

> 
> Author: Jens Axboe <axboe@suse.de>
> Date:   Wed Nov 3 15:47:37 2004 -0800
> 
>     [PATCH] queue congestion threshold hysteresis
>     
>     We need to open the gap between congestion on/off a little bit, or
>     we risk burning many cycles continually putting processes on a wait
>     queue only to wake them up again immediately. This was observed with
>     CFQ at least, which showed way excessive sys time.
>     
>     Patch is from Arjan.
>     
>     Signed-off-by: Jens Axboe <axboe@suse.de>
>     Signed-off-by: Linus Torvalds <torvalds@osdl.org>
> 
> If you feel this isn't necessary, then I think you at least need to
> justify it with testing.  Perhaps Jens can shed some light on the exact
> workload that triggered the pathological behaviour.
> 
> Cheers,
> Jeff
> 
