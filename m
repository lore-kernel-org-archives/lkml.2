Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab0D0VS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 17:18:56 -0400
Received: from www84.your-server.de ([213.133.104.84]:46299 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542Ab0D0VSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 17:18:55 -0400
Subject: Re: Weirdness in /proc/<pid>/maps and /proc/<pid>/stat.
From: Stefani Seibold <stefani@seibold.net>
To: Robin Holt <holt@sgi.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100427185343.GR4920@sgi.com>
References: <20100427185343.GR4920@sgi.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 27 Apr 2010 23:18:49 +0200
Message-ID: <1272403129.29233.20.camel@wall-e.seibold.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 27.04.2010, 13:53 -0500 schrieb Robin Holt:
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

I must guess, because the output of your example code does not fit to
your description. But the stat-28 make sense for me. A thread gets a new
stack, a fork inherits the stack of the process. 

> Note: For all of the above, the /proc/<pids>/task/*/maps files had the
> stack line like:
> 7fff55c7d000-7fff56081000 rw-p 00000000 00:00 0                         [stack]
> 

This should be okay, because this is the stack of the main thread. The
stack of the thread is marked as [thread stack: xxxxxxxx]. Where
xxxxxxxx is the max size of the stack, because the thread stack could
start at a arbitrary position inside the VMA.

> The problems I see are:
> 1)  In the fork() case, we are using the current userland stack
>     pointer for task->stack_start.  This appears wrong as the
>     function which called fork() may be returned to and may
>     further return to higher level callers, finding sp now
>     beyond the value reported in /proc/self/stat.  Additionally,
>     the value reported for the child of the fork has no relationship
>     to the stack size rlimit any longer.
> 
> 2)  In the pthread + fork case, in addition to the problem
>     above, the size information in /proc/self/maps
>     is incorrect as it does not take into consideration
>     the same return paths.
> 
> The problem I am running into is coming up with any way to
> make the task->stack_start value usable.


