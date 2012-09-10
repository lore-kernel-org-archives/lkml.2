Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab2IJQMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:12:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45868 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754372Ab2IJQMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:12:39 -0400
Date: Mon, 10 Sep 2012 17:11:59 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 02/31] arm64: Kernel booting and initialisation
Message-ID: <20120910161159.GH27042@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <1347035226-18649-3-git-send-email-catalin.marinas@arm.com>
 <20120909172046.GB31430@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120909172046.GB31430@game.jcrosoft.org>
Thread-Topic: [PATCH v3 02/31] arm64: Kernel booting and initialisation
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2012 at 06:20:46PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 17:26 Fri 07 Sep     , Catalin Marinas wrote:
> > +The device tree blob (dtb) must be no bigger than 2 megabytes in size
> > +and placed at a 2-megabyte boundary within the first 512 megabytes from
> > +the start of the kernel image. This is to allow the kernel to map the
> > +blob using a single section mapping in the initial page tables.
> why do you want to restrict the DT to be less tahn 2MiB?

That's a restriction due on the initial memory map. At some point we may
add support in head.S to parse the dtb and extract the size information.
Not critical at this stage.

> > +Before jumping into the kernel, the following conditions must be met:
> > +
> > +- Quiesce all DMA capable devices so that memory does not get
> > +  corrupted by bogus network packets or disk data.  This will save
> > +  you many hours of debug.
> > +
> > +- Primary CPU general-purpose register settings
> > +  x0 = physical address of device tree blob (dtb) in system RAM.
> > +  x1 = 0 (reserved for future use)
> > +  x2 = 0 (reserved for future use)
> > +  x3 = 0 (reserved for future use)
> > +
> > +- CPU mode
> > +  All forms of interrupts must be masked in PSTATE.DAIF (Debug, SError,
> > +  IRQ and FIQ).
> > +  The CPU must be in either EL2 (RECOMMENDED in order to have access to
> > +  the virtualisation extensions) or non-secure EL1.
> > +
> > +- Caches, MMUs
> > +  The MMU must be off.
> > +  Instruction cache may be on or off.
> > +  Data cache must be off and invalidated.
> > +  External caches (if present) must be configured and disabled.
> > +
> > +- Architected timers
> > +  CNTFRQ must be programmed with the timer frequency.
> > +  If entering the kernel at EL1, CNTHCTL_EL2 must have EL1PCTEN (bit 0)
> > +  set where available.
> can you explain why?

Otherwise the kernel cannot access the generic timer registers (it is
described in the AArch64 exception model which isn't public yet).

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
> do you plan AMP boot?

What do you mean by AMP?

If you only want to use 3 CPUs out of 4 for example, you change the FDT
information that gets passed to the kernel accordingly. So the kernel
wouldn't touch the 4th one.

-- 
Catalin
