Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab2JRADU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 20:03:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39464 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab2JRADS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 20:03:18 -0400
Message-ID: <507F473D.1060700@zytor.com>
Date: Wed, 17 Oct 2012 17:03:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        lenb@kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/4] x86/wakeup/sleep: Check whether the TSS GDT descriptor
 is empty before using it.
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com> <1350481786-4969-2-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1350481786-4969-2-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 06:49 AM, Konrad Rzeszutek Wilk wrote:
> We check the TSS descriptor before we try to dereference it.
> Also fix up the value to use the #defines.
>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>   arch/x86/power/cpu.c |    7 +++++--
>   1 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
> index 218cdb1..c17370e 100644
> --- a/arch/x86/power/cpu.c
> +++ b/arch/x86/power/cpu.c
> @@ -133,7 +133,9 @@ static void fix_processor_context(void)
>   {
>   	int cpu = smp_processor_id();
>   	struct tss_struct *t = &per_cpu(init_tss, cpu);
> -
> +#ifdef CONFIG_X86_64
> +	struct desc_struct *desc = get_cpu_gdt_table(cpu);
> +#endif
>   	set_tss_desc(cpu, t);	/*
>   				 * This just modifies memory; should not be
>   				 * necessary. But... This is necessary, because
> @@ -142,7 +144,8 @@ static void fix_processor_context(void)
>   				 */
>
>   #ifdef CONFIG_X86_64
> -	get_cpu_gdt_table(cpu)[GDT_ENTRY_TSS].type = 9;
> +	if (!desc_empty(&desc[GDT_ENTRY_TSS]))
> +		desc[GDT_ENTRY_TSS].type = DESC_TSS;
>
>   	syscall_init();				/* This sets MSR_*STAR and related */
>   #endif
>

Why is this patch necessary?  Presumably there is something further down 
the line which depends on the TSS descriptor being empty, but if so, what?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

