Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505Ab1CCOUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 09:20:07 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:18594 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758478Ab1CCOTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 09:19:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACIyb02rRN+K/2dsb2JhbACmZXSjDpwfhWEEhRqHEoNC
X-IronPort-AV: E=Sophos;i="4.62,258,1297036800"; 
   d="scan'208";a="268828650"
Message-ID: <4D6FA39A.60203@cisco.com>
Date: Thu, 03 Mar 2011 07:20:10 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 3/3] perf script: dump software events and samples from
 hardware-based profiling
References: <1299086960-26964-1-git-send-email-daahern@cisco.com> <1299086960-26964-4-git-send-email-daahern@cisco.com> <20110303030515.GD1946@nowhere>
In-Reply-To: <20110303030515.GD1946@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/02/2011 08:05 PM, Frederic Weisbecker wrote:
> On Wed, Mar 02, 2011 at 10:29:20AM -0700, David Ahern wrote:
>> @@ -763,6 +783,18 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
>>  		exit(-1);
>>  	}
>>  
>> +	if (no_callchain)
>> +		symbol_conf.use_callchain = false;
>> +
>> +	else {
>> +		symbol_conf.use_callchain = true;
>> +		if (callchain_register_param(&callchain_param) < 0) {
> 
> That call doesn't seem needed. Register callchain params is only useful
> for later callchain sorting.

ok. I see that now. I'll remove.

> 
>> +			error("Can't register callchain params\n");
>> +			err = -EINVAL;
>> +			goto out;
>> +		}
>> +	}
>> +
>>  	if (rec_script_path)
>>  		script_path = rec_script_path;
>>  	if (rep_script_path)
> [...]
>> +void perf_session__print_sample(union perf_event *event,
>> +				struct perf_sample *sample,
>> +				struct perf_session *session,
>> +				struct perf_event_attr *attr,
>> +				bool show_unresolved)
>> +{
>> +	struct callchain_cursor_node *node, *prev;
>> +	struct addr_location al;
>> +	const char *evname = NULL;
>> +	const char *comm;
>> +	const char *symname, *dsoname;
>> +	u32 cpu = -1;
>> +	u64 secs = 0, usecs = 0;
>> +
>> +	if (perf_event__preprocess_sample(event, session, &al, sample,
>> +					  NULL) < 0) {
>> +		error("problem processing %d event, skipping it.\n",
>> +			event->header.type);
>> +		return;
>> +	}
>> +
>> +	if (session->sample_type & PERF_SAMPLE_TIME) {
>> +		u64 nsecs = sample->time;
>> +		secs = nsecs / NSECS_PER_SEC;
>> +		nsecs -= secs * NSECS_PER_SEC;
>> +		usecs = nsecs / NSECS_PER_USEC;
>> +	}
>> +
>> +   	evname = __event_name(attr->type, attr->config);
>> +	if  (!evname)
>> +		evname = "(unknown)";
>> +
>> +	comm = al.thread->comm_set ? al.thread->comm : "-";
>> +
>> +	if (attr->sample_type & PERF_SAMPLE_CPU)
>> +		cpu = sample->cpu;
>> +
>> +	if (symbol_conf.use_callchain && sample->callchain) {
>> +
>> +		if (perf_session__resolve_callchain(session, al.thread,
>> +						sample->callchain, NULL) != 0) {
>> +			if (verbose)
>> +				error("Failed to resolve callchain. Skipping\n");
>> +			return;
>> +		}
>> +
>> +		node = session->callchain_cursor.first;
>> +		if (!node)
>> +			return;
>> +
>> +		while (node) {
>> +			if (node->sym && node->sym->name)
>> +				symname = node->sym->name;
>> +			else if (show_unresolved)
>> +				symname = "";
>> +			else
>> +				goto next;
>> +
>> +			if (node->map && node->map->dso && node->map->dso->name)
>> +				dsoname = node->map->dso->name;
>> +			else if (show_unresolved)
>> +				dsoname = "";
>> +			else
>> +				goto next;
>> +
>> +			print_one_symbol(comm, al.thread->pid, cpu, secs, usecs,
>> +			             evname, node->ip, symname, dsoname);
>> +
>> +next:
>> +			prev = node;
>> +			node = node->next;
> 
> Hmm, that's a wrong way of walking through callchains. In fact it's not
> a classical list. node->next can be a ghost entry from a previous callchain
> that we kept cached in order to optimize allocations.
> 
> You need the accessors callchain_cursor_current() and callchain_cursor_advance().

Ok. I'll look at perf-report's callchain_append again.

David
