Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab0G1Wvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 18:51:49 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64363 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595Ab0G1Wvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 18:51:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6057"; a="48985336"
Subject: Re: [PATCH 2/3] arm: mm: do not set missing flags on ScorpionMP
From: Daniel Walker <dwalker@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Steve Muckle <smuckle@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Tony Lindgren <tony@atomide.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
In-Reply-To: <20100728223603.GB6729@n2100.arm.linux.org.uk>
References: <1279911483-7039-1-git-send-email-johlstei@codeaurora.org>
	 <1279911483-7039-3-git-send-email-johlstei@codeaurora.org>
	 <20100724082334.GB15571@n2100.arm.linux.org.uk>
	 <1280354280.21185.10.camel@c-dwalke-linux.qualcomm.com>
	 <20100728223603.GB6729@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 15:51:35 -0700
Message-ID: <1280357495.21185.26.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-28 at 23:36 +0100, Russell King - ARM Linux wrote:
> On Wed, Jul 28, 2010 at 02:58:00PM -0700, Daniel Walker wrote:
> > On Sat, 2010-07-24 at 09:23 +0100, Russell King - ARM Linux wrote:
> > > On Fri, Jul 23, 2010 at 11:58:02AM -0700, Jeff Ohlstein wrote:
> > > > From: Steve Muckle <smuckle@codeaurora.org>
> > > > 
> > > > ScorpionMP does not have the SMP/nAMP mode and TLB ops
> > > > broadcasting bits in the ACTLR.
> > > 
> > > Please provide a separate instance of __v7_proc_info for your processor
> > > and direct it to jump into the __v7_setup code after this setup instead.
> > 
> > 
> > You mean add another label into __v7_setup along with a proc-msm.S to
> > jump over this code?
> 
> Yes to the first, no to the second.
> 

Like so? I haven't tested this.

diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 6bddf5d..167bedb 100644
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
+	.long	0x000f0000		@ Required ID value
+	.long	0x000f0000		@ Mask for ID
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

