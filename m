Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab0JYBbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 21:31:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59379 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752389Ab0JYBba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 21:31:30 -0400
Message-ID: <4CC4DE25.1020408@cn.fujitsu.com>
Date: Mon, 25 Oct 2010 09:32:21 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2][GIT PULL] tracing: Prevent unloadable modules from
 using trace_bprintk()
References: <1287668742.16971.585.camel@gandalf.stny.rr.com>	 <201010221413.28588.rusty@rustcorp.com.au>	 <1287719918.16971.615.camel@gandalf.stny.rr.com>	 <201010221504.51535.rusty@rustcorp.com.au>	 <4CC1218E.9090104@cn.fujitsu.com> <1287755374.16971.629.camel@gandalf.stny.rr.com>
In-Reply-To: <1287755374.16971.629.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Fri, 2010-10-22 at 13:30 +0800, Li Zefan wrote:
> 
>> In fact tracepoint is free from this bug, because we'll empty the ring
>> buffer if the unloading module has tracepoints in it.
> 
> Hehe, and I should know, I wrote that code :-)
> 

I reported that bug. ;)

> 
>> So for trace_bprintk, why can't we do the same thing? If a module has
>> trace_bprintk calls in it, just empty the ring buffer when unloading
>> module.
>>
>> And that's as simple as something like this:
>>
>> diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
>> index 2547d88..103987f 100644
>> --- a/kernel/trace/trace_printk.c
>> +++ b/kernel/trace/trace_printk.c
>> @@ -80,6 +80,13 @@ static int module_trace_bprintk_format_notify(struct notifier_block *self,
>>  
>>  		if (val == MODULE_STATE_COMING)
>>  			hold_module_trace_bprintk_format(start, end);
>> +		else if (val == MODULE_STATE_GOING) {
>> +			/*
>> +			 * It is safest to reset the ring buffer if the
>> +			 * module being unloaded uses trace_bprintk.
>> +			 */
>> +			tracing_reset_current_online_cpus();
>> +		}
>>  	}
>>  	return 0;
>>  }
> 
> This could definitely work.
> 
> But this prevents developers using trace_printk() in their exit() code.
> We should probably add a trace_mod_printk() or something that just
> forces the slow version that does not require flushing the ring buffer
> on removal. As long as there's not a single trace_printk() in the
> module, and it only uses the alternative, then this should work.
> 

Agreed. Add this trace_mod_printk() and add some comments to
explain why and when use it.
