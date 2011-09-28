Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab1I1PXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:23:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39211 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab1I1PXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:23:07 -0400
MIME-Version: 1.0
In-Reply-To: <4E832BD2.50409@kernel.dk>
References: <201109221318.p8MDIXPP020015@pentland.suse.de> <20110928004722.GA27421@kernel.dk>
 <CA+55aFznvejXWe68BpjsJqCWnDizbHWBOzKLY_H+YqhRiK42sQ@mail.gmail.com>
 <4E82751C.9050908@kernel.dk> <CA+55aFyL76hD7o_839G7tKa0y6dFRcK-kC+g_h_coEp=Qk23pw@mail.gmail.com>
 <1317183038.17578.9.camel@dabdike.hansenpartnership.com> <4E832A55.30709@kernel.dk>
 <1317219074.19034.4.camel@dabdike.hansenpartnership.com> <4E832BD2.50409@kernel.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Sep 2011 08:22:46 -0700
X-Google-Sender-Auth: 3RU1RrFEdf0jF6-OQbDXG8Bsg9M
Message-ID: <CA+55aFyFht3njKVep+aT_m5URxRxayZyb6K2ukW6+kazHf8EKA@mail.gmail.com>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
To: Jens Axboe <axboe@kernel.dk>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 7:14 AM, Jens Axboe <axboe@kernel.dk> wrote:
>
>  /*
> - * Note: If a driver supplied the queue lock, it should not zap that lock
> - * unexpectedly as some queue cleanup components like elevator_exit() and
> - * blk_throtl_exit() need queue lock.
> + * Note: If a driver supplied the queue lock, it is disconnected
> + * by this function. The actual state of the lock doesn't matter
> + * here as the request_queue isn't accessible after this point
> + * (QUEUE_FLAG_DEAD is set) and no other requests will be queued.
>  */

So quite frankly, I just don't believe in that comment.

If no more requests will be queued or completed, then the queue lock
is irrelevant and should not be changed.

More importantly, if no more requests are queued or completed after
blk_cleanup_queue(), then we wouldn't have had the bug that we clearly
had with the elevator accesses, now would we? So the comment seems to
be obviously bogus and wrong.

I pulled this, but I think the "just move the teardown" would have
been the safer option. What  happens if a request completes on another
CPU just as we are changing locks, and we lock one lock and then
unlock another?!

                              Linus
