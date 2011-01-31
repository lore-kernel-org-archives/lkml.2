Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab1AaQz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:55:28 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53577 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab1AaQz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:55:27 -0500
Message-ID: <4D46E97B.4060604@austin.ibm.com>
Date: Mon, 31 Jan 2011 10:55:23 -0600
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Greg KH <greg@kroah.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Robin Holt <holt@sgi.com>
Subject: [PATCH] sysfs probe routine should add all memory sections
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a follow-on to the recent patches I submitted that allowed for a sysfs
memory block to span multiple memory sections, we should also update the
probe routine to online all of the memory sections in a memory block.  Without
this patch the current code will only add a single memory section.  I think
the probe routine should add all of the memory sections in the specified memory
block so that its behavior is in line with memory hotplug actions through
the sysfs interfaces.

This patch applies on top of the previous sysfs memory updates to allow
a sysfs directory o span multiple memory sections.

https://lkml.org/lkml/2011/1/20/245

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
---
 drivers/base/memory.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

Index: linux-next/drivers/base/memory.c
===================================================================
--- linux-next.orig/drivers/base/memory.c	2011-01-28 14:14:20.000000000 -0600
+++ linux-next/drivers/base/memory.c	2011-01-31 09:10:11.000000000 -0600
@@ -387,12 +387,19 @@ memory_probe_store(struct class *class,
 {
 	u64 phys_addr;
 	int nid;
-	int ret;
+	int i, ret;
 
 	phys_addr = simple_strtoull(buf, NULL, 0);
 
-	nid = memory_add_physaddr_to_nid(phys_addr);
-	ret = add_memory(nid, phys_addr, PAGES_PER_SECTION << PAGE_SHIFT);
+	for (i = 0; i < sections_per_block; i++) {
+		nid = memory_add_physaddr_to_nid(phys_addr);
+		ret = add_memory(nid, phys_addr,
+				 PAGES_PER_SECTION << PAGE_SHIFT);
+		if (ret)
+			break;
+
+		phys_addr += MIN_MEMORY_BLOCK_SIZE;
+	}
 
 	if (ret)
 		count = ret;
