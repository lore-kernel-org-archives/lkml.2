Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306Ab2EAQpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 12:45:40 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:45666 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562Ab2EAQm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 12:42:58 -0400
Date: Tue, 1 May 2012 12:37:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com
Cc: xen-devel@lists.xensource.com
Subject: Re: [PATCH] auto balloon initial domain and fix dom0_mem=X
 inconsistencies (v5).
Message-ID: <20120501163707.GA8741@phenom.dumpdata.com>
References: <1334596539-18172-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334596539-18172-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 01:15:31PM -0400, Konrad Rzeszutek Wilk wrote:
> Changelog v5 [since v4]:
>  - used populate_physmap, fixed bugs.
> [v2-v4: not posted]
>  - reworked the code in setup.c to work properly.
> [v1: https://lkml.org/lkml/2012/3/30/492]
>  - initial patchset

One bug I found was that with 'dom0_mem=max:1G' (with and without these
patches) I would get a bunch of

(XEN) page_alloc.c:1148:d0 Over-allocation for domain 0: 2097153 > 2097152
(XEN) memory.c:133:d0 Could not allocate order=0 extent: id=0 memflags=0 (0 of 17)

where the (0 of X), sometimes was 1, 2,3,4 or 17 -depending on the machine
I ran on it. I figured it out that the difference was in the ACPI tables
that are allocated - and that those regions - even though are returned
back to the hypervisor, cannot be repopulated. I can't find the actual
exact piece of code in the hypervisor to pin-point and say "Aha".

What I did was use the same metrix that the hypervisor uses to figure
out whether to deny the guest ballooning up - checking the d->tot_pages
against t->max_pages. For that the XENMEM_current_reservation is used.


>From e4568b678455f68d374277319fb5cc41f11b6c4f Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Thu, 26 Apr 2012 22:11:08 -0400
Subject: [PATCH] xen/setup: Cap amount to populate based on current tot_pages
 count.

Previous to this patch we would try to populate exactly up to
xen_released_pages number (so the ones that we released), but
that is incorrect as there are some pages that we thought were
released but in actuality were shared. Depending on the platform
it could be small amounts - 2 pages, but some had much higher - 17.

As such, lets use the XENMEM_current_reservation to get the exact
count of pages we are using, subtract it from nr_pages and use the
lesser of this and xen_released_pages to populate back.

This fixes errors such as:

(XEN) page_alloc.c:1148:d0 Over-allocation for domain 0: 2097153 > 2097152
(XEN) memory.c:133:d0 Could not allocate order=0 extent: id=0 memflags=0 (0 of 17)

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/setup.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 506a3e6..8e7dcfd 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -287,7 +287,15 @@ static unsigned long __init xen_get_max_pages(void)
 
 	return min(max_pages, MAX_DOMAIN_PAGES);
 }
-
+static unsigned long xen_get_current_pages(void)
+{
+	domid_t domid = DOMID_SELF;
+	int ret;
+	ret = HYPERVISOR_memory_op(XENMEM_current_reservation, &domid);
+	if (ret > 0)
+		return ret;
+	return 0;
+}
 static void xen_align_and_add_e820_region(u64 start, u64 size, int type)
 {
 	u64 end = start + size;
@@ -358,7 +366,11 @@ char * __init xen_memory_setup(void)
 
 	/*
 	 * Populate back the non-RAM pages and E820 gaps that had been
-	 * released. */
+	 * released. But cap it as certain regions cannot be repopulated.
+	 */
+	if (xen_get_current_pages())
+		xen_released_pages = min(max_pfn - xen_get_current_pages(),
+				xen_released_pages);
 	populated = xen_populate_chunk(map, memmap.nr_entries,
 			max_pfn, &last_pfn, xen_released_pages);
 
-- 
1.7.7.5

