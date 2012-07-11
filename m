Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab2GKA6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:58:47 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48535 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362Ab2GKA6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:58:46 -0400
X-AuditID: 9c930197-b7b49ae0000027b8-06-4ffccfc02455
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, mingo@kernel.org, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/4] perf kvm: fix bug resolving guest kernel syms
References: <1341956894-69284-1-git-send-email-dsahern@gmail.com>
	<1341956894-69284-5-git-send-email-dsahern@gmail.com>
Date: Wed, 11 Jul 2012 09:54:10 +0900
In-Reply-To: <1341956894-69284-5-git-send-email-dsahern@gmail.com> (David
	Ahern's message of "Tue, 10 Jul 2012 15:48:14 -0600")
Message-ID: <874npf86dp.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David

On Tue, 10 Jul 2012 15:48:14 -0600, David Ahern wrote:
> Guest kernel symbols are not resolved despite passing the information
> needed to resolve them. e.g.,
>
> perf kvm --guest --guestmount=/tmp/guest-mount record -a -- sleep 1
> perf kvm --guest --guestmount=/tmp/guest-mount report --stdio
>
>     36.55%  [guest/11399]  [unknown]         [g] 0xffffffff81600bc8
>     33.19%  [guest/10474]  [unknown]         [g] 0x00000000c0116e00
>     30.26%  [guest/11094]  [unknown]         [g] 0xffffffff8100a288
>
>     43.69%  [guest/10474]  [unknown]         [g] 0x00000000c0103d90
>     37.38%  [guest/11399]  [unknown]         [g] 0xffffffff81600bc8
>     12.24%  [guest/11094]  [unknown]         [g] 0xffffffff810aa91d
>      6.69%  [guest/11094]  [unknown]         [u] 0x00007fa784d721c3
>
> which is just pathetic.
>
> After a maddening 2 days sifting through perf minutia I found it --
> id_hdr_size is not initialized for guest machines. This shows up on the
> report side as random garbage for the cpu and timestamp, e.g.,
>
> 29816 7310572949125804849 0x1ac0 [0x50]: PERF_RECORD_MMAP ...
>
> that messes up the sample sorting such that synthesized guest maps are
> processed last.
>
> With this patch you get a much more helpful report:
>
>   12.11%  [guest/11399]  [guest.kernel.kallsyms.11399]  [g] irqtime_account_process_tick
>   10.58%  [guest/11399]  [guest.kernel.kallsyms.11399]  [g] run_timer_softirq
>    6.95%  [guest/11094]  [guest.kernel.kallsyms.11094]  [g] printk_needs_cpu
>    6.50%  [guest/11094]  [guest.kernel.kallsyms.11094]  [g] do_timer
>    6.45%  [guest/11399]  [guest.kernel.kallsyms.11399]  [g] idle_balance
>    4.90%  [guest/11094]  [guest.kernel.kallsyms.11094]  [g] native_read_tsc
> ...
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>  tools/perf/util/map.c     |   24 ++++++++++++++++++++++++
>  tools/perf/util/map.h     |    1 +
>  tools/perf/util/session.c |    1 +
>  3 files changed, 26 insertions(+)
>
> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> index 641377e..da3411b 100644
> --- a/tools/perf/util/map.c
> +++ b/tools/perf/util/map.c
> @@ -730,3 +730,27 @@ char *machine__mmap_name(struct machine *self, char *bf, size_t size)
>  
>  	return bf;
>  }
> +
> +void machines__set_id_hdr_size(struct rb_root *self, u16 id_hdr_size)
> +{
> +	struct rb_node *p;
> +	struct machine *machine;
> +
> +    p = self->rb_node;
> +	while (p != NULL) {
> +		machine = rb_entry(p, struct machine, rb_node);
> +		machine->id_hdr_size = id_hdr_size;
> +        p = rb_next(p);
> +	}
> +

Looks like white-space damaged. :(

The loop itself looks fine, or you might use this form:

	for (p = rb_first(self); p; p = rb_next(p))


Is there a something like rb_for_each_entry() ?


> +    p = self->rb_node;
> +    if (p)
> +        p = rb_prev(p);
> +	while (p != NULL) {
> +		machine = rb_entry(p, struct machine, rb_node);
> +		machine->id_hdr_size = id_hdr_size;
> +        p = rb_prev(p);
> +	}
> +

I don't see why this second loop is necessary?

Thanks,
Namhyung


> +	return;
> +}
> diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
> index 81371ba..7159b3c 100644
> --- a/tools/perf/util/map.h
> +++ b/tools/perf/util/map.h
> @@ -151,6 +151,7 @@ struct machine *machines__add(struct rb_root *self, pid_t pid,
>  struct machine *machines__find_host(struct rb_root *self);
>  struct machine *machines__find(struct rb_root *self, pid_t pid);
>  struct machine *machines__findnew(struct rb_root *self, pid_t pid);
> +void machines__set_id_hdr_size(struct rb_root *self, u16 id_hdr_size);
>  char *machine__mmap_name(struct machine *self, char *bf, size_t size);
>  int machine__init(struct machine *self, const char *root_dir, pid_t pid);
>  void machine__exit(struct machine *self);
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 7c31623..fcf9498 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -86,6 +86,7 @@ void perf_session__update_sample_type(struct perf_session *self)
>  	self->sample_id_all = perf_evlist__sample_id_all(self->evlist);
>  	self->id_hdr_size = perf_evlist__id_hdr_size(self->evlist);
>  	self->host_machine.id_hdr_size = self->id_hdr_size;
> +    machines__set_id_hdr_size(&self->machines, self->id_hdr_size);
>  }
>  
>  int perf_session__create_kernel_maps(struct perf_session *self)
