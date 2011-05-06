Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab1EFDP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 23:15:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45236 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab1EFDP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 23:15:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DC3672C.3000605@jp.fujitsu.com>
Date: Fri, 06 May 2011 12:12:44 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
CC: Willy Tarreau <w@1wt.eu>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        linux-stable mlist <stable@kernel.org>,
        =?UTF-8?B?SGVydsOpIENvbW1vd2ljaw==?= <hcommowick@exosec.fr>
Subject: Re: [stable] 2.6.32.21 - uptime related crashes?
References: <20110428082625.GA23293@pcnci.linuxbox.cz> <20110428183434.GG30645@1wt.eu> <20110429100200.GB23293@pcnci.linuxbox.cz>
In-Reply-To: <20110429100200.GB23293@pcnci.linuxbox.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nikola,

Sorry for not replying sooner.

(2011/04/29 19:02), Nikola Ciprich wrote:
> (another CC added)
> 
> Hello Willy!
> 
> I made some statistics of our servers regarding kernel version and uptime.
> Here are some my thoughts:
> - I'm 100% sure this problem wasn't present in kernels <= 2.6.30.x (we've got a lot of boxes with uptimes >600days)
> - I'm 90% sure this problem also wasn't present in 2.6.32.16 (we've got 6 boxes running for 235 to 280days)
> 
> What I'm not sure is, whether this is present in 2.6.19, I have:
> 2 boxes running 2.6.32.19 for 238days and one 2.6.32.20 for 216days.
> I also have a bunch ov 2.6.32.23 boxes, which are now getting close to 200days uptime.
> But I suspect this really is first problematic version, more on it later. 
> First regarding Your question about CONFIG_HZ - we use 250HZ setting, which leads me to following:
> 250 * 60 * 60 * 24 * 199 = 4298400000 which is value a little over 2**32! So maybe some unsingned long variable
> might overflow? Does this make sense?
> 
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

No.

The commit you pointed is a change for runtimes (cputime_t) accounted for
threads, not for uptime/jiffies/tick. And I suppose any overflow/zero-div
cannot be there:

   if (total) {
 :
       do_div(temp, total);
 :
   }
 :
   p->prev_utime = max(p->prev_utime, utime);

> 
> Any other thoughts?
> 
> best regards
> 
> nik

>From a glance of diff v2.6.32.16..v2.6.32.23, tick_nohz_* could be an
another suspect. Humm...


Thanks,
H.Seto

