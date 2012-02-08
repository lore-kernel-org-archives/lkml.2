Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab2BHAlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 19:41:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41928 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab2BHAll convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 19:41:41 -0500
MIME-Version: 1.0
In-Reply-To: <20120207095746.GH15359@elte.hu>
References: <1328209817-18913-1-git-send-email-bp@alien8.de>
	<20120202193702.GA9502@elliptictech.com>
	<20120202202427.GA2234@x1.osrc.amd.com>
	<20120203191801.GA2846@x1.osrc.amd.com>
	<20120207095746.GH15359@elte.hu>
Date: Tue, 7 Feb 2012 20:41:40 -0400
Message-ID: <CAELBVzCrMmrw8gRRQ4K9SyVWjjqk5DxuX+7=vQoyzNO0M7qRkg@mail.gmail.com>
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

On 7 February 2012 05:57, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Borislav Petkov <bp@alien8.de> wrote:
>
>> On Thu, Feb 02, 2012 at 09:24:28PM +0100, Borislav Petkov wrote:
>> > > Is this feature truly irrelevant on UP systems?  I ask because I've
>> > > always enabled this option on my UP AMD systems in the past...
>> >
>> > No, you're right. Thanks for the suggestion. Scratch that version, I'll
>> > think of a better fix.
>>
>> Ok, I think I got it, pls take a look and scream if something's amiss.
>>
>> @Randy: it builds fine with your randconfig and with mine default one;
>> I'd appreciate if you could run it too, just in case.
>>
>> Thanks.
>>
>> --
>> From: Borislav Petkov <bp@alien8.de>
>> Date: Fri, 3 Feb 2012 18:07:54 +0100
>> Subject: [PATCH] MCE, AMD: Hide smp-only code around CONFIG_SMP
>>
>> 141168c36cde ("x86: Simplify code by removing a !SMP #ifdefs from
>> 'struct cpuinfo_x86'") removed a bunch of CONFIG_SMP ifdefs around code
>> touching struct cpuinfo_x86 members but also caused the following build
>> error with Randy's randconfigs:
>>
>> mce_amd.c:(.cpuinit.text+0x4723): undefined reference to `cpu_llc_shared_map'
>>
>> Restore the #ifdef in threshold_create_bank() which creates symlinks on
>> the non-BSP CPUs.
>>
>
> Could we please just define an obvious cpu_llc_shared_mask on UP
> (one bit long and set to 1) and not reintroduce the ugly
> #ifdef CONFIG_SMP?
>

I ran into this when I was working on the original patch, and I
thought I had solved all of the issues like this.  Unfortunately not.

The problem is that there doesn't seem to be a great place to define
this (along with a few other functions like this) on UP.  We have
<linux/smp.h> including <asm/smp.h> in the CONFIG_SMP case, but no
arch-specific defs for UP.  Would it be crazy to have <linux/smp.h>
include a new <asm/up.h> for !CONFIG_SMP?

I am willing to prepare the patch, if someone can tell me where to
define cpu_llc_shared_mask for UP?

Thanks,

-- 
Kevin Winchester
