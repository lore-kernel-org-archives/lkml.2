Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298Ab1D1RBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 13:01:16 -0400
Received: from mail.tpi.com ([70.99.223.143]:1968 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab1D1RBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 13:01:15 -0400
Message-ID: <4DB99D2E.9080106@canonical.com>
Date: Thu, 28 Apr 2011 11:00:30 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        suresh.b.siddha@intel.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Subject: [PATCH 2.6.39-rc5] ioremap: Delay sanity check until after a successful
 mapping
Content-Type: multipart/mixed;
 boundary="------------080009090200040602050302"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080009090200040602050302
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

While tracking down the reason for an ioremap() failure I was distracted 
by the WARN_ONCE() in __ioremap_caller(). Can we move the sanity check 
later in the function until _after_ the mapping has been performed?

rtg
-- 
Tim Gardner tim.gardner@canonical.com

--------------080009090200040602050302
Content-Type: text/x-patch;
 name="0001-ioremap-Delay-sanity-check-until-after-a-successful-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-ioremap-Delay-sanity-check-until-after-a-successful-.pa";
 filename*1="tch"

>From 31dec327a254888fcd0b6aa963414b09626d3168 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Thu, 28 Apr 2011 10:07:51 -0600
Subject: [PATCH] ioremap: Delay sanity check until after a successful mapping

Performing a WARN_ONCE() sanity check before the mapping
is successful seems pointless if the caller sends bad values.
A case in point is when the BIOS provides erroneous screen_info values
causing vesafb_probe() to request an outrageuous size. The
WARN_ONCE is then wasted on bogosity. Move the warning to a
point where the mapping has been successfully allocated.

http://bugs.launchpad.net/bugs/772042

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 arch/x86/mm/ioremap.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 0369843..be1ef57 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -91,13 +91,6 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 		return (__force void __iomem *)phys_to_virt(phys_addr);
 
 	/*
-	 * Check if the request spans more than any BAR in the iomem resource
-	 * tree.
-	 */
-	WARN_ONCE(iomem_map_sanity_check(phys_addr, size),
-		  KERN_INFO "Info: mapping multiple BARs. Your kernel is fine.");
-
-	/*
 	 * Don't allow anybody to remap normal RAM that we're using..
 	 */
 	last_pfn = last_addr >> PAGE_SHIFT;
@@ -170,6 +163,13 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	ret_addr = (void __iomem *) (vaddr + offset);
 	mmiotrace_ioremap(unaligned_phys_addr, unaligned_size, ret_addr);
 
+	/*
+	 * Check if the request spans more than any BAR in the iomem resource
+	 * tree.
+	 */
+	WARN_ONCE(iomem_map_sanity_check(unaligned_phys_addr, unaligned_size),
+		  KERN_INFO "Info: mapping multiple BARs. Your kernel is fine.");
+
 	return ret_addr;
 err_free_area:
 	free_vm_area(area);
-- 
1.7.0.4


--------------080009090200040602050302--
