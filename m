Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab1HJG5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 02:57:44 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:44885 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1HJG5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 02:57:42 -0400
Date: Wed, 10 Aug 2011 00:57:42 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Tony Lindgren <tony@atomide.com>
cc: Daniel Morsing <daniel.morsing@gmail.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: Build failure: bisected: v3.1-rc1 with config ARCH_OMAP &&
 !ARCH_OMAP4 fails with linker error
In-Reply-To: <alpine.DEB.2.00.1108092102580.12674@utopia.booyaka.com>
Message-ID: <alpine.DEB.2.00.1108100045270.12674@utopia.booyaka.com>
References: <1312819724.14483.29.camel@morsingpad> <alpine.DEB.2.00.1108081435340.4764@utopia.booyaka.com> <20110809131453.GR1866@atomide.com> <alpine.DEB.2.00.1108092102580.12674@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Aug 2011, Paul Walmsley wrote:

> On Tue, 9 Aug 2011, Tony Lindgren wrote:
> 
> > Hmm, there are also these when CONFIG_ARCH_OMAP4 is not selected:
> > 
> > arch/arm/mach-omap2/built-in.o: In function `_enable_module':
> > arch/arm/mach-omap2/omap_hwmod.c:701: undefined reference to `omap4_cminst_module_enable'
> > arch/arm/mach-omap2/built-in.o: In function `_disable_module':
> > arch/arm/mach-omap2/omap_hwmod.c:726: undefined reference to `omap4_cminst_module_disable'
> > arch/arm/mach-omap2/built-in.o: In function `_wait_target_disable':
> > arch/arm/mach-omap2/omap_hwmod.c:1179: undefined reference to `omap4_cminst_wait_module_idle'
> > distcc[27594] ERROR: compile (null) on localhost failed
> > make: *** [.tmp_vmlinux1] Error 1
> > 
> > Care to take a look?
> 
> Weird, those don't show up on my n800 config (below) with CodeSourcery 
> 2010.09-50.  Looks like something isn't removing the dead code.  will post 
> a patch for this.
> 
> If you post which compiler you're using, I'll add it to my build tests 
> too...

Hmmm, playing around with this further, this is probably not a
compiler problem.  Looks like what triggers this is the MULTI_OMAP2
preprocessor trickery in arch/arm/plat-omap/include/plat/cpu.h, which
would cause something like cpu_is_omap24xx() to be resolved at runtime
rather than by the preprocessor.

This should fix the immediate issue.  Will include in a 3.1-rc fixes branch.


- Paul


From: Paul Walmsley <paul@pwsan.com>
Date: Tue, 9 Aug 2011 22:27:01 -0600
Subject: [PATCH] OMAP: hwmod: fix build break on non-OMAP4 multi-OMAP2 builds

Builds for multi-OMAP2 (e.g., OMAP2420 with OMAP2430) with
CONFIG_ARCH_OMAP4=n fail with the following errors:

arch/arm/mach-omap2/built-in.o: In function `_enable_module':
arch/arm/mach-omap2/omap_hwmod.c:701: undefined reference to `omap4_cminst_module_enable'
arch/arm/mach-omap2/built-in.o: In function `_disable_module':
arch/arm/mach-omap2/omap_hwmod.c:726: undefined reference to `omap4_cminst_module_disable'
arch/arm/mach-omap2/built-in.o: In function `_wait_target_disable':
arch/arm/mach-omap2/omap_hwmod.c:1179: undefined reference to `omap4_cminst_wait_module_idle'

This is probably due to the preprocessor directives in
arch/arm/plat-omap/include/plat/cpu.h that convert some cpu_is_omap*()
expressions from preprocessor directives into something that is only
resolvable during runtime, if multiple OMAP2 build targets are
selected.

Thanks to Tony Lindgren <tony@atomide.com> for reporting.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/cminst44xx.h |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/cminst44xx.h b/arch/arm/mach-omap2/cminst44xx.h
index f2ea645..df9be67 100644
--- a/arch/arm/mach-omap2/cminst44xx.h
+++ b/arch/arm/mach-omap2/cminst44xx.h
@@ -18,13 +18,30 @@ extern void omap4_cminst_clkdm_force_sleep(u8 part, s16 inst, u16 cdoffs);
 extern void omap4_cminst_clkdm_force_wakeup(u8 part, s16 inst, u16 cdoffs);
 
 extern int omap4_cminst_wait_module_ready(u8 part, u16 inst, s16 cdoffs, u16 clkctrl_offs);
-extern int omap4_cminst_wait_module_idle(u8 part, u16 inst, s16 cdoffs, u16 clkctrl_offs);
+
+# ifdef CONFIG_ARCH_OMAP4
+extern int omap4_cminst_wait_module_idle(u8 part, u16 inst, s16 cdoffs,
+					 u16 clkctrl_offs);
 
 extern void omap4_cminst_module_enable(u8 mode, u8 part, u16 inst, s16 cdoffs,
 				       u16 clkctrl_offs);
 extern void omap4_cminst_module_disable(u8 part, u16 inst, s16 cdoffs,
 					u16 clkctrl_offs);
 
+# else
+
+static inline int omap4_cminst_wait_module_idle(u8 part, u16 inst, s16 cdoffs, u16 clkctrl_offs)
+{
+	return 0;
+}
+
+static inline void omap4_cminst_module_enable(u8 mode, u8 part, u16 inst, s16 cdoffs,
+				u16 clkctrl_offs) {}
+static inline void omap4_cminst_module_disable(u8 part, u16 inst, s16 cdoffs,
+				 u16 clkctrl_offs) {}
+
+# endif
+
 /*
  * In an ideal world, we would not export these low-level functions,
  * but this will probably take some time to fix properly
-- 
1.7.5.4

