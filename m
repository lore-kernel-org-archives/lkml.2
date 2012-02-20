Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab2BTXrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 18:47:47 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56395 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab2BTXrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 18:47:45 -0500
Message-ID: <4F42DB8D.7060900@gmail.com>
Date: Mon, 20 Feb 2012 16:47:25 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: perf: kvm events analysis tool
References: <4F338CAA.10807@linux.vnet.ibm.com> <4F338D56.6010505@linux.vnet.ibm.com>
In-Reply-To: <4F338D56.6010505@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally got back to this. Overall nicely written command. Few comments 
and one for Arnaldo at the bottom.

On 2/9/12 2:09 AM, Xiao Guangrong wrote:
> Add 'perf kvm-events' support to analyze kvm vmexit/mmio/ioport smartly
>
> Usage:
>
> - trace kvm events:
> 	perf kvm-events record, or, if other tracepoints are also
> 	interesting, we can append the events like this:
> 	perf kvm-events record -e timer:*
>
> - show the result:
> 	perf kvm-events report

It would be nice to have example reports in this commit message.

>
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@linux.vnet.ibm.com>
> ---
>   tools/perf/Documentation/perf-kvm-events.txt |   52 ++
>   tools/perf/Makefile                          |    1 +
>   tools/perf/builtin-kvm-events.c              |  851 ++++++++++++++++++++++++++
>   tools/perf/builtin.h                         |    1 +
>   tools/perf/command-list.txt                  |    1 +
>   tools/perf/perf.c                            |    1 +
>   tools/perf/util/header.c                     |   54 ++-
>   tools/perf/util/header.h                     |    1 +
>   tools/perf/util/thread.h                     |    2 +
>   9 files changed, 963 insertions(+), 1 deletions(-)
>   create mode 100644 tools/perf/Documentation/perf-kvm-events.txt
>   create mode 100644 tools/perf/builtin-kvm-events.c
>
> diff --git a/tools/perf/Documentation/perf-kvm-events.txt b/tools/perf/Documentation/perf-kvm-events.txt
> new file mode 100644
> index 0000000..ed36550
> --- /dev/null
> +++ b/tools/perf/Documentation/perf-kvm-events.txt
> @@ -0,0 +1,52 @@
> +perf-kvm-events(1)
> +============
> +
> +NAME
> +----
> +perf-kvm-events - Analyze kvm events
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'perf kvm-events' {record|report}
> +
> +DESCRIPTION
> +-----------
> +You can analyze some crucial kvm events and statistics with this
> +'perf kvm-events' command. Currently, vmexit, mmio and ioport events
> +are supported.
First sentence should be written in the 3rd person. eg.,
This command generates a statistical analysis of KVM events.

>
> +
> +  'perf kvm-events record<command>' records kvm events(vmexit,
> +  mmio and ioport) and the events between start and end<command>.
> +  And this command produces the file "perf.data" which contains
> +  tracing results of kvm events.
> +
> +  'perf kvm-events report' reports statistical data which includes
> +  events handled time, samples, and so on.
> +
> +COMMON OPTIONS
> +--------------
> +
> +-i::
> +--input=<file>::
> +        Input file name. (default: perf.data unless stdin is a fifo)
> +
> +-D::
> +--dump-raw-trace::
> +        Dump raw trace in ASCII.
> +
> +REPORT OPTIONS
> +--------------
> +--vcpu=<value>::
> +	analyze events which occures on this vcpu
> +
> +--events=<value>::
> +	events to be analyzed. Possible values: vmexit, mmio, ioport.

Add a comment stating which event type is the default.

>
> +-k::
> +--key=<value>::
> +        Sorting key. Possible values: sample(default, sort by samples number),
> +time(sort by average time).
Space before both of the '('.

