Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938Ab1EBOCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 10:02:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61144 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358Ab1EBOCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 10:02:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nrnaASw/MsEn/IpnJTTYAwBiww8gs2Rc4Hijktt7pnYlgRBk3RP3njPXW07m0bUWBl
         2YW8a9J5J1LghaGQXKQf4PuC/wvG+SMeTRr5XciD+aIbGuylc5IhN/yUZvsyRddTtlMO
         qm339DqbbNzckIUEkk3LETwvS3g7VjkHrAiVg=
Message-ID: <4DBEB96A.8000309@openvz.org>
Date: Mon, 02 May 2011 18:02:18 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] x86, x2apic: minimize IPI register writes using cluster
 groups v4
References: <20110502113445.751391656@openvz.org> <20110502114024.222582172@openvz.org> <20110502132232.GA3873@elte.hu>
In-Reply-To: <20110502132232.GA3873@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2011 05:22 PM, Ingo Molnar wrote:
> 
> * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
>> In the case of x2apic cluster mode we can group
>> IPI register writes based on the cluster group
>> instead of individual per-cpu destiantion messages.
> 
> typo.
> 

ok, will fix, thanks.

>> This reduces the apic register writes and reduces
>> the amount of IPI messages (in the best case we can
>> reduce it by a factor of 16).
>>
>> With this change, microbenchmark measuring the cost
>> of flush_tlb_others(), with the flush tlb IPI being
>> sent from a cpu in the socket-1 to all the logical
>> cpus in socket-2 (on a Westmere-EX system that has
>> 20 logical cpus in a socket) is 3x times better now
>> (compared to the former 'send one-by-one' algorithm).
> 
> What kind of microbenchmark was this, could the actual results and measurement 
> methods be shared as well?

Suresh, could you please post the microbenchmark?
...
>> Index: tip-linux-2.6/arch/x86/kernel/apic/probe_64.c
>> ===================================================================
>> --- tip-linux-2.6.orig/arch/x86/kernel/apic/probe_64.c
>> +++ tip-linux-2.6/arch/x86/kernel/apic/probe_64.c
>> @@ -55,6 +55,15 @@ static int apicid_phys_pkg_id(int initia
>>  void __init default_setup_apic_routing(void)
>>  {
>>  
>> +	/*
>> +	 * FIXME:
>> +	 *
>> +	 * Cleanup the apic routing selection by having an apic driver specific
>> +	 * selection routine. Then all we need to do here is iterate through
>> +	 * them to finalize the apic selection. That would get rid of the
>> +	 * ifdef mess and most of the code here.
>> +	 */
>> +
>>  	enable_IR_x2apic();
>>  
>>  #ifdef CONFIG_X86_X2APIC
>> @@ -71,7 +80,9 @@ void __init default_setup_apic_routing(v
>>  #endif
>>  
>>  	if (apic == &apic_flat && num_possible_cpus() > 8)
>> -			apic = &apic_physflat;
>> +		apic = &apic_physflat;
>> +	else if (apic == &apic_x2apic_cluster)
>> +		x2apic_init_cpu_notifier();
> 
> 
> Why is there an x2apic specific function in the generic 
> default_setup_apic_routing() function?
> 
> Instead of that it would be cleaner to extend the apic driver functions with an 
> init method, which would be filled in for x2apic and left NULL for the others.
> 
> Thanks,
> 
> 	Ingo

  Ingo, the idea was to merge probe_x.c completely, and put all this not into init()
but rather into apic->probe() or something like that. I don't have a clear picture
in mind yet what the best way would be, so instead of fast designed method I thought
to leave it opencoded with fixme note.

  So lets wait until Suresh post the benchmark and I will make apic->init() meanwhile.

-- 
    Cyrill
