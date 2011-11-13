Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab1KMPRY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 10:17:24 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55085 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab1KMPRX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 10:17:23 -0500
MIME-Version: 1.0
In-Reply-To: <1321075592-31600-7-git-send-email-fenghua.yu@intel.com>
References: <1321075592-31600-1-git-send-email-fenghua.yu@intel.com>
	<1321075592-31600-7-git-send-email-fenghua.yu@intel.com>
Date: Sun, 13 Nov 2011 10:17:21 -0500
Message-ID: <CAMzpN2i40ZOJ7GyARFg+dVeox3DpfTFV8WL-C_OzjQ0z7Xz_kQ@mail.gmail.com>
Subject: Re: [PATCH v4 6/7] x86/i387.c: Thread xstate is initialized only on
 BSP once
From: Brian Gerst <brgerst@gmail.com>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 12, 2011 at 12:26 AM, Fenghua Yu <fenghua.yu@intel.com> wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
>
> init_thread_xstate() is only called on BSP once to avoid overriding xstate_size.
>
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/kernel/i387.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
> index 739d859..72652ff 100644
> --- a/arch/x86/kernel/i387.c
> +++ b/arch/x86/kernel/i387.c
> @@ -93,6 +93,7 @@ void __cpuinit fpu_init(void)
>  {
>        unsigned long cr0;
>        unsigned long cr4_mask = 0;
> +       static int once = 1;
>
>        if (cpu_has_fxsr)
>                cr4_mask |= X86_CR4_OSFXSR;
> @@ -107,8 +108,14 @@ void __cpuinit fpu_init(void)
>                cr0 |= X86_CR0_EM;
>        write_cr0(cr0);
>
> -       if (!smp_processor_id())
> +       /*
> +        * init_thread_xstate is only called on BSP once to avoid overriding
> +        * xstate_size.
> +        */
> +       if (!smp_processor_id() && once) {
> +               once = 0;
>                init_thread_xstate();
> +       }

Just check if xstate_size is 0 instead of adding a new flag.

--
Brian Gerst