>
> +
> +SEE ALSO
> +--------
> +linkperf:perf[1]
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index ac86d67..ee43451 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -382,6 +382,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-probe.o
>   BUILTIN_OBJS += $(OUTPUT)builtin-kmem.o
>   BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
>   BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
> +BUILTIN_OBJS += $(OUTPUT)builtin-kvm-events.o
>   BUILTIN_OBJS += $(OUTPUT)builtin-test.o
>   BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
>
> diff --git a/tools/perf/builtin-kvm-events.c b/tools/perf/builtin-kvm-events.c
> new file mode 100644
> index 0000000..9903d2b
> --- /dev/null
> +++ b/tools/perf/builtin-kvm-events.c
> @@ -0,0 +1,851 @@
> +#include "builtin.h"
> +#include "perf.h"
> +#include "util/util.h"
> +#include "util/cache.h"
> +#include "util/symbol.h"
> +#include "util/thread.h"
> +#include "util/header.h"
> +#include "util/parse-options.h"
> +#include "util/trace-event.h"
> +#include "util/debug.h"
> +#include "util/debugfs.h"
> +#include "util/session.h"
> +#include "util/tool.h"
> +
> +#include<math.h>
> +
> +#include<linux/kvm.h>
> +
> +#include "../../arch/x86/include/asm/svm.h"
> +#include "../../arch/x86/include/asm/vmx.h"
> +#include "../../arch/x86/include/asm/kvm_host.h"
> +
> +struct event_key {
> +	#define INVALID_KEY	(~0ULL)
> +	u64 key;
> +	int info;
> +};
> +
> +struct kvm_events_ops {
> +	bool (*is_begin_event)(struct event *event, void *data,
> +			       struct event_key *key);
> +	bool (*is_end_event)(struct event *event, void *data,
> +			     struct event_key *key);
> +	void (*decode_key)(struct event_key *key, char decode[20]);
> +	const char *name;
> +};
> +
> +static int cpu_isa;
> +
> +static void exit_event_get_key(struct event *event, void *data,
> +			       struct event_key *key)
> +{
> +	key->info = cpu_isa;
> +	key->key = raw_field_value(event, "exit_reason", data);
> +}
> +
> +static bool kvm_exit_event(struct event *event)
> +{
> +	return !strcmp(event->name, "kvm_exit");
> +}
> +
> +static bool exit_event_begin(struct event *event, void *data,
> +			     struct event_key *key)
> +{
> +	if (kvm_exit_event(event)) {
> +		exit_event_get_key(event, data, key);
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static bool kvm_entry_event(struct event *event)
> +{
> +	return !strcmp(event->name, "kvm_entry");
> +}
> +
> +static bool exit_event_end(struct event *event, void *data __unused,
> +			   struct event_key *key __unused)
> +{
> +	return kvm_entry_event(event);
> +}
> +
> +struct exit_reasons_table {
> +	unsigned long exit_code;
> +	const char *reason;
> +};
> +
> +struct exit_reasons_table vmx_exit_reasons[] = {
> +	VMX_EXIT_REASONS
> +};
> +
> +struct exit_reasons_table svm_exit_reasons[] = {
> +	SVM_EXIT_REASONS
> +};
> +
> +static const char *get_exit_reason(u64 exit_code, int isa)
> +{
> +	int table_size = ARRAY_SIZE(svm_exit_reasons);
> +	struct exit_reasons_table *table = svm_exit_reasons;
> +
> +	if (isa == 1) {
> +		table = vmx_exit_reasons;
> +		table_size = ARRAY_SIZE(vmx_exit_reasons);
> +	}
Why not use globals that are set once in read_events() after looking up 
cpu_isa? Then you don't have to state a preference on default init here 
-- AMD or Intel. And the isa argument will not be needed here.

> +
> +	while (table_size--) {
> +		if (table->exit_code == exit_code)
> +			return table->reason;
> +		table++;
> +	}
> +
> +	die("unknown kvm exit code:%ld on %s\n", exit_code,
> +						isa ? "VMX" : "SVM");
> +}
> +
> +static void exit_event_decode_key(struct event_key *key, char decode[20])
> +{
> +	const char *exit_reason = get_exit_reason(key->key, key->info);
> +
> +	snprintf(decode, 20, "%s", exit_reason);
> +}
> +
> +static struct kvm_events_ops exit_events = {
> +	.is_begin_event = exit_event_begin,
> +	.is_end_event = exit_event_end,
> +	.decode_key = exit_event_decode_key,
> +	.name = "VM-EXIT"
> +};
> +
> +/*
> + * For the old kernel, we treat:
> + * the time of MMIO write: kvm_mmio(KVM_TRACE_MMIO_WRITE...) ->  kvm_entry
> + * the time of MMIO read: kvm_exit ->  kvm_mmio(KVM_TRACE_MMIO_READ...).
> + *
> + * For the new kernel, we use kvm_mmio_begin and kvm_mmio_done to make
> + * things better.
> + */
> +static void mmio_event_get_key(struct event *event, void *data,
> +			       struct event_key *key)
> +{
> +	key->key = raw_field_value(event, "gpa", data);
> +	key->info = raw_field_value(event, "type", data);
> +}
> +
> +#define KVM_TRACE_MMIO_READ_UNSATISFIED 0
> +#define KVM_TRACE_MMIO_READ 1
> +#define KVM_TRACE_MMIO_WRITE 2
> +
> +static bool kvm_mmio_done_event(struct event *event)
> +{
> +	return !strcmp(event->name, "kvm_mmio_done");
> +}
> +
> +static bool mmio_event_begin(struct event *event, void *data,
> +			     struct event_key *key)
> +{
> +	/* MMIO read begin in old kernel. */
> +	if (kvm_exit_event(event))
> +		return true;
> +
> +	/* MMIO write begin in old kernel. */
> +	if (!strcmp(event->name, "kvm_mmio")&&
> +	      raw_field_value(event, "type", data) == KVM_TRACE_MMIO_WRITE) {
> +		mmio_event_get_key(event, data, key);
> +		return true;
> +	}
> +
> +	/* MMIO read/write begin in new kernel. */
> +	if (!strcmp(event->name, "kvm_mmio_begin")) {
> +		mmio_event_get_key(event, data, key);
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static bool mmio_event_end(struct event *event,  void *data,
> +			   struct event_key *key)
> +{
> +	/* MMIO write end in old kernel. */
> +	if (kvm_entry_event(event))
> +		return true;
> +
> +	/* MMIO read end in the old kernel.*/
> +	if (!strcmp(event->name, "kvm_mmio")&&
> +	      raw_field_value(event, "type", data) == KVM_TRACE_MMIO_READ) {
> +		mmio_event_get_key(event, data, key);
> +		return true;
> +	}
> +
> +	/* MMIO read/write end event in the new kernel.*/
> +	return kvm_mmio_done_event(event);
> +}
> +
> +static void mmio_event_decode_key(struct event_key *key, char decode[20])
> +{
> +	snprintf(decode, 20, "%#lx:%s", key->key,
> +			      key->info == KVM_TRACE_MMIO_WRITE ? "W" : "R");
> +}
> +
> +static struct kvm_events_ops mmio_events = {
> +	.is_begin_event = mmio_event_begin,
> +	.is_end_event = mmio_event_end,
> +	.decode_key = mmio_event_decode_key,
> +	.name = "MMIO Access"
> +};
> +
> +/*
> + * For the old kernel, the time of emulation pio access is from kvm_pio to
> + * kvm_entry. In the new kernel, the end time is indicated by kvm_mmio_done.
> + */
> +static void ioport_event_get_key(struct event *event, void *data,
> +				 struct event_key *key)
> +{
> +	key->key = raw_field_value(event, "port", data);
> +	key->info = raw_field_value(event, "rw", data);
> +}
> +
> +static bool ioport_event_begin(struct event *event, void *data,
> +			       struct event_key *key)
> +{
> +	if (!strcmp(event->name, "kvm_pio")) {
> +		ioport_event_get_key(event, data, key);
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static bool ioport_event_end(struct event *event, void *data __unused,
> +			     struct event_key *key __unused)
> +{
> +	if (kvm_entry_event(event))
> +		return true;
> +
> +	return kvm_mmio_done_event(event);
> +}
> +
> +static void ioport_event_decode_key(struct event_key *key, char decode[20])
> +{
> +	snprintf(decode, 20, "%#lx:%s", key->key, key->info ? "POUT" : "PIN");
> +}
> +
> +static struct kvm_events_ops ioport_events = {
> +	.is_begin_event = ioport_event_begin,
> +	.is_end_event = ioport_event_end,
> +	.decode_key = ioport_event_decode_key,
> +	.name = "IO Port Access"
> +};
> +
> +static const char *report_event = "vmexit";
> +struct kvm_events_ops *events_ops;
> +
> +static void register_kvm_events_ops(void)
> +{
> +	if (!strcmp(report_event, "vmexit"))
> +		events_ops =&exit_events;
> +	else if (!strcmp(report_event, "mmio"))
> +		events_ops =&mmio_events;
> +	else if (!strcmp(report_event, "ioport"))
> +		events_ops =&ioport_events;
> +	else
> +		die("Unknown report event:%s\n", report_event);
> +}
> +
> +struct event_stats {
> +	u64 count;
> +	u64 time;
> +
> +	/* used to calculate stddev. */
> +	double mean;
> +	double M2;
> +};
> +
> +struct kvm_event {
> +	struct list_head hash_entry;
> +	struct rb_node rb;
> +
> +	struct event_key key;
> +
> +	struct event_stats total;
> +
> +	#define DEFAULT_VCPU_NUM 32
Why 32 for the default number of vcpus in a guest? Seems like a lot for 
the typical VM. Versus something like 4 or 8.
>
> +	int max_vcpu;
> +	struct event_stats *vcpu;
> +};
> +
> +struct vcpu_event_record {
> +	int vcpu_id;
> +	u64 start_time;
> +	struct kvm_event *last_event;
> +};
> +
> +#define EVENTS_BITS			12
> +#define EVENTS_CACHE_SIZE	(1UL<<  EVENTS_BITS)
> +
> +static u64 total_time;
> +static u64 total_count;
> +static struct list_head kvm_events_cache[EVENTS_CACHE_SIZE];
> +
> +static void init_kvm_event_record(void)
> +{
> +	int i;
> +
> +	for (i = 0; i<  (int)EVENTS_CACHE_SIZE; i++)
> +		INIT_LIST_HEAD(&kvm_events_cache[i]);
> +}
> +
> +static int kvm_events_hash_fn(u64 key)
> +{
> +	return key&  (EVENTS_CACHE_SIZE - 1);
> +}
> +
> +static void kvm_event_expand(struct kvm_event *event, int vcpu_id)
> +{
> +	int old_max_vcpu = event->max_vcpu;
> +
> +	if (vcpu_id<  event->max_vcpu)
> +		return;
> +
> +	while (event->max_vcpu<= vcpu_id)
> +		event->max_vcpu += DEFAULT_VCPU_NUM;
> +
> +	event->vcpu = realloc(event->vcpu,
> +			      event->max_vcpu * sizeof(*event->vcpu));
> +	if (!event->vcpu)
> +		die("Not enough memory\n");
> +
> +	memset(event->vcpu + old_max_vcpu, 0,
> +	       (event->max_vcpu - old_max_vcpu) * sizeof(*event->vcpu));
> +}
> +
> +static struct kvm_event *kvm_alloc_init_event(struct event_key *key)
> +{
> +	struct kvm_event *event;
> +
> +	event = zalloc(sizeof(*event));
> +	if (!event)
> +		die("Not enough memory\n");
> +
> +	event->key = *key;
> +	return event;
> +}
> +
> +static struct kvm_event *find_create_kvm_event(struct event_key *key)
> +{
> +	struct kvm_event *event;
> +	struct list_head *head;
> +
> +	BUG_ON(key->key == INVALID_KEY);
> +
> +	head =&kvm_events_cache[kvm_events_hash_fn(key->key)];
> +	list_for_each_entry(event, head, hash_entry)
> +		if (event->key.key == key->key&&  event->key.info == key->info)
> +			return event;
> +
> +	event = kvm_alloc_init_event(key);
> +	list_add(&event->hash_entry, head);
> +	return event;
> +}
> +
> +static void handle_begin_event(struct vcpu_event_record *vcpu_record,
> +			       struct event_key *key, u64 timestamp)
> +{
> +	struct kvm_event *event = NULL;
> +
> +	if (key->key != INVALID_KEY)
> +		event = find_create_kvm_event(key);
> +
> +	vcpu_record->last_event = event;
> +	vcpu_record->start_time = timestamp;
> +}
> +
> +static void update_event_stats(struct event_stats *stats, u64 time_diff)
> +{
> +	double delta;
> +
> +	stats->count++;
> +	stats->time += time_diff;
> +
> +	delta = time_diff - stats->mean;
> +	stats->mean += delta / stats->count;
> +	stats->M2 += delta*(time_diff - stats->mean);
> +}
> +
> +static double event_stats_stddev(int vcpu_id, struct kvm_event *event)
> +{
> +	struct event_stats *stats =&event->total;
> +	double variance, variance_mean, stddev;
> +
> +	if (vcpu_id != -1)
> +		stats =&event->vcpu[vcpu_id];
> +
> +	BUG_ON(!stats->count);
> +
> +	variance = stats->M2 / (stats->count - 1);
> +	variance_mean = variance / stats->count;
> +	stddev = sqrt(variance_mean);
> +
> +	return stddev * 100 / stats->mean;
> +}
> +
> +static void update_kvm_event(struct kvm_event *event, int vcpu_id,
> +			     u64 time_diff)
> +{
> +	update_event_stats(&event->total, time_diff);
> +	kvm_event_expand(event, vcpu_id);
> +	update_event_stats(&event->vcpu[vcpu_id], time_diff);
> +}
> +
> +static void handle_end_event(struct vcpu_event_record *vcpu_record,
> +			     struct event_key *key, u64 timestamp)
> +{
> +	struct kvm_event *event;
> +	u64 time_begin, time_diff;
> +
> +	event = vcpu_record->last_event;
> +	time_begin = vcpu_record->start_time;
> +
> +	/* The begin event is not caught. */
> +	if (!time_begin)
> +		return;
> +
> +	/* Both begin and end events did not get the key. */
> +	if (!event&&  key->key == INVALID_KEY)
> +		return;
> +
Should not be able to get here with event unset, so the next 2 lines 
should not be needed. ie., you only want to process events where the 
begin event was seen in which case event is defined.
> +	if (!event)
> +		event = find_create_kvm_event(key);
> +
> +	vcpu_record->last_event = NULL;
> +	vcpu_record->start_time = 0;
> +
> +	BUG_ON(timestamp<  time_begin);
> +
> +	time_diff = timestamp - time_begin;
> +	update_kvm_event(event, vcpu_record->vcpu_id, time_diff);
> +}
> +
> +static struct vcpu_event_record
> +*per_vcpu_record(struct thread *thread, struct event *event, void *data)
> +{
> +	/* Only kvm_entry records vcpu id. */
> +	if (!thread->private&&  kvm_entry_event(event)) {
> +		struct vcpu_event_record *vcpu_record;
> +
> +		vcpu_record = zalloc(sizeof(struct vcpu_event_record));
> +		if (!vcpu_record)
> +			die("Not enough memory\n");
> +
> +		vcpu_record->vcpu_id = raw_field_value(event, "vcpu_id", data);
> +		thread->private = vcpu_record;
> +	}
> +
> +	return (struct vcpu_event_record *)thread->private;
> +}
> +
> +static void handle_kvm_event(struct thread *thread, struct event *event,
> +			     void *data, u64 timestamp)
> +{
> +	struct vcpu_event_record *vcpu_record;
> +	struct event_key key = {.key = INVALID_KEY};
> +
> +	vcpu_record = per_vcpu_record(thread, event, data);
> +	if (!vcpu_record)
> +		return;
> +
> +	if (events_ops->is_begin_event(event, data,&key))
> +		return handle_begin_event(vcpu_record,&key, timestamp);
> +
> +	if (events_ops->is_end_event(event, data,&key))
> +		return handle_end_event(vcpu_record,&key, timestamp);
> +}
> +
> +typedef int (*key_cmp_fun)(struct kvm_event*, struct kvm_event*, int);
> +struct kvm_event_key {
> +	const char *name;
> +	key_cmp_fun key;
> +};
> +
> +static int trace_vcpu = -1;
> +#define GET_EVENT_KEY(member)						\
> +static u64 get_event_ ##member(struct kvm_event *event, int vcpu)	\
> +{									\
> +	if (vcpu == -1)							\
> +		return event->total.member;				\
> +									\
> +	if (vcpu>= event->max_vcpu)					\
> +		return 0;						\
> +									\
> +	return event->vcpu[vcpu].member;				\
> +}
> +
> +#define COMPARE_EVENT_KEY(member)					\
> +GET_EVENT_KEY(member)							\
> +static int compare_kvm_event_ ## member(struct kvm_event *one,		\
> +					struct kvm_event *two, int vcpu)\
> +{									\
> +	return get_event_ ##member(one, vcpu)>				\
> +				get_event_ ##member(two, vcpu);		\
> +}
> +
> +GET_EVENT_KEY(time);
> +COMPARE_EVENT_KEY(count);
> +COMPARE_EVENT_KEY(mean);
> +
> +#define DEF_SORT_NAME_KEY(name, compare_key)	\
> +	{ #name, compare_kvm_event_ ## compare_key }
> +
> +static struct kvm_event_key keys[] = {
> +	DEF_SORT_NAME_KEY(sample, count),
> +	DEF_SORT_NAME_KEY(time, mean),
> +	{ NULL, NULL }
> +};
> +
> +static const char *sort_key = "sample";
> +static key_cmp_fun compare;
> +
> +static void select_key(void)
> +{
> +	int i;
> +
> +	for (i = 0; keys[i].name; i++) {
> +		if (!strcmp(keys[i].name, sort_key)) {
> +			compare = keys[i].key;
> +			return;
> +		}
> +	}
> +
> +	die("Unknown compare key:%s\n", sort_key);
> +}
> +
> +static struct rb_root result;
> +static void insert_to_result(struct kvm_event *event, key_cmp_fun bigger,
> +			     int vcpu)
> +{
> +	struct rb_node **rb =&result.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct kvm_event *p;
> +
> +	while (*rb) {
> +		p = container_of(*rb, struct kvm_event, rb);
> +		parent = *rb;
> +
> +		if (bigger(event, p, vcpu))
> +			rb =&(*rb)->rb_left;
> +		else
> +			rb =&(*rb)->rb_right;
> +	}
> +
> +	rb_link_node(&event->rb, parent, rb);
> +	rb_insert_color(&event->rb,&result);
> +}
> +
> +static void update_total_count(struct kvm_event *event, int vcpu)
> +{
> +	total_count += get_event_count(event, vcpu);
> +	total_time += get_event_time(event, vcpu);
> +}
> +
> +static bool event_is_valid(struct kvm_event *event, int vcpu)
> +{
> +	return get_event_count(event, vcpu);
> +}
> +
> +static void sort_result(int vcpu)
> +{
> +	unsigned int i;
> +	struct kvm_event *event;
> +
> +	for (i = 0; i<  EVENTS_CACHE_SIZE; i++)
> +		list_for_each_entry(event,&kvm_events_cache[i], hash_entry)
> +			if (event_is_valid(event, vcpu)) {
> +				update_total_count(event, vcpu);
> +				insert_to_result(event, compare, vcpu);
> +			}
> +}
> +
> +/* returns left most element of result, and erase it */
> +static struct kvm_event *pop_from_result(void)
> +{
> +	struct rb_node *node = result.rb_node;
> +
> +	if (!node)
> +		return NULL;
> +
> +	while (node->rb_left)
> +		node = node->rb_left;
> +
> +	rb_erase(node,&result);
> +	return container_of(node, struct kvm_event, rb);
> +}
> +
> +static void print_vcpu_info(int vcpu)
> +{
> +	pr_info("Analyze events for ");
> +
> +	if (vcpu == -1)
> +		pr_info("all VCPUs:\n\n");
> +	else
> +		pr_info("VCPU %d:\n\n", vcpu);
> +}
> +
> +static void print_result(int vcpu)
> +{
> +	char decode[20];
> +	struct kvm_event *event;
> +
> +	pr_info("\n\n");
> +	print_vcpu_info(vcpu);
> +	pr_info("%20s ", events_ops->name);
> +	pr_info("%10s ", "Samples");
> +	pr_info("%9s ", "Samples%");
> +
> +	pr_info("%9s ", "Time%");
> +	pr_info("%16s ", "Avg time");
> +	pr_info("\n\n");
> +
> +	while ((event = pop_from_result())) {
> +		u64 ecount, etime;
> +
> +		ecount = get_event_count(event, vcpu);
> +		etime = get_event_time(event, vcpu);
> +
> +		events_ops->decode_key(&event->key, decode);
> +		pr_info("%20s ", decode);
> +		pr_info("%10lu ", ecount);
> +		pr_info("%8.2f%% ", (double)ecount / total_count * 100);
> +		pr_info("%8.2f%% ", (double)etime / total_time * 100);
> +		pr_info("%9.2fus ( +-%7.2f%% )", (double)etime / ecount/1e3,
> +			event_stats_stddev(trace_vcpu, event));
> +		pr_info("\n");
> +	}
> +
> +	pr_info("\nTotal Samples:%ld, Total events handled time:%.2fus.\n\n",
> +		total_count, total_time / 1e3);
> +}
> +
> +static void process_raw_event(struct thread *thread, void *data, u64 timestamp)
> +{
> +	struct event *event;
> +	int type;
> +
> +	type = trace_parse_common_type(data);
> +	event = trace_find_event(type);
> +
> +	return handle_kvm_event(thread, event, data, timestamp);
> +}
> +
> +static int process_sample_event(struct perf_tool *tool __used,
> +				union perf_event *event,
> +				struct perf_sample *sample,
> +				struct perf_evsel *evsel __used,
> +				struct machine *machine)
> +{
> +	struct thread *thread = machine__findnew_thread(machine, sample->tid);
> +
> +	if (thread == NULL) {
> +		pr_debug("problem processing %d event, skipping it.\n",
> +			event->header.type);
> +		return -1;
> +	}
> +
> +	process_raw_event(thread, sample->raw_data, sample->time);
> +
> +	return 0;
> +}
> +
> +static struct perf_tool eops = {
> +	.sample			= process_sample_event,
> +	.comm			= perf_event__process_comm,
> +	.ordered_samples	= true,
> +};
> +
> +static char const *input_name = "perf.data";
> +
> +static int get_cpu_isa(struct perf_session *session)
> +{
> +	char *cpuid;
> +	int isa;
> +
> +	cpuid = perf_header__read_feature(session, HEADER_CPUID);
> +
> +	if (!cpuid)
> +		die("read HEADER_CPUID failed.\n");
> +
> +	if (strstr(cpuid, "Intel"))
> +		isa = 1;
> +	else if (strstr(cpuid, "AMD"))
> +		isa = 0;
> +	else
> +		die("CPU %s is not supported.\n", cpuid);
> +
> +	free(cpuid);
> +	return isa;
> +}
> +
> +static int read_events(void)
> +{
> +	struct perf_session *session;
> +
> +	session = perf_session__new(input_name, O_RDONLY, 0, false,&eops);
> +	if (!session)
> +		die("Initializing perf session failed\n");
> +
> +	if (!perf_session__has_traces(session, "kvm record"))
> +		return -1;
> +
> +	/*
> +	 * Do not use 'isa' recorded in kvm_exit tracepoint since it is not
> +	 * traced in the old kernel.
> +	 */
> +	cpu_isa = get_cpu_isa(session);
> +
> +	return perf_session__process_events(session,&eops);
> +}
> +
> +static void verify_vcpu(int vcpu)
> +{
> +	if (vcpu != -1&&  vcpu<  0)
> +		die("Invalid vcpu:%d.\n", vcpu);
> +}
> +
> +static int kvm_events_report(int vcpu)
> +{
> +	init_kvm_event_record();
> +	verify_vcpu(vcpu);
> +	select_key();
> +	register_kvm_events_ops();
> +	setup_pager();
> +
> +	read_events();
> +
> +	sort_result(vcpu);
> +	print_result(vcpu);
> +	return 0;
> +}
> +
> +static const char * const record_args[] = {
> +	"record",
> +	"-a",
> +	"-R",
> +	"-f",
> +	"-m", "1024",
> +	"-c", "1",
> +	"-e", "kvm:kvm_entry",
> +	"-e", "kvm:kvm_exit",
> +	"-e", "kvm:kvm_mmio",
> +	"-e", "kvm:kvm_pio",
> +};
> +
> +static const char * const new_event[] = {
> +	"kvm_mmio_begin",
> +	"kvm_mmio_done"
> +};
> +
> +static bool kvm_events_exist(const char *event)
> +{
> +	char evt_path[MAXPATHLEN];
> +	int fd;
> +
> +	snprintf(evt_path, MAXPATHLEN, "%s/kvm/%s/id", tracing_events_path,
> +		 event);
> +
> +	fd = open(evt_path, O_RDONLY);
> +
> +	if (fd<  0)
> +		return false;
> +
> +	close(fd);
> +
> +	return true;
> +}
> +
> +static int kvm_events_record(int argc, const char **argv)
> +{
> +	unsigned int rec_argc, i, j;
> +	const char **rec_argv;
> +
> +	rec_argc = ARRAY_SIZE(record_args) + argc - 1;
> +	rec_argc += ARRAY_SIZE(new_event) * 2;
> +	rec_argv = calloc(rec_argc + 1, sizeof(char *));
> +
> +	if (rec_argv == NULL)
> +		return -ENOMEM;
> +
> +	for (i = 0; i<  ARRAY_SIZE(record_args); i++)
> +		rec_argv[i] = strdup(record_args[i]);
> +
> +	for (j = 0; j<  ARRAY_SIZE(new_event); j++)
> +		if (kvm_events_exist(new_event[j])) {
> +			char event[256];
> +
> +			sprintf(event, "kvm:%s", new_event[j]);
> +
> +			rec_argv[i++] = strdup("-e");
> +			rec_argv[i++] = strdup(event);
> +		}
> +
> +	for (j = 1; j<  (unsigned int)argc; j++, i++)
> +		rec_argv[i] = argv[j];
> +
> +	return cmd_record(i, rec_argv, NULL);
> +}
> +
> +static const char * const kvm_events_report_usage[] = {
> +	"perf kvm events report [<options>]",
missing '-' between kvm and events

>
> +	NULL
> +};
> +
> +static const struct option kvm_events_report_options[] = {
> +	OPT_STRING(0, "event",&report_event, "reprot event",
report is misspelled in the above line.
>
> +		    "event for reporting: vmexit, mmio, ioport"),
> +	OPT_INTEGER(0, "vcpu",&trace_vcpu,
> +		    "vcpu id to report"),
> +	OPT_STRING('k', "key",&sort_key, "sort-key",
> +		    "key for sorting: sample(sort by samples number)"
> +		    " time (sort by avg time)"),
> +	OPT_END()
> +};
> +
> +static const char * const kvm_events_usage[] = {
> +	"perf kvm events [<options>] {record|report}",
missing '-' between kvm and events
>
> +	NULL
> +};
> +
> +static const struct option kvm_events_options[] = {
> +	OPT_STRING('i', "input",&input_name, "file", "input file name"),
> +	OPT_BOOLEAN('D', "dump-raw-trace",&dump_trace,
> +		 "dump raw trace in ASCII"),
> +	OPT_END()
> +};
> +
> +int cmd_kvm_events(int argc, const char **argv, const char *prefix __used)
> +{
> +	argc = parse_options(argc, argv, kvm_events_options, kvm_events_usage,
> +			     PARSE_OPT_STOP_AT_NON_OPTION);
> +	if (!argc)
> +		usage_with_options(kvm_events_usage, kvm_events_options);
> +
> +	symbol__init();
> +
> +	if (!strncmp(argv[0], "rec", 3))
> +		return kvm_events_record(argc, argv);
> +
> +	if (!strncmp(argv[0], "rep", 3)) {
> +		if (argc) {
> +			argc = parse_options(argc, argv,
> +					     kvm_events_report_options,
> +					     kvm_events_report_usage, 0);
> +			if (argc)
> +				usage_with_options(kvm_events_report_usage,
> +						   kvm_events_report_options);
> +		}
> +		return kvm_events_report(trace_vcpu);
> +	}
> +
> +	usage_with_options(kvm_events_usage, kvm_events_options);
> +	return 0;
> +}
> diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
> index b382bd5..fb19e3d 100644
> --- a/tools/perf/builtin.h
> +++ b/tools/perf/builtin.h
> @@ -33,6 +33,7 @@ extern int cmd_probe(int argc, const char **argv, const char *prefix);
>   extern int cmd_kmem(int argc, const char **argv, const char *prefix);
>   extern int cmd_lock(int argc, const char **argv, const char *prefix);
>   extern int cmd_kvm(int argc, const char **argv, const char *prefix);
> +extern int cmd_kvm_events(int argc, const char **argv, const char *prefix);
>   extern int cmd_test(int argc, const char **argv, const char *prefix);
>   extern int cmd_inject(int argc, const char **argv, const char *prefix);
>
> diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
> index d695fe4..c5e97d8 100644
> --- a/tools/perf/command-list.txt
> +++ b/tools/perf/command-list.txt
> @@ -22,4 +22,5 @@ perf-probe			mainporcelain common
>   perf-kmem			mainporcelain common
>   perf-lock			mainporcelain common
>   perf-kvm			mainporcelain common
> +perf-kvm-events			mainporcelain common
>   perf-test			mainporcelain common
> diff --git a/tools/perf/perf.c b/tools/perf/perf.c
> index 2b2e225..ab85ea5 100644
> --- a/tools/perf/perf.c
> +++ b/tools/perf/perf.c
> @@ -317,6 +317,7 @@ static void handle_internal_command(int argc, const char **argv)
>   		{ "kmem",	cmd_kmem,	0 },
>   		{ "lock",	cmd_lock,	0 },
>   		{ "kvm",	cmd_kvm,	0 },
> +		{ "kvm-events", cmd_kvm_events, 0},
>   		{ "test",	cmd_test,	0 },
>   		{ "inject",	cmd_inject,	0 },
>   	};
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 3e7e0b0..73f2a6f 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -1305,9 +1305,15 @@ static void print_cpuid(struct perf_header *ph, int fd, FILE *fp)
>   	free(str);
>   }
>
> +static char *read_cpuid(struct perf_header *ph, int fd)
> +{
> +	return do_read_string(fd, ph);
> +}
> +
>   struct feature_ops {
>   	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
>   	void (*print)(struct perf_header *h, int fd, FILE *fp);
> +	char *(*read)(struct perf_header *h, int fd);
>   	const char *name;
>   	bool full_only;
>   };
> @@ -1316,6 +1322,8 @@ struct feature_ops {
>   	[n] = { .name = #n, .write = write_##func, .print = print_##func }
>   #define FEAT_OPF(n, func) \
>   	[n] = { .name = #n, .write = write_##func, .print = print_##func, .full_only = true }
> +#define FEAT_OPA_R(n, func) \
> +	[n] = { .name = #n, .write = write_##func, .print = print_##func, .read  = read_##func }
>
>   /* feature_ops not implemented: */
>   #define print_trace_info		NULL
> @@ -1330,7 +1338,7 @@ static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
>   	FEAT_OPA(HEADER_ARCH,		arch),
>   	FEAT_OPA(HEADER_NRCPUS,		nrcpus),
>   	FEAT_OPA(HEADER_CPUDESC,	cpudesc),
> -	FEAT_OPA(HEADER_CPUID,		cpuid),
> +	FEAT_OPA_R(HEADER_CPUID,	cpuid),
>   	FEAT_OPA(HEADER_TOTAL_MEM,	total_mem),
>   	FEAT_OPA(HEADER_EVENT_DESC,	event_desc),
>   	FEAT_OPA(HEADER_CMDLINE,	cmdline),
> @@ -1383,6 +1391,50 @@ int perf_header__fprintf_info(struct perf_session *session, FILE *fp, bool full)
>   	return 0;
>   }
>
> +struct header_read_data {
> +	int feat;
> +	char *result;
> +};
> +
> +static int perf_file_section__read_feature(struct perf_file_section *section,
> +					   struct perf_header *ph,
> +					   int feat, int fd, void *data)
> +{
> +	struct header_read_data *hd = data;
> +
> +	if (feat != hd->feat)
> +		return 0;
> +
> +	if (lseek(fd, section->offset, SEEK_SET) == (off_t)-1) {
> +		pr_debug("Failed to lseek to %" PRIu64 " offset for feature "
> +				"%d, continuing...\n", section->offset, feat);
> +		return 0;
> +	}
> +
> +	if (feat>= HEADER_LAST_FEATURE) {
> +		pr_warning("unknown feature %d\n", feat);
> +		return 0;
> +	}
> +
> +	hd->result = feat_ops[feat].read(ph, fd);
> +	return 0;
> +}
> +
> +char *perf_header__read_feature(struct perf_session *session, int feat)
> +{
> +	struct perf_header *header =&session->header;
> +	struct header_read_data hd;
> +	int fd = session->fd;
> +
> +	hd.feat = feat;
> +	hd.result = NULL;
> +
> +
> +	perf_header__process_sections(header, fd,&hd,
> +				  perf_file_section__read_feature);
> +	return hd.result;
> +}
> +
>   static int do_write_feat(int fd, struct perf_header *h, int type,
>   			 struct perf_file_section **p,
>   			 struct perf_evlist *evlist)
> diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
> index ac4ec95..41ddfad 100644
> --- a/tools/perf/util/header.h
> +++ b/tools/perf/util/header.h
> @@ -92,6 +92,7 @@ int perf_header__process_sections(struct perf_header *header, int fd,
>   				  int feat, int fd, void *data));
>
>   int perf_header__fprintf_info(struct perf_session *s, FILE *fp, bool full);
> +char *perf_header__read_feature(struct perf_session *session, int feat);
>
>   int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
>   			  const char *name, bool is_kallsyms);
> diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
> index 70c2c13..c48ebf3 100644
> --- a/tools/perf/util/thread.h
> +++ b/tools/perf/util/thread.h
> @@ -16,6 +16,8 @@ struct thread {
>   	bool			comm_set;
>   	char			*comm;
>   	int			comm_len;
> +
> +	void			*private;
Arnaldo: Are you ok with this design for now? I can fix this command to 
whatever API we agree to when it gets committed.

David
>
>   };
>
>   struct machine;
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

