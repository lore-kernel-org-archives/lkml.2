Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab2JJT7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 15:59:31 -0400
Received: from lunge.queued.net ([173.255.254.236]:42134 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114Ab2JJT7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 15:59:30 -0400
Date: Wed, 10 Oct 2012 12:59:27 -0700
From: Andres Salomon <dilinger@queued.net>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Woodhouse <dwmw2@infradead.org>, Vivek Goyal <vgoyal@in.ibm.com>,
        Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        techteam@lists.laptop.org
Subject: Re: [RFC PATCH] x86-32: Start out eflags and cr4 clean
Message-ID: <20121010125927.0968dd8b@dev.queued.net>
In-Reply-To: <1348529239-17943-1-git-send-email-hpa@linux.intel.com>
References: <87sjaaj3cx.fsf@xmission.com>
	<1348529239-17943-1-git-send-email-hpa@linux.intel.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for Cc'ing me.  I just tested this on an XO-1, and it doesn't
appear to break anything.  So, looks fine to me.

Acked-by: Andres Salomon <dilinger@queued.net>


On Mon, 24 Sep 2012 16:27:19 -0700 "H. Peter
Anvin" <hpa@linux.intel.com> wrote:

> From: "H. Peter Anvin" <hpa@linux.intel.com>
> 
> %cr4 is supposed to reflect a set of features into which the operating
> system is opting in.  If the BIOS or bootloader leaks bits here, this
> is not desirable.  Consider a bootloader passing in %cr4.pae set to a
> legacy paging kernel, for example -- it will not have any immediate
> effect, but the kernel would crash when turning paging on.
> 
> A similar argument applies to %eflags, and since we have to look for
> %eflags.id being settable we can use a sequence which clears %eflags
> as a side effect.
> 
> Note that we already do this for x86-64.
> 
> I would like opinions on this especially from the PV crowd and
> nonstandard platforms (e.g. OLPC) to make sure we don't screw them up.
> 
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/kernel/head_32.S |   31 ++++++++++++++++---------------
>  1 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> index d42ab17..957a47a 100644
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -287,27 +287,28 @@ ENTRY(startup_32_smp)
>  	leal -__PAGE_OFFSET(%ecx),%esp
>  
>  default_entry:
> -
>  /*
>   *	New page tables may be in 4Mbyte page mode and may
>   *	be using the global pages. 
>   *
>   *	NOTE! If we are on a 486 we may have no cr4 at all!
> - *	So we do not try to touch it unless we really have
> - *	some bits in it to set.  This won't work if the BSP
> - *	implements cr4 but this AP does not -- very unlikely
> - *	but be warned!  The same applies to the pse feature
> - *	if not equally supported. --macro
> - *
> - *	NOTE! We have to correct for the fact that we're
> - *	not yet offset PAGE_OFFSET..
> + *	Specifically, cr4 exists if and only if CPUID exists,
> + *	which in turn exists if and only if EFLAGS.ID exists.
>   */
> -#define cr4_bits pa(mmu_cr4_features)
> -	movl cr4_bits,%edx
> -	andl %edx,%edx
> -	jz 6f
> -	movl %cr4,%eax		# Turn on paging options
> (PSE,PAE,..)
> -	orl %edx,%eax
> +	movl $X86_EFLAGS_ID,%ecx
> +	pushl %ecx
> +	popfl
> +	pushfl
> +	popl %eax
> +	pushl $0
> +	popfl
> +	pushfl
> +	popl %edx
> +	xorl %edx,%eax
> +	testl %ecx,%eax
> +	jz 6f			# No ID flag = no CPUID = no CR4
> +
> +	movl pa(mmu_cr4_features),%eax
>  	movl %eax,%cr4
>  
>  	testb $X86_CR4_PAE, %al		# check if PAE is
> enabled
