Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab2IGWUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 18:20:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55149 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab2IGWUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 18:20:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120907142723.5766b42d.akpm@linux-foundation.org>
References: <1347009393-8751-1-git-send-email-benjamin.gaignard@stericsson.com>
	<20120907142723.5766b42d.akpm@linux-foundation.org>
Date: Sat, 8 Sep 2012 00:20:09 +0200
Message-ID: <CACRpkdap5Ujx5q=NjORgdz1DxE0_bTnCX+MxRdaycKTtv63Qdw@mail.gmail.com>
Subject: Re: [PATCH] genalloc: make possible to use a custom allocation algorithm
From: Linus Walleij <linus.walleij@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-kernel@vger.kernel.org, ying.huang@intel.com,
        Benjamin Gaignard <benjamin.gaignard@stericsson.com>,
        Staffan Mansson <staffan.mansson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 11:27 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri,  7 Sep 2012 11:16:33 +0200
> Benjamin Gaignard <benjamin.gaignard@linaro.org> wrote:

> hm, OK.  What kernel subsystem are you referring to here?  Where do I
> find this "ESRAM shared by multiple hardware"?

This is on the Ux500 in the ARM tree. We have defined the bases
for this memory down there:

cd arch/arm/mach-ux500 && grep -r ESRAM .
./include/mach/db8500-regs.h:/* Base address and bank offsets for ESRAM */
./include/mach/db8500-regs.h:#define U8500_ESRAM_BASE	0x40000000
./include/mach/db8500-regs.h:#define U8500_ESRAM_BANK_SIZE	0x00020000
./include/mach/db8500-regs.h:#define U8500_ESRAM_BANK0	U8500_ESRAM_BASE
./include/mach/db8500-regs.h:#define
U8500_ESRAM_BANK1	(U8500_ESRAM_BASE + U8500_ESRAM_BANK_SIZE)
./include/mach/db8500-regs.h:#define
U8500_ESRAM_BANK2	(U8500_ESRAM_BANK1 + U8500_ESRAM_BANK_SIZE)
./include/mach/db8500-regs.h:#define
U8500_ESRAM_BANK3	(U8500_ESRAM_BANK2 + U8500_ESRAM_BANK_SIZE)
./include/mach/db8500-regs.h:#define
U8500_ESRAM_BANK4	(U8500_ESRAM_BANK3 + U8500_ESRAM_BANK_SIZE)
./include/mach/db8500-regs.h:#define U8500_ESRAM_DMA_LCPA_OFFSET     0x10000
./include/mach/db8500-regs.h:#define U8500_DMA_LCPA_BASE
(U8500_ESRAM_BANK0 + U8500_ESRAM_DMA_LCPA_OFFSET)
./include/mach/db8500-regs.h:#define U8500_DMA_LCLA_BASE	U8500_ESRAM_BANK4

So 5 banks of on-chip (fast!) RAM of 128 KB each. (And my
Commodore 128 had 128 kB in total ... sob.)

As you can see the last three defines start to do something that
will grow unmaintainable: use static allocations in that ESRAM.
In this case to hold linked lists for DMA transfers.

Needless to say, a few high-performance use cases will really
benefit from using this high-speed RAM. Typically DMA
linked lists, graphics accelerators, encoders/decoders,
SETI@Home work units, you name it.

So we need to chop up this memory using a real allocator.
So we've tried to use genalloc and it turns out it works fine
until we run into allocation issues as those described by
Benjamin, and it becomes a chicken-and-egg problem
that we need fixing genalloc first to get to use the resource
in a good way before we can submit code using the
allocator.

(The rest of the review comments I think Benjamin can
answer way better than me...)

Yours,
Linus Walleij
