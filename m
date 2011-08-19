Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab1HSK0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 06:26:15 -0400
Received: from aaar.vm.bytemark.co.uk ([80.68.92.230]:37809 "EHLO
	aaar.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab1HSK0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 06:26:12 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, tim@xen.org
In-Reply-To: <1312988619-16804-10-git-send-email-catalin.marinas@arm.com>
References: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com>
	 <1312988619-16804-10-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Aug 2011 11:25:57 +0100
Message-ID: <1313749557.5010.345.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH v7 09/16] ARM: LPAE: MMU setup for the 3-level page
 table format
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 16:03 +0100, Catalin Marinas wrote:
> +/*
> + *     cpu_v7_set_pte_ext(ptep, pte)
> + *
> + *     Set a level 2 translation table entry.
> + *
> + *     - ptep  - pointer to level 2 translation table entry
> + *               (hardware version is stored at +2048 bytes)

+2048 thing not true for LPAE?

> + *     - pte   - PTE value to store
> + *     - ext   - value for extended PTE bits

"ext" is not actually present/used in this variant, rather pte is split
between r1 and r2?

> + */
> +ENTRY(cpu_v7_set_pte_ext)
> +#ifdef CONFIG_MMU
> +       tst     r2, #L_PTE_PRESENT
> +       beq     1f
> +       tst     r3, #1 << (55 - 32)             @ L_PTE_DIRTY
> +       orreq   r2, #L_PTE_RDONLY
> +1:     strd    r2, r3, [r0]

AIUI this 64-bit store is not atomic. Is there something about the ARM
architecture which would prevent the MMU prefetching the half written
entry and caching it in the TLB?

i.e. If you are transitioning from a
	"0..0 | 0..0 (!L_PTE_PRESENT)"
entry to a
        "ST   | UFF  ( L_PTE_PRESENT)"
entry you will temporarily be in the
        "0..0 | UFF  ( L_PTE_PRESENT)"
state. (or vice versa going the other way if you do the writes in the
other order). This might mean that a subsequent access through the VA
corresponding to this PTE goes to the wrong place.

I'm asking because we had a very subtle bug on x86 Xen relating to this
sort of issue ages ago, it was hell to debug ;-).

Ian.

> +       mcr     p15, 0, r0, c7, c10, 1          @ flush_pte
> +#endif
> +       mov     pc, lr
> +ENDPROC(cpu_v7_set_pte_ext) 
-- 
Ian Campbell

Working with Julie Andrews is like getting hit over the head with a valentine.
		-- Christopher Plummer

