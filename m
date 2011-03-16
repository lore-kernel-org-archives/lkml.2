Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab1CPJKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 05:10:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49066 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab1CPJKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 05:10:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.38
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20110314232156.0c363813.akpm@linux-foundation.org>
References: <alpine.DEB.2.00.1103142137020.13734@chino.kir.corp.google.com> <20110314232156.0c363813.akpm@linux-foundation.org>
Message-Id: <20110315153801.3526.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 16 Mar 2011 18:09:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Yesterdays earthquake was announced magnitude 6.5, but M6 quake is
 no longer treated significant news in this country. We are living 
 slightly in a floating mood.]


> So we're talking about three patches:
> 
> oom-prevent-unnecessary-oom-kills-or-kernel-panics.patch
> oom-skip-zombies-when-iterating-tasklist.patch
> oom-avoid-deferring-oom-killer-if-exiting-task-is-being-traced.patch
> 
> all appended below.
> 
> About all of which Oleg had serious complaints, some of which haven't
> yet been addressed.
> 
> And that's OK.  As I said, please let's work through it and get it right.

I haven't understand what is "OK" and what do you want talk. probably
the reason is in my language skill or I haven't catch up Oleg and David
discussion. then instead, I'll post my debugging progressing condition.


 o vmscan.c#all_unreclaimable() might return false negative and lead
   to prevent oom-killer by mistaken. Why? zone->pages_scanned is not
   protected by lock, in other words, it's unstable value. in the other
   hands, x86 ZONE_DMA has only a very little memory, then usually
   never recover all_unreclaimable=no if once become all_unreclaimable=yes.
   then, if zone state become unmatched (eg pages_scanned=0 and all_unreclaimable=yes)
   it can't be recovered never. I mean I could reproduced Andrey reported issue.

 o oom_kill.c#boost_dying_task_prio() makes kernel hang-up if user
   are using cpu cgroups. because cpu cgroup has inadequate default
   RT rt_runtime_us (0 by default. 0 mean RT tasks can't run at all).

 o oom_kill.c#TIF_MEMDIE check makes kernel hang-up. I haven't catch
   the exact reason of a oom killed process sticking even though zone has
   enough memory. 

My dislikeness is, Many people in the list fun to make flamewar but 
nobody except really a few developers run the real code nor join to 
debug real and actual reported issue. In fact, Andrey made testcase and
reported his test environment and help we made reproduce envronemnt.

I also dislike some developer say they haven't seen oom livelock case yet.
It indicate they haven't tested stress workload oom scenario. How do i
trust an untested patch, an untested guys? All developer have to test
until seen oom livelock.

I know oom debugging is very painful and need to take a lot of time.
much false positive, much unfixable live lock, need mililion reset. 
But, I don't think this is good reason to take untested.

Now I'm only access a three years old PC. Therefore, I have no reason
anyone can't debug the issue.


