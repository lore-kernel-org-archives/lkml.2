Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab0G2WnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 18:43:09 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20743 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab0G2WnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 18:43:05 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6058"; a="49262844"
Subject: Re: [PATCH 2/3] arm: mm: do not set missing flags on ScorpionMP
From: Daniel Walker <dwalker@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Steve Muckle <smuckle@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Tony Lindgren <tony@atomide.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
In-Reply-To: <20100729071818.GC6729@n2100.arm.linux.org.uk>
References: <1279911483-7039-1-git-send-email-johlstei@codeaurora.org>
	 <1279911483-7039-3-git-send-email-johlstei@codeaurora.org>
	 <20100724082334.GB15571@n2100.arm.linux.org.uk>
	 <1280354280.21185.10.camel@c-dwalke-linux.qualcomm.com>
	 <20100728223603.GB6729@n2100.arm.linux.org.uk>
	 <1280357495.21185.26.camel@c-dwalke-linux.qualcomm.com>
	 <20100729071818.GC6729@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 15:42:46 -0700
Message-ID: <1280443366.27035.14.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-29 at 08:18 +0100, Russell King - ARM Linux wrote:
> On Wed, Jul 28, 2010 at 03:51:35PM -0700, Daniel Walker wrote:
> > @@ -326,6 +327,29 @@ cpu_elf_name:
> >  
> >  	.section ".proc.info.init", #alloc, #execinstr
> >  
> > +	.type   __v7_msm_proc_info, #object
> > +__v7_msm_proc_info:
> > +	.long	0x000f0000		@ Required ID value
> > +	.long	0x000f0000		@ Mask for ID
> 
> Almost - is there no more specific ID value for your CPU?

Here's one with a more specific cpu id. Would you be willing to take
this for 2.6.36 or are you pretty much done taking pull requests?

Daniel

diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 6bddf5d..a5b613d 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -196,6 +196,7 @@ __v7_setup:
 	orreq	r0, r0, #(1 << 6) | (1 << 0)	@ Enable SMP/nAMP mode and
 	mcreq	p15, 0, r0, c1, c0, 1		@ TLB ops broadcasting
 #endif
+__v7_msm_setup:
 	adr	r12, __v7_setup_stack		@ the local stack
 	stmia	r12, {r0-r5, r7, r9, r11, lr}
 	bl	v7_flush_dcache_all
@@ -326,6 +327,29 @@ cpu_elf_name:
 
 	.section ".proc.info.init", #alloc, #execinstr
 
+	.type   __v7_msm_proc_info, #object
+__v7_msm_proc_info:
+	.long	0x510f0000		@ Required ID value
+	.long	0xff0f0000		@ Mask for ID
+	.long   PMD_TYPE_SECT | \
+		PMD_SECT_AP_WRITE | \
+		PMD_SECT_AP_READ | \
+		PMD_FLAGS
+	.long   PMD_TYPE_SECT | \
+		PMD_SECT_XN | \
+		PMD_SECT_AP_WRITE | \
+		PMD_SECT_AP_READ
+	b	__v7_msm_setup
+	.long	cpu_arch_name
+	.long	cpu_elf_name
+	.long	HWCAP_SWP|HWCAP_HALF|HWCAP_THUMB|HWCAP_FAST_MULT|HWCAP_EDSP
+	.long	cpu_v7_name
+	.long	v7_processor_functions
+	.long	v7wbi_tlb_fns
+	.long	v6_user_fns
+	.long	v7_cache_fns
+	.size	__v7_msm_proc_info, . - __v7_msm_proc_info
+
 	/*
 	 * Match any ARMv7 processor core.
 	 */

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

