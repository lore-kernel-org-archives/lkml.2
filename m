Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab2FYInP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 04:43:15 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47710 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab2FYInN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 04:43:13 -0400
X-AuditID: 9c93016f-b7cbdae0000024ac-9b-4fe8249f86ca
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, psuriset@linux.vnet.ibm.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] perf kvm: fix segfault with default guest arguments
References: <1340599286-89757-1-git-send-email-dsahern@gmail.com>
Date: Mon, 25 Jun 2012 17:39:22 +0900
In-Reply-To: <1340599286-89757-1-git-send-email-dsahern@gmail.com> (David
	Ahern's message of "Sun, 24 Jun 2012 22:41:26 -0600")
Message-ID: <877guvwzt1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David

On Sun, 24 Jun 2012 22:41:26 -0600, David Ahern wrote:
> (This time with actual backtrace; forgot to remove the leading '#' on the frames.)
>
> File generated with:
> $ perf kvm --host --guest --guestkallsyms=/tmp/guest-kallsyms
>     --guestmodules=/tmp/guest-modules record -a
>
> The report command:
> $ perf kvm --host --guest --guestkallsyms=/tmp/guest-kallsyms
>     --guestmodules=/tmp/guest-modules report
>
> dies with a SEGFAULT:
> Program received signal SIGSEGV, Segmentation fault.
> 0x000000000046dd7b in machine__mmap_name (self=0x0, bf=0x7fffffffbd20 "q\021", size=4096) at util/map.c:715
> 715			snprintf(bf, size, "[%s.%d]", "guest.kernel.kallsyms", self->pid);
>
> (gdb) bt
> 0  0x000000000046dd7b in machine__mmap_name (self=0x0, bf=0x7fffffffbd20 "q\021", size=4096) at util/map.c:715
> 1  0x0000000000444161 in perf_event__process_kernel_mmap (tool=0x7fffffffdd80, event=0x7ffff7fb4120, machine=0x0) at util/event.c:562
> 2  0x0000000000444642 in perf_event__process_mmap (tool=0x7fffffffdd80, event=0x7ffff7fb4120, sample=0x7fffffffd210, machine=0x0)
>     at util/event.c:668
> 3  0x0000000000470e0b in perf_session_deliver_event (session=0x915ca0, event=0x7ffff7fb4120, sample=0x7fffffffd210, tool=0x7fffffffdd80,
>     file_offset=8480) at util/session.c:979
> 4  0x000000000047032e in flush_sample_queue (s=0x915ca0, tool=0x7fffffffdd80) at util/session.c:679
> 5  0x0000000000471c8d in __perf_session__process_events (session=0x915ca0, data_offset=400, data_size=150448, file_size=150848, tool=
>     0x7fffffffdd80) at util/session.c:1363
> 6  0x0000000000471d42 in perf_session__process_events (self=0x915ca0, tool=0x7fffffffdd80) at util/session.c:1379
> 7  0x000000000042484a in __cmd_report (rep=0x7fffffffdd80) at builtin-report.c:368
> 8  0x0000000000425bf1 in cmd_report (argc=0, argv=0x915b00, prefix=0x0) at builtin-report.c:756
> 9  0x0000000000438505 in __cmd_report (argc=4, argv=0x7fffffffe260) at builtin-kvm.c:84
> 10 0x000000000043882a in cmd_kvm (argc=4, argv=0x7fffffffe260, prefix=0x0) at builtin-kvm.c:131
> 11 0x00000000004152cd in run_builtin (p=0x7a54e8, argc=9, argv=0x7fffffffe260) at perf.c:273
> 12 0x00000000004154c7 in handle_internal_command (argc=9, argv=0x7fffffffe260) at perf.c:345
> 13 0x0000000000415613 in run_argv (argcp=0x7fffffffe14c, argv=0x7fffffffe140) at perf.c:389
> 14 0x0000000000415899 in main (argc=9, argv=0x7fffffffe260) at perf.c:487
>
> If no samples hit within a guest module then no build id events are written
> to the header during the record. On the report side this cases no 'machine'
> to be generated for the default guest (pid == 0) leading to a
> machine == NULL in perf_session_deliver_event.
>
> perf's handling of default kallsyms and guest-modules needs to be reworked.
> Until then perf should at least not segfault.
>
> Reported-by: Pradeep Kumar Surisetty <psuriset@linux.vnet.ibm.com>
> CC: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: David Ahern <dsahern@gmail.com>
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/util/session.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index c3e399b..3999d5e 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -976,6 +976,8 @@ static int perf_session_deliver_event(struct perf_session *session,
>  		}
>  		return tool->sample(tool, event, sample, evsel, machine);
>  	case PERF_RECORD_MMAP:
> +		if (machine == NULL)
> +			return 0;
>  		return tool->mmap(tool, event, sample, machine);
>  	case PERF_RECORD_COMM:
>  		return tool->comm(tool, event, sample, machine);

I don't know about the kvm, but isn't there a possibility that the same
thing happends on other types of event too - i.e. comm, fork, exit..?

Thanks,
Namhyung
