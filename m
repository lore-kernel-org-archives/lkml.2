Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab2FIWZq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 18:25:46 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:32784 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2FIWZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 18:25:44 -0400
Message-ID: <4FD3CD6A.9020801@gmail.com>
Date: Sat, 09 Jun 2012 18:25:46 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, kosaki.motohiro@gmail.com
Subject: Re: [patch for-3.5-rc1] mm, oom: fix badness score underflow
References: <20120607165942.GA31966@redhat.com> <20120608140328.GA26650@redhat.com> <20120608142625.GC1711@redhat.com> <20120608150437.GA31091@redhat.com> <alpine.DEB.2.00.1206081317120.19054@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1206081317120.19054@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(6/8/12 4:21 PM), David Rientjes wrote:
> If the privileges given to root threads (3% of allowable memory) or a
> negative value of /proc/pid/oom_score_adj happen to exceed the amount of
> rss of a thread, its badness score overflows as a result of a7f638f999ff
> ("mm, oom: normalize oom scores to oom_score_adj scale only for
> userspace").
>
> Fix this by making the type signed and return 1, meaning the thread is
> still eligible for kill, if the value is negative.
>
> Reported-by: Dave Jones<davej@redhat.com>
> Acked-by: Oleg Nesterov<oleg@redhat.com>
> Signed-off-by: David Rientjes<rientjes@google.com>
> ---
>   mm/oom_kill.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -183,7 +183,7 @@ static bool oom_unkillable_task(struct task_struct *p,
>   unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
>   			  const nodemask_t *nodemask, unsigned long totalpages)
>   {
> -	unsigned long points;
> +	long points;
>
>   	if (oom_unkillable_task(p, memcg, nodemask))
>   		return 0;
> @@ -223,7 +223,7 @@ unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
>   	 * Never return 0 for an eligible task regardless of the root bonus and
>   	 * oom_score_adj (oom_score_adj can't be OOM_SCORE_ADJ_MIN here).
>   	 */
> -	return points ? points : 1;
> +	return points>  0 ? points : 1;
>   }

Use long long. following line is dangerous.

         points += p->signal->oom_score_adj * totalpages / 1000;

maximum oom_score_adj is 1000. then if system has >8G memory on 32bit
(i.e. LONG_MAX [pages] * 4096 [pagesize] / 1000), it might get an overflow.

Or, don't use normalized oom_score_adj. i.e, oom_score_adj_write() convert
oom_score_adj into rss based modifier.

This is oom-killer code. A micro optimization don't bring us a performance benefit.

