Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620Ab1JJUzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 16:55:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59902 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab1JJUzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 16:55:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH RESEND] CPU hotplug,x86 Microcode: Don't request microcode from userspace unnecessarily
Date: Mon, 10 Oct 2011 22:58:02 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <borislav.petkov@amd.com>,
        Borislav Petkov <bp@amd64.org>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "amd64-microcode@amd64.org" <amd64-microcode@amd64.org>,
        Tejun Heo <tj@kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4E90B6F9.8020804@linux.vnet.ibm.com> <4E91F82E.4080007@linux.vnet.ibm.com> <4E91F908.5010006@linux.vnet.ibm.com>
In-Reply-To: <4E91F908.5010006@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110102258.02628.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 09, 2011, Srivatsa S. Bhat wrote:
> Requesting the microcode from userspace *every time* when onlining CPUs
> (during a CPU hotplug operation) is unnecessary.
> 
> So, this patch ensures that once the kernel gets the microcode after booting,
> it is not freed nor invalidated when a CPU goes offline, so that it can be
> reused when that CPU comes back online, without requesting userspace for it
> again. As a result, the CPU hotplug operations become faster as well.
> 
> Tested-by: Borislav Petkov <bp@amd64.org>
> Acked-by: Borislav Petkov <bp@amd64.org>
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Fine by me.  I wonder who should take this?

Rafael


> ---
> 
>  arch/x86/kernel/microcode_core.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
> index f924280..33c8a67 100644
> --- a/arch/x86/kernel/microcode_core.c
> +++ b/arch/x86/kernel/microcode_core.c
> @@ -483,7 +483,14 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
>  		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
>  		pr_debug("CPU%d removed\n", cpu);
>  		break;
> -	case CPU_DEAD:
> +
> +	/*
> +	 * When a CPU goes offline, don't free up or invalidate the copy of
> +	 * the microcode in kernel memory, so that we can reuse it when the
> +	 * CPU comes back online without unnecessarily requesting the userspace
> +	 * for it again.
> +	 */
> +
>  	case CPU_UP_CANCELED_FROZEN:
>  		/* The CPU refused to come up during a system resume */
>  		microcode_fini_cpu(cpu);
> 
> 
> 
> 

