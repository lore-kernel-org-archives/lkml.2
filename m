Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935905Ab1JFWNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 18:13:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42608 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935612Ab1JFWNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 18:13:39 -0400
Date: Thu, 6 Oct 2011 15:13:34 -0700
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@amd64.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <bp@alien8.de>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [BUGFIX][PATCH RESEND] Freezer, CPU hotplug, x86 Microcode:
 Fix task freezing failures
Message-ID: <20111006221334.GB7085@google.com>
References: <20111002195023.GC31799@mtj.dyndns.org>
 <201110052226.58373.rjw@sisk.pl>
 <4E8CC8FA.2090100@linux.vnet.ibm.com>
 <201110060043.19583.rjw@sisk.pl>
 <4E8D4FC6.1080204@linux.vnet.ibm.com>
 <20111006083439.GA21575@aftab>
 <4E8DCDA6.8030802@linux.vnet.ibm.com>
 <4E8E1125.4050701@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8E1125.4050701@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Oct 07, 2011 at 02:05:49AM +0530, Srivatsa S. Bhat wrote:
...
> diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
> index f924280..cd7ef2f 100644
> --- a/arch/x86/kernel/microcode_core.c
> +++ b/arch/x86/kernel/microcode_core.c
> @@ -483,7 +483,15 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
>  		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
>  		pr_debug("CPU%d removed\n", cpu);
>  		break;
> -	case CPU_DEAD:
> +
> +	/*
> +	 * Do not invalidate the microcode if a CPU goes offline,
> +	 * because it would be impossible to get the microcode again
> +	 * from userspace when the CPU comes back up, if the userspace
> +	 * happens to be frozen at that moment by the freezer subsystem,
> +	 * for example, due to a suspend operation in progress.
> +	 */
> +

This still looks like a bandaid to me.  The exclusion approach didn't
pan out?

Thank you.

-- 
tejun
