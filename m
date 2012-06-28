Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab2F1GIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:08:50 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:42818 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559Ab2F1GIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:08:42 -0400
X-AuditID: 9c93016f-b7c85ae00000559e-ea-4febf4e7187a
From: "Kim, Jong-Sung" <neidhard.kim@lge.com>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Cc: "'Minchan Kim'" <minchan@kernel.org>, "'Nicolas Pitre'" <nico@linaro.org>,
        "'Catalin Marinas'" <catalin.marinas@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "'Chanho Min'" <chanho.min@lge.com>, <linux-mm@kvack.org>
References: <1338880312-17561-1-git-send-email-minchan@kernel.org> <025701cd457e$d5065410$7f12fc30$@lge.com> <20120627191801.GD25319@n2100.arm.linux.org.uk>
In-Reply-To: <20120627191801.GD25319@n2100.arm.linux.org.uk>
Subject: RE: [PATCH] [RESEND] arm: limit memblock base address for	early_pte_alloc
Date: Thu, 28 Jun 2012 15:08:39 +0900
Message-ID: <00e901cd54f4$76773650$6365a2f0$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQLyw5u255N8mX4sZ4V+/prpc6IPugIAV1CoATUkNV+UqpvyoA==
Content-Language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
> Sent: Thursday, June 28, 2012 4:18 AM
> On Fri, Jun 08, 2012 at 10:58:50PM +0900, Kim, Jong-Sung wrote:
> >
> > May I suggest another simple approach? The first continuous couples of
> > sections are always safely section-mapped inside alloc_init_section
> funtion.
> > So, by limiting memblock_alloc to the end of the first continuous
> > couples of sections at the start of map_lowmem, map_lowmem can safely
> > memblock_alloc & memset even if we have one or more section-unaligned
> > memory regions. The limit can be extended back to arm_lowmem_limit after
> the map_lowmem is done.
> 
> No.  What if the first block of memory is not large enough to handle all
the
> allocations?
> 
Thank you for your comment, Russell. I sent a modified patch not to limit to
the first memory memblock_region as a reply to Dave's message.

> I think the real problem is folk trying to reserve small amounts.  I have
> said all reservations must be aligned to 1MB.
>
Ok, now I know your thought about arm_memblock_steal(). Then, how about
adding a simple aligning to prevent the possible problem just like me:

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index f54d592..d0daf0d 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -324,6 +324,8 @@ phys_addr_t __init arm_memblock_steal(phys_addr_t size,
phys
 
        BUG_ON(!arm_memblock_steal_permitted);
 
+       size = ALIGN(size, SECTION_SIZE);
+
        phys = memblock_alloc(size, align);
        memblock_free(phys, size);
        memblock_remove(phys, size);

or, leaving a few comments about the restriction kindly..?



