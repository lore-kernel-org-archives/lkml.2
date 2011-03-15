Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab1COB4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 21:56:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63309 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab1COB4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 21:56:42 -0400
Message-ID: <4D7EC791.4040003@cn.fujitsu.com>
Date: Tue, 15 Mar 2011 09:57:37 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: hpa@zytor.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, tlb: small cleanup for native_flush_tlb_others
References: <4D7DBBE3.1010104@cn.fujitsu.com> <20110314123355.GA27477@elte.hu>
In-Reply-To: <20110314123355.GA27477@elte.hu>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-15 09:55:22,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-15 09:55:22,
	Serialize complete at 2011-03-15 09:55:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2011 08:33 PM, Ingo Molnar wrote:
> 
> * Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:
> 
>> Use smp_processor_id instead of get_cpu and put_cpu since
>> the caller has already disabled preemption
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> ---
>>  arch/x86/mm/tlb.c |    3 +--
>>  1 files changed, 1 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
>> index 6acc724..92849d0 100644
>> --- a/arch/x86/mm/tlb.c
>> +++ b/arch/x86/mm/tlb.c
>> @@ -211,11 +211,10 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
>>  	if (is_uv_system()) {
>>  		unsigned int cpu;
>>  
>> -		cpu = get_cpu();
>> +		cpu = smp_processor_id();
>>  		cpumask = uv_flush_tlb_others(cpumask, mm, va, cpu);
>>  		if (cpumask)
>>  			flush_tlb_others_ipi(cpumask, mm, va);
>> -		put_cpu();
>>  		return;
> 
> There's multiple callers. Could you please update the changelog with the list of 
> callers and a statement that all of them disable preemption already?
> 

Thanks Ingo, there is the new version.

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH] x86, tlb: small micro-optimization for native_flush_tlb_others

native_flush_tlb_others is called from:
flush_tlb_current_task
flush_tlb_mm
flush_tlb_page

All these functions disable preemption explicitly, so we can use smp_processor_id
instead of get_cpu and put_cpu

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/mm/tlb.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 6acc724..92849d0 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -211,11 +211,10 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 	if (is_uv_system()) {
 		unsigned int cpu;
 
-		cpu = get_cpu();
+		cpu = smp_processor_id();
 		cpumask = uv_flush_tlb_others(cpumask, mm, va, cpu);
 		if (cpumask)
 			flush_tlb_others_ipi(cpumask, mm, va);
-		put_cpu();
 		return;
 	}
 	flush_tlb_others_ipi(cpumask, mm, va);
-- 
1.7.4

