Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab0JWSVr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 14:21:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55085 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756357Ab0JWSVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 14:21:46 -0400
Date: Sat, 23 Oct 2010 20:21:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [origin tree boot failure] Re: [GIT PULL] core block bits for
 2.6.37-rc1
Message-ID: <20101023182127.GA4160@elte.hu>
References: <4CC143F5.3060202@fusionio.com>
 <20101023152959.GA20930@elte.hu>
 <4CC31283.1060607@fusionio.com>
 <4CC318AE.8010209@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC318AE.8010209@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jaxboe@fusionio.com> wrote:

> > Looks like a fairly straight forward case of uninitialized memory and 
> > blk_sync_queue() -> throtl_shutdown_timer() -> cancel_delayed_work_sync().
> > 
> > Will get that fixed up.
> 
> It frees q->td in blk_cleanup_queue(), but doesn't clear q->td. When the final put 
> happens, blk_sync_queue() is called and then ends up doing the 
> cancel_delayed_work_sync() on freed memory.
> 
> Two possible fixes:
> 
> - Clear ->td when the queue is goin dead. May require other ->td == NULL
>   checks in the code, so I opted for:
> 
> - Move the free to when the queue is really going away, post doing the
>   blk_sync_queue() call.
> 
> The below should fix it.
> 
> Signed-off-by: Jens Axboe <jaxboe@fusionio.com>

This did the trick, thanks Jens!

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo
