Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751164Ab0LSGI6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 01:08:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab0LSGI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 01:08:57 -0500
Message-ID: <4D0DA15B.7080401@redhat.com>
Date: Sun, 19 Dec 2010 08:08:27 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mike Galbraith <mgalbraith@suse.de>
CC: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
References: <20101213224434.7495edb2@annuminas.surriel.com>	 <20101213224657.7e141746@annuminas.surriel.com>	 <1292306896.7448.157.camel@marge.simson.net> <4D0A6D34.6070806@redhat.com>	 <1292569018.7772.75.camel@marge.simson.net>	 <1292570143.7772.84.camel@marge.simson.net>  <4D0CEA7F.9080603@redhat.com> <1292699629.1181.58.camel@marge.simson.net>
In-Reply-To: <1292699629.1181.58.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2010 09:13 PM, Mike Galbraith wrote:
> On Sat, 2010-12-18 at 19:08 +0200, Avi Kivity wrote:
> >  On 12/17/2010 09:15 AM, Mike Galbraith wrote:
> >  >  BTW, with this vruntime donation thingy, what prevents a task from
> >  >  forking off accomplices who do nothing but wait for a wakeup and
> >  >  yield_to(exploit)?
> >  >
> >
> >  What's the difference between that and forking off accomplices who
> >  run(exploit) directly?
>
> The clock still advances.  What I described is a clock stopper.

That's scheduler jargon, I'm not familiar with scheduler internals.  
Let's talk about this at a high level, since whenever I describe it in 
scheduler terms I'm likely to get it wrong.

If there are N tasks on the machine, each is entitled to 1/N of the 
machine's cpu resources (ignoring nice and cgroups for the moment).  
What I'd like is for one task to temporarily pass a portion of its 
entitlement to another.  No other task's entitlement is affected; they 
still get their 1/N.

If a task donates its entitlement and immediately commits suicide, still 
we won't have fundamentally changed anything; the task could have kept 
itself alive and consumed that entitlement, so the scheduler was already 
prepared to give it this entitlement so nothing was gained by the 
forking task.  The problem of fork() creating new entitlements out of 
thin air has nothing to do with directed yield, and is solved by cgroups.

We already do something similar with priority inheritance.  This doesn't 
involve cpu entitlement, but we have the same situation where a task's 
ability to make progress depends on another task receiving cpu time.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

