Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab0CXDOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 23:14:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098Ab0CXDOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 23:14:19 -0400
Message-ID: <4BA9844E.8020204@redhat.com>
Date: Tue, 23 Mar 2010 23:17:34 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Li Zefan <lizf@cn.fujitsu.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] tracing: Convert some signal events to DEFINE_TRACE
References: <4BA97FA7.6040406@cn.fujitsu.com>	 <4BA97FBD.8070703@cn.fujitsu.com> <1269400070.2957.1943.camel@gandalf.stny.rr.com>
In-Reply-To: <1269400070.2957.1943.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2010-03-24 at 10:58 +0800, Li Zefan wrote:
>> Use DECLARE_EVENT_CLASS to remove duplicate code:
>>
>> text    data     bss     dec     hex filename
>>   23639    6084       8   29731    7423 kernel/signal.o.orig
>>   22727    6084       8   28819    7093 kernel/signal.o

Nice :)

>>
>> 2 events are converted:
>>
>>   signal_queue_overflow: signal_overflow_fail, signal_lose_info
>>
> 
> Masami,
> 
> Can I get your Acked-by for this.

Sure,

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

Thank you,

> 
> Thanks,
> 
> -- Steve
> 
>> No functional change.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  include/trace/events/signal.h |   52 +++++++++++++++++-----------------------
>>  1 files changed, 22 insertions(+), 30 deletions(-)
>>
>> diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
>> index a510b75..814566c 100644
>> --- a/include/trace/events/signal.h
>> +++ b/include/trace/events/signal.h
>> @@ -100,18 +100,7 @@ TRACE_EVENT(signal_deliver,
>>  		  __entry->sa_handler, __entry->sa_flags)
>>  );
>>  
>> -/**
>> - * signal_overflow_fail - called when signal queue is overflow
>> - * @sig: signal number
>> - * @group: signal to process group or not (bool)
>> - * @info: pointer to struct siginfo
>> - *
>> - * Kernel fails to generate 'sig' signal with 'info' siginfo, because
>> - * siginfo queue is overflow, and the signal is dropped.
>> - * 'group' is not 0 if the signal will be sent to a process group.
>> - * 'sig' is always one of RT signals.
>> - */
>> -TRACE_EVENT(signal_overflow_fail,
>> +DECLARE_EVENT_CLASS(signal_queue_overflow,
>>  
>>  	TP_PROTO(int sig, int group, struct siginfo *info),
>>  
>> @@ -135,6 +124,24 @@ TRACE_EVENT(signal_overflow_fail,
>>  );
>>  
>>  /**
>> + * signal_overflow_fail - called when signal queue is overflow
>> + * @sig: signal number
>> + * @group: signal to process group or not (bool)
>> + * @info: pointer to struct siginfo
>> + *
>> + * Kernel fails to generate 'sig' signal with 'info' siginfo, because
>> + * siginfo queue is overflow, and the signal is dropped.
>> + * 'group' is not 0 if the signal will be sent to a process group.
>> + * 'sig' is always one of RT signals.
>> + */
>> +DEFINE_EVENT(signal_queue_overflow, signal_overflow_fail,
>> +
>> +	TP_PROTO(int sig, int group, struct siginfo *info),
>> +
>> +	TP_ARGS(sig, group, info)
>> +);
>> +
>> +/**
>>   * signal_lose_info - called when siginfo is lost
>>   * @sig: signal number
>>   * @group: signal to process group or not (bool)
>> @@ -145,28 +152,13 @@ TRACE_EVENT(signal_overflow_fail,
>>   * 'group' is not 0 if the signal will be sent to a process group.
>>   * 'sig' is always one of non-RT signals.
>>   */
>> -TRACE_EVENT(signal_lose_info,
>> +DEFINE_EVENT(signal_queue_overflow, signal_lose_info,
>>  
>>  	TP_PROTO(int sig, int group, struct siginfo *info),
>>  
>> -	TP_ARGS(sig, group, info),
>> -
>> -	TP_STRUCT__entry(
>> -		__field(	int,	sig	)
>> -		__field(	int,	group	)
>> -		__field(	int,	errno	)
>> -		__field(	int,	code	)
>> -	),
>> -
>> -	TP_fast_assign(
>> -		__entry->sig	= sig;
>> -		__entry->group	= group;
>> -		TP_STORE_SIGINFO(__entry, info);
>> -	),
>> -
>> -	TP_printk("sig=%d group=%d errno=%d code=%d",
>> -		  __entry->sig, __entry->group, __entry->errno, __entry->code)
>> +	TP_ARGS(sig, group, info)
>>  );
>> +
>>  #endif /* _TRACE_SIGNAL_H */
>>  
>>  /* This part must be outside protection */
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com

