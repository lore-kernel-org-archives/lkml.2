Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759787Ab2HXQOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 12:14:55 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48624 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759647Ab2HXQOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 12:14:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120824160838.GC2297@aftab.osrc.amd.com>
References: <20120824133434.GA8014@quad>
	<20120824160838.GC2297@aftab.osrc.amd.com>
Date: Fri, 24 Aug 2012 18:14:51 +0200
Message-ID: <CABPqkBRV=2k34yfnr_y0fpftWab6YN2Q=qDKqA5xAW-R-r1bHg@mail.gmail.com>
Subject: Re: [PATCH] perf/x86: fix microcode revision check for SNB-PEBS
From: Stephane Eranian <eranian@google.com>
To: Borislav Petkov <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        andi@firstfloor.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 6:08 PM, Borislav Petkov <bp@amd64.org> wrote:
> On Fri, Aug 24, 2012 at 03:34:34PM +0200, Stephane Eranian wrote:
>>
>> The following patch, relative to 3.6.0-rc3, makes
>> the microcode update code path actually invoke the
>> perf_check_microcode() function and thus potentially
>> renabling SNB PEBS.
>>
>> By default, CONFIG_MICROCODE_OLD_INTERFACE is
>> forced to Y in arch/x86/Kconfig. There is no
>> way to disable this. That means that the code
>> path used in arch/x86/kernel/microcode_core.c
>> did not include the call to perf_check_microcode().
>>
>> Thus, even though the microcode was updated to a
>> version that fixes the SNB PEBS problem, perf_event
>> would still return EOPNOTSUPP when enabling precise
>> sampling.
>>
>> This patch simply adds a call to perf_check_microcode()
>> in the call path used when OLD_INTERFACE=y.
>
> Ok, so c93dc84cbe324 added calls to perf_check_microcode but it looks
> like you're updating the microcode from /dev/cpu/microcode, correct?
>
> And if so, the old interface got missed.
>

So you're saying there is a cmdline tool that can use another interface
to pass the ucode to the kernel. I am using the microcode_ctl on Ubuntu
11.04. Apparently that one is still using the old interface. But I may
not be the
only one in this situation then, so I think it's worth fixing now.

What's the tool to update the ucode using the "new" interface then?

Thanks.

> Oh well, as long as we have to support it, we might as well add that
> perf call there - it will go when the interface goes anyway so until
> then:
>
> Acked-by: Borislav Petkov <borislav.petkov@amd.com>
>
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>> ---
>>
>> --- a/arch/x86/kernel/microcode_core.c
>> +++ b/arch/x86/kernel/microcode_core.c
>> @@ -225,6 +225,9 @@ static ssize_t microcode_write(struct file *file, const char __user *buf,
>>       if (do_microcode_update(buf, len) == 0)
>>               ret = (ssize_t)len;
>>
>> +     if (ret > 0)
>> +             perf_check_microcode();
>> +
>>       mutex_unlock(&microcode_mutex);
>>       put_online_cpus();
>>
>>
>
> Thanks.
>
> --
> Regards/Gruss,
> Boris.
>
> Advanced Micro Devices GmbH
> Einsteinring 24, 85609 Dornach
> GM: Alberto Bozzo
> Reg: Dornach, Landkreis Muenchen
> HRB Nr. 43632 WEEE Registernr: 129 19551
