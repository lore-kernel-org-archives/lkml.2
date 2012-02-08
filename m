Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab2BHGQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 01:16:36 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:57392 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab2BHGQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 01:16:34 -0500
Message-ID: <4F3212CA.4080208@linux.vnet.ibm.com>
Date: Wed, 08 Feb 2012 14:14:34 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Xiao Guangrong <xiaoguangrong.eric@gmail.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] KVM: perf: kvm events analysis tool
References: <4F3121DE.7020502@linux.vnet.ibm.com> <4F31225C.1020703@gmail.com> <4F316596.3060509@gmail.com>
In-Reply-To: <4F316596.3060509@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12020806-9574-0000-0000-000001494436
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 01:55 AM, David Ahern wrote:

> On 02/07/2012 06:08 AM, Xiao Guangrong wrote:
>> Add 'perf kvm-events' support to analyze kvm vmexit/mmio/ioport smartly
> 
> example output?
> 


You can find a example output at this website:
	http://lwn.net/Articles/479069/

[ Sorry, i did not put it into changlog in the v3 ]

>> +--------
>> +[verse]
>> +'perf kvm-events' {record|report}
> 
> command name is very generic -- kvm-events; but command focus is rather
> narrow -- I/O events.
> 


It is not only analysing IO events but also for other events(like vmexit,
and other events will be added). I prefer to kvm-events :)

>> +static int get_cpu_isa(void)
>> +{
>> +	FILE *f;
>> +	char line[512], vendor[64];
>> +	int ret;
>> +
>> +	f = fopen("/proc/cpuinfo", "r");
>> +	if (!f)
>> +		die("/proc/cpuinfo does not exist.\n");
>> +
>> +	while (fgets(line, sizeof(line), f))
>> +		if (sscanf(line, "vendor_id	: %s", vendor) > 0) {
>> +			if (strstr(vendor, "Intel"))
>> +				ret = 1;
>> +			else if (strstr(vendor, "AMD"))
>> +				ret = 0;
>> +			else
>> +				break;
>> +			goto exit;
>> +		}
>> +
>> +	die("CPU vendor is unknown.\n");
>> +exit:
>> +	fclose(f);
>> +	return ret;
>> +}
> 
> This breaks with off-box analysis -- collect data on target and analyze
> it on another. I would think the HEADER_CPUDESC or HEADER_CPUID feature
> would cover what you need.
> 


Right, i will using these instead.

>> +static void init_kvm_event_record(void)
>> +{
>> +	int i;
>> +
>> +	kvm_max_vcpus = kvm_max_cpus();
> 
> This breaks off-box analysis too.
> 


Hmm, actually, i will drop kvm_max_vcpu ant let the buffer to be dynamically
resized.

>> +
>> +	vcpu_event_record = zalloc(sizeof(*vcpu_event_record) * kvm_max_vcpus);
>> +	if (!vcpu_event_record)
>> +		die("zalloc.\n");
>> +
>> +	for (i = 0; i < (int)EVENTS_CACHE_SIZE; i++)
>> +		INIT_LIST_HEAD(&kvm_events_cache[i]);
>> +}
> 
> Really, the caches could be tied to thread structs, and then you don't
> need a max vcpu style allocation. more below.
> 


Hmm, this cache is used to cache "event struct", this is the common resources
for all vcpus.

>> +static int process_sample_event(struct perf_tool *tool __used,
>> +				union perf_event *event,
>> +				struct perf_sample *sample,
>> +				struct perf_evsel *evsel __used,
>> +				struct machine *machine)
>> +{
>> +	struct thread *thread = machine__findnew_thread(machine, sample->tid);
>> +
>> +	if (thread == NULL) {
>> +		pr_debug("problem processing %d event, skipping it.\n",
>> +			event->header.type);
>> +		return -1;
>> +	}
>> +
>> +	process_raw_event(sample->raw_data, sample->cpu, sample->time,
>> +			  sample->tid);
> 
> I have not taken the time to digest the vcpu to tid logic, but you are
> missing a connection I was expecting -- vcpus are tasks which will have
> a struct thread associated with them. If you look above you are
> retrieving the struct at the start of this function.
> 
> What I've done locally -- and something I've been meaning to suggest to
> Arnaldo as an exported API -- is to add an entry to struct thread in
> util/thread.h:
> 
>    void            *private;
> 
> and then in local process_sample_event implementations:
> 
>    if (thread->private == NULL) {
>         thread->private = zalloc(sizeof(struct thread_runtime));
>         if (thread->private == NULL) {
>             pr_debug("failed to malloc memory for runtime data.\n");
>             rc = -1;
>             goto out;
>         }
>     }
> 
> and in functions processing samples:
>    struct thread_runtime *r = thread->private;
> 
> Doing this means you aren't allocating large, max vcpus structs and you
> have the vcpu - tid association on the first kvm_entry event -- ie., you
> don't need the code for vcpu-tid tracking.
> 
> Events happen in thread contexts and threads == vcpus.
> 


Good point, it can clean up the code a lot.

>> +static int kvm_events_report(int vcpu)
>> +{
>> +	init_kvm_event_record();
>> +	init_kvm_tid_to_pid();
>> +	verify_vcpu(vcpu);
>> +	select_key();
>> +	register_kvm_events_ops();
>> +	setup_pager();
> 
> I believe setup_pager is handled by perf.c
> 


Hmm, i did not find it, could you please tell me where is it?
And, setup_pager is also used in other tools such 'perf sched',
'perf lock'...

>> +	read_events();
>> +	sort_result(vcpu);
>> +	print_result(vcpu);
>> +	return 0;
> 
> ouch. a little separation in the lines would help readability.


Yes. :)

>> +static const struct option kvm_events_options[] = {
>> +	OPT_STRING('i', "input", &input_name, "file", "input file name"),
>> +	OPT_INCR('v', "verbose", &verbose,
>> +		 "be more verbose (show symbol address, etc)"),
> 
> 'show symbol address' does not seem relevant for this command.
> 


Right, i just copied these from other tool.

> 
>> +	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
>> +		 "dump raw trace in ASCII"),
> 
> Does the -D make sense?


Hmm, it is good for trace parsing i think.


>> +	if (!strncmp(argv[0], "rec", 3))
>> +		return kvm_events_record(argc, argv);
>> +
>> +	if (!strncmp(argv[0], "report", 6)) {
> 
> exact match for 'report'?
> 


It is the style in other tools, what is your suggestion?

Thanks, David! :)

