Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab1LOTcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:32:41 -0500
Received: from gate.ebshome.net ([173.228.72.32]:53065 "EHLO gate.ebshome.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab1LOTck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:32:40 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Dec 2011 14:32:40 EST
Date: Thu, 15 Dec 2011 11:25:59 -0800
From: Eugene Surovegin <ebs@ebshome.net>
To: tj@kernel.org
Cc: ptesarik@suse.cz, xiyou.wangcong@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, vgoyal@redhat.com
Subject: [PATCH] percpu: fix per_cpu_ptr_to_phys() handling of
 non-page-aligned addresses.
Message-ID: <20111215192559.GA28283@gate.ebshome.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ICQ-UIN: 1193073
X-Operating-System: Linux i686
X-PGP-Key: http://www.ebshome.net/pubkey.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

per_cpu_ptr_to_phys() incorrectly rounds up its result for non-kmalloc case
to the page boundary, which is bogus for any non-page-aligned address.

This fixes the only in-tree user of this function - sysfs handler for
per-cpu 'crash_notes' physical address. The manifestation of this bug is
missing 'CORE' ELF notes in kdump.

Signed-off-by: Eugene Surovegin <ebs@ebshome.net>
---
 mm/percpu.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 3bb810a..716eb4a 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1023,9 +1023,11 @@ phys_addr_t per_cpu_ptr_to_phys(void *addr)
 		if (!is_vmalloc_addr(addr))
 			return __pa(addr);
 		else
-			return page_to_phys(vmalloc_to_page(addr));
+			return page_to_phys(vmalloc_to_page(addr)) +
+			       offset_in_page(addr);
 	} else
-		return page_to_phys(pcpu_addr_to_page(addr));
+		return page_to_phys(pcpu_addr_to_page(addr)) +
+		       offset_in_page(addr);
 }
 
 /**
-- 
1.7.5.1

