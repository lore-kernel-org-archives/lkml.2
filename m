Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab1KRInX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 03:43:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab1KRInX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 03:43:23 -0500
Message-ID: <4EC61B2A.7010000@redhat.com>
Date: Fri, 18 Nov 2011 16:45:30 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: tim@edgecast.com
CC: WANG Cong <xiyou.wangcong@gmail.com>, Tejun Heo <tj@kernel.org>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Crash during vmcore_init
References: <1318376345.2050.20.camel@boudreau>	 <j9r5m5$b18$1@dough.gmane.org>	<1321296650.2066.17.camel@boudreau>	 <4EC21F67.10905@redhat.com>	<1321396371.4198.5.camel@boudreau>	 <4EC31E55.6040809@redhat.com>	<1321467647.2137.4.camel@boudreau>	 <4EC47FCA.5090908@redhat.com>	 <CAOS58YMOuJrvGxE1VxsU=ZPTLgY60HDJoLFjTowx9ZApUQ3tTw@mail.gmail.com>	 <4EC491B3.705@redhat.com>	 <CAMMEr5k_ynqg5-7Looar2DxXTGZcMqi5Lo+jtETn9awO_bsaGg@mail.gmail.com>	 <4EC4B60C.3030706@redhat.com> <1321548033.12208.12.camel@boudreau> <4EC61AB6.4090808@redhat.com>
In-Reply-To: <4EC61AB6.4090808@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 04:43 PM, Dave Young wrote:

> On 11/18/2011 12:40 AM, Tim Hartrick wrote:
> 
>>
>> Dave, Tejun, Americo,
>>
>> Attached find three configs:
>>
>> Ubuntu 2.6.32-21-server - works
>> Ubuntu 2.6.38-8-server - fails
>> Ubuntu 3.3.1-030101-generic (stable) - fails
> 
> 
> Thanks, Tim
> 
>>
>> On Thu, 2011-11-17 at 15:21 +0800, Dave Young wrote:
>>> On 11/17/2011 01:22 PM, Tim Hartrick wrote:
>>>
>>>> Tejun, Dave,
>>>>
>>>> I will be happy to answer any questions about our environment or test
>>>> debug or other patches.  Just tell me what you need.
>>>
>>>
>>> Thank you. Can you share your kernel config?
>>>
>>>>
>>>> tim
>>>>
>>>> On Nov 16, 2011 8:44 PM, "Dave Young" <dyoung@redhat.com
>>>> <mailto:dyoung@redhat.com>> wrote:
>>>>
>>>>     On 11/17/2011 12:34 PM, Tejun Heo wrote:
>>>>
>>>>     > Hello,
>>>>     >
>>>>     > On Wed, Nov 16, 2011 at 7:30 PM, Dave Young <dyoung@redhat.com
>>>>     <mailto:dyoung@redhat.com>> wrote:
>>>>     >> This addr is converted to an invalid phys address,
>>>>     >
>>>>     > I'm a bit lost on the context here. Who's calling
>>>>     per_cpu_ptr_to_phys()?
>>>>
>>>>
>>>>     It's drivers/base/cpu.c : show_crash_notes()
>>>>
>>>>     >
>>>>     >> looking the code below:
>>>>     >>       if (in_first_chunk) {
>>>>     >>                if (!is_vmalloc_addr(addr))
>>>>     >>                        return __pa(addr);
>>>>     >>                else
>>>>     >>                        return page_to_phys(vmalloc_to_page(addr));
>>>>     >>        } else
>>>>     >>                return page_to_phys(pcpu_addr_to_page(addr));
>>>>     >>
>>>>     >> I dont understand per cpu allocation well, if addr is not in
>>>>     first chunk
>>>>     >> then it should be in vmalloc area?
>>>>     >
>>>>     > Yes, it is. First chunk can be embedded in the kernel linear address
>>>>     > space but from the second one, it's always set up from the top of the
>>>>     > vmalloc area with the same offset layout as the first chunk.
>>>>
>>>>
>>>>     in this case ffff880667c19ad0 fall out of vmalloc area and it's not in
>>>>     first chunk also.
> 
> 
> Tejun,
> 
> With config provided by Tim, I can reproduce this problem on a dell
> machine. I did some debug about this, found that fisrt_start <
> first_end, 


typo, I mean first_start > first_end

so there's no chance to check in for_each_possible_cpu(cpu)
> 
> why is the first_start/first_end wrong? pcpu_unit_offsets[] is not
> ordered? any idea?
> 
> I see below hack make the bug gone, it confirmed the addr is indeed in
> first chunk.
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index bf80e55..8f6eb58 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -984,26 +984,14 @@ phys_addr_t per_cpu_ptr_to_phys(void *addr)
>  {
>  	void __percpu *base = __addr_to_pcpu_ptr(pcpu_base_addr);
>  	bool in_first_chunk = false;
> -	unsigned long first_start, first_end;
>  	unsigned int cpu;
> 
> -	/*
> -	 * The following test on first_start/end isn't strictly
> -	 * necessary but will speed up lookups of addresses which
> -	 * aren't in the first chunk.
> -	 */
> -	first_start = pcpu_chunk_addr(pcpu_first_chunk, pcpu_first_unit_cpu, 0);
> -	first_end = pcpu_chunk_addr(pcpu_first_chunk, pcpu_last_unit_cpu,
> -				    pcpu_unit_pages);
> -	if ((unsigned long)addr >= first_start &&
> -	    (unsigned long)addr < first_end) {
> -		for_each_possible_cpu(cpu) {
> -			void *start = per_cpu_ptr(base, cpu);
> -
> -			if (addr >= start && addr < start + pcpu_unit_size) {
> -				in_first_chunk = true;
> -				break;
> -			}
> +	for_each_possible_cpu(cpu) {
> +		void *start = per_cpu_ptr(base, cpu);
> +
> +		if (addr >= start && addr < start + pcpu_unit_size) {
> +			in_first_chunk = true;
> +			break;
>  		}
>  	}
> 
>>>>
>>>>     >
>>>>     >> Tejun, do you have any idea about this?
>>>>     >
>>>>     > Can you please tell me how to reproduce the problem? I'll try to find
>>>>     > out what's going on.
>>>>
>>>>
>>>>     make sure kernel support CRASH DUMP, then cat
>>>>     /sys/devices/system/cpu/cpu[x]/crash_notes
>>>>
>>>>     Tim Hartrick <tim@edgecast.com <mailto:tim@edgecast.com>> reported
>>>>     the problem when test kdump.
>>>>     But I can not reproduce this. I think tim can help to test
>>>>
>>>>     >
>>>>     > Thanks.
>>>>     >
>>>>
>>>>
>>>>
>>>>     --
>>>>     Thanks
>>>>     Dave
>>>>
>>>
>>>
>>>
>>
> 
> 
> 



-- 
Thanks
Dave
