Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238Ab2GGEjB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 00:39:01 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:45116 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab2GGEi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 00:38:59 -0400
Date: Sat, 7 Jul 2012 06:38:47 +0200
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH] x86/mce: Need to let kill_proc() send signal to doomed
 process
Message-ID: <20120707043847.GB5708@aftab.osrc.amd.com>
References: <6695e005b7368df4307d34276300fe030e83466c.1341611925.git.tony.luck@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6695e005b7368df4307d34276300fe030e83466c.1341611925.git.tony.luck@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 02:33:15PM -0700, Tony Luck wrote:
> In commit dad1743e5993f19b3d7e7bd0fb35dc45b5326626
>   x86/mce: Only restart instruction after machine check recovery if it is safe
> we fixed mce_notify_process() to force a signal to the current process
> if it was not restartable (RIPV bit not set in MCG_STATUS). But doing
> it here means that the process doesn't get told the virtual address of
> the fault via siginfo_t->si_addr. This would prevent application level
> recovery from the fault.

Ok, this makes sense, we want to kill all the processes mapping that
page.

> Make a new MF_MUST_KILL flag bit for memory_failure() et. al. to use
> so that we will provide the right information with the signal.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c | 4 ++--
>  include/linux/mm.h               | 1 +
>  mm/memory-failure.c              | 8 +++++---
>  3 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index da27c5d..43f918d 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1200,8 +1200,8 @@ void mce_notify_process(void)
>  	 * doomed. We still need to mark the page as poisoned and alert any
>  	 * other users of the page.
>  	 */
> -	if (memory_failure(pfn, MCE_VECTOR, MF_ACTION_REQUIRED) < 0 ||
> -			   mi->restartable == 0) {
> +	if (memory_failure(pfn, MCE_VECTOR,
> +			   MF_ACTION_REQUIRED|MF_MUST_KILL) < 0) {

This makes mi->restartable unused?

And more specifically, we're not looking at RIPV anymore. I'm guessing
when we've reached this point, we always MUST_KILL?

>  		pr_err("Memory error not recovered");
>  		force_sig(SIGBUS, current);
>  	}
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index b36d08c..f9f279c 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1591,6 +1591,7 @@ void vmemmap_populate_print_last(void);
>  enum mf_flags {
>  	MF_COUNT_INCREASED = 1 << 0,
>  	MF_ACTION_REQUIRED = 1 << 1,
> +	MF_MUST_KILL = 1 << 2,
>  };
>  extern int memory_failure(unsigned long pfn, int trapno, int flags);
>  extern void memory_failure_queue(unsigned long pfn, int trapno, int flags);
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index ab1e714..e3e0045 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -858,7 +858,7 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
>  	struct address_space *mapping;
>  	LIST_HEAD(tokill);
>  	int ret;
> -	int kill = 1;
> +	int kill = 1, doit;
>  	struct page *hpage = compound_head(p);
>  	struct page *ppage;
>  
> @@ -965,12 +965,14 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
>  	 * Now that the dirty bit has been propagated to the
>  	 * struct page and all unmaps done we can decide if
>  	 * killing is needed or not.  Only kill when the page
> -	 * was dirty, otherwise the tokill list is merely
> +	 * was dirty or the process is not restartable,
> +	 * otherwise the tokill list is merely
>  	 * freed.  When there was a problem unmapping earlier
>  	 * use a more force-full uncatchable kill to prevent
>  	 * any accesses to the poisoned memory.
>  	 */
> -	kill_procs(&tokill, !!PageDirty(ppage), trapno,
> +	doit = !!PageDirty(ppage) || (flags & MF_MUST_KILL) != 0;

Maybe

				     !!(flags & MF_MUST_KILL)
?

> +	kill_procs(&tokill, doit, trapno,
>  		      ret != SWAP_SUCCESS, p, pfn, flags);
>  
>  	return ret;
> -- 

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
