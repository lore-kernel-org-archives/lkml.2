Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab2KMQnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:43:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49047 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab2KMQnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:43:12 -0500
Message-ID: <50A27892.1030800@kernel.dk>
Date: Tue, 13 Nov 2012 09:42:58 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Lukas Czerner <lczerner@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jmoyer@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH v3] loop: Limit the number of requests in the bio list
References: <1352824065-6734-1-git-send-email-lczerner@redhat.com>
In-Reply-To: <1352824065-6734-1-git-send-email-lczerner@redhat.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -489,6 +491,12 @@ static void loop_make_request(struct request_queue *q, struct bio *old_bio)
>  		goto out;
>  	if (unlikely(rw == WRITE && (lo->lo_flags & LO_FLAGS_READ_ONLY)))
>  		goto out;
> +	if (lo->lo_bio_count >= q->nr_congestion_on) {
> +		spin_unlock_irq(&lo->lo_lock);
> +		wait_event(lo->lo_req_wait, lo->lo_bio_count <
> +			   q->nr_congestion_off);
> +		spin_lock_irq(&lo->lo_lock);
> +	}

This makes me nervous. You are reading lo_bio_count outside the lock. If
you race with the prepare_to_wait() and condition check in
__wait_event(), then you will sleep forever.

md has private helpers for this, seems it would be a good idea to move
these into the regular wait includes and use them here too.

-- 
Jens Axboe

