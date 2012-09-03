Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab2ICIs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 04:48:56 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:60906 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab2ICIsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 04:48:54 -0400
Message-ID: <50446EEA.5060306@linux.vnet.ibm.com>
Date: Mon, 03 Sep 2012 16:48:42 +0800
From: don <haodong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: avi@redhat.com, acme@infradead.org, mtosatti@redhat.com, mingo@elte.hu,
        xiaoguangrong@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v7 3/3] KVM: perf: kvm events analysis tool
References: <1346061106-5364-1-git-send-email-haodong@linux.vnet.ibm.com> <1346061106-5364-4-git-send-email-haodong@linux.vnet.ibm.com> <503FB105.9000205@gmail.com>
In-Reply-To: <503FB105.9000205@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
x-cbid: 12090308-2674-0000-0000-000005D31EDF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年08月31日 02:29, David Ahern 写道:
> In addition to Andrew's comment about making the stats struct and 
> functions generic...
Yes. :-)
>
> On 8/27/12 3:51 AM, Dong Hao wrote:
> ---8<---
>
>> +static void exit_event_decode_key(struct event_key *key, char 
>> decode[20])
>> +{
>> +       const char *exit_reason = get_exit_reason(key->key);
>> +
>> +       snprintf(decode, 20, "%s", exit_reason);
>> +}
>
> Use scnprintf rather than snprintf.
Why? Since we don't care about the return value, what's the difference?
>
> ---8<---
>
>> +static bool kvm_event_expand(struct kvm_event *event, int vcpu_id)
>> +{
>> +    int old_max_vcpu = event->max_vcpu;
>> +
>> +    if (vcpu_id < event->max_vcpu)
>> +        return true;
>> +
>> +    while (event->max_vcpu <= vcpu_id)
>> +        event->max_vcpu += DEFAULT_VCPU_NUM;
>> +
>> +    event->vcpu = realloc(event->vcpu,
>> +                  event->max_vcpu * sizeof(*event->vcpu));
>> +    if (!event->vcpu) {
>
> If realloc fails you leak memory by overwriting the current pointer.
Thanks for pointing it out, we will terminate the running instance in 
our next
version.
>
> ---8<---
>
>> +static double event_stats_stddev(int vcpu_id, struct kvm_event *event)
>> +{
>> +    struct event_stats *stats = &event->total;
>> +    double variance, variance_mean, stddev;
>> +
>> +    if (vcpu_id != -1)
>> +        stats = &event->vcpu[vcpu_id];
>> +
>> +    BUG_ON(!stats->count);
>> +
>> +    variance = stats->M2 / (stats->count - 1);
>> +    variance_mean = variance / stats->count;
>> +    stddev = sqrt(variance_mean);
>> +
>> +    return stddev * 100 / stats->mean;
>> +}
>
> perf should be consistent in the stddev it shows the user. Any reason 
> to dump relative stddev versus stddev used by perf-stat?
Since 'perf stat' uses relative standard deviation rather than stddev, 
'perf kvm stat'
just follows the style of 'perf stat'.

>
> ---8<---
>
>> +/* returns left most element of result, and erase it */
>> +static struct kvm_event *pop_from_result(void)
>> +{
>> +    struct rb_node *node = result.rb_node;
>> +
>> +    if (!node)
>> +        return NULL;
>> +
>> +    while (node->rb_left)
>> +        node = node->rb_left;
>
> Use rb_first().
OK, we will use it in the next version.
>
> ---8<---
>
>> +    /*
>> +     * Append "-a" only if "-p"/"--pid" is not specified since they
>> +     * are mutually exclusive.
>> +     */
>> +    if (!kvm_record_specified_guest(argc, argv))
>> +        rec_argv[i++] = STRDUP_FAIL_EXIT("-a");
>
> Other perf-kvm commands rely on perf-record semantics -- i.e., for 
> user to add the -a or -p option.
You mean, remove '-a' from the default options, then:
if a user wants to record all guest he will use 'perf stat record -a';
and if a user wants to record the specified guest, he should use
'perf stat record -p xxx'?

Well, as the style of other subcommand, e.g., perf lock/perf sched, the
'perf xxx record' record all events on all cpus, no need to use '-a'.

Based on mentioned above, I prefer the original way. ;)
>
> ---8<---
>
>> +static const char * const kvm_events_report_usage[] = {
>> +    "perf kvm stat report [<options>]",
>> +    NULL
>> +};
>> +
>> +static const struct option kvm_events_report_options[] = {
>> +    OPT_STRING(0, "event", &report_event, "report event",
>> +            "event for reporting: vmexit, mmio, ioport"),
>> +    OPT_INTEGER(0, "vcpu", &trace_vcpu,
>> +            "vcpu id to report"),
>> +    OPT_STRING('k', "key", &sort_key, "sort-key",
>> +            "key for sorting: sample(sort by samples number)"
>> +            " time (sort by avg time)"),
>> +    OPT_END()
>> +};
>> +
>> +static int kvm_events_report(int argc, const char **argv)
>> +{
>> +    symbol__init();
>> +
>> +    if (argc) {
>> +        argc = parse_options(argc, argv,
>> +                     kvm_events_report_options,
>> +                     kvm_events_report_usage, 0);
>> +        if (argc)
>> +            usage_with_options(kvm_events_report_usage,
>> +                       kvm_events_report_options);
>> +    }
>> +
>> +    return kvm_events_report_vcpu(trace_vcpu);
>> +}
>> +
>> +static int kvm_cmd_stat(int argc, const char **argv)
>> +{
>> +    if (argc > 1) {
>> +        if (!strncmp(argv[1], "rec", 3))
>> +            return kvm_events_record(argc - 1, argv + 1);
>> +
>> +        if (!strncmp(argv[1], "rep", 3))
>> +            return kvm_events_report(argc - 1 , argv + 1);
>> +    }
>> +
>> +    return cmd_stat(argc, argv, NULL);
>> +}
>> +
>>   static char            name_buffer[256];
>>
>>   static const char * const kvm_usage[] = {
>> -    "perf kvm [<options>] {top|record|report|diff|buildid-list}",
>> +    "perf kvm [<options>] {top|record|report|diff|buildid-list|stat}",
>>       NULL
>>   };
>>
>
> The usage for the report/record sub commands of stat is never shown. 
> e.g.,
> $ perf kvm stat
> --> shows help for perf-stat
>
> $ perf kvm
> --> shows the above and perf-kvm's usage
>
> To get help for the record/report subcommands you have to know that 
> record and report are subcommands.
Okay, we will improve this.
>
> ---8<---
>
>> +static int perf_file_section__read_feature(struct perf_file_section 
>> *section,
>> +                struct perf_header *ph,
>> +                int feat, int fd, void *data)
>> +{
>> +    struct header_read_data *hd = data;
>> +
>> +    if (feat != hd->feat)
>> +        return 0;
>> +
>> +    if (lseek(fd, section->offset, SEEK_SET) == (off_t)-1) {
>> +        pr_debug("Failed to lseek to %" PRIu64 " offset for feature "
>> +                "%d, continuing...\n", section->offset, feat);
>> +    return 0;
>> +    }
>> +
>> +    if (feat >= HEADER_LAST_FEATURE) {
>> +        pr_warning("unknown feature %d\n", feat);
>> +        return 0;
>> +    }
>> +
>> +    hd->result = feat_ops[feat].read(ph, fd);
>
> you should verify the read() function is implemented for the requested 
> feature.
OK, thank you for your comments, we will correct it. :-)

