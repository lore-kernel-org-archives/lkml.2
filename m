Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab1DUP3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 11:29:21 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:33669 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057Ab1DUP3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 11:29:20 -0400
X-ASG-Debug-ID: 1303399759-01de284cf8177d00001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DB04D4A.1000803@fusionio.com>
Date: Thu, 21 Apr 2011 17:29:14 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jens Axboe <axboe@kernel.dk>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc4 BUG: unable to handle kernel NULL pointer dereference
  at 0000000c IP: cfq_insert_request+0x1d/0x3f5
References: <20110420125824.GA3507@tiehlicka.suse.cz> <4DAEDBEB.7060904@fusionio.com> <20110420132903.GA13554@tiehlicka.suse.cz> <4DAF18DF.9080205@fusionio.com> <20110421071642.GA3556@tiehlicka.suse.cz> <5F35AAD2-8277-44BD-86B6-B1D7B816071E@kernel.dk> <BANLkTinYv+YW6HVCodsWcCKwMmdZFsXPRA@mail.gmail.com>
X-ASG-Orig-Subj: Re: 2.6.39-rc4 BUG: unable to handle kernel NULL pointer dereference
  at 0000000c IP: cfq_insert_request+0x1d/0x3f5
In-Reply-To: <BANLkTinYv+YW6HVCodsWcCKwMmdZFsXPRA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303399759
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.20
X-Barracuda-Spam-Status: No, SCORE=0.20 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=PR0N_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61512
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.20 PR0N_SUBJECT           Subject has letters around special characters (pr0n)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-21 16:38, Linus Torvalds wrote:
> On Thu, Apr 21, 2011 at 12:25 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> I am going to bisect, let's see if I can find anything.
>>
>> Thanks, that would be great!
> 
> I'd expect it to be very timing-dependent, and thus could easily be
> triggered (or hidden) by unrelated changes.
> 
> Just happening to have a request added to the elevator at _just_ the
> same moment that another CPU is changing it and getting rid of the
> data structures for the old one.

This particular bug does seem to trigger very reliably. The switching
works by ensuring that we have no requests with elevator data associated
with it before shutting down the old scheduler and attaching the new
one. I smells more like a bug on doing an insert sort on a non-priv
request. I bet this is it, Michal can you give it a spin?

diff --git a/block/elevator.c b/block/elevator.c
index 6f6abc0..45ca1e3 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -671,7 +671,8 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 			q->boundary_rq = rq;
 		}
 	} else if (!(rq->cmd_flags & REQ_ELVPRIV) &&
-		    where == ELEVATOR_INSERT_SORT)
+		    (where == ELEVATOR_INSERT_SORT ||
+		     where == ELEVATOR_INSERT_SORT_MERGE))
 		where = ELEVATOR_INSERT_BACK;
 
 	switch (where) {

-- 
Jens Axboe

