Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab1CKJ3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:29:35 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46556 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625Ab1CKJ3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:29:33 -0500
Message-ID: <4D79EB7B.10702@kernel.dk>
Date: Fri, 11 Mar 2011 10:29:31 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Lukas Czerner <lczerner@redhat.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2] block: fix mis-synchronisation in blkdev_issue_zeroout()
References: <1299830784-6622-1-git-send-email-lczerner@redhat.com>
In-Reply-To: <1299830784-6622-1-git-send-email-lczerner@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-11 09:06, Lukas Czerner wrote:
> BZ29402
> https://bugzilla.kernel.org/show_bug.cgi?id=29402
> 
> We can hit serious mis-synchronization in bio completion path of
> blkdev_issue_zeroout() leading to a panic.
> 
> The problem is that when we are going to wait_for_completion() in
> blkdev_issue_zeroout() we check if the bb.done equals issued (number of
> submitted bios). If it does, we can skip the wait_for_completition()
> and just out of the function since there is nothing to wait for.
> However, there is a ordering problem because bio_batch_end_io() is
> calling atomic_inc(&bb->done) before complete(), hence it might seem to
> blkdev_issue_zeroout() that all bios has been completed and exit. At
> this point when bio_batch_end_io() is going to call complete(bb->wait),
> bb and wait does not longer exist since it was allocated on stack in
> blkdev_issue_zeroout() ==> panic!
> 
> (thread 1)                      (thread 2)
> bio_batch_end_io()              blkdev_issue_zeroout()
>   if(bb) {                      ...
>     if (bb->end_io)             ...
>       bb->end_io(bio, err);     ...
>     atomic_inc(&bb->done);      ...
>     ...                         while (issued != atomic_read(&bb.done))
>     ...                         (let issued == bb.done)
>     ...                         (do the rest of the function)
>     ...                         return ret;
>     complete(bb->wait);
>     ^^^^^^^^
>     panic
> 
> We can fix this easily by simplifying bio_batch and completion counting.
> 
> Also remove bio_end_io_t *end_io since it is not used.

Thanks Lukas, I'll expedite this for 2.6.38!

-- 
Jens Axboe

