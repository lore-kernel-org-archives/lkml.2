Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab2HNOY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:24:29 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:41703 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756368Ab2HNOYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:24:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120814114856.GA17040@linux-mips.org>
References: <1344862344-27434-1-git-send-email-chenhc@lemote.com>
	<20120814114856.GA17040@linux-mips.org>
Date: Tue, 14 Aug 2012 22:24:23 +0800
X-Google-Sender-Auth: OdjvaVSow-eFKblR3wnQTBWGSpk
Message-ID: <CAAhV-H7s0Fc0TVLaJoVWschvoZGnZtiQ1X1fS61H_+=a5Tc0Aw@mail.gmail.com>
Subject: Re: [PATCH V2] MIPS: Fix poweroff failure when HOTPLUG_CPU configured.
From: Huacai Chen <chenhc@lemote.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>, Zhangjin Wu <wuzhangjin@gmail.com>,
        Hongliang Tao <taohl@lemote.com>, Hua Yan <yanh@lemote.com>,
        Yong Zhang <yong.zhang@windriver.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 7:48 PM, Ralf Baechle <ralf@linux-mips.org> wrote:
> On Mon, Aug 13, 2012 at 08:52:24PM +0800, Huacai Chen wrote:
>
>> When poweroff machine, kernel_power_off() call disable_nonboot_cpus().
>> And if we have HOTPLUG_CPU configured, disable_nonboot_cpus() is not an
>> empty function but attempt to actually disable the nonboot cpus. Since
>> system state is SYSTEM_POWER_OFF, play_dead() won't be called and thus
>> disable_nonboot_cpus() hangs. Therefore, we make this patch to avoid
>> poweroff failure.
>
>> diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
>> index e9a5fd7..69b17a9 100644
>> --- a/arch/mips/kernel/process.c
>> +++ b/arch/mips/kernel/process.c
>> @@ -72,9 +72,7 @@ void __noreturn cpu_idle(void)
>>                       }
>>               }
>>  #ifdef CONFIG_HOTPLUG_CPU
>> -             if (!cpu_online(cpu) && !cpu_isset(cpu, cpu_callin_map) &&
>> -                 (system_state == SYSTEM_RUNNING ||
>> -                  system_state == SYSTEM_BOOTING))
>> +             if (!cpu_online(cpu) && !cpu_isset(cpu, cpu_callin_map))
>
> Looks good - but I'm wondering if the "!cpu_isset(cpu, cpu_callin_map)"
> can be removed as well?
For X86, IA64, ARM, SPARC64 and most other arch, "!cpu_online(cpu)" is
the only condition of play_dead(). I keep "!cpu_isset(cpu,
cpu_callin_map)" because this does't refuse poweroff and I don't know
why the old condition of play_dead() is so complex.

>
> Also, which -stable branches is this patch applicable?
3.3, 3.4 and 3.5 branch can use it, 3.2 and earlier kernels should do
some small changes.

>
>   Ralf
>
