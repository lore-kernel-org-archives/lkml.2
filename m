Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab2GPTm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 15:42:59 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51500 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab2GPTmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 15:42:55 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1207161433420.14068@xanadu.home>
References: <1342462640-18410-1-git-send-email-ccross@android.com>
	<alpine.LFD.2.02.1207161433420.14068@xanadu.home>
Date: Mon, 16 Jul 2012 12:42:53 -0700
X-Google-Sender-Auth: hRPxfvknijclG80AymoGh4mzvno
Message-ID: <CAMbhsRQVrmia_FHwwWbVcrzNh5s24PYPqGCXuH1r1MvMnpYSzA@mail.gmail.com>
Subject: Re: [PATCH v6] ARM: vfp: Always save VFP state in vfp_pm_suspend on UP
From: Colin Cross <ccross@android.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Barry Song <bs14@csr.com>,
        Ido Yariv <ido@wizery.com>, Daniel Drake <dsd@laptop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 11:34 AM, Nicolas Pitre
<nicolas.pitre@linaro.org> wrote:
> On Mon, 16 Jul 2012, Colin Cross wrote:
>
>> vfp_pm_suspend should save the VFP state in suspend after
>> any lazy context switch.  If it only saves when the VFP is enabled,
>> the state can get lost when, on a UP system:
>>   Thread 1 uses the VFP
>>   Context switch occurs to thread 2, VFP is disabled but the
>>      VFP context is not saved
>>   Thread 2 initiates suspend
>>   vfp_pm_suspend is called with the VFP disabled, and the unsaved
>>      VFP context of Thread 1 in the registers
>>
>> Modify vfp_pm_suspend to save the VFP context whenever
>> vfp_current_hw_state is not NULL.
>>
>> Includes a fix from Ido Yariv <ido@wizery.com>, who pointed out that on
>> SMP systems, the state pointer can be pointing to a freed task struct if
>> a task exited on another cpu, fixed by using #ifdef CONFIG_SMP in the
>> new if clause.
>>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Barry Song <bs14@csr.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Ido Yariv <ido@wizery.com>
>> Cc: Daniel Drake <dsd@laptop.org>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Signed-off-by: Colin Cross <ccross@android.com>
>> ---
>>  arch/arm/vfp/vfpmodule.c |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
>> index 58696192..ce55f05 100644
>> --- a/arch/arm/vfp/vfpmodule.c
>> +++ b/arch/arm/vfp/vfpmodule.c
>> @@ -457,6 +457,12 @@ static int vfp_pm_suspend(void)
>>
>>               /* disable, just in case */
>>               fmxr(FPEXC, fmrx(FPEXC) & ~FPEXC_EN);
>> +     } else if (vfp_current_hw_state[ti->cpu]) {
>> +#ifndef CONFIG_SMP
>> +             fmxr(FPEXC, fpexc | FPEXC_EN);
>> +             vfp_save_state(vfp_current_hw_state[ti->cpu], fpexc);
>> +             fmxr(FPEXC, fpexc);
>> +#endif
>>       }
>
> Couldn't vfp_sync_hwstate() be used here instead?

Not easily, we don't have the thread struct of the thread that is in
the vfp hardware.  We would have to read vfp_current_hw_state for the
current cpu and use container_of to get from  struct vfpstate to
struct thread_info, and then pass that back in to vfp_sync_hwstate.
