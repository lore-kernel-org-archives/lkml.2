Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab1EIPeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 11:34:37 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44166 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab1EIPeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 11:34:36 -0400
Date: Mon, 9 May 2011 16:34:16 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v5 02/19] ARM: LPAE: add ISBs around MMU enabling code
Message-ID: <20110509153416.GC16919@n2100.arm.linux.org.uk>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com> <1304859098-10760-3-git-send-email-catalin.marinas@arm.com> <20110508214101.GO27807@n2100.arm.linux.org.uk> <1304936539.7658.31.camel@e102109-lin.cambridge.arm.com> <20110509103242.GQ27807@n2100.arm.linux.org.uk> <1304938794.7658.56.camel@e102109-lin.cambridge.arm.com> <20110509120509.GR27807@n2100.arm.linux.org.uk> <1304953316.7658.71.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1304953316.7658.71.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 04:01:56PM +0100, Catalin Marinas wrote:
> This doesn't work. From the ARM ARM (B1.3.3):
> 
>         The execution state bits are the IT[7:0], J, E, and T bits. In
>         exception modes you can read or write these bits in the current
>         SPSR.
>         In the CPSR, unless the processor is in Debug state:
>         • The execution state bits, other than the E bit, are RAZ when
>         read by an MRS instruction.
> 
> So reading the CPSR doesn't copy the T and E bits. Of course, we could
> set them explicitly but I find the ISB much simpler (and in practice we
> only need it for ARMv7 onwards but adding the ARMv6 in case we have a
> kernel compiled for both).

Err.  If that's correct then the Linux kernel is totally broken, and
that's an incompatible change to the behaviour of the MRS and MSR
instructions which has gone unnoticed.

We use "MRS reg, cpsr" for saving the IRQ state in SVC mode and
"MSR cpsr, reg" to restore the interrupt state.  If the T bit gets
reset by that, then Thumb kernels can never work.

What you've just said tells me that our implementation of:
- arch_local_irq_save()
- arch_local_save_flags()
- arch_local_irq_restore()
won't work because we can't read or write the I and F bits using
MSR/MRS, even in SVC mode.

What is the replacement method for doing this?

If there isn't a replacement method...
