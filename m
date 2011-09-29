Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab1I2Kjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 06:39:52 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60451 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870Ab1I2Kjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 06:39:51 -0400
Date: Thu, 29 Sep 2011 11:39:39 +0100
From: Will Deacon <will.deacon@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCHv2 2/2] ARM: debug: Move DEBUG_ICEDCC into the DEBUG_LL
 choice
Message-ID: <20110929103939.GD25061@e102144-lin.cambridge.arm.com>
References: <1316568208-4518-1-git-send-email-sboyd@codeaurora.org>
 <1316568208-4518-2-git-send-email-sboyd@codeaurora.org>
 <4E83D25C.6020306@codeaurora.org>
 <20110929092102.GB25061@e102144-lin.cambridge.arm.com>
 <20110929094243.GC25061@e102144-lin.cambridge.arm.com>
 <20110929094602.GH23944@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929094602.GH23944@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Thu, Sep 29, 2011 at 10:46:02AM +0100, Russell King - ARM Linux wrote:
> On Thu, Sep 29, 2011 at 10:42:43AM +0100, Will Deacon wrote:
> > Bah, just took this for a spin on my Realview-PBX (Cortex-A9) platform and
> > the board won't boot unless I have a hardware debugger enabled that can
> > service the comms channel. This contradicts the Kconfig text which says:
> > 
> > 	  It does include a timeout to ensure that the system does not
> > 	  totally freeze when there is nothing connected to read.
> > 
> > so we certainly need to fix something!
> 
> One of the problems you'll encounter is that there's places where we
> don't have any timer infrastructure (eg, decompressor) and software
> timing loops won't work (they'll be too slow for the lower-end CPUs
> and too fast for the upper-end CPUs.)

Agreed, software timing loops are the only option and it's impossible to get
them right everywhere. I think the Kconfig help text should be updated so
that the timeout paragraph is removed.

> The best fix is probably to leave that as-is, but introduce a 'default'
> output entry instead - so platforms which don't have any listed will
> get that instead of the ICEDDC stuff.

Ok. Rather than 'default' (which people will probably select in preference
to choosing the correct UART) how about something like below? I can split
this into two patches if you prefer.

Will


----8<----

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 32b1be4..bfdf86b 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -81,6 +81,14 @@ choice
        prompt "Kernel low-level debugging port"
        depends on DEBUG_LL
 
+       config DEBUG_LL_UART_NONE
+               bool "No low-level debugging UART"
+               help
+                 Say Y here if your platform doesn't provide a UART option
+                 below. This relies on your platform choosing the right UART
+                 definition internally in order for low-level debugging to
+                 work.
+
        config DEBUG_ICEDCC
                bool "Kernel low-level debugging via EmbeddedICE DCC channel"
                help
@@ -89,8 +97,8 @@ choice
                  co-processor 14. This is known to work on the ARM9 style ICE
                  channel and on the XScale with the PEEDI.
 
-                 It does include a timeout to ensure that the system does not
-                 totally freeze when there is nothing connected to read.
+                 Note that this may cause the system to hang during boot if
+                 there is nothing to read from the DCC.
 
        config DEBUG_FOOTBRIDGE_COM1
                bool "Kernel low-level debugging messages via footbridge 8250 at PCI COM1"

