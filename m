Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787Ab1CSBYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 21:24:08 -0400
Received: from smtp-out.google.com ([74.125.121.67]:28557 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043Ab1CSBYB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 21:24:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mSYU3QDGwRXkqMWTaf0ESiGj3xHNKJEFqHdI91Aods7OMx3p4+M2BQdWqpKqHld9PQ
         ZLI1Ys3vafXbMCVD6gTw==
MIME-Version: 1.0
In-Reply-To: <20110314152227.191956337@chello.nl>
References: <20110314150613.749843433@chello.nl>
	<20110314152227.191956337@chello.nl>
Date: Fri, 18 Mar 2011 18:23:58 -0700
Message-ID: <AANLkTikUGwkOwUoGcti0SOFWVKxAMZNUk9c30oBRFmMx@mail.gmail.com>
Subject: Re: [RFC][PATCH 09/14] sched: Dynamically allocate
 sched_domain/sched_group data-structures
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 8:06 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> @@ -1721,10 +1724,11 @@ select_task_rq_fair(struct rq *rq, struc
>        }
>
>        if (affine_sd) {
> -               if (cpu == prev_cpu || wake_affine(affine_sd, p, sync))
> -                       return select_idle_sibling(p, cpu);
> -               else
> -                       return select_idle_sibling(p, prev_cpu);
> +               if (wake_affine(affine_sd, p, sync))
> +                       prev_cpu = cpu;
> +
> +               new_cpu = select_idle_sibling(p, prev_cpu);
> +               goto unlock;
>        }
>
>        while (sd) {

This would result in going through wake_affine() doing all
effective_load stuff even with cpu == prev_cpu. No?
So, we need either if (cpu != prev_cpu && wake_affine(affine_sd, p,
sync)) or an check at the start to have want_affine=0 for this case.

Overall patchset looks great!

Thanks,
Venki
