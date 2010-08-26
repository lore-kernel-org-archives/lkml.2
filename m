Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab0HZCud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 22:50:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:17606 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab0HZCua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 22:50:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=PhTdLJkxkG1XtFZ6LIusHw0ceocwiOgbYyz1viwq2HpIQSM1imei6gnClFTWsNqo2
	C1Wsor1V8Tzp8jZx21wXw==
Date: Wed, 25 Aug 2010 19:50:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 1/2][BUGFIX] oom: remove totalpage normalization from
 oom_badness()
In-Reply-To: <20100826101139.eb05fe2d.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1008251920510.6227@chino.kir.corp.google.com>
References: <20100825184001.F3EF.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1008250300500.13300@chino.kir.corp.google.com> <20100826093923.d4ac29b6.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1008251746200.28401@chino.kir.corp.google.com>
 <20100826101139.eb05fe2d.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010, KAMEZAWA Hiroyuki wrote:

> Hmm. I'll add a text like following to cgroup/memory.txt. O.K. ?
> 
> ==
> Notes on oom_score and oom_score_adj.
> 
> oom_score is calculated as
> 	oom_score = (taks's proportion of memory) + oom_score_adj.
> 

I'd replace "memory" with "memory limit (or memsw limit)" so it's clear 
we're talking about the amount of memory available to task.

> Then, when you use oom_score_adj to control the order of priority of oom,
> you should know about the amount of memory you can use.

Hmm, you need to know the amount of memory that you can use iff you know 
the memcg limit and it's a static value.  Otherwise, you only need to know 
the "memory usage of your application relative to others in the same 
cgroup."  An oom_score_adj of +300 adds 30% of that memcg's limit to the 
task, allowing all other tasks to use 30% more memory than that task with 
it still be killed.  An oom_score_adj of -300 allows that task to use 30% 
more memory than other tasks without getting killed.  These don't need to 
know the actual limit.

> So, an approximate oom_score under memcg can be
> 
>  memcg_oom_score = (oom_score - oom_score_adj) * system_memory/memcg's limit
> 		+ oom_score_adj.
> 

Right, that's the exact score within the memcg.

But, I still wouldn't encourage a formula like this because the memcg 
limit (or cpuset mems, mempolicy nodes, etc) are dynamic and may change 
out from under us.  So it's more important to define oom_score_adj in the 
user's mind as a proportion of memory available to be added (either 
positively or negatively) to its memory use when comparing it to other 
tasks.  The point is that the memcg limit isn't interesting in this 
formula, it's more important to understand the priority of the task 
_compared_ to other tasks memory usage in that memcg.

It probably would be helpful, though, if you know that a vital system task 
uses 1G, for instance, in a 4G memcg that an oom_score_adj of -250 will 
disable oom killing for it.  If that tasks leaks memory or becomes 
significantly large, for whatever reason, it could be killed, but we _can_ 
discount the 1G in comparison to other tasks as the "cost of doing 
business" when it comes to vital system tasks:

	(memory usage) * (memory+swap limit / system memory)
