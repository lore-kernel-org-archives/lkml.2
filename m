Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab2IMRNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 13:13:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61837 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758620Ab2IMRNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 13:13:00 -0400
Date: Thu, 13 Sep 2012 18:11:25 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Will Deacon <Will.Deacon@arm.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 02/31] arm64: Kernel booting and initialisation
Message-ID: <20120913171125.GD25131@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <1347035226-18649-3-git-send-email-catalin.marinas@arm.com>
 <20120909172046.GB31430@game.jcrosoft.org>
 <20120910161159.GH27042@arm.com>
 <20120912120858.GI31430@game.jcrosoft.org>
 <20120912134916.GF21823@arm.com>
 <5052021B.4050808@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5052021B.4050808@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 04:56:11PM +0100, Christopher Covington wrote:
> On 09/12/2012 09:49 AM, Catalin Marinas wrote:
> > On Wed, Sep 12, 2012 at 01:08:58PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >> On 17:11 Mon 10 Sep     , Catalin Marinas wrote:
> >>> On Sun, Sep 09, 2012 at 06:20:46PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >>>> On 17:26 Fri 07 Sep     , Catalin Marinas wrote:
> >>>>> +Before jumping into the kernel, the following conditions must be met:
> >>>>> +
> >>>>> +- Quiesce all DMA capable devices so that memory does not get
> >>>>> +  corrupted by bogus network packets or disk data.  This will save
> >>>>> +  you many hours of debug.
> >>>>> +
> >>>>> +- Primary CPU general-purpose register settings
> >>>>> +  x0 = physical address of device tree blob (dtb) in system RAM.
> >>>>> +  x1 = 0 (reserved for future use)
> >>>>> +  x2 = 0 (reserved for future use)
> >>>>> +  x3 = 0 (reserved for future use)
> >>>>> +
> >>>>> +- CPU mode
> >>>>> +  All forms of interrupts must be masked in PSTATE.DAIF (Debug, SError,
> >>>>> +  IRQ and FIQ).
> >>>>> +  The CPU must be in either EL2 (RECOMMENDED in order to have access to
> >>>>> +  the virtualisation extensions) or non-secure EL1.
> >>>>> +
> >>>>> +- Caches, MMUs
> >>>>> +  The MMU must be off.
> >>>>> +  Instruction cache may be on or off.
> >>>>> +  Data cache must be off and invalidated.
> >>>>> +  External caches (if present) must be configured and disabled.
> >>>>> +
> >>>>> +- Architected timers
> >>>>> +  CNTFRQ must be programmed with the timer frequency.
> >>>>> +  If entering the kernel at EL1, CNTHCTL_EL2 must have EL1PCTEN (bit 0)
> >>>>> +  set where available.
> >>>> can you explain why?
> >>>
> >>> Otherwise the kernel cannot access the generic timer registers (it is
> >>> described in the AArch64 exception model which isn't public yet).
> >> I do not like the idea to do too much in the boot loader
> 
> I agree that where possible we should minimize the amount of work required of
> bootloaders. I'm not sure that the percentage of work we might be able to trim
> away on hardware would be significant, but on simulators I think we might be
> able to get to the point where, if you can specify the r0 reset value to be
> the dtb pointer, you can just load a devicetree blob and kernel image into
> memory and start executing the kernel, no boot wrapper required.

The boot wrapper is *only* required on our software model because this
model does not have any firmware and it simply starts at EL3. We do not
have this behaviour on real hardware where there is firmware to
initialise the hardware, memory controller, secure world etc. before a
normal boot loader can be loaded. Many of the requirements would be part
of the board firmware rather than boot loader, so the boot loader would
just need to deal with the usual cache maintenance and turning the MMU
off.

The conditions above are not really much in addition to what we require
on 32-bit.

> I don't know if Jean-Christophe was commenting on just the EL1PCTEN bit or

The EL1PCTEN requirement is pretty clearly described above - only if
Linux is started at EL1 (e.g. guest OS), since the CNTHCTL_EL2 register
is an EL2 only register and not accessible at EL1.

> also the CNTFRQ register, but with regard to the latter, it appears to me that
> the timer code actually reads the frequency primarily from the devicetree and
> only reads CNTFRQ if the "clock-frequency" property is unspecified or
> specified as zero.

Linus W has a few more suggestions here but I didn't get to implementing
them.

> I suggest that the kernel calling requirements be modified to communicate this
> fallback, rather than mandatory, status, unless some not-yet-released part of
> the arm64 kernel needs it. If userspace code will need to use CNTFRQ at some
> point then perhaps that should be mentioned in an informational note rather
> than being presented as a kernel booting requirement.

In general, we would like the firmware to write the correct value into
the CNTFRQ register, as specified in the generic timers spec, or maybe
hard-wire the register to the correct value. However, in case some
firmware gets it wrong or a read-only register is not hard-wired we want
to override the value with the FDT. A historical reason for this was
that the software model we use doesn't have any firmware. But primarily
we should use the hardware value.

So far we don't export the CNTFRQ to user because of the possibility to
override the value via other means. That's pretty much a read-only or
EL3 writable only register.

> > git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/boot-wrapper-aarch64.git
> 
> The UART and GIC stuff is board-specific, and I don't currently have any
> suggestions about the multicore initialization, but would you object to the
> kernel eventually being equipped to make the descent from EL3 itself?

I'm strongly pushing for single Image support from the beginning and
this would require a few things to be initialised by the firmware (on a
case by case basis). The secondary CPU release also needs to be handled
by the firmware.

For example, in a standard system you would want to run the kernel in
non-secure mode to make use of the virtualisation extensions. The GIC
(address depending on the SoC) would need to be configured to enable
interrupts for the non-secure world and this can only be done in secure
mode. So even if you start the kernel at EL3 and shortly drop to
EL2/EL1, for the single Image to work you need such GIC initialisation
to be done by the firmware.

While the requirement to have some hardware pre-initialisation does not
necessarily mandate the mode in which Linux is started, I don't see
value in starting Linux at EL3. You most likely will have some boot
loader and we don't want to add extra complexity to them for running in
different modes or having to switch back to the highest mode before
calling the kernel. The boot loader already needs to handle EL1 and EL2.

ARM is also proposing an SMC API to make secondary startup and a few
power management things simpler from a Linux perspective. Such code
would reside at EL3.

-- 
Catalin
