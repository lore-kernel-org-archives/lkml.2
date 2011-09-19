Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab1ISQK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 12:10:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45237 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab1ISQK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 12:10:57 -0400
Subject: Re: [PATCH 2/9] Make cpuacct fields per cpu variables
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, xemul@parallels.com, paul@paulmenage.org,
        lizf@cn.fujitsu.com, daniel.lezcano@free.fr, mingo@elte.hu,
        jbottomley@parallels.com
In-Reply-To: <1316030695-19826-3-git-send-email-glommer@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
	 <1316030695-19826-3-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 19 Sep 2011 18:10:26 +0200
Message-ID: <1316448626.1511.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 3.0.3- 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-14 at 17:04 -0300, Glauber Costa wrote:
> @@ -9258,11 +9253,17 @@ static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
>                 struct cgroup_map_cb *cb)
>  {
>         struct cpuacct *ca = cgroup_ca(cgrp);
> -       int i;
> +       int i, cpu;
> +       u64 acc[CPUACCT_STAT_NSTATS] = { 0, };
> +
> +       for_each_present_cpu(cpu) {
> +               u64 *vec = per_cpu_ptr(ca->cpustat, cpu);
> +               for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
> +                       acc[i] += vec[i];
> +       }
>  
>         for (i = 0; i < CPUACCT_STAT_NSTATS; i++) {
> -               s64 val = percpu_counter_read(&ca->cpustat[i]);
> -               val = cputime64_to_clock_t(val);
> +               s64 val = cputime64_to_clock_t(acc[i]);
>                 cb->fill(cb, cpuacct_stat_desc[i], val);
>         }
>         return 0; 

The changelog doesn't mention this function is a lot more expensive now.

Someone might have daft software polling this frequently.. at least its
still fully preemptible so its not much of a problem, but it is
something to be aware of.
