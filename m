Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab2E2RFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 13:05:05 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18752 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab2E2RFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 13:05:02 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, david.vrabel@citrix.com,
        linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/balloon: Subtract from xen_released_pages the count that is populated.
Date: Tue, 29 May 2012 12:58:09 -0400
Message-Id: <1338310689-5967-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We did not take into account that xen_released_pages would be
used outside the initial E820 parsing code. As such we would
not subtract from xen_released_pages the count of pages
that we had populated back. Instead we just did a simple
extra_pages = released - populated calculation.

However the balloon worker uses xen_released_pages to figure
out how many more pages it can balloon up to and not having
the proper numbers we would balloon more than we should have.

This fixes errors such as:

(XEN) memory.c:133:d0 Could not allocate order=0 extent: id=0 memflags=0 (51 of 512)
during bootup and
free_memory            : 0

where the free_memory should be 128.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/setup.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 3ebba07..a4790bf 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -371,7 +371,8 @@ char * __init xen_memory_setup(void)
 	populated = xen_populate_chunk(map, memmap.nr_entries,
 			max_pfn, &last_pfn, xen_released_pages);
 
-	extra_pages += (xen_released_pages - populated);
+	xen_released_pages -= populated;
+	extra_pages += xen_released_pages;
 
 	if (last_pfn > max_pfn) {
 		max_pfn = min(MAX_DOMAIN_PAGES, last_pfn);
-- 
1.7.7.6

