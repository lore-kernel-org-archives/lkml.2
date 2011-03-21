Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab1CUWCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 18:02:14 -0400
Received: from kroah.org ([198.145.64.141]:36575 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589Ab1CUWCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 18:02:12 -0400
Date: Mon, 21 Mar 2011 14:43:20 -0700
From: Greg KH <greg@kroah.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: mananth@in.ibm.com, benh@kernel.crashing.org, stable@kernel.org,
        anton@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] [2/3] powerpc/kdump: Fix race in kdump shutdown
Message-ID: <20110321214320.GA9546@kroah.com>
References: <20110319181433.GC23832@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110319181433.GC23832@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 19, 2011 at 11:44:33PM +0530, Kamalesh Babulal wrote:
> 	powerpc/kdump: Fix race in kdump shutdown
> 
> 	Commit: 60adec6226bbcf061d4c2d10944fced209d1847d upstream
> 
> 	When we are crashing, the crashing/primary CPU IPIs the secondaries to
> 	turn off IRQs, go into real mode and wait in kexec_wait.  While this
> 	is happening, the primary tears down all the MMU maps.  Unfortunately
> 	the primary doesn't check to make sure the secondaries have entered
> 	real mode before doing this.
> 
> 	On PHYP machines, the secondaries can take a long time shutting down
> 	the IRQ controller as RTAS calls are need.  These RTAS calls need to
> 	be serialised which resilts in the secondaries contending in
> 	lock_rtas() and hence taking a long time to shut down.
> 
> 	We've hit this on large POWER7 machines, where some secondaries are
> 	still waiting in lock_rtas(), when the primary tears down the HPTEs.
> 
> 	This patch makes sure all secondaries are in real mode before the
> 	primary tears down the MMU.  It uses the new kexec_state entry in the
> 	paca.  It times out if the secondaries don't reach real mode after
> 	10sec.
> 
> 	Signed-off-by: Michael Neuling <mikey@neuling.org>
> 	Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 	Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> 	cc: Anton Blanchard <anton@samba.org>

Please don't indent these, I have to unindent them for every patch I
apply from you, which is a pain.


> ---
>  arch/powerpc/kernel/crash.c |   28 ++++++++++++++++++++++++++++
>  1 files changed, 28 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
> index b779818..706b622 100644
> --- a/arch/powerpc/kernel/crash.c
> +++ b/arch/powerpc/kernel/crash.c
> @@ -153,6 +153,7 @@ static void crash_kexec_prepare_cpus(int cpu)
> 		while (cpus_weight(cpus_in_crash) < ncpus)
> 			cpu_relax();
> 	}
> +
> 	/*
> 	 * Make sure all CPUs are entered via soft-reset if the kdump is
> 	 * invoked using soft-reset.

That chunk is not in the upstream commit.  Please be more careful.

greg k-h
