Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab0LAAMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 19:12:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:6549 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab0LAAMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 19:12:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,282,1288594800"; 
   d="scan'208";a="579243760"
Subject: Re: -tip tree resume fail, bisect to 5bd5a45(x86: Add NX
 protection for kernel data)
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mat <castet.matthieu@free.fr>, Andi Kleen <andi@firstfloor.org>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Xuxian Jiang <jiang@cs.ncsu.edu>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>
In-Reply-To: <1291116438.32004.649.camel@laptop>
References: <1290410581.2405.24.camel@minggr.sh.intel.com>
	 <1290431008.2072.119.camel@laptop>	<1290443379.4cea9a73cd9ce@imp.free.fr>
	 <1290443758.2072.318.camel@laptop>	<20101122164247.GC21836@basil.fritz.box>
	 <20101123235527.54293b59@mat-laptop>  <20101126183144.300a71a4@mat-laptop>
	 <1291093230.2405.191.camel@minggr.sh.intel.com>
	 <1291116438.32004.649.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 08:15:04 +0800
Message-ID: <1291162504.2405.216.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 19:27 +0800, Peter Zijlstra wrote:
> On Tue, 2010-11-30 at 13:00 +0800, Lin Ming wrote:
> > echo 0 > /sys/devices/system/cpu/cpu1/online;
> > echo 1 > /sys/devices/system/cpu/cpu1/online;
> > 
> > then machine just reboots...
> > 
> 
> That should work on current -tip (and my test machine confirms with a
> -tip of yesterday) due to:

Yes, I know.

I tested for Mat's request to confirm that CPU suspend/resume also
broken, not only S3.

And no interesting trace I can get because machine just reboots
immediately when CPU suspend/resume.

Thanks.

> 
> ---
> commit 691513f70d3957939a318da970987b876c720861
> Author: Lin Ming <ming.m.lin@intel.com>
> Date:   Mon Nov 22 14:03:28 2010 +0100
> 
>     x86: Resume trampoline must be executable
>     
>     commit 5bd5a452(x86: Add NX protection for kernel data) marked the
>     trampoline area NX - which unsurprisingly breaks resume and cpu
>     hotplug.
>     
>     Revert the portion of that commit, which touches the trampoline.
>     
>     Originally-from: Lin Ming <ming.m.lin@intel.com>
>     LKML-Reference: <1290410581.2405.24.camel@minggr.sh.intel.com>
>     Cc: Matthieu Castet <castet.matthieu@free.fr>
>     Cc: Siarhei Liakh <sliakh.lkml@gmail.com>
>     Cc: Xuxian Jiang <jiang@cs.ncsu.edu>
>     Cc: Ingo Molnar <mingo@elte.hu>
>     Cc: Arjan van de Ven <arjan@infradead.org>
>     Cc: Andi Kleen <andi@firstfloor.org>
>     Tested-by: Peter Zijlstra <peterz@infradead.org>
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index ce59c05..71a5929 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -788,7 +788,6 @@ void mark_rodata_ro(void)
>  	unsigned long rodata_start =
>  		((unsigned long)__start_rodata + PAGE_SIZE - 1) & PAGE_MASK;
>  	unsigned long end = (unsigned long) &__end_rodata_hpage_align;
> -	unsigned long kernel_end = (((unsigned long)&__init_end + HPAGE_SIZE) & HPAGE_MASK);
>  	unsigned long text_end = PAGE_ALIGN((unsigned long) &__stop___ex_table);
>  	unsigned long rodata_end = PAGE_ALIGN((unsigned long) &__end_rodata);
>  	unsigned long data_start = (unsigned long) &_sdata;
> @@ -803,7 +802,7 @@ void mark_rodata_ro(void)
>  	 * The rodata section (but not the kernel text!) should also be
>  	 * not-executable.
>  	 */
> -	set_memory_nx(rodata_start, (kernel_end - rodata_start) >> PAGE_SHIFT);
> +	set_memory_nx(rodata_start, (end - rodata_start) >> PAGE_SHIFT);
>  
>  	rodata_test();
>  
> 


