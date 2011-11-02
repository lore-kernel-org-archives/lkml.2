Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522Ab1KCBgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:36:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50764 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933355Ab1KCBgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:36:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:58 2011
Message-Id: <20111102221458.284719342@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jens Axboe <jens.axboe@oracle.com>,
        Suresh Jayaraman <sjayaraman@suse.de>
Subject: [089/107] cfq-iosched: get rid of the coop_preempt flag
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------


From: Jens Axboe <jens.axboe@oracle.com>

commit e00ef7997195e4f8e10593727a6286e2e2802159 upstream

We need to rework this logic post the cooperating cfq_queue merging,
for now just get rid of it and Jeff Moyer will fix the fall out.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/cfq-iosched.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -210,7 +210,6 @@ enum cfqq_state_flags {
 	CFQ_CFQQ_FLAG_slice_new,	/* no requests dispatched in slice */
 	CFQ_CFQQ_FLAG_sync,		/* synchronous queue */
 	CFQ_CFQQ_FLAG_coop,		/* cfqq is shared */
-	CFQ_CFQQ_FLAG_coop_preempt,	/* coop preempt */
 };
 
 #define CFQ_CFQQ_FNS(name)						\
@@ -237,7 +236,6 @@ CFQ_CFQQ_FNS(prio_changed);
 CFQ_CFQQ_FNS(slice_new);
 CFQ_CFQQ_FNS(sync);
 CFQ_CFQQ_FNS(coop);
-CFQ_CFQQ_FNS(coop_preempt);
 #undef CFQ_CFQQ_FNS
 
 #define cfq_log_cfqq(cfqd, cfqq, fmt, args...)	\
@@ -962,9 +960,6 @@ static struct cfq_queue *cfq_set_active_
 	if (!cfqq)
 		cfqq = cfq_get_next_queue(cfqd);
 
-	if (cfqq)
-		cfq_clear_cfqq_coop_preempt(cfqq);
-
 	__cfq_set_active_queue(cfqd, cfqq);
 	return cfqq;
 }
@@ -2168,16 +2163,8 @@ cfq_should_preempt(struct cfq_data *cfqd
 	 * if this request is as-good as one we would expect from the
 	 * current cfqq, let it preempt
 	 */
-	if (cfq_rq_close(cfqd, cfqq, rq) && (!cfq_cfqq_coop(new_cfqq) ||
-	    cfqd->busy_queues == 1)) {
-		/*
-		 * Mark new queue coop_preempt, so its coop flag will not be
-		 * cleared when new queue gets scheduled at the very first time
-		 */
-		cfq_mark_cfqq_coop_preempt(new_cfqq);
-		cfq_mark_cfqq_coop(new_cfqq);
+	if (cfq_rq_close(cfqd, cfqq, rq))
 		return true;
-	}
 
 	return false;
 }


