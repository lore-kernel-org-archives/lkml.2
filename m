Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab1BQSTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:19:45 -0500
Received: from smtp-out.google.com ([74.125.121.67]:29002 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093Ab1BQSTm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:19:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w4REBF8s1lDcE4U8GV3uXwV1BP/TtYNHeHcrzZAEX63y5QxqvWf6H6KpHvO+UcxEwo
         7VG/9kAQONRRH4mJlvSw==
MIME-Version: 1.0
In-Reply-To: <20110217152313.GD10805@ghostprotocols.net>
References: <AANLkTi=mRvkO-0Lvf4OhnnAg6X0Z-RpeKpCD3JtANJZ8@mail.gmail.com>
	<20110217152313.GD10805@ghostprotocols.net>
Date: Thu, 17 Feb 2011 19:19:37 +0100
Message-ID: <AANLkTi=Cbx7PdwPnL4QR1+GA37BQ63X5Cs_bW70yAwZJ@mail.gmail.com>
Subject: Re: [BUG] perf: perf report -n shows bogus number of samples
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
        Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 4:23 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Em Wed, Feb 09, 2011 at 12:34:44AM +0100, Stephane Eranian escreveu:
>> I think the -n option of perf report shows bogus number of samples.
>>
>> I believe it does not print the number of samples but rather the
>> number of events if I understand the code in hist_entry__snprintf().
>> I think that's useless, the number of samples is more useful.
>
> <SNIP
>
>> $ perf record -e cycles ./repmov
>> $ perf report -D | fgrep RECORD_SAMPLE | wc -l
>> 86346
>> $ ./perf report -n
>> # Events: 86K cycles
>> #
>> # Overhead  Samples    Command      Shared Object                     Symbol
>> # ........ ..........  .......  .................  .........................
>> #
>>     98.92%238206388334   repmov  repmov             [.] main
>>      0.08%  189506224   repmov  [kernel.kallsyms]  [k] perf_ctx_adjust_freq
>>      0.06%  147582706   repmov  [kernel.kallsyms]  [k] perf_event_task_tick
>>
>> It should be easy to reproduce with any other program.
>
> Like this? Can I have your acked-by?
>
Yes. Works for me.

Acked-by: Stephane Eranian <eranian@google.com>

> commit 58e57f4dd6164bdbd5bc1f7d7c1ba5eb104e9b32
> Author: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date:   Thu Feb 17 10:37:23 2011 -0200
>
>    perf hists: Print number of samples, not the period sum
>
>    So that we match the header where we state the number of events with the
>    "Samples" column when using 'perf report -n/--show-nr-samples':
>
>     [root@emilia ~]# perf record -a sleep 1
>     [ perf record: Woken up 1 times to write data ]
>     [ perf record: Captured and wrote 0.111 MB perf.data (~4860 samples) ]
>     [root@emilia ~]# perf report --stdio --show-nr-samples
>     # Events: 11  cycles
>     #
>     # Overhead  Samples        Command       Shared Object                        Symbol
>     # ........ ..........  ...........  ..................  ............................
>     #
>         16.65%          1        sleep  [kernel.kallsyms]   [k] unmap_vmas
>         16.10%          1         perf  libpthread-2.12.so  [.] __pthread_cleanup_push_defer
>         15.79%          2         perf  [kernel.kallsyms]   [k] format_decode
>         12.88%          1  kworker/1:2  [kernel.kallsyms]   [k] cache_reap
>         10.69%          1      swapper  [kernel.kallsyms]   [k] _raw_spin_lock
>          7.55%          1        sleep  [kernel.kallsyms]   [k] prepare_exec_creds
>          6.00%          1         perf  [jbd2]              [k] start_this_handle
>          5.29%          1         perf  [kernel.kallsyms]   [k] seq_read
>          4.75%          1         perf  [kernel.kallsyms]   [k] get_pid_task
>          4.30%          1         perf  [kernel.kallsyms]   [k] _raw_spin_unlock_irqrestore
>
>     #
>     # (For a higher level overview, try: perf report --sort comm,dso)
>     #
>     [root@emilia ~]#
>
>    Reported-by: Stephane Eranian <eranian@google.com>
>    Cc: Frederic Weisbecker <fweisbec@gmail.com>
>    Cc: Ingo Molnar <mingo@elte.hu>
>    Cc: Mike Galbraith <efault@gmx.de>
>    Cc: Paul Mackerras <paulus@samba.org>
>    Cc: Peter Zijlstra <peterz@infradead.org>
>    Cc: Stephane Eranian <eranian@google.com>
>    Cc: Tom Zanussi <tzanussi@gmail.com>
>    LKML-Reference: <new-submission>
>    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 3f43723..da2899e 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -591,6 +591,7 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
>  {
>        struct sort_entry *se;
>        u64 period, total, period_sys, period_us, period_guest_sys, period_guest_us;
> +       u64 nr_events;
>        const char *sep = symbol_conf.field_sep;
>        int ret;
>
> @@ -599,6 +600,7 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
>
>        if (pair_hists) {
>                period = self->pair ? self->pair->period : 0;
> +               nr_events = self->pair ? self->pair->nr_events : 0;
>                total = pair_hists->stats.total_period;
>                period_sys = self->pair ? self->pair->period_sys : 0;
>                period_us = self->pair ? self->pair->period_us : 0;
> @@ -606,6 +608,7 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
>                period_guest_us = self->pair ? self->pair->period_guest_us : 0;
>        } else {
>                period = self->period;
> +               nr_events = self->nr_events;
>                total = session_total;
>                period_sys = self->period_sys;
>                period_us = self->period_us;
> @@ -646,9 +649,9 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
>
>        if (symbol_conf.show_nr_samples) {
>                if (sep)
> -                       ret += snprintf(s + ret, size - ret, "%c%" PRIu64, *sep, period);
> +                       ret += snprintf(s + ret, size - ret, "%c%" PRIu64, *sep, nr_events);
>                else
> -                       ret += snprintf(s + ret, size - ret, "%11" PRIu64, period);
> +                       ret += snprintf(s + ret, size - ret, "%11" PRIu64, nr_events);
>        }
>
>        if (pair_hists) {
>
