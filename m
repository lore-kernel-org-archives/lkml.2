Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab1CPVNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:13:13 -0400
Received: from kroah.org ([198.145.64.141]:42587 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269Ab1CPVLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:11:47 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Nathan Fontenot <nfont@austin.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/50] memory hotplug: sysfs probe routine should add all memory sections
Date: Wed, 16 Mar 2011 14:10:55 -0700
Message-Id: <1300309888-5028-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Fontenot <nfont@austin.ibm.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/memory.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 71b4a32..3da6a43 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -387,12 +387,19 @@ memory_probe_store(struct class *class, struct class_attribute *attr,
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
-- 
1.7.4.1

