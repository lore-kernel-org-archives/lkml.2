Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab0LCFL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 00:11:57 -0500
Received: from smtp-out.google.com ([74.125.121.35]:59874 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0LCFL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 00:11:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=Ap2h7CzeViv+xVLUr49nBfRXDF6ox2MweAas1mFIA4p8ewBpyjZSE8nk1LNWG39Wuu
         Xz1VO/sBJj/D+4CAQAPA==
Message-ID: <4CF87C14.8000708@google.com>
Date: Thu, 02 Dec 2010 21:11:48 -0800
From: Paul Turner <pjt@google.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Mike Galbraith <efault@gmx.de>
CC: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] sched: automated per session task groups
References: <20101121133744.GA10765@elte.hu>	 <1290700829.4759.16.camel@maggy.simson.net>	 <1290954299.30515.15.camel@marge.simson.net>  <4CF5C379.8030204@google.com> <1291184173.7466.147.camel@marge.simson.net>
In-Reply-To: <1291184173.7466.147.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/10 22:16, Mike Galbraith wrote:
> On Tue, 2010-11-30 at 19:39 -0800, Paul Turner wrote:
>> On 11/28/10 06:24, Mike Galbraith wrote:
>>>
>>> Something else is seriously wrong though.  36.1 with attached (plus
>>> sched, cgroup: Fixup broken cgroup movement) works a treat, whereas
>>> 37.git and tip with fixlet below both suck rocks.  With a make -j40
>>> running, wakeup-latency is showing latencies of>100ms, amarok skips,
>>> mouse lurches badly.. generally horrid.  Something went south.
>>
>> I'm looking at this.
>>
>> The share:share ratios looked good in static testing, but perhaps we
>> need a little more wake-up boost to improve interactivity.
>
> Yeah, feels like a wakeup issue.  I too did a (brief) static test, and
> that looked ok.
>
> 	-Mike
>

Hey Mike,

Does something like the below help?

We're quick to drive the load_contribution up (to avoid over-commit). 
However on sleepy workloads this results in lots of weight being 
stranded (since it reaches maximum contribution instantaneously but 
decays slowly) as the thread migrates between cpus.

Avoid this by averaging "up" in the wake-up direction as well as the sleep.

We also get a boost from the fact that we use the instantaneous weight 
in computing the actual received shares.

I actually don't have a desktop setup handy to test "interactivity" (sad 
but true -- working on grabbing one).  But it looks better on under 
synthetic load.

- Paul

===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -743,12 +743,19 @@ static void update_cfs_load(struct cfs_r
                 return;

         now = rq_of(cfs_rq)->clock;
-       delta = now - cfs_rq->load_stamp;
+
+       if (likely(cfs_rq->load_stamp))
+               delta = now - cfs_rq->load_stamp;
+       else {
+               /* avoid large initial delta and initialize load_period */
+               delta = 1;
+               cfs_rq->load_stamp = 1;
+       }

         /* truncate load history at 4 idle periods */
         if (cfs_rq->load_stamp > cfs_rq->load_last &&
             now - cfs_rq->load_last > 4 * period) {
-               cfs_rq->load_period = 0;
+               cfs_rq->load_period = period/2;
                 cfs_rq->load_avg = 0;
         }
