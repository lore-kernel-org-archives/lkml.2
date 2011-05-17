Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab1EQTfC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 15:35:02 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51259 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086Ab1EQTfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 15:35:00 -0400
Message-ID: <4DD2CDE2.60604@kernel.dk>
Date: Tue, 17 May 2011 21:34:58 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Sitsofe Wheeler <sitsofe@yahoo.com>, Borislav Petkov <bp@alien8.de>,
        Meelis Roos <mroos@linux.ee>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED 2/3 v2.6.39-rc7] block: make disk_block_events()
  properly wait for work cancellation
References: <20110517102713.GJ20624@htj.dyndns.org> <20110517102824.GK20624@htj.dyndns.org> <20110517102853.GL20624@htj.dyndns.org> <20110517154748.GS20624@htj.dyndns.org>
In-Reply-To: <20110517154748.GS20624@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-17 17:47, Tejun Heo wrote:
> disk_block_events() should guarantee that the event work is not in
> flight on return and once blocked it shouldn't issue further
> cancellations.
> 
> Because there was no synchronization between the first blocker doing
> cancel_delayed_work_sync() and the following blockers, the following
> blockers could finish before cancellation was complete, which broke
> both guarantees - event work could be in flight and cancellation could
> happen after return.
> 
> This bug triggered WARN_ON_ONCE() in disk_clear_events() reported in
> bug#34662.
> 
>   https://bugzilla.kernel.org/show_bug.cgi?id=34662
> 
> Fix it by adding an outer mutex which protects both block count
> manipulation and work cancellation.
> 
> -v2: Use outer mutex instead of bit waitqueue per Linus.

Thanks, much cleaner indeed. I've rebased for-linus. BTW, this is patch
3/3, not 2/3. Had me confused for a while, the numbering on the initial
series was off as well.

I'll let this simmer until tomorrow, then send out the pull request.

-- 
Jens Axboe

