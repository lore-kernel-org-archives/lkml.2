Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab1BKMMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 07:12:37 -0500
Received: from service87.mimecast.com ([94.185.240.25]:50408 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755560Ab1BKMMe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 07:12:34 -0500
Subject: Re: [RFC PATCH 3/3] ARM: vfp: Use cpu pm notifiers to save vfp
 state
From: Catalin Marinas <catalin.marinas@arm.com>
To: Colin Cross <ccross@android.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        santosh.shilimkar@ti.com, Will Deacon <Will.Deacon@arm.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1297373487-23902-4-git-send-email-ccross@android.com>
References: <1297373487-23902-1-git-send-email-ccross@android.com>
	 <1297373487-23902-4-git-send-email-ccross@android.com>
Organization: ARM Limited
Date: Fri, 11 Feb 2011 12:12:25 +0000
Message-ID: <1297426345.17584.99.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 11 Feb 2011 12:12:26.0606 (UTC) FILETIME=[F25C68E0:01CBC9E4]
X-MC-Unique: 111021112123009001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Colin,

On Thu, 2011-02-10 at 21:31 +0000, Colin Cross wrote:
> +static int vfp_idle_notifier(struct notifier_block *self, unsigned long cmd,
> +       void *v)
> +{
> +       u32 fpexc = fmrx(FPEXC);
> +       unsigned int cpu = smp_processor_id();
> +
> +       if (cmd != CPU_PM_ENTER)
> +               return NOTIFY_OK;
> +
> +       /* The VFP may be reset in idle, save the state */
> +       if ((fpexc & FPEXC_EN) && last_VFP_context[cpu]) {
> +               vfp_save_state(last_VFP_context[cpu], fpexc);
> +               last_VFP_context[cpu]->hard.cpu = cpu;
> +       }

Should we only handle the case where the VFP is enabled? At context
switch we disable the VFP and re-enable it when an application tries to
use it but it will remain disabled even the application hasn't used the
VFP. So switching to the idle thread would cause the VFP to be disabled
but the state not necessarily saved.

On SMP systems, we save the VFP at every context switch to deal with the
thread migration (though I have a plan to make this lazily on SMP as
well). On UP however, we don't save the VFP registers at context switch,
we just disable it and save it lazily if used later in a different task

Something like below (untested):

	if (last_VFP_context[cpu]) {
		vfp_save_state(last_VFP_context[cpu], fpexc);
		/* force a reload when coming back from idle */
		last_VFP_context[cpu] = NULL;
		fmxr(FPEXC, fpexc & ~FPEXC_EN);
	}

The last line (disabling) may not be necessary if we know that it comes
back from idle as disabled.

I wonder whether the current vfp_pm_suspend() function needs fixing for
UP systems as well. It is find if the hardware preserves the VFP
registers (which may not be the case).

-- 
Catalin


