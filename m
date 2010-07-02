Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab0GBADo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 20:03:44 -0400
Received: from ozlabs.org ([203.10.76.45]:59242 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab0GBADm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 20:03:42 -0400
From: Michael Neuling <mikey@neuling.org>
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 054/149] powerpc/pseries: Only call start-cpu when a CPU is stopped
In-reply-to: <20100701173211.356448329@clark.site>
References: <20100701173211.356448329@clark.site>
Comments: In-reply-to Greg KH <gregkh@suse.de>
   message dated "Thu, 01 Jul 2010 10:31:20 -0700."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Fri, 02 Jul 2010 10:03:41 +1000
Message-ID: <24044.1278029021@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not going to work without:
f8b67691828321f5c85bb853283aa101ae673130

It'll get a build failure.

You seemed to have pulled this one the 33 stable.

Mikey

In message <20100701173211.356448329@clark.site> you wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us know
.
> 
> ------------------
> 
> From: Michael Neuling <mikey@neuling.org>
> 
> commit aef40e87d866355ffd279ab21021de733242d0d5 upstream.
> 
> Currently we always call start-cpu irrespective of if the CPU is
> stopped or not. Unfortunatley on POWER7, firmware seems to not like
> start-cpu being called when a cpu already been started.  This was not
> the case on POWER6 and earlier.
> 
> This patch checks to see if the CPU is stopped or not via an
> query-cpu-stopped-state call, and only calls start-cpu on CPUs which
> are stopped.
> 
> This fixes a bug with kexec on POWER7 on PHYP where only the primary
> thread would make it to the second kernel.
> 
> Reported-by: Ankita Garg <ankita@linux.vnet.ibm.com>
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  arch/powerpc/platforms/pseries/smp.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- a/arch/powerpc/platforms/pseries/smp.c
> +++ b/arch/powerpc/platforms/pseries/smp.c
> @@ -81,6 +81,12 @@ static inline int __devinit smp_startup_
>  
>  	pcpu = get_hard_smp_processor_id(lcpu);
>  
> +	/* Check to see if the CPU out of FW already for kexec */
> +	if (smp_query_cpu_stopped(pcpu) == QCSS_NOT_STOPPED){
> +		cpu_set(lcpu, of_spin_map);
> +		return 1;
> +	}
> +
>  	/* Fixup atomic count: it exited inside IRQ handler. */
>  	task_thread_info(paca[lcpu].__current)->preempt_count	= 0;
>  
> 
> 
