Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab1CUQ2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:28:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42792 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab1CUQ2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:28:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=o7zcb57jITGHmjt+6n5GC9TUT/0hVrFuzIwjeDjAKjWnLXM8yLP/tV1Bb0aCR+YB4o
         wryCppoosxCKfL3Mo2wSlQzlC8zcdG0B7l6Lgh+jQ6aUjkpdAx+4QQQTZQOp6qSSvWdr
         xErr3NEvX7J5LOUY6GPfNIJIFm7hhx9Nz27pQ=
Message-ID: <4D877C4B.9090602@gmail.com>
Date: Mon, 21 Mar 2011 19:26:51 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jack Steiner <steiner@sgi.com>, tglx@linutronix.de, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
References: <20110321160135.GA31562@sgi.com> <20110321161425.GC23614@elte.hu>
In-Reply-To: <20110321161425.GC23614@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2011 07:14 PM, Ingo Molnar wrote:
> 
> * Jack Steiner <steiner@sgi.com> wrote:
> 
>> This fixes a problem seen on UV systems handling NMIs from the node controller.
>> The original code used the DIE notifier as the hook to get to the UV NMI
>> handler. This does not work if performance counters are active - the hw_perf
>> code consumes the NMI and the UV handler is not called.
> 
> Sigh:
> 
>> --- linux.orig/arch/x86/kernel/traps.c	2011-03-21 09:05:43.000000000 -0500
>> +++ linux/arch/x86/kernel/traps.c	2011-03-21 09:13:01.306555675 -0500
>> @@ -57,6 +57,7 @@
>>  #include <asm/mce.h>
>>  
>>  #include <asm/mach_traps.h>
>> +#include <asm/uv/uv.h>
>>  
>>  #ifdef CONFIG_X86_64
>>  #include <asm/x86_init.h>
>> @@ -397,13 +398,16 @@ unknown_nmi_error(unsigned char reason,
>>  static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
>>  {
>>  	unsigned char reason = 0;
>> +	int handled;
>>  
>>  	/*
>>  	 * CPU-specific NMI must be processed before non-CPU-specific
>>  	 * NMI, otherwise we may lose it, because the CPU-specific
>>  	 * NMI can not be detected/processed on other CPUs.
>>  	 */
>> -	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
>> +	handled = uv_handle_nmi(regs, reason);
>> +	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP ||
>> +	    		handled)
>>  		return;
> 
> Such code is extremely ugly. Please *reduce* the number of is_uv_system() type 
> of hacks in core x86 code, not increase it!
> 
> Any reason why a higher priority for the UV NMI handler cannot solve the 'perf 
> eats the NMI' problem?
> 
> Thanks,
> 
> 	Ingo

Yeah, Don has made priority system for NMI notifiers. Need to look in.

-- 
    Cyrill
