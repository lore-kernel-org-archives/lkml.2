Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab2BCVH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 16:07:56 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:54466 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757896Ab2BCVHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 16:07:54 -0500
Message-ID: <4F2C5A35.1050407@xenotime.net>
Date: Fri, 03 Feb 2012 14:05:41 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Nick Bowler <nbowler@elliptictech.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Kevin Winchester <kjwinchester@gmail.com>
Subject: Re: MCE, AMD: Hide smp-only code around CONFIG_SMP
References: <1328209817-18913-1-git-send-email-bp@alien8.de> <20120202193702.GA9502@elliptictech.com> <20120202202427.GA2234@x1.osrc.amd.com> <20120203191801.GA2846@x1.osrc.amd.com>
In-Reply-To: <20120203191801.GA2846@x1.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2012 11:18 AM, Borislav Petkov wrote:
> On Thu, Feb 02, 2012 at 09:24:28PM +0100, Borislav Petkov wrote:
>>> Is this feature truly irrelevant on UP systems?  I ask because I've
>>> always enabled this option on my UP AMD systems in the past...
>>
>> No, you're right. Thanks for the suggestion. Scratch that version, I'll
>> think of a better fix.
> 
> Ok, I think I got it, pls take a look and scream if something's amiss.
> 
> @Randy: it builds fine with your randconfig and with mine default one;
> I'd appreciate if you could run it too, just in case.

Yes, it's fine for me also.
Thanks.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>


> Thanks.
> 
> --
> From: Borislav Petkov <bp@alien8.de>
> Date: Fri, 3 Feb 2012 18:07:54 +0100
> Subject: [PATCH] MCE, AMD: Hide smp-only code around CONFIG_SMP
> 
> 141168c36cde ("x86: Simplify code by removing a !SMP #ifdefs from
> 'struct cpuinfo_x86'") removed a bunch of CONFIG_SMP ifdefs around code
> touching struct cpuinfo_x86 members but also caused the following build
> error with Randy's randconfigs:
> 
> mce_amd.c:(.cpuinit.text+0x4723): undefined reference to `cpu_llc_shared_map'
> 
> Restore the #ifdef in threshold_create_bank() which creates symlinks on
> the non-BSP CPUs.
> 
> Cc: Kevin Winchester <kjwinchester@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Link: http://lkml.kernel.org/r/4F298A6C.6010101@xenotime.net
> Signed-off-by: Borislav Petkov <bp@alien8.de>
> ---
>  arch/x86/kernel/cpu/mcheck/mce_amd.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> index 786e76a..e4eeaaf 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> @@ -528,6 +528,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
>  
>  	sprintf(name, "threshold_bank%i", bank);
>  
> +#ifdef CONFIG_SMP
>  	if (cpu_data(cpu).cpu_core_id && shared_bank[bank]) {	/* symlink */
>  		i = cpumask_first(cpu_llc_shared_mask(cpu));
>  
> @@ -553,6 +554,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
>  
>  		goto out;
>  	}
> +#endif
>  
>  	b = kzalloc(sizeof(struct threshold_bank), GFP_KERNEL);
>  	if (!b) {


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
