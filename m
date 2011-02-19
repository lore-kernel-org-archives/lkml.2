Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab1BSS0w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 13:26:52 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52007 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab1BSS0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 13:26:51 -0500
Date: Sat, 19 Feb 2011 18:26:31 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4 15/19] ARM: LPAE: use phys_addr_t instead of
	unsigned long for physical addresses
Message-ID: <20110219182631.GS29493@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com> <1295891761-18366-16-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295891761-18366-16-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 05:55:57PM +0000, Catalin Marinas wrote:
> From: Will Deacon <will.deacon@arm.com>
> 
> The unsigned long datatype is not sufficient for mapping physical addresses
> >= 4GB.
> 
> This patch ensures that the phys_addr_t datatype is used to represent
> physical addresses which may be beyond the range of an unsigned long.
> The virt <-> phys macros are updated accordingly to ensure that virtual
> addresses can remain as they are.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

This patch needs some more things fixed to prevent warnings:

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index a81355d..6cf76b3 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -809,9 +809,10 @@ static void __init sanity_check_meminfo(void)
 		 */
 		if (__va(bank->start) >= vmalloc_min ||
 		    __va(bank->start) < (void *)PAGE_OFFSET) {
-			printk(KERN_NOTICE "Ignoring RAM at %.8lx-%.8lx "
+			printk(KERN_NOTICE "Ignoring RAM at %.8llx-%.8llx "
 			       "(vmalloc region overlap).\n",
-			       bank->start, bank->start + bank->size - 1);
+			       (unsigned long long)bank->start,
+			       (unsigned long long)bank->start + bank->size - 1);
 			continue;
 		}
 
@@ -822,10 +823,11 @@ static void __init sanity_check_meminfo(void)
 		if (__va(bank->start + bank->size) > vmalloc_min ||
 		    __va(bank->start + bank->size) < __va(bank->start)) {
 			unsigned long newsize = vmalloc_min - __va(bank->start);
-			printk(KERN_NOTICE "Truncating RAM at %.8lx-%.8lx "
-			       "to -%.8lx (vmalloc region overlap).\n",
-			       bank->start, bank->start + bank->size - 1,
-			       bank->start + newsize - 1);
+			printk(KERN_NOTICE "Truncating RAM at %.8llx-%.8llx "
+			       "to -%.8llx (vmalloc region overlap).\n",
+			       (unsigned long long)bank->start,
+			       (unsigned long long)bank->start + bank->size - 1,
+			       (unsigned long long)bank->start + newsize - 1);
 			bank->size = newsize;
 		}
 #endif
