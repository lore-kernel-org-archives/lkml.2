Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab1D2Gbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 02:31:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:52876 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab1D2Gbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 02:31:48 -0400
Date: Fri, 29 Apr 2011 06:31:12 GMT
From: tip-bot for Tim Gardner <tim.gardner@canonical.com>
Message-ID: <tip-c7a7b814c9dca9ee01b38e63b4a46de87156d3b6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        suresh.b.siddha@intel.com, tim.gardner@canonical.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        tim.gardner@canonical.com, mingo@elte.hu
In-Reply-To: <4DB99D2E.9080106@canonical.com>
References: <4DB99D2E.9080106@canonical.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] ioremap: Delay sanity check until after a successful mapping
Git-Commit-ID: c7a7b814c9dca9ee01b38e63b4a46de87156d3b6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Apr 2011 06:31:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7a7b814c9dca9ee01b38e63b4a46de87156d3b6
Gitweb:     http://git.kernel.org/tip/c7a7b814c9dca9ee01b38e63b4a46de87156d3b6
Author:     Tim Gardner <tim.gardner@canonical.com>
AuthorDate: Thu, 28 Apr 2011 11:00:30 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Apr 2011 08:02:47 +0200

ioremap: Delay sanity check until after a successful mapping

While tracking down the reason for an ioremap() failure I was
distracted  by the WARN_ONCE() in __ioremap_caller().

Performing a WARN_ONCE() sanity check before the mapping
is successful seems pointless if the caller sends bad values.

A case in point is when the BIOS provides erroneous screen_info
values causing vesafb_probe() to request an outrageuous size.
The WARN_ONCE is then wasted on bogosity. Move the warning to a
point where the mapping has been successfully allocated.

Addresses:

  http://bugs.launchpad.net/bugs/772042

Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Link: http://lkml.kernel.org/r/4DB99D2E.9080106@canonical.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
