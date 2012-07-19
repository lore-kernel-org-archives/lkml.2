Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab2GSNce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 09:32:34 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44263 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab2GSNca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 09:32:30 -0400
Date: Thu, 19 Jul 2012 15:32:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: msb@chromium.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        shaohua.li@intel.com, yinghai@kernel.org, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, tj@kernel.org,
        akpm@linux-foundation.org, sfr@canb.auug.org.au, cl@gentwo.org,
        olofj@chromium.org, paulmck@linux.vnet.ibm.com,
        Alex Shi <alex.shi@intel.com>, Conny Seidel <conny.seidel@amd.com>
Subject: Re: [PATCH] x86, mm: Send tlb flush IPIs to online cpus only
Message-ID: <20120719133229.GB10073@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	msb@chromium.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
	shaohua.li@intel.com, yinghai@kernel.org, tglx@linutronix.de,
	hpa@zytor.com, x86@kernel.org, tj@kernel.org,
	akpm@linux-foundation.org, sfr@canb.auug.org.au, cl@gentwo.org,
	olofj@chromium.org, paulmck@linux.vnet.ibm.com,
	Alex Shi <alex.shi@intel.com>, Conny Seidel <conny.seidel@amd.com>
References: <20120719125643.30033.58913.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120719125643.30033.58913.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 06:27:33PM +0530, Srivatsa S. Bhat wrote:

[ … ]
 
> So we are sending an IPI to a cpu which is now offline. Once a cpu is offline,
> it will no longer respond to IPIs. This explains the softlockup.
> 
> A cpu in the mm_cpumask could go offline before we send the invalidate
> IPI causing us to wait forever. Avoid this by sending the IPI to only the
> online cpus.
> 
> [Since flush_tlb_others_ipi() is always called with preempt disabled, it is
> not possible for a CPU to go offline once we enter this function, because
> CPU offline goes through the stop_machine() stuff (which cannot proceed until
> all preempt disabled sections are exited). So we don't have to worry about
> any race between CPU offline and the target cpumask calculation in
> flush_tlb_others_ipi().]
> 
> Addresses http://crosbug.com/31737
> 
> Reported-and-debugged-by: Mandeep Singh Baines <msb@chromium.org>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Acked-by: Mandeep Singh Baines <msb@chromium.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Christoph Lameter <cl@gentwo.org>
> Cc: Olof Johansson <olofj@chromium.org>
> ---
> 
>  arch/x86/mm/tlb.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
> index 5e57e11..9d387a9 100644
> --- a/arch/x86/mm/tlb.c
> +++ b/arch/x86/mm/tlb.c
> @@ -186,7 +186,11 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
>  
>  	f->flush_mm = mm;
>  	f->flush_va = va;
> -	if (cpumask_andnot(to_cpumask(f->flush_cpumask), cpumask, cpumask_of(smp_processor_id()))) {
> +
> +	cpumask_and(to_cpumask(f->flush_cpumask), cpumask, cpu_online_mask);
> +	cpumask_clear_cpu(smp_processor_id(), to_cpumask(f->flush_cpumask));
> +
> +	if (!cpumask_empty(to_cpumask(f->flush_cpumask))) {

FWIW, there's code in tip/x86/mm which reworks all that and
flush_tlb_others_ipi along with the 32 TLB flush vectors are being
removed in favor of a smp_call_function_many thing. And it should be
hotplug-safe since it must be called with preemption disabled anyway.

-- 
Regards/Gruss,
Boris.
