Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab1CYPv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:51:56 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:50589 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984Ab1CYPvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:51:55 -0400
X-ASG-Debug-ID: 1301068314-03d6a5170503350001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D8CBA0A.9040105@fusionio.com>
Date: Fri, 25 Mar 2011 16:51:38 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
References: <20110324214150.GA1739@gentoo.trippels.de> <4D8C4304.3050101@fusionio.com> <20110325083757.GA1754@gentoo.trippels.de> <4D8C55D9.1060903@fusionio.com> <20110325095704.GA1694@gentoo.trippels.de> <4D8C8E1C.1020304@fusionio.com> <20110325130959.GA1698@gentoo.trippels.de> <4D8CA263.9090006@fusionio.com> <20110325141413.GA1725@gentoo.trippels.de> <4D8CA498.8060403@fusionio.com> <20110325142827.GA1739@gentoo.trippels.de>
X-ASG-Orig-Subj: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
In-Reply-To: <20110325142827.GA1739@gentoo.trippels.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301068314
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58937
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-25 15:28, Markus Trippelsdorf wrote:
> On 2011.03.25 at 15:20 +0100, Jens Axboe wrote:
>> On 2011-03-25 15:14, Markus Trippelsdorf wrote:
>>> On 2011.03.25 at 15:10 +0100, Jens Axboe wrote:
>>>> On 2011-03-25 14:09, Markus Trippelsdorf wrote:
>>>>> On 2011.03.25 at 13:44 +0100, Jens Axboe wrote:
>>>>>> On 2011-03-25 10:57, Markus Trippelsdorf wrote:
>>>>>>>
>>>>>>> Reverting it solves all problems here.
>>>>>>
>>>>>> Can you try this one?
>>>>>
>>>>> This one doesn't help; I still get the same BUG.
>>>>>
>>>>> BTW if you're having trouble reproducing this, here is the only non
>>>>> stock xfs option that I use on the affected partitions:
>>>>>
>>>>> noatime,logbsize=262144
>>>>
>>>> This?
>>>
>>> No.
>>
>> Lets expand the scope a bit, this one?
> 
> No. And setting CONFIG_PREEMPT_NONE also doesn't help.
> 

Does this work? I'm actually relieved that the preempt was a red
herring. I had earlier convinced myself that it was all safe without
that mucking around with preempt counts.

diff --git a/block/blk-core.c b/block/blk-core.c
index 59b5c00..64e96ee 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2702,7 +2702,10 @@ static void flush_plug_list(struct blk_plug *plug)
 		/*
 		 * rq is already accounted, so use raw insert
 		 */
-		__elv_add_request(q, rq, ELEVATOR_INSERT_SORT_MERGE);
+		if (rq->cmd_flags & (REQ_FLUSH | REQ_FUA))
+			__elv_add_request(q, rq, ELEVATOR_INSERT_FLUSH);
+		else
+			__elv_add_request(q, rq, ELEVATOR_INSERT_SORT_MERGE);
 	}
 
 	if (q) {


-- 
Jens Axboe

