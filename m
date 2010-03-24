Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0CXBlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 21:41:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60101 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab0CXBlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 21:41:04 -0400
Message-ID: <4BA96DEC.7050007@cn.fujitsu.com>
Date: Wed, 24 Mar 2010 09:42:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: 2.6.33 GP fault only when built with tracing
References: <4BA2B69D.3000309@oracle.com> <1268956555.758.18.camel@gandalf.stny.rr.com> <20100319005901.GB23020@Krystal> <4BA3C0CF.6070005@oracle.com> <20100319184610.GA29161@Krystal> <20100323082643.dbf77c46.randy.dunlap@oracle.com> <20100324012053.GA17187@Krystal>
In-Reply-To: <20100324012053.GA17187@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Randy Dunlap (randy.dunlap@oracle.com) wrote:
>> On Fri, 19 Mar 2010 14:46:10 -0400 Mathieu Desnoyers wrote:
>>
>>> * Randy Dunlap (randy.dunlap@oracle.com) wrote:
>>>> On 03/18/10 17:59, Mathieu Desnoyers wrote:
>>>>> * Steven Rostedt (rostedt@goodmis.org) wrote:
>>>>>> On Thu, 2010-03-18 at 16:26 -0700, Randy Dunlap wrote:
>>>>>>> I can build/boot 2.6.33 with CONFIG_TRACE/TRACING disabled successfully,
>>>>>>> but when I enable lots of tracing config options and then boot with
>>>>>>> ftrace=nop on the kernel command line, I see a GP fault when the parport &
>>>>>>> parport_pc modules are loading/initializing.
>>>>>> Do you see it without adding the "ftrace=nop"? The only thing that
>>>>>> should do is expand the ring buffer on boot up.
>>>>>>
>>>>>>> It happens in drivers/parport/share.c::parport_register_device(), when that
>>>>>>> function calls try_module_get().
>>>>>>>
>>>>>>> If I comment out the trace_module_get() calls in include/linux/module.h,
>>>>>>> the kernel boots with no problems.
>>>>>>
>>>>>> Interesting. Well, trace_module_get() is a TRACE_EVENT tracepoint. But
>>>>>> should be disabled here. It may be something to do with DEFINE_TRACE. 
>>>>>>
>>>>>> (added Mathieu to Cc since he wrote that code)
>>>>> can you try replacing the "local_read(__module_ref_addr(module, cpu))" argument
>>>>> with "0" ?
>>>> Yes, that boots with no problems.
>>> clickety-clicketa... git blame include/linux/module.h :
>>>
>>> commit 7ead8b8313d92b3a69a1a61b0dcbc4cd66c960dc
>>> Author: Li Zefan <lizf@cn.fujitsu.com>
>>> Date:   Mon Aug 17 16:56:28 2009 +0800
>>>
>>>     tracing/events: Add module tracepoints
>>>
>>> (Adding Li Zefan in CC)
>>>
>>> Two things:
>>>
>>> 1) In this commit, most of the tracepoints contain argument with side-effects.
>>>    These do not belong there; they should be moved into TRACE_EVENT macros.
>>>
>>> 2) There seem to be a null-pointer bug with
>>>    local_read(__module_ref_addr(module, cpu)) in try_module_get(). This should
>>>    be investigated even if we move the argument to TRACE_EVENT.
>> Hi Li,
>>
>> Fix this, please?
>>
> 
> While we wait for the sun to move to other time zones, can you check if the
> following patch fixes your problem ?
> 

Sorry, I overlooked this mail thread..

I'll make a patch to move side-effects arguments from trace_module_xxx()
to the definition of TRACE_EVENT().

But it's for reducing overhead when tracepoints are disabled, this should
not be the real cultprit of the bug here.

> 
> module: fix __module_ref_addr()
> 
> __module_ref_addr() should use per_cpu_ptr() to obfuscate the pointer
> (RELOC_HIDE is needed for per cpu pointers).
> 
> This non-standard per-cpu pointer use has been introduced by commit
> 720eba31f47aeade8ec130ca7f4353223c49170f
> 

So the uptream kernel is free from this bug, because __module_ref_addr()
has gone.

> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Eric Dumazet <dada1@cosmosbay.com>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  include/linux/module.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6-lttng/include/linux/module.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/linux/module.h	2010-03-23 18:11:14.000000000 -0400
> +++ linux-2.6-lttng/include/linux/module.h	2010-03-23 18:14:07.000000000 -0400
> @@ -467,7 +467,7 @@ void symbol_put_addr(void *addr);
>  static inline local_t *__module_ref_addr(struct module *mod, int cpu)
>  {
>  #ifdef CONFIG_SMP
> -	return (local_t *) (mod->refptr + per_cpu_offset(cpu));
> +	return (local_t *) per_cpu_ptr(mod->refptr, cpu);
>  #else
>  	return &mod->ref;
>  #endif
> 
> 
