Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab0JZUIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:08:30 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54482 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262Ab0JZUI2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 16:08:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EiGMqdeMXIVIYE2CNkzzZj7bFN3smK+XfjHj2p2ikReVE89QT+sbkxT6I0PPee4Mh1
         p7aEfQ9aqefp3x+8KG31nUeLuR584XDnHXMyH7jBIwHRaYCf9uiljGIhva69K89GMQbX
         M+hlZNyYiRGKkFivTuVUKOGR2z6gVf/u2Dqe8=
MIME-Version: 1.0
In-Reply-To: <20101004154633.GA2900@redhat.com>
References: <AANLkTimF2tcksBkww50MhiO0YY=MCt4rcnfDR+tJhTUJ@mail.gmail.com>
	<20101004154633.GA2900@redhat.com>
Date: Tue, 26 Oct 2010 21:08:27 +0100
X-Google-Sender-Auth: M4_c7xvWEjsfG9v1ExMlgzf_Mkk
Message-ID: <AANLkTikiQHLAM9GwMF8+spW-RgG9-=rducMLaThQmE+i@mail.gmail.com>
Subject: Re: Dynamic nop selection breaks boot on Geode LX
From: Daniel Drake <dsd@laptop.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Andres Salomon <dilinger@queued.net>, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, mingo@elte.hu,
        hpa@zytor.com, nick.lowe@gmail.com, Borislav Petkov <bp@alien8.de>,
        tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 4 October 2010 16:46, Jason Baron <jbaron@redhat.com> wrote:
> Hi Daniel,
>
> looks like I moved dynamic no-op selection way too early in the boot -
> before the exception tables required to select invalid opcodes were
> even set up. The patch belows moves them later and should resolve this
> issue for you. thanks for narrowing it down!

Bump... This patch has not been merged. I see that there is still some
lack of consensus in this area but please don't forget about it. The
offending commit (f49aa448561fe) has ended up in Linus' tree, so
Linus' tree does not boot on Geode as a result.

>
>
> move arch_init_ideal_nop5 later
>
> arch_init_ideal_nop5() was being called from setup_arch() before
> the exception table was setup. Move it later into
> alternative_instructions().
>
> Fixes a boot hang on OLPC's XO-1 laptop based on Geode LX
> processor.
>
>
> Reported-by: Daniel Drake <dsd@laptop.org>
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
>  arch/x86/kernel/alternative.c |    5 +++++
>  arch/x86/kernel/setup.c       |    6 ------
>  2 files changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index cb0e6d3..d8b5b21 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -454,6 +454,7 @@ extern struct paravirt_patch_site __start_parainstructions[],
>
>  void __init alternative_instructions(void)
>  {
> +       unsigned long flags;
>        /* The patching is not fully atomic, so try to avoid local interruptions
>           that might execute the to be patched code.
>           Other CPUs are not running. */
> @@ -508,6 +509,10 @@ void __init alternative_instructions(void)
>                                (unsigned long)__smp_locks_end);
>
>        restart_nmi();
> +
> +       local_irq_save(flags);
> +       arch_init_ideal_nop5();
> +       local_irq_restore(flags);
>  }
>
>  /**
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 468ccd2..85b02b6 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -112,7 +112,6 @@
>  #include <asm/numa_64.h>
>  #endif
>  #include <asm/mce.h>
> -#include <asm/alternative.h>
>
>  /*
>  * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
> @@ -690,7 +689,6 @@ void __init setup_arch(char **cmdline_p)
>  {
>        int acpi = 0;
>        int k8 = 0;
> -       unsigned long flags;
>
>  #ifdef CONFIG_X86_32
>        memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
> @@ -1038,10 +1036,6 @@ void __init setup_arch(char **cmdline_p)
>        x86_init.oem.banner();
>
>        mcheck_init();
> -
> -       local_irq_save(flags);
> -       arch_init_ideal_nop5();
> -       local_irq_restore(flags);
>  }
>
>  #ifdef CONFIG_X86_32
> --
> 1.7.1
>
>
