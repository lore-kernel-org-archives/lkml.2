Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab2JAQwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 12:52:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab2JAQwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 12:52:24 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH] loop: Limit the number of requests in the bio list
References: <1348767205-17230-1-git-send-email-lczerner@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 01 Oct 2012 12:52:19 -0400
In-Reply-To: <1348767205-17230-1-git-send-email-lczerner@redhat.com> (Lukas
	Czerner's message of "Thu, 27 Sep 2012 13:33:25 -0400")
Message-ID: <x49ipaukud8.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Czerner <lczerner@redhat.com> writes:

> Currently there is not limitation of number of requests in the loop bio
> list. This can lead into some nasty situations when the caller spawns
> tons of bio requests taking huge amount of memory. This is even more
> obvious with discard where blkdev_issue_discard() will submit all bios
> for the range and wait for them to finish afterwards. On really big loop
> devices this can lead to OOM situation as reported by Dave Chinner.
>
> With this patch we will wait in loop_make_request() if the number of
> bios in the loop bio list would exceed 'nr_requests' number of requests.
> We'll wake up the process as we process the bios form the list.

I think you might want to do something similar to what is done for
request_queues by implementing a congestion on and off threshold.  As
Jens writes in this commit (predating the conversion to git):

Author: Jens Axboe <axboe@suse.de>
Date:   Wed Nov 3 15:47:37 2004 -0800

    [PATCH] queue congestion threshold hysteresis
    
    We need to open the gap between congestion on/off a little bit, or
    we risk burning many cycles continually putting processes on a wait
    queue only to wake them up again immediately. This was observed with
    CFQ at least, which showed way excessive sys time.
    
    Patch is from Arjan.
    
    Signed-off-by: Jens Axboe <axboe@suse.de>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

If you feel this isn't necessary, then I think you at least need to
justify it with testing.  Perhaps Jens can shed some light on the exact
workload that triggered the pathological behaviour.

Cheers,
Jeff
