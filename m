Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab2FVPyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:54:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41323 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab2FVPx4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:53:56 -0400
Message-ID: <1340380427.18025.84.camel@twins>
Subject: Re: [PATCH 4/4] perf, x86: Improve debug output in check_hw_exists()
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 22 Jun 2012 17:53:47 +0200
In-Reply-To: <1340217996-2254-5-git-send-email-robert.richter@amd.com>
References: <1340217996-2254-1-git-send-email-robert.richter@amd.com>
	 <1340217996-2254-5-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 20:46 +0200, Robert Richter wrote:
> It might be of interest which perfctr msr failed.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index bb340dc..8d29a35 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -178,7 +178,7 @@ static void release_pmc_hardware(void) {}
>  
>  static bool check_hw_exists(void)
>  {
> -	u64 val, val_new = 0;
> +	u64 val, val_new = ~0;
>  	int i, reg, ret = 0;
>  
>  	/*
> @@ -229,6 +229,7 @@ bios_fail:
>  
>  msr_fail:
>  	printk(KERN_CONT "Broken PMU hardware detected, using software events only.\n");
> +	printk(KERN_ERR "Failed to access perfctr msr (MSR %x is %Lx)\n", reg, val_new);
>  
>  	return false;
>  }

My gcc wants me to add the below to avoid used uninitialized warns:

---
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -211,8 +211,9 @@ static bool check_hw_exists(void)
 	 * that don't trap on the MSR access and always return 0s.
 	 */
 	val = 0xabcdUL;
-	ret = wrmsrl_safe(x86_pmu_event_addr(0), val);
-	ret |= rdmsrl_safe(x86_pmu_event_addr(0), &val_new);
+	reg = x86_pmu_event_addr(0);
+	ret = wrmsrl_safe(reg, val);
+	ret |= rdmsrl_safe(reg, &val_new);
 	if (ret || val != val_new)
 		goto msr_fail;
 

