Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab0KPST3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 13:19:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49626 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444Ab0KPST2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 13:19:28 -0500
Date: Tue, 16 Nov 2010 18:19:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/20] ARM: LPAE: Introduce L_PTE_NOEXEC and
	L_PTE_NOWRITE
Message-ID: <20101116181906.GA21926@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com> <1289584840-18097-6-git-send-email-catalin.marinas@arm.com> <20101115183014.GD31421@n2100.arm.linux.org.uk> <AANLkTikCVCuR2mxyoE7e=V_FauTxztLHUJp97+rroUe-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikCVCuR2mxyoE7e=V_FauTxztLHUJp97+rroUe-@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 03:18:03PM +0000, Catalin Marinas wrote:
> On 15 November 2010 18:30, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > Let's not make this more complicated than it has to be.  If we need the
> > inverse of WRITE and EXEC, then that's what we should change everyone to,
> > not invent a new system to work along side the old system.
> 
> This adds an additional instruction in set_pte_ext, unless you can
> write the bit checking in a better way:

It actually results in the same number of instructions.  From memory:

ARMv3-ARMv5:
-	eor	r3, r1, #L_PTE_PRESENT | L_PTE_YOUNG | L_PTE_WRITE | L_PTE_DIRTY
-	tst	r3, #L_PTE_WRITE | L_PTE_DIRTY	@ write and dirty?
-	orreq	r2, r2, #PTE_SMALL_AP_UNO_SRW
+	eor	r3, r1, #L_PTE_PRESENT | L_PTE_YOUNG | L_PTE_DIRTY
+	tst	r3, #L_PTE_RDONLY | L_PTE_DIRTY	@ write and dirty?
+	orreq	r2, r2, #PTE_SMALL_AP_UNO_SRW

and for ARMv6+:

-	tst	r1, #L_PTE_WRITE
-	tstne	r1, #L_PTE_DIRTY
-	orreq	r3, r3, #PTE_EXT_APX
+	eor	r1, r1, #L_PTE_DIRTY
+	tst	r1, #L_PTE_RDONLY | L_PTE_DIRTY
+	orrne	r3, r3, #PTE_EXT_APX
