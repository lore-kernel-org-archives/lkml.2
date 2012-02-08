Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab2BHO0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 09:26:41 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56428 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab2BHO0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 09:26:40 -0500
Message-ID: <4F32861C.5020907@gmail.com>
Date: Wed, 08 Feb 2012 07:26:36 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Xiao Guangrong <xiaoguangrong.eric@gmail.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] KVM: perf: kvm events analysis tool
References: <4F3121DE.7020502@linux.vnet.ibm.com> <4F31225C.1020703@gmail.com> <4F316596.3060509@gmail.com> <4F3212CA.4080208@linux.vnet.ibm.com>
In-Reply-To: <4F3212CA.4080208@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/07/2012 11:14 PM, Xiao Guangrong wrote:
> On 02/08/2012 01:55 AM, David Ahern wrote:
> 
>> On 02/07/2012 06:08 AM, Xiao Guangrong wrote:
>>> Add 'perf kvm-events' support to analyze kvm vmexit/mmio/ioport smartly
>>
>> example output?
>>
> 
> 
> You can find a example output at this website:
> 	http://lwn.net/Articles/479069/
> 
> [ Sorry, i did not put it into changlog in the v3 ]

Right, I meant add an example output to the changelog.

> 
>>> +--------
>>> +[verse]
>>> +'perf kvm-events' {record|report}
>>
>> command name is very generic -- kvm-events; but command focus is rather
>> narrow -- I/O events.
>>
> 
> 
> It is not only analysing IO events but also for other events(like vmexit,
> and other events will be added). I prefer to kvm-events :)

Same. kvm-events should be the name of the command. But from the
admittedly not thorough review of the code it seemed to be expecting I/O
(and entry/exit tracepoints as a part of that) and not easily amendable
to add new tracepoints.

---8<---

>>> +
>>> +	vcpu_event_record = zalloc(sizeof(*vcpu_event_record) * kvm_max_vcpus);
>>> +	if (!vcpu_event_record)
>>> +		die("zalloc.\n");
>>> +
>>> +	for (i = 0; i < (int)EVENTS_CACHE_SIZE; i++)
>>> +		INIT_LIST_HEAD(&kvm_events_cache[i]);
>>> +}
>>
>> Really, the caches could be tied to thread structs, and then you don't
>> need a max vcpu style allocation. more below.
>>
> 
> 
> Hmm, this cache is used to cache "event struct", this is the common resources
> for all vcpus.

But consecutive events that are analyzed together happen in the context
of a thread -- the vcpu task.

---8<---

>>> +static int kvm_events_report(int vcpu)
>>> +{
>>> +	init_kvm_event_record();
>>> +	init_kvm_tid_to_pid();
>>> +	verify_vcpu(vcpu);
>>> +	select_key();
>>> +	register_kvm_events_ops();
>>> +	setup_pager();
>>
>> I believe setup_pager is handled by perf.c
>>
> 
> 
> Hmm, i did not find it, could you please tell me where is it?
> And, setup_pager is also used in other tools such 'perf sched',
> 'perf lock'...
> 

run_builtin() --> commit_pager_choice() --> setup_pager()

It could be that the other commands need to be updated.

---8<---

>>> +	if (!strncmp(argv[0], "rec", 3))
>>> +		return kvm_events_record(argc, argv);
>>> +
>>> +	if (!strncmp(argv[0], "report", 6)) {
>>
>> exact match for 'report'?
>>
> 
> 
> It is the style in other tools, what is your suggestion?

Right, I see that. builtin-lock should be fixed.

rec is ok for record; is report123 ok for report? if not that string
should be an exact match.

David
