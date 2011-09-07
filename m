Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab1IGFsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 01:48:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:3472 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695Ab1IGFr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 01:47:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,343,1312182000"; 
   d="scan'208";a="49840378"
Message-ID: <4E670586.7020701@linux.intel.com>
Date: Wed, 07 Sep 2011 13:47:50 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0.1) Gecko/20110830 Thunderbird/6.0.1
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 3/5] HWPOISON: Handle hwpoison in current process
References: <4e5eb4f3210531eb0c@agluck-desktop.sc.intel.com>
In-Reply-To: <4e5eb4f3210531eb0c@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011/9/1 6:25, Luck, Tony 写道:
> From: Andi Kleen<andi@firstfloor.org>
>
> When hardware poison handles the current process use
> a forced signal with _AR severity.
>
> [Tony: changed some function names .. the "_ao" suffix was no longer meaningful]
>
> Signed-off-by: Andi Kleen<ak@linux.intel.com>
> Signed-off-by: Tony Luck<tony.luck@intel.com>
> ---
>   mm/memory-failure.c |   39 ++++++++++++++++++++++-----------------
>   1 files changed, 22 insertions(+), 17 deletions(-)
>
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 2b43ba0..6ccb8a6 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -186,33 +186,38 @@ int hwpoison_filter(struct page *p)
>   EXPORT_SYMBOL_GPL(hwpoison_filter);
>
>   /*
> - * Send all the processes who have the page mapped an ``action optional''
> - * signal.
> + * Send one process who has the page mapped a SIGBUS. It might
> + * be able to catch it and initiate its own task level recovery.
>    */
> -static int kill_proc_ao(struct task_struct *t, unsigned long addr, int trapno,
> +static int user_recovery(struct task_struct *t, unsigned long addr, int trapno,
>   			unsigned long pfn, struct page *page)
>   {
>   	struct siginfo si;
>   	int ret;
>
>   	printk(KERN_ERR
> -		"MCE %#lx: Killing %s:%d early due to hardware memory corruption\n",
> -		pfn, t->comm, t->pid);
> +		"MCE %#lx: Killing %s:%d due to hardware memory corruption\n",
> +	       pfn, t->comm, t->pid);
>   	si.si_signo = SIGBUS;
>   	si.si_errno = 0;
> -	si.si_code = BUS_MCEERR_AO;
>   	si.si_addr = (void *)addr;
>   #ifdef __ARCH_SI_TRAPNO
>   	si.si_trapno = trapno;
>   #endif
>   	si.si_addr_lsb = compound_trans_order(compound_head(page)) + PAGE_SHIFT;
> -	/*
> -	 * Don't use force here, it's convenient if the signal
> -	 * can be temporarily blocked.
> -	 * This could cause a loop when the user sets SIGBUS
> -	 * to SIG_IGN, but hopefully no one will do that?
> -	 */
> -	ret = send_sig_info(SIGBUS,&si, t);  /* synchronous? */
> +	if (t == current) {
> +		si.si_code = BUS_MCEERR_AR;
> +		ret = force_sig_info(SIGBUS,&si, t);
> +	} else {
> +		/*
> +		 * Don't use force here, it's convenient if the signal
> +		 * can be temporarily blocked.
> +		 * This could cause a loop when the user sets SIGBUS
> +		 * to SIG_IGN, but hopefully noone will do that?
                                              ^^^^^
spelling error

