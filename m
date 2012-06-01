Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab2FAM74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 08:59:56 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41693 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab2FAM7z convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:14:2>);
	Fri, 1 Jun 2012 08:59:55 -0400
Message-Id: <4FC8D8E30200007800087D2B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 01 Jun 2012 13:59:47 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <srivatsa.bhat@linux.vnet.ibm.com>
Cc: <yong.zhang0@gmail.com>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
        <peterz@infradead.org>, <mingo@kernel.org>, <x86@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, <akpm@linux-foundation.org>,
        <nikunj@linux.vnet.ibm.com>, <paulmck@linux.vnet.ibm.com>,
        <vatsa@linux.vnet.ibm.com>,
        <virtualization@lists.linux-foundation.org>,
        <xen-devel@lists.xensource.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Ingo Molnar" <mingo@redhat.com>, <rusty@rustcorp.com.au>,
        <rjw@sisk.pl>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "Keir Fraser" <keir@xen.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 05/27] xen, cpu hotplug: Don't call
 cpu_bringup() in xen_play_dead()
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
 <20120601091124.31979.91984.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120601091124.31979.91984.stgit@srivatsabhat.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 01.06.12 at 11:11, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
wrote:
> xen_play_dead calls cpu_bringup() which looks weird, because xen_play_dead()
> is invoked in the cpu down path, whereas cpu_bringup() (as the name 
> suggests) is useful in the cpu bringup path.

This might not be correct - the code as it is without this change is
safe even when the vCPU gets onlined back later by an external
entity (e.g. the Xen tool stack), and it would in that case resume
at the return point of the VCPUOP_down hypercall. That might
be a heritage from the original XenoLinux tree though, and be
meaningless in pv-ops context - Jeremy, Konrad?

Possibly it was bogus/unused even in that original tree - Keir?

Jan

> Getting rid of xen_play_dead()'s dependency on cpu_bringup() helps in 
> hooking on to the generic SMP booting framework.
> 
> Also remove the extra call to preempt_enable() added by commit 41bd956
> (xen/smp: Fix CPU online/offline bug triggering a BUG: scheduling while
> atomic) because it becomes unnecessary after this change.
> 
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org 
> Cc: xen-devel@lists.xensource.com 
> Cc: virtualization@lists.linux-foundation.org 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
>  arch/x86/xen/smp.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index 09a7199..602d6b7 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -417,14 +417,6 @@ static void __cpuinit xen_play_dead(void) /* used only 
> with HOTPLUG_CPU */
>  {
>  	play_dead_common();
>  	HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);
> -	cpu_bringup();
> -	/*
> -	 * Balance out the preempt calls - as we are running in cpu_idle
> -	 * loop which has been called at bootup from cpu_bringup_and_idle.
> -	 * The cpucpu_bringup_and_idle called cpu_bringup which made a
> -	 * preempt_disable() So this preempt_enable will balance it out.
> -	 */
> -	preempt_enable();
>  }
>  
>  #else /* !CONFIG_HOTPLUG_CPU */
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org 
> http://lists.xen.org/xen-devel 



