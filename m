Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab1CYOKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:10:52 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:34043 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab1CYOKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:10:47 -0400
X-ASG-Debug-ID: 1301062245-01de284cf8bb6f0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D8CA263.9090006@fusionio.com>
Date: Fri, 25 Mar 2011 15:10:43 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
References: <20110324194546.GA1741@gentoo.trippels.de> <4D8BA235.7060904@fusionio.com> <20110324200613.GA1724@gentoo.trippels.de> <4D8BB114.2070002@fusionio.com> <20110324214150.GA1739@gentoo.trippels.de> <4D8C4304.3050101@fusionio.com> <20110325083757.GA1754@gentoo.trippels.de> <4D8C55D9.1060903@fusionio.com> <20110325095704.GA1694@gentoo.trippels.de> <4D8C8E1C.1020304@fusionio.com> <20110325130959.GA1698@gentoo.trippels.de>
X-ASG-Orig-Subj: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
In-Reply-To: <20110325130959.GA1698@gentoo.trippels.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301062245
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

On 2011-03-25 14:09, Markus Trippelsdorf wrote:
> On 2011.03.25 at 13:44 +0100, Jens Axboe wrote:
>> On 2011-03-25 10:57, Markus Trippelsdorf wrote:
>>>
>>> Reverting it solves all problems here.
>>
>> Can you try this one?
> 
> This one doesn't help; I still get the same BUG.
> 
> BTW if you're having trouble reproducing this, here is the only non
> stock xfs option that I use on the affected partitions:
> 
> noatime,logbsize=262144

This?

diff --git a/block/blk-core.c b/block/blk-core.c
index 59b5c00..121df87 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1197,6 +1197,7 @@ static bool attempt_plug_merge(struct task_struct *tsk, struct request_queue *q,
 	if (!plug)
 		goto out;
 
+	preempt_disable();
 	list_for_each_entry_reverse(rq, &plug->list, queuelist) {
 		int el_ret;
 
@@ -1214,6 +1215,7 @@ static bool attempt_plug_merge(struct task_struct *tsk, struct request_queue *q,
 				break;
 		}
 	}
+	preempt_enable();
 out:
 	return ret;
 }
@@ -1322,7 +1324,9 @@ get_rq:
 		 * Debug flag, kill later
 		 */
 		req->cmd_flags |= REQ_ON_PLUG;
+		preempt_disable();
 		list_add_tail(&req->queuelist, &plug->list);
+		preempt_enable();
 		drive_stat_acct(req, 1);
 	} else {
 		spin_lock_irq(q->queue_lock);

-- 
Jens Axboe

