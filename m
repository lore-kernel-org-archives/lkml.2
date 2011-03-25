Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1CYOUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:20:16 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:34116 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab1CYOUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:20:15 -0400
X-ASG-Debug-ID: 1301062812-01de284cf8bb7d0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D8CA498.8060403@fusionio.com>
Date: Fri, 25 Mar 2011 15:20:08 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
References: <20110324200613.GA1724@gentoo.trippels.de> <4D8BB114.2070002@fusionio.com> <20110324214150.GA1739@gentoo.trippels.de> <4D8C4304.3050101@fusionio.com> <20110325083757.GA1754@gentoo.trippels.de> <4D8C55D9.1060903@fusionio.com> <20110325095704.GA1694@gentoo.trippels.de> <4D8C8E1C.1020304@fusionio.com> <20110325130959.GA1698@gentoo.trippels.de> <4D8CA263.9090006@fusionio.com> <20110325141413.GA1725@gentoo.trippels.de>
X-ASG-Orig-Subj: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
In-Reply-To: <20110325141413.GA1725@gentoo.trippels.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301062812
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58932
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-25 15:14, Markus Trippelsdorf wrote:
> On 2011.03.25 at 15:10 +0100, Jens Axboe wrote:
>> On 2011-03-25 14:09, Markus Trippelsdorf wrote:
>>> On 2011.03.25 at 13:44 +0100, Jens Axboe wrote:
>>>> On 2011-03-25 10:57, Markus Trippelsdorf wrote:
>>>>>
>>>>> Reverting it solves all problems here.
>>>>
>>>> Can you try this one?
>>>
>>> This one doesn't help; I still get the same BUG.
>>>
>>> BTW if you're having trouble reproducing this, here is the only non
>>> stock xfs option that I use on the affected partitions:
>>>
>>> noatime,logbsize=262144
>>
>> This?
> 
> No.

Lets expand the scope a bit, this one?

diff --git a/block/blk-core.c b/block/blk-core.c
index 59b5c00..5876c73 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
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


-- 
Jens Axboe

