Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab1D3Jgt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 05:36:49 -0400
Received: from 1wt.eu ([62.212.114.60]:35817 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab1D3Jgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 05:36:48 -0400
Date: Sat, 30 Apr 2011 11:36:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: linux-kernel mlist <linux-kernel@vger.kernel.org>,
        linux-stable mlist <stable@kernel.org>,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        seto.hidetoshi@jp.fujitsu.com
Subject: Re: [stable] 2.6.32.21 - uptime related crashes?
Message-ID: <20110430093605.GA10529@1wt.eu>
References: <20110428082625.GA23293@pcnci.linuxbox.cz> <20110428183434.GG30645@1wt.eu> <20110429100200.GB23293@pcnci.linuxbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110429100200.GB23293@pcnci.linuxbox.cz>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Nikola,

On Fri, Apr 29, 2011 at 12:02:00PM +0200, Nikola Ciprich wrote:
> (another CC added)
> 
> Hello Willy!
> 
> I made some statistics of our servers regarding kernel version and uptime.
> Here are some my thoughts:
> - I'm 100% sure this problem wasn't present in kernels <= 2.6.30.x (we've got a lot of boxes with uptimes >600days)
> - I'm 90% sure this problem also wasn't present in 2.6.32.16 (we've got 6 boxes running for 235 to 280days)

OK those are all precious information.

> What I'm not sure is, whether this is present in 2.6.19, I have:
> 2 boxes running 2.6.32.19 for 238days and one 2.6.32.20 for 216days.
> I also have a bunch ov 2.6.32.23 boxes, which are now getting close to 200days uptime.
> But I suspect this really is first problematic version, more on it later. 
> First regarding Your question about CONFIG_HZ - we use 250HZ setting, which leads me to following:
> 250 * 60 * 60 * 24 * 199 = 4298400000 which is value a little over 2**32! So maybe some unsingned long variable
> might overflow? Does this make sense?

Yes of course it makes sense, that was also my worries. 2^32 jiffies at
250 Hz is slightly less than 199 days. Maybe an overflow somewhere keeps
propagating wrong results on some computations. I remember having encountered
a lot of funny things when trying to get 2.4 get past the 497 days limit
using the jiffies64 patch. So I would not be surprized at all that we're
in a similar situation here.

Also, I've checked the Debian kernel config where we had the divide overflow
and it was running at 250 Hz too.

> And to my suspicion about 2.6.32.19, there is one commit which maybe is related:
> 
> commit 0cf55e1ec08bb5a22e068309e2d8ba1180ab4239
> Author: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> Date:   Wed Dec 2 17:28:07 2009 +0900
> 
>     sched, cputime: Introduce thread_group_times()
>     
>     This is a real fix for problem of utime/stime values decreasing
>     described in the thread:
>     
>        http://lkml.org/lkml/2009/11/3/522
>     
>     Now cputime is accounted in the following way:
>     
>      - {u,s}time in task_struct are increased every time when the thread
>        is interrupted by a tick (timer interrupt).
>     
>      - When a thread exits, its {u,s}time are added to signal->{u,s}time,
>        after adjusted by task_times().
>     
>      - When all threads in a thread_group exits, accumulated {u,s}time
>        (and also c{u,s}time) in signal struct are added to c{u,s}time
>        in signal struct of the group's parent.
> .
> .
> .
> 
> I haven't studied this into detail yet, but it seems to me it might really be related. Hidetoshi-san - do You have some opinion about this?
> Could this somehow either create or invoke the problem with overflow of some variable which would lead to division by zero or similar problems?
> 
> Any other thoughts?

There was a kernel parameter in the past that was used to make jiffies wrap
a few minutes after boot, maybe we should revive it to try to reproduce
without waiting 7 new months :-/

Last, the "advantage" with a suspected regression in a stable series is that 
there are a lot less patches to test.

Regards,
Willy

