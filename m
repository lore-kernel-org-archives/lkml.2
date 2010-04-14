Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab0DNUlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 16:41:25 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:17457 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab0DNUlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 16:41:22 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIvFxUurR7Ht/2dsb2JhbACbWHGkHJoHhQ0E
X-IronPort-AV: E=Sophos;i="4.52,206,1270425600"; 
   d="scan'208";a="115330573"
Message-ID: <4BC6286F.6030308@cisco.com>
Date: Wed, 14 Apr 2010 16:41:19 -0400
From: David VomLehn <dvomlehn@cisco.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Davi Howells <dhowells@redhat.com>
CC: to@dvomlehn-lnx2.corp.sa.net, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: Re: [PATCH 1/23] Make register values available to panic notifiers
References: <20100412060609.GA25273@dvomlehn-lnx2.corp.sa.net> <24048.1271070978@redhat.com>
In-Reply-To: <24048.1271070978@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> David VomLehn <dvomlehn@cisco.com> wrote:
>
>   
>> +NORET_TYPE void panic(const char *fmt, ...)
>> +{
>> +	va_list args;
>> +	const struct pt_regs *regs;
>> +	int i;
>> +
>> +	preempt_disable();
>> +	bust_spinlocks(1);
>> +	regs = save_ptregs(&__get_cpu_var(panic_panic_regs));
>> +	va_start(args, fmt);
>> +	vpanic_with_regs(regs, fmt, args);
>> +	/* Since vpanic_with_regs doesn't return, we skip va_end() */
>> +	/* Infinite loop so compiler doesn't complain about this returning */
>> +	for (i = 0; ; )
>> +		mdelay(1);
>> +}
>>     
>
> Can the use of va_start() clobber lots of registers, thereby rendering the
> exercise pointless on some arches?
>   
The implementations I'm familiar with only need one or two registers. 
What it
*does* do is to force the contents of registers being used to pass 
argument values
onto the stack. This is roughly what gcc does for asm() statements when you
tell it registers are clobbered.
> Also, can the save_ptregs() function be out of line asm?  The FRV constructed
> inline statement is huge (and wrong).
>   

With this implementation it has to be inline. One use of the saved 
registers is to
backtrace the stack. If  you call a function to save the registers, the 
stack pointer
and program counter would be those of the called function, which will not be
valid after it returns. I expect that you could come up with an alternative
out-of-line function--on every processor I know, you could backtrace one 
frame
to get reasonable values for those registers,. Unfortunately, you would 
run the
risk of clobbering other registers by doing the function call. The more you
change register values from those in the function that calls panic(), 
the less
useful this becomes. In this case, I think an inline function is worth the
effort to get working. (I'd be interested in know more details about how
tshings are broken in the FRV)
> David
>   

