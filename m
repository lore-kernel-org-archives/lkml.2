Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339Ab2FHPGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:06:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab2FHPGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:06:46 -0400
Date: Fri, 8 Jun 2012 17:04:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: oom-killer is crazy? (Was: [PATCH 0/3] uprobes fixes for 3.5)
Message-ID: <20120608150437.GA31091@redhat.com>
References: <20120607165942.GA31966@redhat.com> <20120608140328.GA26650@redhat.com> <20120608142625.GC1711@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608142625.GC1711@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08, Dave Jones wrote:
>
> On Fri, Jun 08, 2012 at 04:03:28PM +0200, Oleg Nesterov wrote:
>  >
>  > Hmm. oom_badness() does
>  >
>  > 	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
>  > 		points -= 30 * totalpages / 1000;
>  >
>  > very nice, but what if this underflows? points is unsigned long.
>  > points += p->signal->oom_score_adj... looks suspicious too.
>  >
>  > Looks like we should remove "unsigned" from oom_badness() and
>  > its callers? Probably not, it does "return points ? points : 1".
>
> I've been running this from David for a week, but it still isn't right..
>
> 	Dave
>
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index ed0e196..416637f 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -183,7 +183,7 @@ static bool oom_unkillable_task(struct task_struct *p,
>  unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
>                           const nodemask_t *nodemask, unsigned long totalpages)
>  {
> -       unsigned long points;
> +       long points;
>
>         if (oom_unkillable_task(p, memcg, nodemask))
>                 return 0;
> @@ -223,7 +223,7 @@ unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
>          * Never return 0 for an eligible task regardless of the root bonus and
>          * oom_score_adj (oom_score_adj can't be OOM_SCORE_ADJ_MIN here).
>          */
> -       return points ? points : 1;
> +       return points > 0 ? points : 1;
>  }

I did the same to avoid the problem.

Even if it still isn't right, I think it is much better ;) Currently
oom_badness() is obviously and seriously broken.

Oleg.

