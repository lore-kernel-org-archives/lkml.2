Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab1BKTux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 14:50:53 -0500
Received: from smtp-out.google.com ([216.239.44.51]:30139 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab1BKTuv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 14:50:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=itSU0sRgm8s7nv7FCCs/zOXAC8srgoBv8sFTSKPRVXAfTCZC5RvdqqTOW3qxlcYjMJ
         AZUjmBD+XZ+NFA0dh9xg==
MIME-Version: 1.0
In-Reply-To: <1297426345.17584.99.camel@e102109-lin.cambridge.arm.com>
References: <1297373487-23902-1-git-send-email-ccross@android.com>
	<1297373487-23902-4-git-send-email-ccross@android.com>
	<1297426345.17584.99.camel@e102109-lin.cambridge.arm.com>
Date: Fri, 11 Feb 2011 11:50:48 -0800
X-Google-Sender-Auth: TtAfXQsp7YJET0P2_iLbxqwbZe0
Message-ID: <AANLkTinYf3G+b8n6okeZk44xvO0xP0dw8S_dfE2C4E1-@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] ARM: vfp: Use cpu pm notifiers to save vfp state
From: Colin Cross <ccross@android.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        santosh.shilimkar@ti.com, Will Deacon <Will.Deacon@arm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 4:12 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> Colin,
>
> On Thu, 2011-02-10 at 21:31 +0000, Colin Cross wrote:
>> +static int vfp_idle_notifier(struct notifier_block *self, unsigned long cmd,
>> +       void *v)
>> +{
>> +       u32 fpexc = fmrx(FPEXC);
>> +       unsigned int cpu = smp_processor_id();
>> +
>> +       if (cmd != CPU_PM_ENTER)
>> +               return NOTIFY_OK;
>> +
>> +       /* The VFP may be reset in idle, save the state */
>> +       if ((fpexc & FPEXC_EN) && last_VFP_context[cpu]) {
>> +               vfp_save_state(last_VFP_context[cpu], fpexc);
>> +               last_VFP_context[cpu]->hard.cpu = cpu;
>> +       }
>
> Should we only handle the case where the VFP is enabled? At context
> switch we disable the VFP and re-enable it when an application tries to
> use it but it will remain disabled even the application hasn't used the
> VFP. So switching to the idle thread would cause the VFP to be disabled
> but the state not necessarily saved.
Right

> On SMP systems, we save the VFP at every context switch to deal with the
> thread migration (though I have a plan to make this lazily on SMP as
> well). On UP however, we don't save the VFP registers at context switch,
> we just disable it and save it lazily if used later in a different task
>
> Something like below (untested):
>
>        if (last_VFP_context[cpu]) {
>                vfp_save_state(last_VFP_context[cpu], fpexc);
>                /* force a reload when coming back from idle */
>                last_VFP_context[cpu] = NULL;
>                fmxr(FPEXC, fpexc & ~FPEXC_EN);
>        }
>
> The last line (disabling) may not be necessary if we know that it comes
> back from idle as disabled.
It shouldn't be necessary, the context switch into the idle thread
should have disabled it, but it doesn't hurt.  We should also disable
it when exiting idle.

> I wonder whether the current vfp_pm_suspend() function needs fixing for
> UP systems as well. It is find if the hardware preserves the VFP
> registers (which may not be the case).
I think there is a case where the VFP registers can be lost in suspend
on UP platforms that don't save the VFP registers in their platform
suspend.  If a thread is using the VFP, and then context switches to a
thread that does not use VFP but triggers suspend by writing to
/sys/power/state, vfp_pm_suspend will be called with the VFP disabled
but the registers not saved.  I think this would work:

	/* save state for resumption */
	if (last_VFP_context[ti->cpu]) {
		printk(KERN_DEBUG "%s: saving vfp state\n", __func__);
		vfp_save_state(last_VFP_context[ti->cpu], fpexc);

		/* disable, just in case */
		fmxr(FPEXC, fpexc & ~FPEXC_EN);
	}

If the thread that wrote to /sys/power/state is using VFP,
last_VFP_context will be the same as ti->vfpstate, so we can always
save last_VFP_context.
