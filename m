Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab1CRJIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 05:08:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63870 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311Ab1CRJI1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 05:08:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hytf6sdtmQXsT1ZRKCn5sx3C02Yg0lTpDQVEG1qUHdHB1fJ6i+0iA22uWIQd3PSXjy
         wUcV4qdY8VDqBFKFyVrKLYD/2oh/WVQI0+pQeVQyl5NiURwAZ6oFu1nlsA6UBOuBZb8c
         iF0fra5EbyGBts+V170YvTnojHcTfpKbjSk40=
MIME-Version: 1.0
In-Reply-To: <20110314152227.191956337@chello.nl>
References: <20110314150613.749843433@chello.nl>
	<20110314152227.191956337@chello.nl>
Date: Fri, 18 Mar 2011 14:38:25 +0530
Message-ID: <AANLkTi=sDHEAMK0fWF07brEd6WEki0Sffmgcy3LkERK3@mail.gmail.com>
Subject: Re: [RFC][PATCH 09/14] sched: Dynamically allocate
 sched_domain/sched_group data-structures
From: Bharata B Rao <bharata.rao@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 8:36 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
>  enum s_alloc {
>        sa_rootdomain,
>        sa_sd,
> -       sa_tmpmask,
> +       sa_sd_storage,
>        sa_send_covered,
>        sa_nodemask,
>        sa_none,
>  };
>
>
>
>  SD_INIT_FUNC(CPU)
> @@ -7079,13 +6995,22 @@ static void set_domain_attribute(struct
>  static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
>                                 const struct cpumask *cpu_map)
>  {
> +       int i, j;
> +
>        switch (what) {
>        case sa_rootdomain:
> -               free_rootdomain(d->rd); /* fall through */
> +               free_rootdomain(&d->rd->rcu); /* fall through */
>        case sa_sd:
>                free_percpu(d->sd); /* fall through */
> -       case sa_tmpmask:
> -               free_cpumask_var(d->tmpmask); /* fall through */
> +       case sa_sd_storage:
> +               for (i = 0; i < SD_LV_MAX; i++) {
> +                       for_each_cpu(j, cpu_map) {
> +                               kfree(*per_cpu_ptr(d->sdd[i].sd, j));
> +                               kfree(*per_cpu_ptr(d->sdd[i].sg, j));
> +                       }
> +                       free_percpu(d->sdd[i].sd);
> +                       free_percpu(d->sdd[i].sg);
> +               } /* fall through */
>        case sa_send_covered:
>                free_cpumask_var(d->send_covered); /* fall through */
>        case sa_nodemask:
> @@ -7098,25 +7023,70 @@ static void __free_domain_allocs(struct
>  static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
>                                                   const struct cpumask *cpu_map)
>  {
> +       int i, j;
> +
> +       memset(d, 0, sizeof(*d));
> +
>        if (!alloc_cpumask_var(&d->nodemask, GFP_KERNEL))
>                return sa_none;
>        if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
>                return sa_nodemask;
> -       if (!alloc_cpumask_var(&d->tmpmask, GFP_KERNEL))
> -               return sa_send_covered;

sa_send_covered enum member can be removed, since you no longer seem
to be using it.

Regards,
Bharata.
