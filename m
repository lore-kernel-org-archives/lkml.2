Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab1FJIIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 04:08:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38582 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab1FJIIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 04:08:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DF1D0DC.8060806@jp.fujitsu.com>
Date: Fri, 10 Jun 2011 17:07:56 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 06/10] HWPOISON: Handle hwpoison in current process
References: <4df13c722729547622@agluck-desktop.sc.intel.com>
In-Reply-To: <4df13c722729547622@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/10 6:34), Luck, Tony wrote:
> From: Andi Kleen <andi@firstfloor.org>
> 
> When hardware poison handles the current process use
> a forced signal with _AR severity.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  mm/memory-failure.c |   28 ++++++++++++++++------------
>  1 files changed, 16 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 2b9a5ee..a203113 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -184,8 +184,7 @@ int hwpoison_filter(struct page *p)
>  EXPORT_SYMBOL_GPL(hwpoison_filter);
>  
>  /*
> - * Send all the processes who have the page mapped an ``action optional''
> - * signal.
> + * Send all the processes who have the page mapped a SIGBUS.
>   */
>  static int kill_proc_ao(struct task_struct *t, unsigned long addr, int trapno,
>  			unsigned long pfn, struct page *page)

It doesn't make sense that the function named "*_ao" sends _AR.

> @@ -194,23 +193,28 @@ static int kill_proc_ao(struct task_struct *t, unsigned long addr, int trapno,
>  	int ret;
>  
>  	printk(KERN_ERR
> -		"MCE %#lx: Killing %s:%d early due to hardware memory corruption\n",
> -		pfn, t->comm, t->pid);
> +		"MCE %#lx: Killing %s:%d due to hardware memory corruption\n",
> +	       pfn, t->comm, t->pid);
>  	si.si_signo = SIGBUS;
>  	si.si_errno = 0;
> -	si.si_code = BUS_MCEERR_AO;
>  	si.si_addr = (void *)addr;
>  #ifdef __ARCH_SI_TRAPNO
>  	si.si_trapno = trapno;
>  #endif
>  	si.si_addr_lsb = compound_trans_order(compound_head(page)) + PAGE_SHIFT;
> -	/*
> -	 * Don't use force here, it's convenient if the signal
> -	 * can be temporarily blocked.
> -	 * This could cause a loop when the user sets SIGBUS
> -	 * to SIG_IGN, but hopefully no one will do that?
> -	 */
> -	ret = send_sig_info(SIGBUS, &si, t);  /* synchronous? */
> +	if (t == current) {
> +		si.si_code = BUS_MCEERR_AR;
> +		ret = force_sig_info(SIGBUS, &si, t);
> +	} else {
> +		/*
> +		 * Don't use force here, it's convenient if the signal
> +		 * can be temporarily blocked.
> +		 * This could cause a loop when the user sets SIGBUS
> +		 * to SIG_IGN, but hopefully noone will do that?
> +		 */
> +		si.si_code = BUS_MCEERR_AO;
> +		ret = send_sig_info(SIGBUS, &si, t);
> +	}
>  	if (ret < 0)
>  		printk(KERN_INFO "MCE: Error sending signal to %s:%d: %d\n",
>  		       t->comm, t->pid, ret);

I suppose that usually SRAO is handled in worker thread scheduled after
MCE, so current is unlikely one of affected threads in that case...
And I also suppose that you'd like to use this function to be called
from affected thread before leaving kernel in the case of SRAR...

My concern is that "t == current" is neither strong nor clear statement
to switch the type of signal.  Someone might want to use this function
to inject _AO to current.

It is better to have new kill_proc_ar() (separated, or one shared _common
plus a couple of _ar/_ao), I think.  I believe that there is no caller
who have no idea whether it should request sending _AR or _AO.


Thanks,
H.Seto

