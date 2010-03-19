Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677Ab0CSWDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 18:03:05 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51642 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab0CSWDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 18:03:01 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5925"; a="36832708"
Message-ID: <4BA3F494.2040705@codeaurora.org>
Date: Fri, 19 Mar 2010 18:03:00 -0400
From: Ashwin Chaugule <ashwinc@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Tim Bird <tim.bird@am.sony.com>
CC: "Bird, Tim" <Timothy.Bird@am.sony.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH] Make Function Duration Tracer work with __gnu_mcount_nc
References: <4BA3F000.5030404@codeaurora.org> <4BA3F25C.9000105@am.sony.com>
In-Reply-To: <4BA3F25C.9000105@am.sony.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird wrote:
> On 03/19/2010 02:43 PM, Ashwin Chaugule wrote:
>   
>> Is there a better way to fix this in the original ftrace_graph_caller ?
>> The lr isn't pushed on the stack before "bl mcount".
>>
>> --
>>
>> From: Ashwin Chaugule <ashwinc@quicinc.com>
>>
>> Newer compilers use the __gnu_mcount_nc stub in every function
>> prologue. The lr of the instrumented function is pushed on the
>> stack before branching to __gnu_mcount_nc. Pop it before returning
>> back to instrumented function so that it can return to its parent
>> from its epilogue.
>>
>>
>> Signed-off-by: Ashwin Chaugule <ashwinc@quicinc.com>
>> ---
>>  arch/arm/kernel/entry-common.S |   20 ++++++++++++++++++++
>>  1 files changed, 20 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
>> index b8a9e47..30feac3 100644
>> --- a/arch/arm/kernel/entry-common.S
>> +++ b/arch/arm/kernel/entry-common.S
>> @@ -144,6 +144,14 @@ ENTRY(__gnu_mcount_nc)
>>      adr r0, ftrace_stub
>>      cmp r0, r2
>>      bne gnu_trace
>> +
>> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
>> +    ldr r1, =ftrace_graph_return
>> +    ldr r2, [r1]
>> +    cmp r0, r2        @ if *ftrace_graph_return != ftrace_stub
>> +    bne new_ftrace_graph_caller
>> +#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
>> +
>>      ldmia sp!, {r0-r3, ip, lr}
>>      bx ip
>>  
>> @@ -155,6 +163,18 @@ gnu_trace:
>>      mov pc, r2
>>      ldmia sp!, {r0-r3, ip, lr}
>>      bx ip
>> +
>> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
>> +ENTRY(new_ftrace_graph_caller)        @ for use with __gnu_mcount_nc
>> +    sub r0, fp, #4                    @ &lr of instrumented routine 
>> (&parent)
>> +    mov r1, lr                        @ instrumented routine (func)
>> +    sub r1, r1, #MCOUNT_INSN_SIZE
>> +    mov r2, fp                        @ frame pointer
>> +    bl prepare_ftrace_return
>> +    ldmia sp!, {r0-r3, ip, lr}        @ need to pop lr, pushed before
>> +    mov pc, ip                        @ bl __gnu_mcount_nc
>> +
>> +#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
>>     
>>  ENTRY(mcount)
>>      stmdb sp!, {r0-r3, lr}
>>     
>
> Wow, interesting timing.  I just finished yesterday my own
> version of this patch (for 2.6.29) - it looks amazingingly similar.
>
> What's up with putting fp in r2 - is that required in the latest
> prepare_ftrace_return()?
>  -- Tim
>   
:D
I had to wait for legal clearance ;)

mov r2, fp is there in your patches on 
http://elinux.org/Ftrace_Function_Graph_ARM. I'm using this for 2.6.31.
It seemed fishy to me as well, since you don't really change the fp, so 
it should remain intact when control returns to the epilogue of the 
instrumented function.


> ------------- patch follows ----------------
> Add support to __gnu_mcount_nc, used by newer (4.x?) Gnu compilers,
> for ftrace function_graph support on ARM.
>
> Signed-off-by: Tim Bird <tim.bird@am.sony.com>
> ---
>  arch/arm/kernel/entry-common.S |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> --- a/arch/arm/kernel/entry-common.S
> +++ b/arch/arm/kernel/entry-common.S
> @@ -140,6 +140,12 @@ ENTRY(__gnu_mcount_nc)
>  	adr r0, ftrace_stub
>  	cmp r0, r2
>  	bne gnu_trace
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +	ldr r1, =ftrace_graph_return
> +	ldr r2, [r1]
> +	cmp r0, r2		@ if *ftrace_graph_return != ftrace_stub
> +	bne gnu_ftrace_graph_caller
> +#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
>  	ldmia sp!, {r0-r3, ip, lr}
>  	bx ip
>
> @@ -196,6 +202,13 @@ return_to_handler:
>  	ldmia sp!, {r0-r3}
>  	mov pc, lr
>
> +ENTRY(gnu_ftrace_graph_caller)
> +	sub r0, fp, #4			@ &lr of instrumented routine (&parent)
> +	sub r1, lr, #MCOUNT_INSN_SIZE	@ instrumented routine (func)
> +	bl prepare_ftrace_return
> +	ldmia sp!, {r0-r3, ip, lr}
> +	bx ip
> +
>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
>
>  #endif /* CONFIG_DYNAMIC_FTRACE */
>
>   

