Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab1DGIDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 04:03:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52004 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab1DGIDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 04:03:12 -0400
Date: Thu, 7 Apr 2011 10:03:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Lutomirski <luto@mit.edu>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFT/PATCH v2 6/6] x86-64: Turn off -pg and turn on
 -foptimize-sibling-calls for vDSO
Message-ID: <20110407080301.GE24879@elte.hu>
References: <cover.1302137785.git.luto@mit.edu>
 <78b66387ae46799690413ea241053e4d592cf728.1302137785.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78b66387ae46799690413ea241053e4d592cf728.1302137785.git.luto@mit.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@mit.edu> wrote:

> The vDSO isn't part of the kernel, so profiling and kernel
> backtraces don't really matter.
> 
> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> ---
>  arch/x86/vdso/Makefile |   15 ++++++++++++++-
>  1 files changed, 14 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
> index a651861..bef0bc9 100644
> --- a/arch/x86/vdso/Makefile
> +++ b/arch/x86/vdso/Makefile
> @@ -37,11 +37,24 @@ $(obj)/%.so: OBJCOPYFLAGS := -S
>  $(obj)/%.so: $(obj)/%.so.dbg FORCE
>  	$(call if_changed,objcopy)
>  
> +#
> +# Don't omit frame pointers for ease of userspace debugging, but do
> +# optimize sibling calls.
> +#
>  CFL := $(PROFILING) -mcmodel=small -fPIC -O2 -fasynchronous-unwind-tables -m64 \
> -       $(filter -g%,$(KBUILD_CFLAGS)) $(call cc-option, -fno-stack-protector)
> +       $(filter -g%,$(KBUILD_CFLAGS)) $(call cc-option, -fno-stack-protector) \
> +       -fno-omit-frame-pointer -foptimize-sibling-calls
>  
>  $(vobjs): KBUILD_CFLAGS += $(CFL)
>  
> +#
> +# vDSO code runs in userspace and -pg doesn't help with profiling anyway.
> +#
> +CFLAGS_REMOVE_vdso-note.o = -pg
> +CFLAGS_REMOVE_vclock_gettime.o = -pg
> +CFLAGS_REMOVE_vgetcpu.o = -pg
> +CFLAGS_REMOVE_vvar.o = -pg

The comment makes no sense in this form, -pg is not used for profiling but 
in-kernel tracing.

Also, please do not do multiple changes in a single patch, split out the -pg, 
the -fomit-frame-pointers and the -foptimize-sibling-calls change into two 
patches. This will also help bisection, should some GCC version do something 
silly with -foptimize-sibling-calls ...

Thanks,

	Ingo
