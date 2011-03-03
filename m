Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338Ab1CCOLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 09:11:21 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:17004 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab1CCOLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 09:11:19 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAEMwb02rR7Hu/2dsb2JhbACmZXSjDJwchWEEhRqHEoNCgh8
X-IronPort-AV: E=Sophos;i="4.62,258,1297036800"; 
   d="scan'208";a="273146285"
Message-ID: <4D6FA19A.3040604@cisco.com>
Date: Thu, 03 Mar 2011 07:11:38 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 1/3] perf script: change process_event prototype
References: <1299086960-26964-1-git-send-email-daahern@cisco.com> <1299086960-26964-2-git-send-email-daahern@cisco.com> <20110303024003.GC1946@nowhere>
In-Reply-To: <20110303024003.GC1946@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/02/2011 07:40 PM, Frederic Weisbecker wrote:
> On Wed, Mar 02, 2011 at 10:29:18AM -0700, David Ahern wrote:
>> Prepare for handling of samples for any event type.
>>
>> Signed-off-by: David Ahern <daahern@cisco.com>
>> ---
>>  tools/perf/builtin-script.c                        |   40 +++++++++++--------
>>  .../util/scripting-engines/trace-event-python.c    |   20 ++++++++-
> 
> What about Perl?

Oversight. Stumbled onto it yesterday afternoon. I have the perl module
installed now, so builds will get it too from now on.

> 
>>  tools/perf/util/trace-event-scripting.c            |    8 +--
>>  tools/perf/util/trace-event.h                      |    6 ++-
>>  4 files changed, 47 insertions(+), 27 deletions(-)
>>
>> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
>> index 5f40df6..0bee150 100644
>> --- a/tools/perf/builtin-script.c
>> +++ b/tools/perf/builtin-script.c
>> @@ -20,6 +20,27 @@ static u64			last_timestamp;
>>  static u64			nr_unordered;
>>  extern const struct option	record_options[];
>>  
>> +static void process_event(union perf_event *event,
>> +			  struct perf_sample *sample,
>> +			  struct perf_session *session)
>> +{
>> +	struct thread *thread = perf_session__findnew(session, event->ip.pid);
>> +
>> +	if (thread == NULL) {
>> +		pr_debug("problem processing %d event, skipping it.\n",
>> +			 event->header.type);
>> +		return;
>> +	}
> 
> Seems the thread is needed by any endpoints. It would be better to resolve
> it from process_sample_event and pass it to the process_event() handler.

tracepoints yes; S/W samples no. If you want it I'll add it.

> 
>> +
>> +	/*
>> +	 * FIXME: better resolve from pid from the struct trace_entry
>> +	 * field, although it should be the same than this perf
>> +	 * event pid
>> +	 */
>> +	print_event(sample->cpu, sample->raw_data, sample->raw_size,
>> +		    sample->time, thread->comm);
>> +}
> [...]
>> diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
>> index 2040b85..5b03fb6 100644
>> --- a/tools/perf/util/scripting-engines/trace-event-python.c
>> +++ b/tools/perf/util/scripting-engines/trace-event-python.c
>> @@ -204,9 +204,9 @@ static inline struct event *find_cache_event(int type)
>>  	return event;
>>  }
>>  
>> -static void python_process_event(int cpu, void *data,
>> -				 int size __unused,
>> -				 unsigned long long nsecs, char *comm)
>> +static void python_process_event(union perf_event *pevent,
>> +				struct perf_sample *sample,
>> +				struct perf_session *session)
>>  {
>>  	PyObject *handler, *retval, *context, *t, *obj, *dict = NULL;
>>  	static char handler_name[256];
>> @@ -218,6 +218,20 @@ static void python_process_event(int cpu, void *data,
>>  	int type;
>>  	int pid;
> 
> Please avoid such blank line in the middle of local vars declaration.

ok.

David

> 
>> +	int cpu = sample->cpu;
>> +	void *data = sample->raw_data;
>> +	unsigned long long nsecs = sample->time;
>> +	char *comm;
>> +	struct thread *thread;
>> +
>> +	thread = perf_session__findnew(session, pevent->ip.pid);
>> +	if (thread == NULL) {
>> +		pr_debug("problem processing %d event, skipping it.\n",
>> +			 pevent->header.type);
>> +		return;
>> +	}
>> +	comm = thread->comm;
>> +
