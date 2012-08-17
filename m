Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab2HQKGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:06:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57712 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752262Ab2HQKGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:06:21 -0400
Date: Fri, 17 Aug 2012 11:05:33 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 02/31] arm64: Kernel booting and initialisation
Message-ID: <20120817100533.GE24389@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-3-git-send-email-catalin.marinas@arm.com>
 <502E11B6.4020104@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502E11B6.4020104@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 10:41:10AM +0100, Santosh Shilimkar wrote:
> On Tuesday 14 August 2012 11:22 PM, Catalin Marinas wrote:
> > +The boot loader is expected to enter the kernel on each CPU in the
> > +following manner:
> > +
> > +- The primary CPU must jump directly to the first instruction of the
> > +  kernel image.  The device tree blob passed by this CPU must contain
> > +  for each CPU node:
> > +
> > +    1. An 'enable-method' property. Currently, the only supported value
> > +       for this field is the string "spin-table".
> > +
> > +    2. A 'cpu-release-addr' property identifying a 64-bit,
> > +       zero-initialised memory location.
> > +
> > +  It is expected that the bootloader will generate these device tree
> > +  properties and insert them into the blob prior to kernel entry.
> > +
> > +- Any secondary CPUs must spin outside of the kernel in a reserved area
> > +  of memory (communicated to the kernel by a /memreserve/ region in the
> > +  device tree) polling their cpu-release-addr location, which must be
> > +  contained in the reserved region.  A wfe instruction may be inserted
> > +  to reduce the overhead of the busy-loop and a sev will be issued by
> > +  the primary CPU.  When a read of the location pointed to by the
> > +  cpu-release-addr returns a non-zero value, the CPU must jump directly
> > +  to this value.
> 
> So you expect all the secondary CPUs to be in wakeup state and probably
> looping in WFE for a signal from kernel to boot. There is one issue
> with this requirement though. For large CPU system, you need to reset
> all the CPUs and hit this waiting loop. This will lead to large inrush
> current need at bootup which may be not be supported. To avoid this
> issue, secondary CPUs are kept in OFF state and then they are woken
> up from kernel one by one whenever they need to be brought into the
> system. This requirement should be considered.

I agree, this part will be extended. That's one method that we currently
support and suitable to the model.

The better method is the SMC standardisation that Charles Garcia-Tobin
has written (to be made available soon) and was presented at the last
Linaro Connect in HK. Given that the CPU power is usually controlled by
the secure side, we'll ask for an SMC to be issued for waking up
secondary CPUs, so it's up to the secure firmware to write the correct
hardware registers.

> > --- /dev/null
> > +++ b/arch/arm64/kernel/head.S
> [..]
> > +	/*
> > +	 * DO NOT MODIFY. Image header expected by Linux boot-loaders.
> > +	 */
> > +	b	stext				// branch to kernel start, magic
> > +	.long	0				// reserved
> > +	.quad	TEXT_OFFSET			// Image load offset from start of RAM
> > +	.quad	0				// reserved
> > +	.quad	0				// reserved
> > +
> 
> Minor nit. Avoid C++ commenting style "//"  here and rest of the patch.

That's not C++ comment style, it's the *official* assembly comment style
for AArch64 ('@' is no longer supported).

-- 
Catalin
