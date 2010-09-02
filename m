Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab0IBBPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 21:15:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56573 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754042Ab0IBBPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 21:15:39 -0400
Message-ID: <4C7EFBE6.3040408@cn.fujitsu.com>
Date: Thu, 02 Sep 2010 09:20:38 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        kvm-devel <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ftrace/perf_event leak
References: <4C7E11E5.1040402@redhat.com> <1283331868.2059.808.camel@laptop> <4C7E1C36.6070400@redhat.com> <4C7E1F12.8030304@cn.fujitsu.com> <4C7E2D1D.3080603@redhat.com> <1283338977.2059.938.camel@laptop> <20100901121518.GA5378@nowhere>
In-Reply-To: <20100901121518.GA5378@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Subject: perf, trace: Fix module leak
>> From: Li Zefan <lizf@cn.fujitsu.com>
>> Date: Wed Sep 01 12:58:43 CEST 2010
>>
>> Commit 1c024eca (perf, trace: Optimize tracepoints by using
>> per-tracepoint-per-cpu hlist to track events) caused a module refcount
>> leak.
>>
>> Tested-by: Avi Kivity <avi@redhat.com>
>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> LKML-Reference: <4C7E1F12.8030304@cn.fujitsu.com>
>> ---
>>  kernel/trace/trace_event_perf.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> Index: linux-2.6/kernel/trace/trace_event_perf.c
>> ===================================================================
>> --- linux-2.6.orig/kernel/trace/trace_event_perf.c
>> +++ linux-2.6/kernel/trace/trace_event_perf.c
>> @@ -91,6 +91,8 @@ int perf_trace_init(struct perf_event *p
>>  		    tp_event->class && tp_event->class->reg &&
>>  		    try_module_get(tp_event->mod)) {
>>  			ret = perf_trace_event_init(tp_event, p_event);
>> +			if (ret)
>> +				module_put(tp_event->mod);
>>  			break;
>>  		}
>>  	}
>> @@ -147,6 +149,7 @@ void perf_trace_destroy(struct perf_even
>>  		}
>>  	}
>>  out:
>> +	module_put(tp_event->mod);
>>  	mutex_unlock(&event_mutex);
>>  }
>>  
>>
> 
> Thanks for fixing this.
> 
> However, can we split this in two patches to ease the backport?
> 
> The lack of a module_put() after perf_trace_init() failure is there for a while
> (the backport needs to start in 2.6.32).

The failure should be a rare case, I don't think this has to be backported?

> 
> But the lack of a module_put in the destroy path needs a .35 backport only.
> 

