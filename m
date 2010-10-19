Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab0JSAtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 20:49:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56239 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756217Ab0JSAtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 20:49:03 -0400
Message-ID: <4CBCEB1D.7010101@cn.fujitsu.com>
Date: Tue, 19 Oct 2010 08:49:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: subrata@linux.vnet.ibm.com, ltp-list@lists.sourceforge.net,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: BUG: dead loop in PowerPC hcall tracepoint (Was: [LTP] [PATCH
 v2] Add ftrace-stress-test to LTP)
References: <4C85A88D.10700@cn.fujitsu.com>	 <1285689961.11429.12.camel@subratamodak.linux.ibm.com>	 <1286954486.4893.15.camel@subratamodak.linux.ibm.com>	 <4CB55FE6.6000604@cn.fujitsu.com> <4CB5615C.4070406@cn.fujitsu.com>	 <4CB59825.7060504@cn.fujitsu.com>	 <1286995066.4893.17.camel@subratamodak.linux.ibm.com>	 <4CBBBCB0.8070406@cn.fujitsu.com> <1287411903.16971.275.camel@gandalf.stny.rr.com>
In-Reply-To: <1287411903.16971.275.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Mon, 2010-10-18 at 11:19 +0800, Li Zefan wrote:
> 
>> This is a dead loop:
>>
>> trace_hcall_entry() -> trace_clock_global() -> trace_hcall_entry() ..
>>
>> And this is a PPC specific bug. Hope some ppc guys will fix it?
>> Or we kill trace_clock_global() if no one actually uses it..
> 
> trace_clock_global() is used by many. I use it (and recommend using it)
> on boxes where the TSC is horribly out of sync, and the trace needs
> synchronization between CPUs.
> 
> The trace_hcall_entry and exit has wrappers already. Just add recursion
> protection there.
> 

Right, I thought of this. But as I have no machine to test, I'll leave
this to others.

> Perhaps something like this:
> 
> (Not compiled nor ran)
> 
> +static DEFINE_PER_CPU(hcall_trace_disable);
> +
>  void hcall_tracepoint_regfunc(void)
>  {
>  	hcall_tracepoint_refcount++;
>  }
> 
>  void hcall_tracepoint_unregfunc(void)
>  {
>  	hcall_tracepoint_refcount--;
>  }
> 
> +int __trace_disable_check(void)
> +{
> +	if (!hcall_tracepoint_refcount)
> +		return 1;
> +
> +	if (get_cpu_var(hcall_trace_disable)) {
> +		put_cpu_var(hcall_trace_disable);
> +		return 1;
> +	}
> +
> +	__get_cpu_var(hcall_trace_disable)++;
> +
> +	return 0;
> +}
> +
> +void __trace_disable_put(void)
> +{
> +	__get_cpu_var(hcall_trace_disable)--;
> +	put_cpu_var(hcall_trace_disable);
> +}
> +
>  void __trace_hcall_entry(unsigned long opcode, unsigned long *args)
>  {
> +	int trace_disable;
> +
> +	if (__trace_disable_check())
> +		return;
> +
>  	trace_hcall_entry(opcode, args);
> +	__trace_disable_put();
>  }
> 
>  void __trace_hcall_exit(long opcode, unsigned long retval,
>  			unsigned long *retbuf)
>  {
> +	if (__trace_disable_check())
> +		return;
> +
>  	trace_hcall_exit(opcode, retval, retbuf);
> +	__trace_disable_put();
>  }
> 
> -- Steve
> 
> 
> 
> 
