Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab0D1DTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 23:19:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48592 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab0D1DTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 23:19:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Robin Holt <holt@sgi.com>
Subject: Re: Weirdness in /proc/<pid>/maps and /proc/<pid>/stat.
Cc: kosaki.motohiro@jp.fujitsu.com, Stefani Seibold <stefani@seibold.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100427185343.GR4920@sgi.com>
References: <20100427185343.GR4920@sgi.com>
Message-Id: <20100428085631.F835.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 28 Apr 2010 12:19:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> With commit d899bf7b, the behavior of field 28 of /proc/<pid>/stat
> was changed as was /proc/<pid>/maps.  I don't know if that change was
> correct, but its resulting behavior is much more difficult to explain.
> I was wondering if we could determine what the "correct" behavior is
> before I spend much more time trying to give it the wrong behavior.
> 
> My test program is attached below.  Essentially:
> fork() -> pthread_create() -> fork()
> 
> x86_64 2.6.32 stable kernel:
> Step			stat-28		maps-threadstack
> p (parent)		0x7fff5607ddc0	N/A
> c (child)		0x7fff55c7dc50	N/A
> ppthread		0x7f2cf5c9bff0	0x7f2cf5c9d000:007feff0
> ppthread+fork		0x7f2cf589be30	0x7f2cf5c9d000:003fee30
> cpthread		0x7f2cf589be30  0x7f2cf5c9d000:007feff0
> cpthread+fork		0x7f2cf589be30	0x7f2cf5c9d000:003fee30
> Note: For all of the above, the /proc/<pids>/task/*/maps files had the
> stack line like:
> 7fff55c7d000-7fff56081000 rw-p 00000000 00:00 0                         [stack]
> 
> The problems I see are:
> 1)  In the fork() case, we are using the current userland stack
>     pointer for task->stack_start.  This appears wrong as the
>     function which called fork() may be returned to and may
>     further return to higher level callers, finding sp now
>     beyond the value reported in /proc/self/stat.  Additionally,
>     the value reported for the child of the fork has no relationship
>     to the stack size rlimit any longer.

BUG.


> 2)  In the pthread + fork case, in addition to the problem
>     above, the size information in /proc/self/maps
>     is incorrect as it does not take into consideration
>     the same return paths.

BUG.

Robin, do you really need this feature? if not, I'll revert this one.


sidenote: if anyone really need to know thread stack range, I think we need to
prevent vma consoliation of thread stack, iow need to implement MAP_STACK.


> 
> The problem I am running into is coming up with any way to
> make the task->stack_start value usable.





