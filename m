Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab2IERGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 13:06:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57782 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2IERGK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 13:06:10 -0400
Message-ID: <1346864762.2600.30.camel@twins>
Subject: Re: [BUG] perf: perf_swevent PMU should not be on rotation_list
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 05 Sep 2012 19:06:02 +0200
In-Reply-To: <CABPqkBQGNx0od5-nkRDsrXkKa3+TAYW07j59ct5b17gPU-Oqeg@mail.gmail.com>
References: <CABPqkBQGNx0od5-nkRDsrXkKa3+TAYW07j59ct5b17gPU-Oqeg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 16:03 +0200, Stephane Eranian wrote:
> Hi,
> 
> I was looking at the rotation code and I found out that when
> I monitor a SW event (in my case a probe), I end up having
> two PMUs on the rotation list on Intel Core: cpu and software.
> 
> I thought there was no multiplexing needed for SW events.

Correct, since programming of swevents should always succeed.

> So why is the SW PMU on the rotation list causing extra
> iterations through the rotation code?

Because... uhm.. someone (probably me) didn't think to exclude swevents.

> Shouldn't we do something like:
> 
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -771,6 +780,9 @@ static void perf_pmu_rotate_start(struct pmu *pmu)
>         struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
>         struct list_head *head = &__get_cpu_var(rotation_list);
> 
> +       if (pmu->type == PERF_TYPE_SOFTWARE)
> +               return;
> +
>         WARN_ON(!irqs_disabled());
> 
>         if (list_empty(&cpuctx->rotation_list))


Yeah, I guess that'll do, although I guess something like:

  pmu->task_ctx_nr == perf_sw_context

would be even better, since that would also work for TYPE_TRACEPOINT and
possibly any other swevent like things.
