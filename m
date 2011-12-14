Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab1LNQE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:04:28 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:43520 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368Ab1LNQE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:04:27 -0500
Date: Wed, 14 Dec 2011 17:04:10 +0100
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 5/6] x86, mce: handle "action required" errors
Message-ID: <20111214160409.GG23589@aftab>
References: <cover.1323803130.git.tony.luck@intel.com>
 <80cbf65ae6e4bd610523cc8568b0c2dcb8c629b6.1323803130.git.tony.luck@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80cbf65ae6e4bd610523cc8568b0c2dcb8c629b6.1323803130.git.tony.luck@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 01:47:45PM -0800, Tony Luck wrote:
[..]

> - * Called after mce notification in process context. This code
> - * is allowed to sleep. Call the high level VM handler to process
> - * any corrupted pages.
> - * Assume that the work queue code only calls this one at a time
> - * per CPU.
> - * Note we don't disable preemption, so this code might run on the wrong
> - * CPU. In this case the event is picked up by the scheduled work queue.
> - * This is merely a fast path to expedite processing in some common
> - * cases.
> + * Called in process context that interrupted by MCE and marked with
> + * TIF_MCE_NOTFY, just before returning to errorneous userland.
> + * This code is allowed to sleep.
> + * Attempt possible recovery such as calling the high level VM handler to
> + * process any corrupted pages, and kill/signal current process if required.
>   */
>  void mce_notify_process(void)
>  {
> +	__u64	paddr = paddr;
>  	unsigned long pfn;
> -	mce_notify_irq();
> -	while (mce_ring_get(&pfn))
> -		memory_failure(pfn, MCE_VECTOR, 0);
> +
> +	if (!mce_find_info(&paddr))
> +		mce_panic("Lost address", NULL, NULL);

Wouldn't it be good to return struct mce_info *mi here in addition to
&paddr...

> +	pfn = paddr >> PAGE_SHIFT;
> +
> +	clear_thread_flag(TIF_MCE_NOTIFY);
> +
> +	pr_err("Uncorrected hardware memory error in user-access at %llx",
> +		 paddr);
> +	if (memory_failure(pfn, MCE_VECTOR, MF_ACTION_REQUIRED) < 0) {
> +		pr_err("Memory error not recovered");
> +		force_sig(SIGBUS, current);
> +	} else {
> +		pr_err("Memory error recovered");
> +		mce_clear_info();

so that you don't need to iterate again over the mce_info array but do:

	mce_clear_info(mi);

?

This assumes, of course, that you have only one AR MCE per task, per
return to userspace. I guess this is fine for now.

> +	}
>  }
>  
>  static void mce_process_work(struct work_struct *dummy)
>  {
> -	mce_notify_process();
> +	unsigned long pfn;
> +
> +	while (mce_ring_get(&pfn))
> +		memory_failure(pfn, MCE_VECTOR, 0);
>  }
>  
>  #ifdef CONFIG_X86_MCE_INTEL
> @@ -1232,8 +1246,6 @@ int mce_notify_irq(void)
>  	/* Not more than two messages every minute */
>  	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
>  
> -	clear_thread_flag(TIF_MCE_NOTIFY);
> -
>  	if (test_and_clear_bit(0, &mce_need_notify)) {
>  		/* wake processes polling /dev/mcelog */
>  		wake_up_interruptible(&mce_chrdev_wait);
> -- 
> 1.7.3.1
> 

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
