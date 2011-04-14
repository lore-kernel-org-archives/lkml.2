Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab1DNHvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 03:51:12 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44469 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab1DNHvL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:51:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OXiSyd3q2z7YDiApvtRYsPlV0vp4pzKMGm9ZnBKa8yvYp/xrHMYrocZ/tZfp/Li2D8
         xeHQlMBjjv/NOCsKllx+xUs7ht/qktJUDaYVkXRSYDUqrv6CJZEyoVgB5e+uBkCiYuKr
         xQnsUgZ6nAzO8LUwJO+nE6luuiQEKaiF/RmFY=
MIME-Version: 1.0
In-Reply-To: <20110414064737.GB15535@elte.hu>
References: <20110406223036.GA15721@digium.com>
	<201104132133.51958.maciej.rutecki@gmail.com>
	<4DA6011F.7070405@openvz.org>
	<20110414064737.GB15535@elte.hu>
Date: Thu, 14 Apr 2011 11:51:11 +0400
X-Google-Sender-Auth: NJ1fEjMNAbmOeuJX9reISXCrtck
Message-ID: <BANLkTinC18PetP=dzCsfOL_v_1hGv0jUag@mail.gmail.com>
Subject: Re: [regression 2.6.39-rc2][bisected] "perf, x86: P4 PMU - Read
 proper MSR register to catch" and NMIs
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, maciej.rutecki@gmail.com,
        Shaun Ruffell <sruffell@digium.com>, Don Zickus <dzickus@redhat.com>,
        linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 10:47 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
>
>> -     apic_write(APIC_LVTPC, APIC_DM_NMI);
>>
>>       handled = x86_pmu.handle_irq(args->regs);
>>       if (!handled)
>>               return NOTIFY_DONE;
>>
>> +     /*
>> +      * Unmasking should be done after IRQ handled, otherwise
>> +      * there is a race between clearing of counter overflow
>> +      * flag and LTV entry unmasking (which might lead to double
>> +      * NMIs generation).
>> +      */
>> +     apic_write(APIC_LVTPC, APIC_DM_NMI);
>
> Here we could leak a masked IRQ through the !handled path. If we got a LVTPC
> irq we better handle it and unmask the LVTPC unconditionally - regardless of
> whether we consider it 'handled' or not from the kernel POV ...
>
> Thanks,
>
>        Ingo

If there is no counters overflowed I believe we should not poke LVTPC until
we sure NMI comes from it (and counter overflow is the only sign that
NMI came from LVTPC as far as I may say,  and I see also a possibility for race
if counter signal reaches LVTPC and it is being processed inside apic chip
{which might take some time too before real NMI signal appears in cpu} and as
result hard to tell what we get in output -- double nmi again or
something else).
I might be screwed of course :)
