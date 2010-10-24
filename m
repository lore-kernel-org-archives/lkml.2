Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab0JXUm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 16:42:59 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:45348 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932872Ab0JXUm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 16:42:58 -0400
X-ASG-Debug-ID: 1287952977-16967aaf0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CC49A4B.8010300@fusionio.com>
Date: Sun, 24 Oct 2010 22:42:51 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Revert of the IO stat fix
References: <4CC49274.3030803@fusionio.com> <AANLkTik4qAzZPLO8HHBCM34_NLEEdPj04RyXPfeR-wSv@mail.gmail.com>
X-ASG-Orig-Subj: Re: [GIT PULL] Revert of the IO stat fix
In-Reply-To: <AANLkTik4qAzZPLO8HHBCM34_NLEEdPj04RyXPfeR-wSv@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1287952977
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.4658 1.0000 0.0000
X-Barracuda-Spam-Score: 0.23
X-Barracuda-Spam-Status: No, SCORE=0.23 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=RCVD_ILLEGAL_IP
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.44634
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.23 RCVD_ILLEGAL_IP        Received: contains illegal IP address
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-24 22:35, Linus Torvalds wrote:
> On Sun, Oct 24, 2010 at 1:09 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>> The fix for cross-partition merges screwing up disk stats turns out
>> to be problematic on various levels. Lets revert this one so we have
>> time to come up with a proper solution for this.
> 
> Hmm.. I think the reverted patch looks like it really is the right
> thing to do, so I hate reverting it this early. What were the problems
> with it?
> 
> Btw, one thing that seems to be missing in the original commit (which
> is not necessarily the reason for the trouble, of course), is that
> elv_rq_merge_ok() seems to not check the partition. As far as I can
> tell, we should have a
> 
>     if (req->part != bio->bi_bdev->bd_part)
>        return 0;
> 
> there, no? And you should _not_ set rq->part in "drive_stat_acct()",
> you should set it from bio->bi_bdev->bd_part when you create the
> request.
> 
> (And if it is NULL, just don't do partition accounting at all)
> 
> Hmm? What am I missing? What were the bugs?

The patch itself is sound, the problems are around the area of it not
really liking non-elevator devices with the elv_quiesce_start/end()
parts. I had the below patch for that, but then I could not decide
whether we were fully safe on queue free after talking to Vivek about
it.

So that shows up as an oops on removal of mspro for instance, and loop
throws a fit as well. Coverage of the bug is too large just to let side
idle for a few days.

And since I'll be travelling the next few days, I would rather just
revert this one and I have time in-flight to fix it for real.

OK?

-- 
Jens Axboe

