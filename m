Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab1INU0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:26:22 -0400
Received: from ozlabs.org ([203.10.76.45]:48468 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933122Ab1INU0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:26:21 -0400
Date: Thu, 15 Sep 2011 06:26:15 +1000
From: Anton Blanchard <anton@samba.org>
To: gregkh@suse.de, nfont@austin.ibm.com
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] memory hotplug: Refuse to add unaligned memory regions
Message-ID: <20110915062615.782bc4df@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The sysfs memory probe interface allows unaligned regions
to be added:

# echo 0xffffff > /sys/devices/system/memory/probe

# cat /proc/iomem 
00ffffff-01fffffe : System RAM
01ffffff-02fffffe : System RAM
02ffffff-03fffffe : System RAM
03ffffff-04fffffe : System RAM
04ffffff-05fffffe : System RAM

Return -EINVAL instead of creating these bad regions.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-build/drivers/base/memory.c
===================================================================
--- linux-build.orig/drivers/base/memory.c	2011-08-11 08:25:55.005941391 +1000
+++ linux-build/drivers/base/memory.c	2011-08-11 08:28:27.938580440 +1000
@@ -380,9 +380,13 @@ memory_probe_store(struct class *class,
 	u64 phys_addr;
 	int nid;
 	int i, ret;
+	unsigned long pages_per_block = PAGES_PER_SECTION * sections_per_block;
 
 	phys_addr = simple_strtoull(buf, NULL, 0);
 
+	if (phys_addr & ((pages_per_block << PAGE_SHIFT) - 1))
+		return -EINVAL;
+
 	for (i = 0; i < sections_per_block; i++) {
 		nid = memory_add_physaddr_to_nid(phys_addr);
 		ret = add_memory(nid, phys_addr,
