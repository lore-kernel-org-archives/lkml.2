Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab1JBRsQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 13:48:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56801 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab1JBRsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 13:48:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jason Chagas <jason.chagas@marvell.com>,
        Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: Re: [PATCH 16/26] ARM: pxa: CPU_PJ4 requires IWMMXT
Date: Sun, 02 Oct 2011 19:46:53 +0200
Message-ID: <20295619.jOfPxmug8T@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.0.0-rc1nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <20111002160328.GZ11710@n2100.arm.linux.org.uk>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-17-git-send-email-arnd@arndb.de> <20111002160328.GZ11710@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:KeyIsTWRQ8m0SHyblWZTKI6SBFfKPq5WyqPlVabEgIN
 TZ/iseT+eGuvdcG4VTTOQkNK7aQZj8/aEurcgIn0uZJpu5KRAG
 AFZJF5xaAzHRIqMCOjDM4X9T4qgqqd5LrPgyjl0c0q04ZZapjk
 1QKzsZMxA0SCauabhCfcRLRmkTsrjFb18CenY4Cy+J5iYjhKQP
 iftM3j1ieqY7dS7tTIyfnyZO+hh/gbSfShpiQZiH+C9Pe7qEXl
 pPLDUNZZovyIgpLc+FdEPc1wEZu7A2V9iD5yNURto9dF81yacC
 2gaiTaBS2GA1nUFWrixRBQPMmD+RJ0d9yOug1vTh5etxRy+0M9
 M60NZ1BAyQzSNl0S+C1Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 October 2011 17:03:28 Russell King - ARM Linux wrote:
> On Sat, Oct 01, 2011 at 10:03:48PM +0200, Arnd Bergmann wrote:
> > The PJ4 based pxa95x cpus all have iwmmxt and there is no way to
> > build that code conditionally, so better not ask the user
> > in that configuration, in order to prevent broken builds.
> 
> This suggests we want IWMMXT=y if PJ4=y...
> 
> >  config IWMMXT
> > -     bool "Enable iWMMXt support"
> > +     bool "Enable iWMMXt support" if !CPU_PJ4
> >       depends on CPU_XSCALE || CPU_XSC3 || CPU_MOHAWK || CPU_PJ4
> >       default y if PXA27x || PXA3xx || PXA95x || ARCH_MMP
> >       help
> 
> This hides the option if CPU_PJ4 is enabled, but it will only be set
> to 'y' if PXA27x || PXA3xx || PXA95x || ARCH_MMP are set.  Luckily,
> ARCH_MMP will be - but is that really what's intended?  It's a little
> obscure to work that out.

It was the idea at least, but you are right: adding an explicit || CPU_PJ4
to the default makes it more robust and more obvious to the reader.

I've replaced this patch with the version below and pushed the result to
same location.

	Arnd

8<-----
Subject: [PATCH] ARM: pxa: CPU_PJ4 requires IWMMXT

The PJ4 based pxa95x cpus all have iwmmxt and there is no way to
build that code conditionally, so better not ask the user
in that configuration, in order to prevent broken builds.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5ebc5d9..8d66c32 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1071,9 +1071,10 @@ config ARM_TIMER_SP804
 source arch/arm/mm/Kconfig
 
 config IWMMXT
-	bool "Enable iWMMXt support"
+	bool "Enable iWMMXt support" if !CPU_PJ4
 	depends on CPU_XSCALE || CPU_XSC3 || CPU_MOHAWK || CPU_PJ4
 	default y if PXA27x || PXA3xx || PXA95x || ARCH_MMP
+	default y if CPU_PJ4
 	help
 	  Enable support for iWMMXt context switching at run time if
 	  running on a CPU that supports it.
