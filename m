Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab1JKImI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 04:42:08 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:9561
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751970Ab1JKImE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 04:42:04 -0400
X-SpamScore: -9
X-BigFish: VPS-9(z37d5kz1432N98dK4015Lzz1202hzz8275bh8275dhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,13,
X-WSS-ID: 0LSW85F-01-DNN-02
X-M-MSG: 
Date: Tue, 11 Oct 2011 10:41:35 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, "Petkov, Borislav" <Borislav.Petkov@amd.com>,
        Borislav Petkov <bp@amd64.org>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "amd64-microcode@amd64.org" <amd64-microcode@amd64.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] CPU hotplug,x86 Microcode: Don't request
 microcode from userspace unnecessarily
Message-ID: <20111011084135.GA6501@alberich.amd.com>
References: <4E90B6F9.8020804@linux.vnet.ibm.com>
 <20111009112755.GC17926@aftab>
 <4E91F82E.4080007@linux.vnet.ibm.com>
 <4E91F908.5010006@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E91F908.5010006@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 09, 2011 at 03:42:00PM -0400, Srivatsa S. Bhat wrote:
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

Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>


Thanks,

Andreas

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


