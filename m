Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab2BJAAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:00:48 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34916 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758487Ab2BJAAr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:00:47 -0500
MIME-Version: 1.0
In-Reply-To: <20120209080648.GI18387@elte.hu>
References: <1328209817-18913-1-git-send-email-bp@alien8.de>
	<20120202193702.GA9502@elliptictech.com>
	<20120202202427.GA2234@x1.osrc.amd.com>
	<20120203191801.GA2846@x1.osrc.amd.com>
	<20120207095746.GH15359@elte.hu>
	<20120208101956.GA1772@x1.osrc.amd.com>
	<20120209080648.GI18387@elte.hu>
Date: Thu, 9 Feb 2012 20:00:45 -0400
Message-ID: <CAELBVzBAYRYWsO=PpwQhi0=_hejdLaq5Yci8uC_NT12KiFLb4w@mail.gmail.com>
Subject: Re: MCE, AMD: Hide smp-only code around CONFIG_SMP
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@alien8.de>, Nick Bowler <nbowler@elliptictech.com>,
        Randy Dunlap <rdunlap@xenotime.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 February 2012 04:06, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Borislav Petkov <bp@alien8.de> wrote:
>
>> +++ b/arch/x86/include/asm/smp.h
>> @@ -33,8 +33,15 @@ static inline bool cpu_has_ht_siblings(void)
>>
>>  DECLARE_PER_CPU(cpumask_var_t, cpu_sibling_map);
>>  DECLARE_PER_CPU(cpumask_var_t, cpu_core_map);
>> -/* cpus sharing the last level cache: */
>> +
>> +#ifdef CONFIG_SMP
>> +/* CPUs sharing the last level cache: */
>>  DECLARE_PER_CPU(cpumask_var_t, cpu_llc_shared_map);
>> +#else
>> +static DECLARE_BITMAP(cpu_llc_shared_bits, NR_CPUS) __read_mostly = { [0] = 1UL };
>> +static struct cpumask *const cpu_llc_shared_map = to_cpumask(cpu_llc_shared_bits);
>> +#endif
>
> Why not just expose it like on SMP?
>
> We want to *reduce* the specialness of UP, not increase it - one
> more word of .data and .text does not matter much - UP is
> becoming more and more an oddball, rarely tested config. By the
> time these changes hit any real boxes it will be even more
> oddball.
>

It seems that cpu_llc_shared_map is actually defined in
arch/x86/kernel/smpboot.c, which is not compiled/linked for UP builds.
 Is there an equivalent file for UP that could be used instead, or
could the:

DEFINE_PER_CPU(cpumask_var_t, cpu_llc_shared_map);

be moved to some other file?

Generally, it sounds like you might approve of an eventual merging of
the boot paths for SMP and UP.  Is that true?  I wonder how much work
that would be.  That would really reduce the specialness of UP.

-- 
Kevin Winchester
