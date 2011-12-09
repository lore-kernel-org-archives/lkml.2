Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab1LIEhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 23:37:39 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5583 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab1LIEhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 23:37:36 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 08 Dec 2011 20:37:24 -0800
Message-ID: <4EE1907F.5000003@nvidia.com>
Date: Thu, 08 Dec 2011 21:37:19 -0700
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Erik Gilling <konkers@android.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the tegra tree with the  tree
References: <20111209114736.d418deb7228f2b544434b77b@canb.auug.org.au>
In-Reply-To: <20111209114736.d418deb7228f2b544434b77b@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2011 05:47 PM, Stephen Rothwell wrote:
> * PGP Signed by an unknown key
> 
> Hi all,
> 
> Today's linux-next merge of the tegra tree got a conflict in
> arch/arm/mach-tegra/include/mach/entry-macro.S between commit
> afed2a261825 ("ARM: tegra2: convert to CONFIG_MULTI_IRQ_HANDLER") from
> the arm tree and commit f5ce5e7e9cc3 (arm/tegra: Remove code that's
> ifndef CONFIG_ARM_GIC"") from the tegra tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

StephenR,

I'm not very familiar with git diff for merge conflicts, so I might be
wrong here, but I did reproduce this conflict to investigate, and I
think your fixup isn't quite correct.

I think you're left with two separate copies of the macro
arch_ret_to_user, and your conflict resolution diff should be more like
that below:

diff --git a/arch/arm/mach-tegra/include/mach/entry-macro.S
b/arch/arm/mach-tegra/include/mach/entry-macro.S
index ac11262..e577cfe 100644
--- a/arch/arm/mach-tegra/include/mach/entry-macro.S
+++ b/arch/arm/mach-tegra/include/mach/entry-macro.S
@@ -18,21 +18,3 @@

        .macro  arch_ret_to_user, tmp1, tmp2
        .endm
-
-#if !defined(CONFIG_ARM_GIC)
-       /* legacy interrupt controller for AP16 */
-
-       .macro  get_irqnr_preamble, base, tmp
-       @ enable imprecise aborts
-       cpsie   a
-       @ EVP base at 0xf010f000
-       mov \base, #0xf0000000
-       orr \base, #0x00100000
-       orr \base, #0x0000f000
-       .endm
-
-       .macro  get_irqnr_and_base, irqnr, irqstat, base, tmp
-       ldr \irqnr, [\base, #0x20]      @ EVT_IRQ_STS
-       cmp \irqnr, #0x80
-       .endm
-#endif

Thanks for the work on linux-next.

-- 
nvpublic
