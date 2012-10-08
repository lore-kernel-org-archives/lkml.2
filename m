Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab2JHUfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 16:35:47 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:46427 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab2JHUfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 16:35:40 -0400
Date: Mon, 8 Oct 2012 13:35:34 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        fweisbec@gmail.com, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>
Subject: Re: [PATCH 12/12] perf kvm: add live mode
Message-ID: <20121008203534.GF2631@ghostprotocols.net>
References: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
 <1349716656-48165-13-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349716656-48165-13-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 08, 2012 at 11:17:36AM -0600, David Ahern escreveu:
> perf kvm stat currently requires back to back record and report
> commands to see stats. e.g,.
> 
>   perf kvm stat record -p $pid -- sleep 1
>   perf kvm stat report
> 
> This is rather inconvenvient for on box monitoring of a VM. This
> patch introduces a 'live' mode that in effect combines the record
> plus report into one command. e.g., to monitor a single VM:
> 
>   perf kvm stat live -p $pid
> 
> Same stats options for the record+report path work with the live mode.
> Display rate defaults to 1 and can be changed using the -d option.

Overall it looks good, I like the fact you're not doing it the way perf
script does, i.e. that "pipe mode" thing, more or less like I'm doing on
'perf trace', but I think this is the time to get rid of 'perf_session'
too for this specific "live mode" tools.

I'm almost getting there for 'trace' and 'top', just need to move the
ordered_samples code to evlist, then session, top, trace, kvm live and
script will not need to use 'perf_session' at all.

Also that 'perf_kvm__open_counters' really is just a third copy of code
in 'record' and 'top', right? You could move it to
'perf_ev{list,open}__open' and solve this dup :-)

I applied the cleanups/simple stuff, will try to do some of the prep
work on ordered_samples to use on top and trace and then I think you
could look there so that we get to something that is useful for all
these !perf.data tools.

- Arnaldo
 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> Cc: Dong Hao <haodong@linux.vnet.ibm.com>
