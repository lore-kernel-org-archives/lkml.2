Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab1DPPxF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 11:53:05 -0400
Received: from smtp-out.google.com ([74.125.121.67]:9758 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab1DPPw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 11:52:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Luyq6L0UrSO5bSRLQXMSKsWLGaRBrD3/sRMF9O+dED1TooKdJj+p+XlrhyDu0LyoGt
         mBVCgzn/Yd+0BkdwHtTA==
MIME-Version: 1.0
In-Reply-To: <1302913676-14352-5-git-send-email-robert.richter@amd.com>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
	<1302913676-14352-5-git-send-email-robert.richter@amd.com>
Date: Sat, 16 Apr 2011 08:52:54 -0700
Message-ID: <BANLkTikg5mJNDTqNMRz3AtjfnAa6mLdtHw@mail.gmail.com>
Subject: Re: [PATCH 4/4] perf, x86: Fix event scheduler to solve complex
 scheduling problems
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3GFrAaa032052

On Fri, Apr 15, 2011 at 5:27 PM, Robert Richter <robert.richter@amd.com> wrote:
> The current x86 event scheduler fails to resolve scheduling problems
> of certain combinations of events and constraints. This happens esp.
> for events with complex constraints such as those of the AMD family
> 15h pmu. The scheduler does not find then an existing solution.
> Examples are:
>
>        event code      counter         failure         possible solution
>
> 1)      0x043           PMC[2:0]        0               1
>        0x02E           PMC[3,0]        3               0
>        0x003           PMC3            FAIL            3
>
I am not sure I understand this failure case. If I recall
the scheduler looks at the weight of each event first:

                                            weight
1)      0x043           PMC[2:0]  3
        0x02E           PMC[3,0]   2
        0x003           PMC3        1

Then, it schedules in increasing weight order. So it will
schedule weight 1, 2, 3. For weight 1, it will find counter3,
for weight 2, it will take counter0, for  weight 3, it will
take counter 1 given 0 is already used.

Or am I reading your example the wrong way?

The fact that counter have overlapping constraints
should not matter. In fact this is what happens with
counters without constraints.

> 2)      0x02E           PMC[3,0]        0               3
>        0x043           PMC[2:0]        1               0
>        0x045           PMC[2:0]        2               1
>        0x046           PMC[2:0]        FAIL            2
>
> Scheduling events on counters is a Hamiltonian path problem. To find a
> possible solution we must traverse all existing paths. This patch
> implements this.
>
> We need to save all states of already walked paths. If we fail to
> schedule an event we now rollback the previous state and try to use
> another free counter until we have analysed all paths.
>
> We might consider to later remove the constraint weight implementation
> completely, but I left this out as this is a much bigger and more
> risky change than this fix.
>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c |   48 +++++++++++++++++++++++++++++++------
>  1 files changed, 40 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 224a84f..887a500 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -770,11 +770,19 @@ static inline int is_x86_event(struct perf_event *event)
>        return event->pmu == &pmu;
>  }
>
> +struct sched_log
> +{
> +       int     i;
> +       int     w;
> +       int     idx;
> +};
> +
>  static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
>  {
>        struct event_constraint *c, *constraints[X86_PMC_IDX_MAX];
>        unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
> -       int i, j, w, wmax, num = 0;
> +       struct sched_log sched_log[X86_PMC_IDX_MAX];
> +       int i, idx, w, wmax, num = 0, scheduled = 0;
>        struct hw_perf_event *hwc;
>
>        bitmap_zero(used_mask, X86_PMC_IDX_MAX);
> @@ -815,6 +823,7 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
>         */
>
>        bitmap_zero(used_mask, X86_PMC_IDX_MAX);
> +       memset(&sched_log, 0, sizeof(sched_log));
>
>        /*
>         * weight = number of possible counters
> @@ -838,25 +847,48 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
>        for (w = 1, num = n; num && w <= wmax; w++) {
>                /* for each event */
>                for (i = 0; num && i < n; i++) {
> +               redo:
>                        c = constraints[i];
>                        hwc = &cpuc->event_list[i]->hw;
>
>                        if (c->weight != w)
>                                continue;
>
> -                       for_each_set_bit(j, c->idxmsk, X86_PMC_IDX_MAX) {
> -                               if (!test_bit(j, used_mask))
> +                       idx = sched_log[scheduled].idx;
> +                       /* for each bit in idxmsk starting from idx */
> +                       while (idx < X86_PMC_IDX_MAX) {
> +                               idx = find_next_bit(c->idxmsk, X86_PMC_IDX_MAX,
> +                                                   idx);
> +                               if (idx == X86_PMC_IDX_MAX)
> +                                       break;
> +                               if (!__test_and_set_bit(idx, used_mask))
>                                        break;
> +                               idx++;
>                        }
>
> -                       if (j == X86_PMC_IDX_MAX)
> -                               break;
> -
> -                       __set_bit(j, used_mask);
> +                       if (idx >= X86_PMC_IDX_MAX) {
> +                               /* roll back and try next free counter */
> +                               if (!scheduled)
> +                                       /* no free counters anymore */
> +                                       break;
> +                               sched_log[scheduled].idx = 0;
> +                               scheduled--;
> +                               num++;
> +                               clear_bit(sched_log[scheduled].idx, used_mask);
> +                               i = sched_log[scheduled].i;
> +                               w = sched_log[scheduled].w;
> +                               sched_log[scheduled].idx++;
> +                               goto redo;
> +                       }
>
>                        if (assign)
> -                               assign[i] = j;
> +                               assign[i] = idx;
> +
>                        num--;
> +                       sched_log[scheduled].i = i;
> +                       sched_log[scheduled].w = w;
> +                       sched_log[scheduled].idx = idx;
> +                       scheduled++;
>                }
>        }
>  done:
> --
> 1.7.3.4
>
>
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
