Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab2LUK4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 05:56:25 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:45389 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab2LUK4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 05:56:19 -0500
X-AuditID: 85900ec0-d5e7ab900000152f-bc-50d4405050c3
Message-ID: <50D4403C.8040708@hitachi.com>
Date: Fri, 21 Dec 2012 19:55:56 +0900
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: masami.hiramatsu.pt@hitachi.com, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH v3 -tip 2/4] tracing: replace static old_tracer with strcmp
References: <20121219070218.31200.64647.stgit@liselsia>  <20121219070243.31200.73060.stgit@liselsia> <1356059062.5896.87.camel@gandalf.local.home>
In-Reply-To: <1356059062.5896.87.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(12/21/2012 12:04 PM), Steven Rostedt wrote:
> On Wed, 2012-12-19 at 16:02 +0900, Hiraku Toyooka wrote:
>> Currently, read functions for trace buffer use static "old_tracer"
>> for detecting changes of current tracer. This is because we can
>> assume that these functions are used from only one file ("trace").
>>
>> But we are adding snapshot feature for ftrace, then those functions
>> are called from two files. So we remove all static "old_tracer", and
>> replace those with string comparison between current and previous
>> tracers.
>
> I reworded what you wrote:
>

Thank you very much.

> ---
> Currently the trace buffer read functions use a static variable
> "old_tracer" for detecting if the current tracer changes. This was
> suitable for a single trace file ("trace"), but to add a snapshot
> feature that will use the same function for its file, a check against
> a static variable is not sufficient.
>
> To use the output functions for two different files, instead of storing
> the current tracer in a static variable, as the trace iterator
> descriptor
> contains a pointer to the original current tracer's name, that pointer
> can now be used to check if the current tracer has changed between
> different reads of the trace file.
> ---
>
> And I also realized a more efficient approach.
>
>>
>> Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>   kernel/trace/trace.c |   18 ++++++------------
>>   1 file changed, 6 insertions(+), 12 deletions(-)
>>
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index a8ce008..8d05a44 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -1948,7 +1948,6 @@ void tracing_iter_reset(struct trace_iterator *iter, int cpu)
>>   static void *s_start(struct seq_file *m, loff_t *pos)
>>   {
>>   	struct trace_iterator *iter = m->private;
>> -	static struct tracer *old_tracer;
>>   	int cpu_file = iter->cpu_file;
>>   	void *p = NULL;
>>   	loff_t l = 0;
>> @@ -1956,10 +1955,9 @@ static void *s_start(struct seq_file *m, loff_t *pos)
>>
>>   	/* copy the tracer to avoid using a global lock all around */
>>   	mutex_lock(&trace_types_lock);
>> -	if (unlikely(old_tracer != current_trace && current_trace)) {
>> -		old_tracer = current_trace;
>> +	if (unlikely(current_trace &&
>> +		     strcmp(iter->trace->name, current_trace->name) != 0))
>>   		*iter->trace = *current_trace;
>
> As iter->trace is a copy of current_trace, it points to everything that
> the current_trace pointed to. As the current_trace->name is a pointer to
> a const char string that never changes, we don't need to do the strcmp()
> you can simply do a direct comparison:
>
> 	if (unlikely(current_trace && iter->trace->name != current_trace->name)) {
>

Yes. I'll update my patch to use this efficient way.

> I would add a comment about that too:
> 	/*
> 	 * iter->trace is a copy of current_trace, the pointer to the
> 	 * name may be used instead of a strcmp(), as iter->trace->name
> 	 * will point to the same string as current_trace->name.
> 	 */

OK. I'll include this comment in my patch.


Thanks,
Hiraku Toyooka

