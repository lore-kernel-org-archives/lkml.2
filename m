Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab0LIDuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 22:50:23 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:49305 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab0LIDuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 22:50:22 -0500
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 9/9] pref: session: Break event ordering when timestamps are missing
From: Ian Munsie <imunsie@au1.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
In-reply-to: <20101207124551.209741779@linutronix.de>
References: <20101207124527.868085529@linutronix.de> <20101207124551.209741779@linutronix.de>
Date: Thu, 09 Dec 2010 14:50:14 +1100
Message-Id: <1291865671-sup-8975@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Thomas Gleixner's message of Tue Dec 07 12:49:04 UTC 2010:
> Allow the session client to specify that event ordering should be
> stopped when not all events have time stamps.

>  	/* These events are processed right away */
>  	switch (event->header.type) {
>  	case PERF_RECORD_HEADER_ATTR:
> -		return ops->attr(event, session);
> +		/* This updates session->sample_id_all */
> +		ret = ops->attr(event, session);
> +		/* Break ordering if sample_id_all is false */
> +		if (ops->ordering_requires_timestamps &&
> +		    ops->ordered_samples && !session->sample_id_all) {
> +			session->ordered_samples.next_flush = ULLONG_MAX;
> +			flush_sample_queue(session, ops);
> +			ops->ordered_samples = false;
> +		}
> +		return ret;

This fallback still relies on receiving a PERF_RECORD_HEADER_ATTR, which
will only happen if the output is being piped:

$ git grep event__synthesize_attr
builtin-record.c:               err = event__synthesize_attrs(&session->header,
util/header.c:int event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
util/header.c:int event__synthesize_attrs(struct perf_header *self, event__handler_t process,
util/header.c:          err = event__synthesize_attr(&attr->attr, attr->ids, attr->id,
util/header.h:int event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
util/header.h:int event__synthesize_attrs(struct perf_header *self,

$ less builtin-record.c
<SNIP>
	if (pipe_output) {
		err = event__synthesize_attrs(&session->header,
					      process_synthesized_event,
					      session);
<SNIP>

So this will work in this situation (timestamps on samples, but this is
an old kernel so not on other events):

delenn% ./perf record -T -o - ~/tests/cachetest | ./perf report -i -
Initialising array...
Trying approach 1: 0x18fff7eb26fd058
Trying approach 2: 0x18fff7eb26fd058
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.081 MB - (~3549 samples) ]
# Events: 1K cycles
#
# Overhead  Command      Shared Object                   Symbol
# ........  .......  .................  .......................
#
    70.23%  cachetest  cachetest          [.] sumArrayNaive
    28.54%  cachetest  cachetest          [.] sumArrayOptimal
     0.43%  cachetest  [kernel.kallsyms]  [k] insert_work
     0.39%  cachetest  [kernel.kallsyms]  [k] machine_kexec_prepare
     0.35%  cachetest  libc-2.11.2.so     [.] __random
     0.06%  cachetest  [kernel.kallsyms]  [k] print_cfs_rq
     0.01%  cachetest  [kernel.kallsyms]  [k] __register_sysctl_paths


#
# (For a higher level overview, try: perf report --sort comm,dso)
#


But will fail in this case:

delenn% ./perf record -T ~/tests/cachetest                                       ~/linus/tools/perf
Initialising array...
Trying approach 1: 0x18fff7eb26fd058
Trying approach 2: 0x18fff7eb26fd058
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.081 MB perf.data (~3543 samples) ]

delenn% ./perf report|cat                                                        ~/linus/tools/perf
# Events: 1K cycles
#
# Overhead  Command      Shared Object                   Symbol
# ........  .......  .................  .......................
#
    99.47%    :5593  [unknown]          [.] 0xf770cff5
     0.48%    :5593  [kernel.kallsyms]  [k] hpet_next_event
     0.05%    :5593  [libahci]          [k] ahci_scr_read
     0.01%    :5593  [kernel.kallsyms]  [k] flush_signal_handlers
     0.00%    :5593  [kernel.kallsyms]  [k] native_write_msr_safe


#
# (For a higher level overview, try: perf report --sort comm,dso)
#

Since the fall back isn't triggered, not only are COMM and MMAP events
processed first (from patch 2 in this series), but EXIT will as well,
which causes no userspace events to be attributed.

Cheers,
-Ian
