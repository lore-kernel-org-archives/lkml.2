Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab0IZDV5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 23:21:57 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:43282 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980Ab0IZDV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 23:21:56 -0400
X-ASG-Debug-ID: 1285471315-0e1238330001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4C9EBC50.3080201@fusionio.com>
Date: Sun, 26 Sep 2010 12:21:52 +0900
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] One important block fix for 2.6.36-rc
References: <4C9DD2D5.8090807@fusionio.com> <AANLkTikcR8fu11jyLcD3Fuvm4TPxU=46jLcpsYryHONP@mail.gmail.com>
X-ASG-Orig-Subj: Re: [GIT PULL] One important block fix for 2.6.36-rc
In-Reply-To: <AANLkTikcR8fu11jyLcD3Fuvm4TPxU=46jLcpsYryHONP@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1285471315
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0005 1.0000 -2.0176
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.41906
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-26 01:59, Linus Torvalds wrote:
> On Sat, Sep 25, 2010 at 3:45 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>> Please pull asap, thanks.
> 
> Pulled, but I _really_ wish you started looking at cleanliness issues,
> even with bug-reports.
> 
> That's a singularly stupid and unreadable way of testing "do those
> flags match". It is quite possible that the compiler fixes up the
> stupidity, but that doesn't make it much better.
> 
> Here's how things like this _should_ be tested:
> 
>    #define REQ_FLAGS_MUST_MATCH (REQ_SECURE | REQ_DISCARD)
> 
>    ...
>    /* Check that flags match in the required bits */
>    if ((req->cmd_flags ^ next->cmd_flags) & REQ_FLAGS_MUST_MATCH)
>       return 0;
>    ...
> 
> which is (a) smaller (b) easier and clearer to add flags as needed and
> (c) actually more readable due to not having duplicated logic (not
> just one if-statement, but one mask too).

Completely agree, I will clean this up for the .37. Since we are very
late in the rc cycle, I prefer obvious patches greatly. Especially
for something like this, which could cause data corruption.

> And yes, I think you'd want to add a few flags there. Looking at the
> REQ_xyz flags, I suspect most o them should really really match for
> requests to be mergeable. Wouldn't it be better to think of it in
> terms of "do we really allow different cmd_flags requests to merge"
> than adding one bit ad-hoc at a time?

The above bits and the failfast bits at least should disallow merging,
and the direction bit as well. So yes, I think we should add an
explicit mask for this.

-- 
Jens Axboe

