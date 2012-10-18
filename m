Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab2JROra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:47:30 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43931 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab2JROrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:47:25 -0400
Date: Thu, 18 Oct 2012 10:47:12 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        lenb@kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/4] x86/wakeup/sleep: Check whether the TSS GDT
 descriptor is empty before using it.
Message-ID: <20121018144709.GB19782@localhost.localdomain>
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com>
 <1350481786-4969-2-git-send-email-konrad.wilk@oracle.com>
 <507F473D.1060700@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507F473D.1060700@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 05:03:09PM -0700, H. Peter Anvin wrote:
> On 10/17/2012 06:49 AM, Konrad Rzeszutek Wilk wrote:
> >We check the TSS descriptor before we try to dereference it.
> >Also fix up the value to use the #defines.
> >
> >Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >---
> >  arch/x86/power/cpu.c |    7 +++++--
> >  1 files changed, 5 insertions(+), 2 deletions(-)
> >
> >diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
> >index 218cdb1..c17370e 100644
> >--- a/arch/x86/power/cpu.c
> >+++ b/arch/x86/power/cpu.c
> >@@ -133,7 +133,9 @@ static void fix_processor_context(void)
> >  {
> >  	int cpu = smp_processor_id();
> >  	struct tss_struct *t = &per_cpu(init_tss, cpu);
> >-
> >+#ifdef CONFIG_X86_64
> >+	struct desc_struct *desc = get_cpu_gdt_table(cpu);
> >+#endif
> >  	set_tss_desc(cpu, t);	/*
> >  				 * This just modifies memory; should not be
> >  				 * necessary. But... This is necessary, because
> >@@ -142,7 +144,8 @@ static void fix_processor_context(void)
> >  				 */
> >
> >  #ifdef CONFIG_X86_64
> >-	get_cpu_gdt_table(cpu)[GDT_ENTRY_TSS].type = 9;
> >+	if (!desc_empty(&desc[GDT_ENTRY_TSS]))
> >+		desc[GDT_ENTRY_TSS].type = DESC_TSS;
> >
> >  	syscall_init();				/* This sets MSR_*STAR and related */
> >  #endif
> >
> 
> Why is this patch necessary?  Presumably there is something further
> down the line which depends on the TSS descriptor being empty, but
> if so, what?

I could not find it. This write has been in the code since the initial
git history. Is the pre-git bitkeeper tree somewhere available?
> 
> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 
