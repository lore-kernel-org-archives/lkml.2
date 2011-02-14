Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab1BNSf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:35:59 -0500
Received: from smtp-out.google.com ([74.125.121.67]:16138 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab1BNSf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:35:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Lio4jom4+RruCzH/a6zheXvUcTpZvSX7eMk6Ld1+PQQybP02I0+Cv4+PgGac2GoAYX
         tXciu0c/KOGts2phbyMg==
MIME-Version: 1.0
In-Reply-To: <1297683742.30092.11.camel@e102109-lin.cambridge.arm.com>
References: <1297638813-1315-1-git-send-email-ccross@android.com>
	<1297683742.30092.11.camel@e102109-lin.cambridge.arm.com>
Date: Mon, 14 Feb 2011 10:35:37 -0800
X-Google-Sender-Auth: 47_39DbBbWrnAh28bpWvfpwmbLw
Message-ID: <AANLkTik_Jey_PtRmr530FVckA6RXHESeX+CyoJC=ZTkR@mail.gmail.com>
Subject: Re: [PATCH] ARM: vfp: Always save VFP state in vfp_pm_suspend
From: Colin Cross <ccross@android.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 3:42 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Sun, 2011-02-13 at 23:13 +0000, Colin Cross wrote:
>> vfp_pm_suspend should save the VFP state any time there is
>> a last_VFP_context.  If it only saves when the VFP is enabled,
>> the state can get lost when, on a UP system:
>>    Thread 1 uses the VFP
>>    Context switch occurs to thread 2, VFP is disabled but the
>>       VFP context is not saved to allow lazy save and restore
>>    Thread 2 initiates suspend
>>    vfp_pm_suspend is called with the VFP disabled, but the
>>       context has not been saved.
>
> At this point is it guaranteed that the thread won't migrate to another
> CPU? If not, we should use get/put_cpu.

Yes, VFP suspend is implemented with a sysdev, which is suspended
after disable_nonboot_cpus.

>> --- a/arch/arm/vfp/vfpmodule.c
>> +++ b/arch/arm/vfp/vfpmodule.c
>> @@ -415,13 +415,12 @@ static int vfp_pm_suspend(struct sys_device *dev, pm_message_t state)
>>         struct thread_info *ti = current_thread_info();
>>         u32 fpexc = fmrx(FPEXC);
>>
>> -       /* if vfp is on, then save state for resumption */
>> -       if (fpexc & FPEXC_EN) {
>> +       /* save state for resume */
>> +       if (last_VFP_context[ti->cpu]) {
>>                 printk(KERN_DEBUG "%s: saving vfp state\n", __func__);
>> -               vfp_save_state(&ti->vfpstate, fpexc);
>> -
>> -               /* disable, just in case */
>> -               fmxr(FPEXC, fmrx(FPEXC) & ~FPEXC_EN);
>> +               fmxr(FPEXC, fpexc | FPEXC_EN);
>> +               vfp_save_state(last_VFP_context[ti->cpu], fpexc);
>> +               fmxr(FPEXC, fpexc & ~FPEXC_EN);
>>         }
>
> We may want to set the last_VFP_context to NULL so that after resuming
> (to the same thread) we force the VFP reload from the vfpstate
> structure. The vfp_support_entry code ignores the reloading if the
> last_VFP_context is the same as vfpstate.

Right, will fix.
