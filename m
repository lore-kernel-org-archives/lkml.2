Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678Ab1DAVhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 17:37:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43854 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757294Ab1DAVhT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 17:37:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SaKNfzTvXzTKapOwhxGSfjOSCFknH93ml+oqehzK4Ru9I5IFvJ78ulK4X0G4vtokgZ
         77RJmtHMxDphk3Hsu3sWiWCccm5exu2Ksicz1OT/2nRzfrwVPAV57WmPySzIq5RLFoaq
         wlYlpZyYvkYuvg7zasuODaE/VXGBOil/c3wwM=
MIME-Version: 1.0
In-Reply-To: <4D9643F1.1090807@zytor.com>
References: <20110330203215.0a1a41a7@xenia.leun.net>
	<20110331090524.07ad0069@xenia.leun.net>
	<alpine.DEB.2.00.1103311546480.16492@kaball-desktop>
	<201103312348.53678.rjw@sisk.pl>
	<4D94FE37.8070109@kernel.org>
	<alpine.DEB.2.00.1104011230550.16492@kaball-desktop>
	<4D95F80D.7070201@kernel.org>
	<4D95FBDD.9050901@zytor.com>
	<alpine.DEB.2.00.1104011729000.16492@kaball-desktop>
	<4D961FBC.2030105@zytor.com>
	<4D962837.2070300@kernel.org>
	<4D96294B.5050909@zytor.com>
	<4D962D72.2010501@kernel.org>
	<4D9633E7.1010707@zytor.com>
	<AANLkTi=VzMh84szSBNujVU8oLZfzQd_z2bg+O3K_8GMd@mail.gmail.com>
	<4D9643F1.1090807@zytor.com>
Date: Fri, 1 Apr 2011 14:37:18 -0700
X-Google-Sender-Auth: PbL4lL6Cl25gpp1DCDp6RRtO-NA
Message-ID: <AANLkTimd22epcYvZRrvP5p3CzArpnR3To_mKCjdKKuf8@mail.gmail.com>
Subject: Re: 2.6.38.2 breaks suspend to disk
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Michael Leun <lkml20101129@newton.leun.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Mike Pagano <mpagano@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 1, 2011 at 2:30 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/01/2011 02:24 PM, Yinghai Lu wrote:
>> On Fri, Apr 1, 2011 at 1:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 04/01/2011 12:54 PM, Yinghai Lu wrote:
>>>>
>>>> ok, please check if you are happy with this one.
>>>>
>>>
>>> The best would simply be:
>>>
>>>        mmu_cr4_features = read_cr4_safe();
>>>
>>> If this has to run before we can handle exceptions, one can verify the
>>> existence by testing for the CPUID instruction (a CPU has CR4 if and
>>> only if it has CPUID):
>>>
>>>        if (boot_cpu_data.cpuid_level >= 0)
>>>                mmu_cr4_features = read_cr4_safe();
>>>
>>> ... since we set cpuid_level to -1 if there is no CPUID instruction.
>>
>> in that case could use read_cr4 directly.
>>
>> please check attached -v4
>>
>
> Err, yes, that's what I meant.
>
> Now, why the heck did you introduce a bunch of CONFIG_HIBERNATION #ifdefs?

mmu_cr4_features: have two usages:
1. for 32bit to control cr4 access in head_32.S
2. for hibernation resume.

include/asm/processor.h:extern unsigned long            mmu_cr4_features;
include/asm/processor.h:        mmu_cr4_features |= mask;
include/asm/processor.h:        mmu_cr4_features &= ~mask;
kernel/head_32.S:#define cr4_bits pa(mmu_cr4_features)
kernel/setup.c: * mmu_cr4_features two purpose:
kernel/setup.c:unsigned long mmu_cr4_features;
kernel/setup.c:unsigned long mmu_cr4_features = X86_CR4_PAE;
kernel/setup.c:         mmu_cr4_features = read_cr4();
power/hibernate_asm_32.S:       movl    mmu_cr4_features, %ecx
power/hibernate_asm_32.S:       movl    mmu_cr4_features, %ecx
power/hibernate_asm_64.S:       movq    mmu_cr4_features(%rip), %rax
power/hibernate_asm_64.S:       movq    mmu_cr4_features(%rip), %rax

So we don't need to read back cr4 and save it if CONFIG_HIBERNATION is
not defined.

Thanks

Yinghai