> ---
>  tools/perf/builtin-kvm.c |  649 ++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 623 insertions(+), 26 deletions(-)
> 
> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
> index dcbbcc7..9dd1921 100644
> --- a/tools/perf/builtin-kvm.c
> +++ b/tools/perf/builtin-kvm.c
> @@ -2,6 +2,7 @@
>  #include "perf.h"
>  
>  #include "util/evsel.h"
> +#include "util/evlist.h"
>  #include "util/util.h"
>  #include "util/cache.h"
>  #include "util/symbol.h"
> @@ -15,9 +16,12 @@
>  #include "util/debugfs.h"
>  #include "util/tool.h"
>  #include "util/stat.h"
> +#include "util/top.h"
>  
>  #include <sys/prctl.h>
> +#include <sys/timerfd.h>
>  
> +#include <termios.h>
>  #include <semaphore.h>
>  #include <pthread.h>
>  #include <math.h>
> @@ -81,6 +85,8 @@ struct exit_reasons_table {
>  
>  struct perf_kvm {
>  	struct perf_tool    tool;
> +	struct perf_record_opts opts;
> +	struct perf_evlist  *evlist;
>  	struct perf_session *session;
>  
>  	const char *file_name;
> @@ -95,10 +101,16 @@ struct perf_kvm {
>  	struct kvm_events_ops *events_ops;
>  	key_cmp_fun compare;
>  	struct list_head kvm_events_cache[EVENTS_CACHE_SIZE];
> +
>  	u64 total_time;
>  	u64 total_count;
> +	u64 lost_events;
>  
>  	struct rb_root result;
> +
> +	int timerfd;
> +	unsigned int display_time;
> +	bool live;
>  };
>  
>  
> @@ -319,6 +331,23 @@ static void init_kvm_event_record(struct perf_kvm *kvm)
>  		INIT_LIST_HEAD(&kvm->kvm_events_cache[i]);
>  }
>  
> +static void clear_events_cache_stats(struct list_head *kvm_events_cache)
> +{
> +	struct list_head *head;
> +	struct kvm_event *event;
> +	unsigned int i;
> +
> +	for (i = 0; i < EVENTS_CACHE_SIZE; i++) {
> +		head = &kvm_events_cache[i];
> +		list_for_each_entry(event, head, hash_entry) {
> +			/* reset stats for event */
> +			memset(&event->total, 0, sizeof(event->total));
> +			memset(event->vcpu, 0,
> +			       event->max_vcpu * sizeof(*event->vcpu));
> +		}
> +	}
> +}
> +
>  static int kvm_events_hash_fn(u64 key)
>  {
>  	return key & (EVENTS_CACHE_SIZE - 1);
> @@ -471,7 +500,11 @@ static bool handle_end_event(struct perf_kvm *kvm,
>  	vcpu_record->last_event = NULL;
>  	vcpu_record->start_time = 0;
>  
> -	BUG_ON(timestamp < time_begin);
> +	/* seems to happen once in a while during live mode */
> +	if (timestamp < time_begin) {
> +		pr_debug("End time before begin time; skipping event.\n");
> +		return true;
> +	}
>  
>  	time_diff = timestamp - time_begin;
>  	return update_kvm_event(event, vcpu, time_diff);
> @@ -637,24 +670,60 @@ static struct kvm_event *pop_from_result(struct rb_root *result)
>  	return container_of(node, struct kvm_event, rb);
>  }
>  
> -static void print_vcpu_info(int vcpu)
> +static void print_vcpu_info(struct perf_kvm *kvm)
>  {
> +	int vcpu = kvm->trace_vcpu;
> +
>  	pr_info("Analyze events for ");
>  
> +	if (kvm->live) {
> +		if (kvm->opts.target.system_wide)
> +			pr_info("all VMs, ");
> +		else if (kvm->opts.target.pid)
> +			pr_info("pid(s) %s, ", kvm->opts.target.pid);
> +		else if (kvm->opts.target.tid)
> +			pr_info("tid(s) %s, ", kvm->opts.target.tid);
> +		else if (kvm->opts.target.cpu_list)
> +			pr_info("host cpu(s) %s, ", kvm->opts.target.cpu_list);
> +		else
> +			pr_info("dazed and confused on what is monitored, ");
> +	}
> +
>  	if (vcpu == -1)
>  		pr_info("all VCPUs:\n\n");
>  	else
>  		pr_info("VCPU %d:\n\n", vcpu);
>  }
>  
> +static void show_timeofday(void)
> +{
> +	char date[64];
> +	struct timeval tv;
> +	struct tm ltime;
> +
> +	gettimeofday(&tv, NULL);
> +	if (localtime_r(&tv.tv_sec, &ltime)) {
> +		strftime(date, sizeof(date), "%H:%M:%S", &ltime);
> +		pr_info("%s.%06ld", date, tv.tv_usec);
> +	} else
> +		pr_info("00:00:00.000000");
> +
> +	return;
> +}
> +
>  static void print_result(struct perf_kvm *kvm)
>  {
>  	char decode[20];
>  	struct kvm_event *event;
>  	int vcpu = kvm->trace_vcpu;
>  
> +	if (kvm->live) {
> +		puts(CONSOLE_CLEAR);
> +		show_timeofday();
> +	}
> +
>  	pr_info("\n\n");
> -	print_vcpu_info(vcpu);
> +	print_vcpu_info(kvm);
>  	pr_info("%20s ", kvm->events_ops->name);
>  	pr_info("%10s ", "Samples");
>  	pr_info("%9s ", "Samples%");
> @@ -681,6 +750,20 @@ static void print_result(struct perf_kvm *kvm)
>  
>  	pr_info("\nTotal Samples:%" PRIu64 ", Total events handled time:%.2fus.\n\n",
>  		kvm->total_count, kvm->total_time / 1e3);
> +
> +	if (kvm->lost_events)
> +		pr_info("\nLost events: %" PRIu64 "\n\n", kvm->lost_events);
> +}
> +
> +static int process_lost_event(struct perf_tool *tool,
> +			      union perf_event *event __maybe_unused,
> +			      struct perf_sample *sample __maybe_unused,
> +			      struct machine *machine __maybe_unused)
> +{
> +	struct perf_kvm *kvm = container_of(tool, struct perf_kvm, tool);
> +
> +	kvm->lost_events++;
> +	return 0;
>  }
>  
>  static int process_sample_event(struct perf_tool *tool,
> @@ -704,10 +787,20 @@ static int process_sample_event(struct perf_tool *tool,
>  	return 0;
>  }
>  
> -static int get_cpu_isa(struct perf_session *session)
> +static int cpu_isa_config(struct perf_kvm *kvm)
>  {
> -	char *cpuid = session->header.env.cpuid;
> -	int isa;
> +	char buf[64], *cpuid;
> +	int err, isa;
> +
> +	if (kvm->live) {
> +		err = get_cpuid(buf, sizeof(buf));
> +		if (err != 0) {
> +			pr_err("Failed to look up CPU type (Intel or AMD)\n");
> +			return err;
> +		}
> +		cpuid = buf;
> +	} else
> +		cpuid = kvm->session->header.env.cpuid;
>  
>  	if (strstr(cpuid, "Intel"))
>  		isa = 1;
> @@ -715,10 +808,374 @@ static int get_cpu_isa(struct perf_session *session)
>  		isa = 0;
>  	else {
>  		pr_err("CPU %s is not supported.\n", cpuid);
> -		isa = -ENOTSUP;
> +		return -ENOTSUP;
> +	}
> +
> +	if (isa == 1) {
> +		kvm->exit_reasons = vmx_exit_reasons;
> +		kvm->exit_reasons_size = ARRAY_SIZE(vmx_exit_reasons);
> +		kvm->exit_reasons_isa = "VMX";
> +	}
> +
> +	return 0;
> +}
> +
> +static bool verify_vcpu(int vcpu)
> +{
> +	if (vcpu != -1 && vcpu < 0) {
> +		pr_err("Invalid vcpu:%d.\n", vcpu);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +#define PERF_KVM__MAX_EVENTS_PER_MMAP  1000
> +
> +static s64 perf_kvm__mmap_read_idx(struct perf_kvm *kvm, int idx)
> +{
> +	union perf_event *event;
> +	s64 n = 0;
> +	int err;
> +
> +	while ((event = perf_evlist__mmap_read(kvm->evlist, idx)) != NULL) {
> +		err = perf_session__process_event(kvm->session, event,
> +						  &kvm->tool, 0);
> +		if (err) {
> +			pr_err("Failed to process event\n");
> +			return err;
> +		}
> +		n++;
> +
> +		/* limit events per mmap handled all at once */
> +		if (n == PERF_KVM__MAX_EVENTS_PER_MMAP)
> +			break;
> +	}
> +
> +	return n;
> +}
> +
> +static int perf_kvm__mmap_read(struct perf_kvm *kvm)
> +{
> +	int i, err, throttled = 0;
> +	s64 n, ntotal = 0;
> +
> +	for (i = 0; i < kvm->evlist->nr_mmaps; i++) {
> +		n = perf_kvm__mmap_read_idx(kvm, i);
> +		if (n < 0)
> +			return -1;
> +		ntotal += n;
> +		if (n == PERF_KVM__MAX_EVENTS_PER_MMAP)
> +			throttled = 1;
> +	}
> +
> +	/* flush queue after each round in which we processed events */
> +	if (ntotal) {
> +		err = kvm->tool.finished_round(&kvm->tool, NULL, kvm->session);
> +		if (err) {
> +			if (kvm->lost_events)
> +				pr_info("\nLost events: %" PRIu64 "\n\n",
> +					kvm->lost_events);
> +			return err;
> +		}
> +	}
> +
> +	return throttled;
> +}
> +
> +static volatile int done;
> +
> +static void sig_handler(int sig)
> +{
> +	if (sig == SIGINT)
> +		done = 1;
> +}
> +
> +static int perf_kvm__timerfd_create(struct perf_kvm *kvm)
> +{
> +	struct itimerspec new_value;
> +	struct timespec now;
> +	int rc = -1;
> +
> +	kvm->timerfd = timerfd_create(CLOCK_MONOTONIC, TFD_NONBLOCK);
> +	if (kvm->timerfd < 0) {
> +		pr_err("timerfd_create failed\n");
> +		goto out;
> +	}
> +
> +	if (clock_gettime(CLOCK_MONOTONIC, &now) != 0) {
> +		pr_err("clock_gettime failed: %d\n", errno);
> +		close(kvm->timerfd);
> +		goto out;
> +	}
> +
> +	new_value.it_value.tv_sec = now.tv_sec + kvm->display_time;
> +	new_value.it_value.tv_nsec = now.tv_nsec;
> +	new_value.it_interval.tv_sec = kvm->display_time;
> +	new_value.it_interval.tv_nsec = 0;
> +
> +	if (timerfd_settime(kvm->timerfd, TFD_TIMER_ABSTIME,
> +			    &new_value, NULL) != 0) {
> +		pr_err("timerfd_settime failed: %d\n", errno);
> +		close(kvm->timerfd);
> +		goto out;
> +	}
> +
> +	rc = 0;
> +out:
> +	return rc;
> +}
> +
> +static int perf_kvm__handle_timerfd(struct perf_kvm *kvm)
> +{
> +	uint64_t c;
> +	int rc;
> +
> +	rc = read(kvm->timerfd, &c, sizeof(uint64_t));
> +	if (rc < 0) {
> +		if (errno == EAGAIN)
> +			return 0;
> +
> +		pr_err("Failed to read timer fd: %d\n", errno);
> +		return -1;
> +	}
> +
> +	if (rc != sizeof(uint64_t)) {
> +		pr_err("Error reading timer fd - invalid size returned\n");
> +		return -1;
> +	}
> +
> +	if (c != 1)
> +		pr_debug("Missed timer beats: %" PRIu64 "\n", c-1);
> +
> +	/* update display */
> +	sort_result(kvm);
> +	print_result(kvm);
> +
> +	/* reset counts */
> +	clear_events_cache_stats(kvm->kvm_events_cache);
> +	kvm->total_count = 0;
> +	kvm->total_time = 0;
> +	kvm->lost_events = 0;
> +
> +	return 0;
> +}
> +
> +static int fd_set_nonblock(int fd)
> +{
> +	long arg = 0;
> +
> +	arg = fcntl(fd, F_GETFL);
> +	if (arg < 0) {
> +		pr_err("Failed to get current flags for fd %d\n", fd);
> +		return -1;
> +	}
> +
> +	if (fcntl(fd, F_SETFL, arg | O_NONBLOCK) < 0) {
> +		pr_err("Failed to set non-block option on fd %d\n", fd);
> +		return -1;
>  	}
>  
> -	return isa;
> +	return 0;
> +}
> +
> +static
> +int perf_kvm__handle_stdin(struct termios *tc_now, struct termios *tc_save)
> +{
> +	int c;
> +
> +	tcsetattr(0, TCSANOW, tc_now);
> +	c = getc(stdin);
> +	tcsetattr(0, TCSAFLUSH, tc_save);
> +
> +	if (c == 'q')
> +		return 1;
> +
> +	/* TO-DO: add hook for 'd' to change display rate
> +	 *        needs an update to timerfd too
> +	 */
> +
> +	return 0;
> +}
> +
> +static int kvm_events_live_report(struct perf_kvm *kvm)
> +{
> +	struct pollfd *pollfds = NULL;
> +	int nr_fds, ret, err = -EINVAL;
> +	struct termios tc, save;
> +
> +	/* live flag must be set first */
> +	kvm->live = true;
> +
> +	ret = cpu_isa_config(kvm);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!verify_vcpu(kvm->trace_vcpu) ||
> +	    !select_key(kvm) ||
> +	    !register_kvm_events_ops(kvm)) {
> +		goto out;
> +	}
> +
> +	init_kvm_event_record(kvm);
> +
> +
> +	tcgetattr(0, &save);
> +	tc = save;
> +	tc.c_lflag &= ~(ICANON | ECHO);
> +	tc.c_cc[VMIN] = 0;
> +	tc.c_cc[VTIME] = 0;
> +
> +	signal(SIGINT, sig_handler);
> +
> +
> +	/* copy pollfds -- need to add timerfd and stdin */
> +	nr_fds = kvm->evlist->nr_fds;
> +	pollfds = zalloc(sizeof(struct pollfd) * (nr_fds + 2));
> +	if (!pollfds) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +	memcpy(pollfds, kvm->evlist->pollfd,
> +		sizeof(struct pollfd) * kvm->evlist->nr_fds);
> +
> +	/* add timer fd */
> +	if (perf_kvm__timerfd_create(kvm) < 0) {
> +		err = -1;
> +		goto out;
> +	}
> +
> +	pollfds[nr_fds].fd = kvm->timerfd;
> +	pollfds[nr_fds].events = POLLIN;
> +	nr_fds++;
> +
> +	pollfds[nr_fds].fd = fileno(stdin);
> +	pollfds[nr_fds].events = POLLIN;
> +	nr_fds++;
> +	if (fd_set_nonblock(fileno(stdin)) != 0)
> +		goto out;
> +
> +	/* everything is good - enable the events and process */
> +	perf_evlist__enable(kvm->evlist);
> +
> +	while (!done) {
> +		int rc;
> +
> +		rc = perf_kvm__mmap_read(kvm);
> +		if (rc < 0)
> +			break;
> +
> +		err = perf_kvm__handle_timerfd(kvm);
> +		if (err)
> +			goto out;
> +
> +		done = perf_kvm__handle_stdin(&tc, &save);
> +
> +		if (!rc && !done)
> +			err = poll(pollfds, nr_fds, 100);
> +	}
> +
> +	perf_evlist__disable(kvm->evlist);
> +
> +	if (err == 0) {
> +		sort_result(kvm);
> +		print_result(kvm);
> +	}
> +
> +out:
> +	if (kvm->timerfd >= 0)
> +		close(kvm->timerfd);
> +
> +	if (pollfds)
> +		free(pollfds);
> +
> +	return err;
> +}
> +
> +
> +/* TO-DO: how to merge this with perf-stat */
> +static int perf_kvm__open_counters(struct perf_kvm *kvm)
> +{
> +	struct perf_evsel *pos;
> +	struct perf_evlist *evlist = kvm->evlist;
> +	int err = 0;
> +
> +	/*
> +	 * Note: exclude_{guest,host} do not apply here.
> +	 *       This command processes KVM tracepoints form host only
> +	 */
> +	list_for_each_entry(pos, &evlist->entries, node) {
> +		struct perf_event_attr *attr = &pos->attr;
> +
> +		attr->sample_type = 0;
> +		attr->read_format = 0;
> +
> +		attr->sample_type |= PERF_SAMPLE_TID;
> +		attr->sample_type |= PERF_SAMPLE_TIME;
> +		attr->sample_type |= PERF_SAMPLE_CPU;
> +		attr->sample_type |= PERF_SAMPLE_RAW;
> +
> +		if (evlist->nr_entries > 1) {
> +			attr->sample_type |= PERF_SAMPLE_ID;
> +			attr->read_format |= PERF_FORMAT_ID;
> +		}
> +
> +		attr->sample_id_all = kvm->opts.sample_id_all_missing ? 0 : 1;
> +		attr->sample_period = 1;
> +		attr->comm = !pos->idx;
> +
> +		attr->watermark = 0;
> +		attr->wakeup_events = 100;
> +
> +		/* will enable all once we are ready */
> +		attr->disabled = 1;
> +
> +retry_sample_id:
> +		attr->sample_id_all = kvm->opts.sample_id_all_missing ? 0 : 1;
> +		if (perf_evsel__open(pos, evlist->cpus, evlist->threads) < 0) {
> +			err = errno;
> +
> +			if (err == EPERM || err == EACCES) {
> +				ui__error_paranoid();
> +				goto out_err;
> +			} else if ((err == EINVAL) &&
> +				   !kvm->opts.sample_id_all_missing) {
> +				/*
> +				 * Old kernel, no attr->sample_id_type_all field
> +				 */
> +				kvm->opts.sample_id_all_missing = true;
> +				goto retry_sample_id;
> +			}
> +
> +			/*
> +			 * should never happen since the event is validated
> +			 * before adding to evlist.
> +			 */
> +			if (err == ENOENT) {
> +				ui__error("The %s event is not supported.\n",
> +					  perf_evsel__name(pos));
> +				goto out_err;
> +			} else if (err == EMFILE) {
> +				ui__error("Too many events need to be opened.\n");
> +				goto out_err;
> +			}
> +
> +			ui__error("The sys_perf_event_open() syscall "
> +				  "returned with %d (%s).  /bin/dmesg "
> +				  "may provide additional information.\n",
> +				  err, strerror(err));
> +			goto out_err;
> +		}
> +	}
> +
> +	if (perf_evlist__mmap(evlist, kvm->opts.mmap_pages, false) < 0) {
> +		ui__error("Failed to mmap with %d (%s)\n",
> +			  errno, strerror(errno));
> +		goto out_err;
> +	}
> +
> +out_err:
> +	return err;
>  }
>  
>  static int read_events(struct perf_kvm *kvm)
> @@ -746,30 +1203,13 @@ static int read_events(struct perf_kvm *kvm)
>  	 * Do not use 'isa' recorded in kvm_exit tracepoint since it is not
>  	 * traced in the old kernel.
>  	 */
> -	ret = get_cpu_isa(kvm->session);
> -
> +	ret = cpu_isa_config(kvm);
>  	if (ret < 0)
>  		return ret;
>  
> -	if (ret == 1) {
> -		kvm->exit_reasons = vmx_exit_reasons;
> -		kvm->exit_reasons_size = ARRAY_SIZE(vmx_exit_reasons);
> -		kvm->exit_reasons_isa = "VMX";
> -	}
> -
>  	return perf_session__process_events(kvm->session, &kvm->tool);
>  }
>  
> -static bool verify_vcpu(int vcpu)
> -{
> -	if (vcpu != -1 && vcpu < 0) {
> -		pr_err("Invalid vcpu:%d.\n", vcpu);
> -		return false;
> -	}
> -
> -	return true;
> -}
> -
>  static int kvm_events_report_vcpu(struct perf_kvm *kvm)
>  {
>  	int ret = -EINVAL;
> @@ -881,6 +1321,159 @@ static int kvm_events_report(struct perf_kvm *kvm, int argc, const char **argv)
>  	return kvm_events_report_vcpu(kvm);
>  }
>  
> +static int kvm_events_live(struct perf_kvm *kvm, int argc, const char **argv)
> +{
> +	struct perf_session *session = NULL;
> +	char errbuf[BUFSIZ];
> +	int err;
> +	const struct option live_options[] = {
> +		OPT_STRING('p', "pid", &kvm->opts.target.pid, "pid",
> +			"record events on existing process id"),
> +		OPT_STRING('t', "tid", &kvm->opts.target.tid, "tid",
> +			"record events on existing thread id"),
> +		OPT_STRING('C', "cpu", &kvm->opts.target.cpu_list, "cpu",
> +			"list of host cpus to monitor"),
> +		OPT_UINTEGER('m', "mmap-pages", &kvm->opts.mmap_pages,
> +			"number of mmap data pages"),
> +		OPT_INCR('v', "verbose", &verbose,
> +			"be more verbose (show counter open errors, etc)"),
> +		OPT_BOOLEAN('a', "all-cpus", &kvm->opts.target.system_wide,
> +			"system-wide collection from all CPUs"),
> +		OPT_UINTEGER('d', "display", &kvm->display_time,
> +			"time in seconds between display updates"),
> +		OPT_STRING(0, "event", &kvm->report_event, "report event",
> +			"event for reporting: vmexit, mmio, ioport"),
> +		OPT_INTEGER(0, "vcpu", &kvm->trace_vcpu,
> +			"vcpu id to report"),
> +		OPT_STRING('k', "key", &kvm->sort_key, "sort-key",
> +			"key for sorting: sample(sort by samples number)"
> +			" time (sort by avg time)"),
> +		OPT_END()
> +	};
> +	const char * const live_usage[] = {
> +		"perf kvm stat live [<options>]",
> +		NULL
> +	};
> +
> +
> +	/* event handling */
> +	kvm->tool.sample = process_sample_event;
> +	kvm->tool.comm   = perf_event__process_comm;
> +	kvm->tool.exit   = perf_event__process_exit;
> +	kvm->tool.fork   = perf_event__process_fork,
> +	kvm->tool.lost   = process_lost_event;
> +	kvm->tool.ordered_samples = true;
> +	perf_tool__fill_defaults(&kvm->tool);
> +
> +	/* set defaults */
> +	kvm->display_time = 1;
> +	kvm->opts.user_interval = 1;
> +	kvm->opts.mmap_pages = 512;
> +	kvm->opts.target.uses_mmap = true;
> +
> +	kvm->evlist = perf_evlist__new(NULL, NULL);
> +	if (kvm->evlist == NULL)
> +		return -ENOMEM;
> +
> +	symbol__init();
> +	disable_buildid_cache();
> +
> +	if (argc) {
> +		argc = parse_options(argc, argv, live_options,
> +				     live_usage, 0);
> +		if (argc)
> +			usage_with_options(live_usage, live_options);
> +	}
> +
> +	use_browser = 0;
> +	setup_browser(false);
> +
> +	/*
> +	 * target related setups
> +	 */
> +	if (perf_target__none(&kvm->opts.target))
> +		kvm->opts.target.system_wide = true;
> +
> +	err = perf_target__validate(&kvm->opts.target);
> +	if (err) {
> +		perf_target__strerror(&kvm->opts.target, err, errbuf, BUFSIZ);
> +		ui__warning("%s", errbuf);
> +	}
> +
> +	err = perf_target__parse_uid(&kvm->opts.target);
> +	if (err) {
> +		int saved_errno = errno;
> +
> +		perf_target__strerror(&kvm->opts.target, err,
> +				      errbuf, BUFSIZ);
> +		ui__error("%s", errbuf);
> +
> +		err = -saved_errno;
> +		goto out;
> +	}
> +
> +	/*
> +	 * generate the event list
> +	 */
> +	err = perf_evlist__add_tracepoints(kvm->evlist,
> +					   kvm_events_tp,
> +					   ARRAY_SIZE(kvm_events_tp));
> +	if (err != 0)
> +		goto out;
> +
> +	symbol_conf.nr_events = kvm->evlist->nr_entries;
> +
> +	if (perf_evlist__create_maps(kvm->evlist, &kvm->opts.target) < 0)
> +		usage_with_options(live_usage, live_options);
> +
> +	/*
> +	 * perf session
> +	 */
> +	session = perf_session__new(NULL, O_WRONLY, false, false, &kvm->tool);
> +	if (session == NULL) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +	session->evlist = kvm->evlist;
> +	kvm->session = session;
> +	perf_session__set_id_hdr_size(session);
> +
> +
> +	/*
> +	 * need to get pevent initialized
> +	 */
> +	err = perf_evlist__trace_init(kvm->evlist, session);
> +	if (err != 0)
> +		goto out;
> +
> +	if (perf_target__has_task(&kvm->opts.target))
> +		perf_event__synthesize_thread_map(&kvm->tool,
> +						  kvm->evlist->threads,
> +						  perf_event__process,
> +						  &session->host_machine);
> +	else
> +		perf_event__synthesize_threads(&kvm->tool, perf_event__process,
> +					       &session->host_machine);
> +
> +
> +	err = perf_kvm__open_counters(kvm);
> +	if (err != 0)
> +		goto out;
> +
> +	err = kvm_events_live_report(kvm);
> +
> +out:
> +	exit_browser(0);
> +
> +	if (session)
> +		perf_session__delete(session);
> +	kvm->session = NULL;
> +	perf_evlist__delete_maps(kvm->evlist);
> +	perf_evlist__delete(kvm->evlist);
> +
> +	return err;
> +}
> +
>  static void print_kvm_stat_usage(void)
>  {
>  	printf("Usage: perf kvm stat <command>\n\n");
> @@ -888,6 +1481,7 @@ static void print_kvm_stat_usage(void)
>  	printf("# Available commands:\n");
>  	printf("\trecord: record kvm events\n");
>  	printf("\treport: report statistical data of kvm events\n");
> +	printf("\tlive:   live reporting of statistical data of kvm events\n");
>  
>  	printf("\nOtherwise, it is the alias of 'perf stat':\n");
>  }
> @@ -905,6 +1499,9 @@ static int kvm_cmd_stat(struct perf_kvm *kvm, int argc, const char **argv)
>  	if (!strncmp(argv[1], "rep", 3))
>  		return kvm_events_report(kvm, argc - 1 , argv + 1);
>  
> +	if (!strncmp(argv[1], "live", 4))
> +		return kvm_events_live(kvm, argc - 1 , argv + 1);
> +
>  perf_stat:
>  	return cmd_stat(argc, argv, NULL);
>  }
> -- 
> 1.7.10.1
