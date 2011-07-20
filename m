Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab1GTBgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 21:36:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34556 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab1GTBgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 21:36:01 -0400
Date: Wed, 20 Jul 2011 11:35:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>, Jaecheol Lee <jc.lee@samsung.com>
Subject: linux-next: manual merge of the s5p tree with the arm tree
Message-Id: <20110720113558.1fb8c2f8392f52c77becf46a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

Today's linux-next merge of the s5p tree got a conflict in
arch/arm/mach-exynos4/pm.c between commits e7089da9567f ("ARM: pm:
samsung: move cpu_suspend into C code") and 29cb3cd208dd ("ARM: pm: allow
suspend finisher to return error codes") from the arm tree and commit
f8ab7d1a953b ("ARM: EXYNOS4: Add save/restore for other ARM registers")
from the s5p tree.

I fixed it up (see below) and can carry the fix as necessary.

BTW, Russell, commit 29cb3cd208dd above changed the return type of
exynos4_cpu_suspend() from void to int but did not add any return
statement ...

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-exynos4/pm.c
index 533c28f,45f7fd3..0000000
--- a/arch/arm/mach-exynos4/pm.c
+++ b/arch/arm/mach-exynos4/pm.c
@@@ -280,37 -216,11 +216,11 @@@ static struct sleep_save exynos4_l2cc_s
  	SAVE_ITEM(S5P_VA_L2CC + L2X0_AUX_CTRL),
  };
  
+ /* For Cortex-A9 Diagnostic and Power control register */
+ static unsigned int save_arm_register[2];
+ 
 -void exynos4_cpu_suspend(unsigned long arg)
 +static int exynos4_cpu_suspend(unsigned long arg)
  {
- 	unsigned long tmp;
- 	unsigned long mask = 0xFFFFFFFF;
- 
- 	/* Setting Central Sequence Register for power down mode */
- 
- 	tmp = __raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
- 	tmp &= ~(S5P_CENTRAL_LOWPWR_CFG);
- 	__raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
- 
- 	/* Setting Central Sequence option Register */
- 
- 	tmp = __raw_readl(S5P_CENTRAL_SEQ_OPTION);
- 	tmp &= ~(S5P_USE_MASK);
- 	tmp |= S5P_USE_STANDBY_WFI0;
- 	__raw_writel(tmp, S5P_CENTRAL_SEQ_OPTION);
- 
- 	/* Clear all interrupt pending to avoid early wakeup */
- 
- 	__raw_writel(mask, (S5P_VA_GIC_DIST + 0x280));
- 	__raw_writel(mask, (S5P_VA_GIC_DIST + 0x284));
- 	__raw_writel(mask, (S5P_VA_GIC_DIST + 0x288));
- 
- 	/* Disable all interrupt */
- 
- 	__raw_writel(0x0, (S5P_VA_GIC_CPU + 0x000));
- 	__raw_writel(0x0, (S5P_VA_GIC_DIST + 0x000));
- 	__raw_writel(mask, (S5P_VA_GIC_DIST + 0x184));
- 	__raw_writel(mask, (S5P_VA_GIC_DIST + 0x188));
- 
  	outer_flush_all();
  
  	/* issue the standby signal into the pm unit. */
