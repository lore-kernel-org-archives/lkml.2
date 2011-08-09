Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab1HIKNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 06:13:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59706 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab1HIKNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 06:13:00 -0400
Subject: Re: [PATCH] cpufreq: ondemand ignore_nice_level
From: Peter Zijlstra <peterz@infradead.org>
To: joni@shade-fx.com
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Date: Tue, 09 Aug 2011 12:12:39 +0200
In-Reply-To: <4e403bd4.5YAAoSWMDWtU5KOP%joni@shade-fx.com>
References: <4e403bd4.5YAAoSWMDWtU5KOP%joni@shade-fx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312884759.22367.64.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How very good of you to CC all the relevant maintainers..

On Mon, 2011-08-08 at 22:41 +0300, joni@shade-fx.com wrote:
> @@ -3755,7 +3755,7 @@ unsigned long long thread_group_sched_runtime(struct task_struct *p)
>   * @cputime_scaled: cputime scaled by cpu frequency
>   */
>  void account_user_time(struct task_struct *p, cputime_t cputime,
> -                      cputime_t cputime_scaled)
> +               cputime_t cputime_scaled)
>  {
>         struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
>         cputime64_t tmp;

I'm very sure the old alignment was preferred.

> @@ -3769,9 +3769,11 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
>         tmp = cputime_to_cputime64(cputime);
>         if (TASK_NICE(p) > 0)
>                 cpustat->nice = cputime64_add(cpustat->nice, tmp);
> -       else
> +       else 
>                 cpustat->user = cputime64_add(cpustat->user, tmp);
>  
> +       cpustat->nicevalue[TASK_USER_PRIO(p)] = cputime64_add(cpustat->nicevalue[TASK_USER_PRIO(p)], tmp);
> +
>         cpuacct_update_stats(p, CPUACCT_STAT_USER, cputime);
>         /* Account for user time used */
>         acct_update_integrals(p); 

Yay! more senseless accounting.. we really need more of that. What's
even better is your data array being 320 bytes spanning 5 cachelines,
and thus the above almost guarantees a cacheline miss.

All round good stuff, and as DaveJ already pointed out, all without any
justification what so ever.

