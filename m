Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0JCPVv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 11:21:51 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41421 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab0JCPVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 11:21:49 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
References: <20100930221351.682772535@linutronix.de>
	<20100930221740.449419120@linutronix.de>
Date: Sun, 03 Oct 2010 08:21:30 -0700
In-Reply-To: <20100930221740.449419120@linutronix.de> (Thomas Gleixner's
	message of "Thu, 30 Sep 2010 23:16:14 -0000")
Message-ID: <m14od3l2th.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Thomas Gleixner <tglx@linutronix.de>
X-Spam-Relay-Country: 
Subject: Re: [patch 20/47] x86: Remove useless reinitialization of irq descriptors
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> The descriptors are already initialized in exaclty this way.

They aren't only status is initialized exactly that way.

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/kernel/irqinit.c |   17 ++++-------------
>  1 file changed, 4 insertions(+), 13 deletions(-)
>
> Index: linux-2.6-tip/arch/x86/kernel/irqinit.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/x86/kernel/irqinit.c
> +++ linux-2.6-tip/arch/x86/kernel/irqinit.c
> @@ -100,6 +100,8 @@ int vector_used_by_percpu_irq(unsigned i
>  
>  void __init init_ISA_irqs(void)
>  {
> +	struct irq_chip *chip = legacy_pic->chip;
> +	const char *name = chip->name;
>  	int i;
>  
>  #if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
> @@ -107,19 +109,8 @@ void __init init_ISA_irqs(void)
>  #endif
>  	legacy_pic->init(0);
>  
> -	/*
> -	 * 16 old-style INTA-cycle interrupts:
> -	 */

Why delete the comment here?

> -	for (i = 0; i < legacy_pic->nr_legacy_irqs; i++) {
> -		struct irq_desc *desc = irq_to_desc(i);
> -
> -		desc->status = IRQ_DISABLED;
> -		desc->action = NULL;
> -		desc->depth = 1;
> -
> -		set_irq_chip_and_handler_name(i, &i8259A_chip,
> -					      handle_level_irq, "XT");
> -	}
> +	for (i = 0; i < legacy_pic->nr_legacy_irqs; i++)
> +		set_irq_chip_and_handler_name(i, chip, handle_level_irq, name);
>  }
>  
>  void __init init_IRQ(void)

Eric
