Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab1CYOTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:19:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29125 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab1CYOTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:19:23 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
In-reply-to: <20110325141413.GA1725@gentoo.trippels.de>
References: <20110324200613.GA1724@gentoo.trippels.de> <4D8BB114.2070002@fusionio.com> <20110324214150.GA1739@gentoo.trippels.de> <4D8C4304.3050101@fusionio.com> <20110325083757.GA1754@gentoo.trippels.de> <4D8C55D9.1060903@fusionio.com> <20110325095704.GA1694@gentoo.trippels.de> <4D8C8E1C.1020304@fusionio.com> <20110325130959.GA1698@gentoo.trippels.de> <4D8CA263.9090006@fusionio.com> <20110325141413.GA1725@gentoo.trippels.de>
Date: Fri, 25 Mar 2011 10:18:19 -0400
Message-Id: <1301062675-sup-2548@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D8CA463.0126,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Markus Trippelsdorf's message of 2011-03-25 10:14:13 -0400:
> On 2011.03.25 at 15:10 +0100, Jens Axboe wrote:
> > On 2011-03-25 14:09, Markus Trippelsdorf wrote:
> > > On 2011.03.25 at 13:44 +0100, Jens Axboe wrote:
> > >> On 2011-03-25 10:57, Markus Trippelsdorf wrote:
> > >>>
> > >>> Reverting it solves all problems here.
> > >>
> > >> Can you try this one?
> > > 
> > > This one doesn't help; I still get the same BUG.
> > > 
> > > BTW if you're having trouble reproducing this, here is the only non
> > > stock xfs option that I use on the affected partitions:
> > > 
> > > noatime,logbsize=262144
> > 
> > This?
> 
> No.
> 

I was able to reproduce it here.  This is working for me:


diff --git a/block/blk-core.c b/block/blk-core.c
index 59b5c00..88f5f6a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -271,7 +271,7 @@ EXPORT_SYMBOL(blk_start_queue);
  **/
 void blk_stop_queue(struct request_queue *q)
 {
-	cancel_delayed_work(&q->delay_work);
+	__cancel_delayed_work(&q->delay_work);
 	queue_flag_set(QUEUE_FLAG_STOPPED, q);
 }
 EXPORT_SYMBOL(blk_stop_queue);
@@ -1193,6 +1193,7 @@ static bool attempt_plug_merge(struct task_struct *tsk, struct request_queue *q,
 	struct request *rq;
 	bool ret = false;
 
+	preempt_disable();
 	plug = tsk->plug;
 	if (!plug)
 		goto out;
@@ -1215,6 +1216,7 @@ static bool attempt_plug_merge(struct task_struct *tsk, struct request_queue *q,
 		}
 	}
 out:
+	preempt_enable();
 	return ret;
 }
 
@@ -1309,6 +1311,7 @@ get_rq:
 		put_cpu();
 	}
 
+	preempt_disable();
 	plug = current->plug;
 	if (plug) {
 		if (!plug->should_sort && !list_empty(&plug->list)) {
@@ -1324,7 +1327,9 @@ get_rq:
 		req->cmd_flags |= REQ_ON_PLUG;
 		list_add_tail(&req->queuelist, &plug->list);
 		drive_stat_acct(req, 1);
+		preempt_enable();
 	} else {
+		preempt_enable();
 		spin_lock_irq(q->queue_lock);
 		add_acct_request(q, req, where);
 		__blk_run_queue(q, false);
