Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab1JWNpA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 09:45:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438Ab1JWNo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 09:44:59 -0400
Date: Sun, 23 Oct 2011 14:44:49 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Leun <ml@newton.leun.net>
Cc: Alasdair G Kergon <agk@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Bisected: Massive memory leak in dm-snapshot in 3.1
	development introduced
Message-ID: <20111023134449.GA13703@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Michael Leun <ml@newton.leun.net>,
	Alasdair G Kergon <agk@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>
References: <20111023112140.37fd8b3d@xenia.leun.net> <CA+55aFzfFpnEc+Eerdi9SfMw4o17ONfYCHksJkD1O6AS5U2DoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzfFpnEc+Eerdi9SfMw4o17ONfYCHksJkD1O6AS5U2DoQ@mail.gmail.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 12:52:06PM +0300, Linus Torvalds wrote:
> Mikulas, Alasdair? I see the mempool_free() for the "master job", what
> about everything else? Does the dm_kcopyd_prepare_callback() perhaps
> need to do a
> 
>     job->master_job = job;
> 
> or similar?

If you look at the other place that performs that mempool_alloc, it's indeed
present there.

Michael - can you test if this solves the problem?

Alasdair

--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -628,6 +628,7 @@ void *dm_kcopyd_prepare_callback(struct dm_kcopyd_client *kc,
 	job->kc = kc;
 	job->fn = fn;
 	job->context = context;
+	job->master_job = job;
 
 	atomic_inc(&kc->nr_jobs);
 
