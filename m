Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030940Ab1EWWcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:32:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27717 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab1EWWcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:32:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=RuIjiojSjoSIFDv0/6ONvGM/dwtC5eGq5M8w16YW30cPhSztinEwkQ4dEzVHssxbf8
         xWvafbwkEchpNO+6B0ng==
Date: Mon, 23 May 2011 15:32:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com
Subject: Re: [PATCH 4/5] oom: don't kill random process
In-Reply-To: <4DD6207E.1070300@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1105231529340.17840@chino.kir.corp.google.com>
References: <4DD61F80.1020505@jp.fujitsu.com> <4DD6207E.1070300@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011, KOSAKI Motohiro wrote:

> CAI Qian reported oom-killer killed all system daemons in his
> system at first if he ran fork bomb as root. The problem is,
> current logic give them bonus of 3% of system ram. Example,
> he has 16GB machine, then root processes have ~500MB oom
> immune. It bring us crazy bad result. _all_ processes have
> oom-score=1 and then, oom killer ignore process memory usage
> and kill random process. This regression is caused by commit
> a63d83f427 (oom: badness heuristic rewrite).
> 
> This patch changes select_bad_process() slightly. If oom points == 1,
> it's a sign that the system have only root privileged processes or
> similar. Thus, select_bad_process() calculate oom badness without
> root bonus and select eligible process.
> 

You said earlier that you thought it was a good idea to do a proportional 
based bonus for root processes.  Do you have a specific objection to 
giving root processes a 1% bonus for every 10% of used memory instead?

> Also, this patch move finding sacrifice child logic into
> select_bad_process(). It's necessary to implement adequate
> no root bonus recalculation. and it makes good side effect,
> current logic doesn't behave as the doc.
> 

This is unnecessary and just makes the oom killer egregiously long.  We 
are already diagnosing problems here at Google where the oom killer holds 
tasklist_lock on the readside for far too long, causing other cpus waiting 
for a write_lock_irq(&tasklist_lock) to encounter issues when irqs are 
disabled and it is spinning.  A second tasklist scan is simply a 
non-starter.

 [ This is also one of the reasons why we needed to introduce
   mm->oom_disable_count to prevent a second, expensive tasklist scan. ]

> Documentation/sysctl/vm.txt says
> 
>     oom_kill_allocating_task
> 
>     If this is set to non-zero, the OOM killer simply kills the task that
>     triggered the out-of-memory condition.  This avoids the expensive
>     tasklist scan.
> 
> IOW, oom_kill_allocating_task shouldn't search sacrifice child.
> This patch also fixes this issue.
> 

oom_kill_allocating_task was introduced for SGI to prevent the expensive 
tasklist scan, the task that is actually allocating the memory isn't 
actually interesting and is usually random.  This should be turned into a 
documentation fix rather than changing the implementation.

Thanks.
