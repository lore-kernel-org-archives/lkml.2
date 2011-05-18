Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1ERVRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:17:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47692 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1ERVRA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:17:00 -0400
Subject: Re: [PATCH v2] perf, x86: Fix event scheduler for constraints with
 overlapping counters
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110419102600.GU31407@erda.amd.com>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
	 <1302913676-14352-5-git-send-email-robert.richter@amd.com>
	 <20110419102600.GU31407@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 18 May 2011 23:16:38 +0200
Message-ID: <1305753398.2466.7180.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I'm mostly ok with this, just a few nits..

On Tue, 2011-04-19 at 12:26 +0200, Robert Richter wrote:
> @@ -838,25 +877,61 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
>         for (w = 1, num = n; num && w <= wmax; w++) {
>                 /* for each event */
>                 for (i = 0; num && i < n; i++) {
> +                       idx = 0;
> +               redo:

labels go on column 0.

>                         c = constraints[i];
>                         hwc = &cpuc->event_list[i]->hw;
>  
>                         if (c->weight != w)
>                                 continue;
>  
> -                       for_each_set_bit(j, c->idxmsk, X86_PMC_IDX_MAX) {
> -                               if (!test_bit(j, used_mask))
> +                       /* for each bit in idxmsk starting from idx */
> +                       while (idx < X86_PMC_IDX_MAX) {
> +                               idx = find_next_bit(c->idxmsk, X86_PMC_IDX_MAX,
> +                                                   idx);

I'd be mighty tempted to ignore that 80 column rule here ;-)

> +                               if (idx == X86_PMC_IDX_MAX)
>                                         break;
> +                               if (!__test_and_set_bit(idx, used_mask))
> +                                       break;
> +                               idx++;
>                         }
>  
> -                       if (j == X86_PMC_IDX_MAX)
> -                               break;
> -
> -                       __set_bit(j, used_mask);
> +                       if (idx >= X86_PMC_IDX_MAX) {
> +                               /*
> +                                * roll back and try to reschedule
> +                                * events on other counters
> +                                */
> +                               if (!state)
> +                                       /* no events to reschedule */
> +                                       goto done;

Multi line indents get { } even if not strictly needed, alternatively we
can place the comment on the same line as the goto.

> +                               state--;
> +                               /* restore previous state: */
> +                               i = sched_state[state].i;
> +                               w = sched_state[state].w;
> +                               idx = sched_state[state].idx;
> +                               num = sched_state[state].num;
> +                               bitmap_copy(used_mask, sched_state[state].used, n);
> +                               /* try next counter: */
> +                               clear_bit(idx, used_mask);
> +                               num++;

Suppose we put the num--; bit below the if (c->redo) block, then we can
remove this num++;, right?

> +                               idx++;
> +                               goto redo;
> +                       }
>  
>                         if (assign)
> -                               assign[i] = j;
> +                               assign[i] = idx;
> +
>                         num--;
> +
> +                       if (c->redo && state < SCHED_STATES_MAX) {
> +                               /* store scheduler state: */
> +                               sched_state[state].i = i;
> +                               sched_state[state].w = w;
> +                               sched_state[state].idx = idx;
> +                               sched_state[state].num = num;
> +                               bitmap_copy(sched_state[state].used, used_mask, n);
> +                               state++;
> +                       }
>                 }
>         } 
