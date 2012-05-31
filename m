Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446Ab2EaUbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:31:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40747 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758411Ab2EaUbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:31:09 -0400
Message-ID: <1338496257.28384.121.camel@twins>
Subject: Re: [PATCH] sched/x86: Calculate booted cores after construction of
 sibling_mask
From: Peter Zijlstra <peterz@infradead.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Date: Thu, 31 May 2012 22:30:57 +0200
In-Reply-To: <20120531073738.GH7511@linux.vnet.ibm.com>
References: <20120531073738.GH7511@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 13:07 +0530, Kamalesh Babulal wrote:
> While booting tip (1d06e6d354) on qemu with -smp sockets=1,cores=2,threads=2
> topology. There is a mismatch between the number of cores actually present
> and cores reported.
> 
> Changes related to calculating the number of booted cores was introduced
> by 316ad248307fb (sched/x86: Rewrite set_cpu_sibling_map()). With the
> clean up, the calculation of booted cores per package is done on an
> incompletely constructed sibling_mask per cpu.
> 
> sched/x86: Calculate booted cores after construction of sibling_mask

Why repeat this subject again?

> This patch re-introduces the old behaviour of constructing the complete
> sibling mask of the cpu, before calculating the number of cores booted.

> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> ---
>  arch/x86/kernel/smpboot.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index fd019d7..a8d78f3 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -382,7 +382,12 @@ void __cpuinit set_cpu_sibling_map(int cpu)
>  		if ((i == cpu) || (has_mc && match_llc(c, o)))
>  			link_mask(llc_shared, cpu, i);
> 
> -		if ((i == cpu) || (has_mc && match_mc(c, o))) {
> +	}
> +
> +	for_each_cpu(i, cpu_sibling_setup_mask) {
> +		o = &cpu_data(i);
> +
> +	if ((i == cpu) || (has_mc && match_mc(c, o))) {
>  			link_mask(core, cpu, i);
> 
>  			/*

This patch actually horribly mangles the indenting. I did the below to
it:


---
Subject: sched/x86: Calculate booted cores after construction of sibling_mask
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date: Thu, 31 May 2012 13:07:38 +0530

Commit 316ad248307fb ("sched/x86: Rewrite set_cpu_sibling_map()")
broke the booted_cores accounting.

The problem is that the booted_cores accounting needs all the
sibling links set up. So restore the second loop and add a comment as
to why its needed.

On qemu booted with -smp sockets=1,cores=2,threads=2;
Before:
$ grep cores /proc/cpuinfo
cpu cores       : 2
cpu cores       : 1
cpu cores       : 4
cpu cores       : 3

With the patch:
$ grep cores /proc/cpuinfo
cpu cores       : 2
cpu cores       : 2
cpu cores       : 2
cpu cores       : 2

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120531073738.GH7511@linux.vnet.ibm.com
---
 arch/x86/kernel/smpboot.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -382,6 +382,15 @@ void __cpuinit set_cpu_sibling_map(int c
 		if ((i == cpu) || (has_mc && match_llc(c, o)))
 			link_mask(llc_shared, cpu, i);
 
+	}
+
+	/*
+	 * This needs a separate iteration over the cpus because we rely on all
+	 * cpu_sibling_mask links to be set-up.
+	 */
+	for_each_cpu(i, cpu_sibling_setup_mask) {
+		o = &cpu_data(i);
+
 		if ((i == cpu) || (has_mc && match_mc(c, o))) {
 			link_mask(core, cpu, i);
 

