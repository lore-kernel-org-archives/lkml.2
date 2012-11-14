Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab2KNJCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:02:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab2KNJCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:02:20 -0500
Date: Wed, 14 Nov 2012 10:02:13 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lukas@localhost
To: Jens Axboe <axboe@kernel.dk>
cc: Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, jmoyer@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v3] loop: Limit the number of requests in the bio list
In-Reply-To: <50A27892.1030800@kernel.dk>
Message-ID: <alpine.LFD.2.00.1211140951380.3577@localhost>
References: <1352824065-6734-1-git-send-email-lczerner@redhat.com> <50A27892.1030800@kernel.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012, Jens Axboe wrote:

> Date: Tue, 13 Nov 2012 09:42:58 -0700
> From: Jens Axboe <axboe@kernel.dk>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
>     jmoyer@redhat.com, akpm@linux-foundation.org
> Subject: Re: [PATCH v3] loop: Limit the number of requests in the bio list
> 
> > @@ -489,6 +491,12 @@ static void loop_make_request(struct request_queue *q, struct bio *old_bio)
> >  		goto out;
> >  	if (unlikely(rw == WRITE && (lo->lo_flags & LO_FLAGS_READ_ONLY)))
> >  		goto out;
> > +	if (lo->lo_bio_count >= q->nr_congestion_on) {
> > +		spin_unlock_irq(&lo->lo_lock);
> > +		wait_event(lo->lo_req_wait, lo->lo_bio_count <
> > +			   q->nr_congestion_off);
> > +		spin_lock_irq(&lo->lo_lock);
> > +	}
> 
> This makes me nervous. You are reading lo_bio_count outside the lock. If
> you race with the prepare_to_wait() and condition check in
> __wait_event(), then you will sleep forever.

Hi Jens,

I am sorry for being dense, but I do not see how this would be
possible. The only place we increase the lo_bio_count is after that
piece of code (possibly after the wait). Moreover every time we're
decreasing the lo_bio_count and it is smaller than nr_congestion_off
we will wake_up().

That's how wait_event/wake_up is supposed to be used, right ?

Thanks!
-Lukas

> 
> md has private helpers for this, seems it would be a good idea to move
> these into the regular wait includes and use them here too.
> 
> 
