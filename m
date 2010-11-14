Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab0KNV67 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 16:58:59 -0500
Received: from smtp-out.google.com ([74.125.121.35]:25338 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab0KNV66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 16:58:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ml55vum4liFitHk+XgM1oJsAKfkK89YKW577OMn3Zyc2nB9U5SguYI+Ffx1DG66Rab
         QHKImJ9Iljg13Nee1GGg==
Date: Sun, 14 Nov 2010 13:58:51 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>, Bodo Eggert <7eggert@web.de>,
        Mandeep Singh Baines <msb@google.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH] Revert oom rewrite series
In-Reply-To: <20101114133543.E00A.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1011141345100.22262@chino.kir.corp.google.com>
References: <20101114133543.E00A.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Nov 2010, KOSAKI Motohiro wrote:

> Linus,
> 
> Please apply this. this patch revert commits of oom changes since v2.6.35.
> 
> briefly says, "oom: badness heuristic rewrite" was merges by mistaken.
> It haven't been passed our design nor code review. then multiple bug reports
> has been popped up. I believe evey patches should pass a usecase and a code
> review :-/
> 

That's inaccurate, there haven't been multiple bug reports popping up 
since the rewrite; in fact, there hasn't been a single bug report.

There have been two changes to the oom killer since the rewrite:

 - we now kill all threads sharing the oom killed task that share the ->mm 
   since we can't free any memory without them exiting as well, and

 - we count threads that are immune from oom kill attached to an ->mm so 
   we can avoid needlessly killing tasks that aren't immune themselves but 
   have other threads sharing the ->mm that are.

Both of those changes were needed in the old oom killer as well, they have 
nothing to do with the rewrite.

Also, stating that the new heuristic doesn't address CAP_SYS_RESOURCE 
approrpiately isn't a bug report, it's the desired behavior.  I eliminated 
all of the arbitrary heursitics in the old heuristic that we had the 
remove internally as well so that is predictable as possible and achieves 
the oom killer's sole goal: to kill the most memory-hogging task that is 
eligible to allow memory allocations in the current context to succeed.  
CAP_SYS_RESOURCE threads have full control over their oom killing priority 
by /proc/pid/oom_score_adj and need no consideration in the heuristic by 
default since it otherwise allows for the probability that multiple tasks 
will need to be killed when a CAP_SYS_RESOURCE thread uses an egregious 
amount of memory.

> The problem is, DavidR patches don't refrect real world usecase at all
> and breaking them. He can talk about the userland is wrong. but such
> excuse doesn't solve real world issue. it makes no sense.
> 

As mentioned just a few minutes ago in another thread, there is no 
userspace breakage with the rewrite and you're only complaining here about 
the deprecation of /proc/pid/oom_adj for a period of two years.  Until 
it's removed in 2012 or later, it maps to the linear scale that 
oom_score_adj uses rather than its old exponential scale that was 
unusable for prioritization because of (1) the extremely low resolution, 
and (2) the arbitrary heuristics that preceeded it.

You've proposed various forms of your revert (this is the fifth one) and 
I've responded in a very respectful and technical way each time even 
though you have repeatedly called me stupid.  Linus is under the 
impression that this is some kind of flamewar when in reality it's only a 
desperate attempt of yours to start one, this kind of thing just really 
bounces off of me on a personal level.  I will, however, continue to 
remain professional.
