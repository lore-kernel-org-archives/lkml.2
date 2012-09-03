Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab2ICQEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 12:04:44 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56931 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288Ab2ICQEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 12:04:43 -0400
Message-ID: <5044D515.9050903@gmail.com>
Date: Mon, 03 Sep 2012 10:04:37 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: don <haodong@linux.vnet.ibm.com>
CC: avi@redhat.com, acme@infradead.org, mtosatti@redhat.com, mingo@elte.hu,
        xiaoguangrong@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v7 3/3] KVM: perf: kvm events analysis tool
References: <1346061106-5364-1-git-send-email-haodong@linux.vnet.ibm.com> <1346061106-5364-4-git-send-email-haodong@linux.vnet.ibm.com> <503FB105.9000205@gmail.com> <50446EEA.5060306@linux.vnet.ibm.com>
In-Reply-To: <50446EEA.5060306@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/12 2:48 AM, don wrote:
> 于 2012年08月31日 02:29, David Ahern 写道:
>> In addition to Andrew's comment about making the stats struct and
>> functions generic...
> Yes. :-)
>>
>> On 8/27/12 3:51 AM, Dong Hao wrote:
>> ---8<---
>>
>>> +static void exit_event_decode_key(struct event_key *key, char
>>> decode[20])
>>> +{
>>> +       const char *exit_reason = get_exit_reason(key->key);
>>> +
>>> +       snprintf(decode, 20, "%s", exit_reason);
>>> +}
>>
>> Use scnprintf rather than snprintf.
> Why? Since we don't care about the return value, what's the difference?

1. consistency (scnprintf is preferred).
2. what if a new exit reason is added in the future that is larger than 
19 characters? Better to be safe now.

>>
>> ---8<---
>>
>>> +static bool kvm_event_expand(struct kvm_event *event, int vcpu_id)
>>> +{
>>> +    int old_max_vcpu = event->max_vcpu;
>>> +
>>> +    if (vcpu_id < event->max_vcpu)
>>> +        return true;
>>> +
>>> +    while (event->max_vcpu <= vcpu_id)
>>> +        event->max_vcpu += DEFAULT_VCPU_NUM;
>>> +
>>> +    event->vcpu = realloc(event->vcpu,
>>> +                  event->max_vcpu * sizeof(*event->vcpu));
>>> +    if (!event->vcpu) {
>>
>> If realloc fails you leak memory by overwriting the current pointer.
> Thanks for pointing it out, we will terminate the running instance in
> our next
> version.

Ok. Make sure to free the memory of the previous pointer on failure 
before cleaning up. The idea is that all allocations are properly freed 
on exit.

>>
>> ---8<---
>>
>>> +static double event_stats_stddev(int vcpu_id, struct kvm_event *event)
>>> +{
>>> +    struct event_stats *stats = &event->total;
>>> +    double variance, variance_mean, stddev;
>>> +
>>> +    if (vcpu_id != -1)
>>> +        stats = &event->vcpu[vcpu_id];
>>> +
>>> +    BUG_ON(!stats->count);
>>> +
>>> +    variance = stats->M2 / (stats->count - 1);
>>> +    variance_mean = variance / stats->count;
>>> +    stddev = sqrt(variance_mean);
>>> +
>>> +    return stddev * 100 / stats->mean;
>>> +}
>>
>> perf should be consistent in the stddev it shows the user. Any reason
>> to dump relative stddev versus stddev used by perf-stat?
> Since 'perf stat' uses relative standard deviation rather than stddev,
> 'perf kvm stat'
> just follows the style of 'perf stat'.

Yes, I've been working on an idea motivated by Andi Kleen. I have 
noticed that perf stat also uses relative stddev just in a non-direct 
way. I suggest moving common stats code from perf-stat to 
utils/stat.[ch], add a rel_stddev_stats function that returns the above 
and have perf-kvm use that.


>> ---8<---
>>
>>> +    /*
>>> +     * Append "-a" only if "-p"/"--pid" is not specified since they
>>> +     * are mutually exclusive.
>>> +     */
>>> +    if (!kvm_record_specified_guest(argc, argv))
>>> +        rec_argv[i++] = STRDUP_FAIL_EXIT("-a");
>>
>> Other perf-kvm commands rely on perf-record semantics -- i.e., for
>> user to add the -a or -p option.
> You mean, remove '-a' from the default options, then:
> if a user wants to record all guest he will use 'perf stat record -a';
> and if a user wants to record the specified guest, he should use
> 'perf stat record -p xxx'?

Yes. Well, 'perf kvm stat record' with a -a or -p. That makes the new 
stat subcommand consistent with just 'perf kvm record'.

>
> Well, as the style of other subcommand, e.g., perf lock/perf sched, the
> 'perf xxx record' record all events on all cpus, no need to use '-a'.
>
> Based on mentioned above, I prefer the original way. ;)

Yes, I noticed that some commands add -a before calling cmd_record(). 
Can't change that but we can keep perf-kvm consistent with its own 
variants which means not automagically adding -a.

David
