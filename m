Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab0F0Poi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 11:44:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205Ab0F0Poh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 11:44:37 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
References: <20100621094828.GA30748@lst.de> <4C1F3916.4070608@kernel.dk>
	<20100621110436.GA4056@lst.de> <4C1FB5F7.3070908@kernel.dk>
	<20100621191410.GA24213@lst.de> <20100621213618.GC6474@redhat.com>
	<20100623100138.GA9575@lst.de> <20100624014420.GB3297@redhat.com>
	<20100625110319.GA12855@lst.de> <20100626033509.GA2435@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Sun, 27 Jun 2010 11:44:30 -0400
In-Reply-To: <20100626033509.GA2435@redhat.com> (Vivek Goyal's message of
	"Fri, 25 Jun 2010 23:35:10 -0400")
Message-ID: <x49wrtk32g1.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Fri, Jun 25, 2010 at 01:03:20PM +0200, Christoph Hellwig wrote:
>> On Wed, Jun 23, 2010 at 09:44:20PM -0400, Vivek Goyal wrote:
>> I see the point of this logic for reads where various workloads have
>> dependent reads that might be close to each other, but I don't really
>> see any point for writes.
>> 
>> > So looks like fsync path will do bunch of IO and then will wait for jbd thread
>> > to finish the work. In this case idling is waste of time.
>> 
>> Given that ->writepage already does WRITE_SYNC_PLUG I/O which includes
>> REQ_NODILE I'm still confused why we still have that issue.
>
> In current form, cfq honors REQ_NOIDLE conditionally and that's why we
> still have the issue. If you look at cfq_completed_request(), we continue
> to idle in following two cases.
>
> - If we classifed the queue as SYNC_WORKLOAD.
> - If there is another random read/write happening on sync-noidle service
>   tree.
>
> SYNC_WORKLOAD means that cfq thinks this particular queue is doing sequential
> IO. For random IO queues, we don't idle on each individual queue but a
> group of queue.
>
> In jeff's testing, fsync thread/queue sometimes is viewed as sequential
> workload and goes on SYNC_WORKLOAD tree. In that case even if request is
> REQ_NOIDLE, we will continue to idle hence fsync issue.

I'm now testing OCFS2, and I'm seeing performance that is not great
(even with the blk_yield patches applied).  What happens is that we
successfully yield the queue to the journal thread, but then idle on the
journal thread (even though RQ_NOIDLE was set).

So, can we just get rid of idling when RQ_NOIDLE is set?

Vivek sent me this patch to test, and it got rid of the performance
issue for the fsync workload.  Can we discuss its merits?

Thanks,
Jeff

Index: linux-2.6/block/cfq-iosched.c
===================================================================
--- linux-2.6.orig/block/cfq-iosched.c	2010-06-25 15:57:33.832125786 -0400
+++ linux-2.6/block/cfq-iosched.c	2010-06-25 15:59:19.788876361 -0400
@@ -318,6 +318,7 @@
 	CFQ_CFQQ_FLAG_split_coop,	/* shared cfqq will be splitted */
 	CFQ_CFQQ_FLAG_deep,		/* sync cfqq experienced large depth */
 	CFQ_CFQQ_FLAG_wait_busy,	/* Waiting for next request */
+	CFQ_CFQQ_FLAG_group_idle,	/* This queue is doing group idle */
 };
 
 #define CFQ_CFQQ_FNS(name)						\
@@ -347,6 +348,7 @@
 CFQ_CFQQ_FNS(split_coop);
 CFQ_CFQQ_FNS(deep);
 CFQ_CFQQ_FNS(wait_busy);
+CFQ_CFQQ_FNS(group_idle);
 #undef CFQ_CFQQ_FNS
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
@@ -1613,6 +1615,7 @@
 
 	cfq_clear_cfqq_wait_request(cfqq);
 	cfq_clear_cfqq_wait_busy(cfqq);
+	cfq_clear_cfqq_group_idle(cfqq);
 
 	/*
 	 * If this cfqq is shared between multiple processes, check to
@@ -3176,6 +3179,13 @@
 	if (cfq_class_rt(new_cfqq) && !cfq_class_rt(cfqq))
 		return true;
 
+	/*
+	 * If were doing group_idle and we got new request in same group,
+	 * preempt the queue
+	 */
+	if (cfq_cfqq_group_idle(cfqq))
+		return true;
+
 	if (!cfqd->active_cic || !cfq_cfqq_wait_request(cfqq))
 		return false;
 
@@ -3271,6 +3281,7 @@
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
 
 	cfq_log_cfqq(cfqd, cfqq, "insert_request");
+	cfq_clear_cfqq_group_idle(cfqq);
 	cfq_init_prio_data(cfqq, RQ_CIC(rq)->ioc);
 
 	rq_set_fifo_time(rq, jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)]);
@@ -3416,10 +3427,12 @@
 			 * SYNC_NOIDLE_WORKLOAD idles at the end of the tree
 			 * only if we processed at least one !rq_noidle request
 			 */
-			if (cfqd->serving_type == SYNC_WORKLOAD
-			    || cfqd->noidle_tree_requires_idle
-			    || cfqq->cfqg->nr_cfqq == 1)
+			if (cfqd->noidle_tree_requires_idle)
+				cfq_arm_slice_timer(cfqd);
+			else if (cfqq->cfqg->nr_cfqq == 1) {
+				cfq_mark_cfqq_group_idle(cfqq);
 				cfq_arm_slice_timer(cfqd);
+			}
 		}
 	}
 

