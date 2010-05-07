Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab0EGUch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 16:32:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37396 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab0EGUcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 16:32:36 -0400
Message-ID: <4BE478C1.2060602@zytor.com>
Date: Fri, 07 May 2010 13:32:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Alek Du <alek.du@intel.com>, Arjan van de Ven <arjan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Jacob Pan <jacob.jun.pan@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan.van.de.ven@intel.com>
Subject: RFD: Should we remove the HLT check?  (was Re: [PATCH 1/8] x86: avoid
 check hlt if no timer interrupts)
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273254108-3234-2-git-send-email-jacob.jun.pan@linux.intel.com>
In-Reply-To: <1273254108-3234-2-git-send-email-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2010 10:41 AM, Jacob Pan wrote:
> From: Jacob Pan <jacob.jun.pan@intel.com>
> 
> check hlt requires external timer interrupt to wake up the
> cpu. for platforms equipped with only per cpu timers, we don't
> have external interrupts during check hlt.
> this patch checks such condition to avoid kernel hang at hlt.
> it also saves boot time in that hlt four times in the current code
> requires four ticks to break out of them.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  arch/x86/include/asm/bugs.h |    1 +
>  arch/x86/kernel/cpu/bugs.c  |    4 ++++
>  2 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/bugs.h b/arch/x86/include/asm/bugs.h
> index 08abf63..1e0cef8 100644
> --- a/arch/x86/include/asm/bugs.h
> +++ b/arch/x86/include/asm/bugs.h
> @@ -2,6 +2,7 @@
>  #define _ASM_X86_BUGS_H
>  
>  extern void check_bugs(void);
> +extern struct clock_event_device *global_clock_event;
>  
>  #if defined(CONFIG_CPU_SUP_INTEL) && defined(CONFIG_X86_32)
>  int ppro_with_ram_bug(void);
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 01a2652..c0d9688 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -90,6 +90,10 @@ static void __init check_hlt(void)
>  		return;
>  
>  	printk(KERN_INFO "Checking 'hlt' instruction... ");
> +	if (!global_clock_event) {
> +		printk(KERN_CONT "no clockevent to wake up, skipped.\n");
> +		return;
> +	}
>  	if (!boot_cpu_data.hlt_works_ok) {
>  		printk("disabled\n");
>  		return;

I really wish I knew the exact systems affected by the HLT bug.  If I
remember correctly, it was some 386 systems -- or possibly 486 systems
as well -- a very long time ago.  This test just provides a diagnosis if
the system really is bad (it hangs with an obvious message) at the cost
of some 40 ms to the system boot time.  I suspect C1 (HLT) being broken
is not anywhere close to the predominant power management problem in the
current day, and as such I'm wondering if this particular test hasn't
outlived its usefulness.

Thoughts?

	-hpa

