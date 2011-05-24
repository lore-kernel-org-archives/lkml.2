Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab1EXBfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:35:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42513 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab1EXBfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:35:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDB0B45.2080507@jp.fujitsu.com>
Date: Tue, 24 May 2011 10:35:01 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: rientjes@google.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com
Subject: Re: [PATCH 4/5] oom: don't kill random process
References: <4DD61F80.1020505@jp.fujitsu.com> <4DD6207E.1070300@jp.fujitsu.com> <alpine.DEB.2.00.1105231529340.17840@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1105231529340.17840@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/24 7:32), David Rientjes wrote:
> On Fri, 20 May 2011, KOSAKI Motohiro wrote:
>
>> CAI Qian reported oom-killer killed all system daemons in his
>> system at first if he ran fork bomb as root. The problem is,
>> current logic give them bonus of 3% of system ram. Example,
>> he has 16GB machine, then root processes have ~500MB oom
>> immune. It bring us crazy bad result. _all_ processes have
>> oom-score=1 and then, oom killer ignore process memory usage
>> and kill random process. This regression is caused by commit
>> a63d83f427 (oom: badness heuristic rewrite).
>>
>> This patch changes select_bad_process() slightly. If oom points == 1,
>> it's a sign that the system have only root privileged processes or
>> similar. Thus, select_bad_process() calculate oom badness without
>> root bonus and select eligible process.
>>
>
> You said earlier that you thought it was a good idea to do a proportional
> based bonus for root processes.  Do you have a specific objection to
> giving root processes a 1% bonus for every 10% of used memory instead?

Because it's completely another topic. You have to maek another patch.



>> Also, this patch move finding sacrifice child logic into
>> select_bad_process(). It's necessary to implement adequate
>> no root bonus recalculation. and it makes good side effect,
>> current logic doesn't behave as the doc.
>>
>
> This is unnecessary and just makes the oom killer egregiously long.  We
> are already diagnosing problems here at Google where the oom killer holds
> tasklist_lock on the readside for far too long, causing other cpus waiting
> for a write_lock_irq(&tasklist_lock) to encounter issues when irqs are
> disabled and it is spinning.  A second tasklist scan is simply a
> non-starter.
>
>   [ This is also one of the reasons why we needed to introduce
>     mm->oom_disable_count to prevent a second, expensive tasklist scan. ]

You misunderstand the code. Both select_bad_process() and oom_kill_process()
are under tasklist_lock(). IOW, no change lock holding time.


>> Documentation/sysctl/vm.txt says
>>
>>      oom_kill_allocating_task
>>
>>      If this is set to non-zero, the OOM killer simply kills the task that
>>      triggered the out-of-memory condition.  This avoids the expensive
>>      tasklist scan.
>>
>> IOW, oom_kill_allocating_task shouldn't search sacrifice child.
>> This patch also fixes this issue.
>>
>
> oom_kill_allocating_task was introduced for SGI to prevent the expensive
> tasklist scan, the task that is actually allocating the memory isn't
> actually interesting and is usually random.  This should be turned into a
> documentation fix rather than changing the implementation.

No benefit. I don't take it.


