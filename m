Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab2AQCa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 21:30:27 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:43380 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2AQCaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 21:30:25 -0500
Message-ID: <4F14DD39.5000703@linux.vnet.ibm.com>
Date: Tue, 17 Jan 2012 10:30:17 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: perf: kvm events analysis tool
References: <4F13EE3D.2070602@linux.vnet.ibm.com> <4F13EEC5.8050807@linux.vnet.ibm.com> <4F13F631.9010804@redhat.com>
In-Reply-To: <4F13F631.9010804@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011702-9574-0000-0000-000000F8CB44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2012 06:04 PM, Avi Kivity wrote:

> On 01/16/2012 11:32 AM, Xiao Guangrong wrote:
>> Add 'perf kvm-events' support to analyze kvm vmexit/mmio/ioport smartly
>>
>> Usage:
>> 	perf kvm-events record
> 
> Why not 'perf record -e kvm'?


It works, many perf tools have this style, like:
perf lock record,
perf sched record,
perf kmem record,

I think the reason is that only enable the tracepoints we need to avoid
unnecessary overload so that the result is more exacter.

> 
>> 	perf kvm-events report
> 
> 
> 
>> +static const char *get_exit_reason(long isa, u64 exit_code)
>> +{
>> +	int table_size = ARRAY_SIZE(svm_exit_reasons);
>> +	struct exit_reasons_table *table = svm_exit_reasons;
>> +
>> +
>> +	if (isa == 1) {
>> +		table = vmx_exit_reasons;
>> +		table_size = ARRAY_SIZE(vmx_exit_reasons);
>> +	}
>> +
>> +	while (table_size--) {
>> +		if (table->exit_code == exit_code)
>> +			return table->reason;
> 
> ... table[exit_code] ...
> 


Actually, this array is not indexed by exit_code, it means:
table[exit_code].exit_code != exit_code.

>> +		table++;
>> +	}
>> +
>> +	die("unkonw kvm exit code:%ld on %s\n", exit_code, isa == 1 ?
>> +						"VMX" : "SVM");
> 
> "unknown"
> 


......

>> +
>> +struct kvm_events_ops {
>> +	bool (*is_begain_event)(struct event *event, void *data);
> 
> begin
> 


Sorry for my careless.

>> +	bool (*is_end_event)(struct event *event);
>> +	struct event_key (*get_key)(struct event *event, void *data);
>> +	void (*decode_key)(struct event_key *key, char decode[20]);
>> +	const char *name;
>> +};
>> +
>> +
>> +static struct event_key exit_event_get_key(struct event *event, void *data)
>> +{
>> +	struct event_key key;
>> +
>> +	key.key = raw_field_value(event, "exit_reason", data);
>> +	key.info = raw_field_value(event, "isa", data);
> 
> "isa" is not available on all kernel versions; need to fall back to
> /proc/cpuid detection.
> 


Got it, will do it in the next version. Thanks Avi!

