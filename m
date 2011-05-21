Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab1EUTjg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 15:39:36 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:49161 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271Ab1EUTj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 15:39:28 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-m68k@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/4] sparc: _sparc_find_resource() should check for exact matches
Date: Sat, 21 May 2011 21:39:13 +0200
Message-Id: <1306006756-32009-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1306006756-32009-1-git-send-email-geert@linux-m68k.org>
References: <1306006756-32009-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The address that's passed to _sparc_find_resource() should always be the
start address of a resource:
  - iounmap() passes a page-aligned virtual address, while the original
    address was created by adding the in-page offset to the resource's
    start address,
  - sbus_free_coherent() and pci32_free_coherent() should be passed an
    address obtained from sbus_alloc_coherent() resp. pci32_alloc_coherent(),
    which is always a resource's start address.

Hence replace the range check by a check for an exact match.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/sparc/kernel/ioport.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index c6ce9a6..91e8c76 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -733,12 +733,12 @@ static const struct file_operations sparc_io_proc_fops = {
  * This probably warrants some sort of hashing.
  */
 static struct resource *_sparc_find_resource(struct resource *root,
-					     unsigned long hit)
+					     unsigned long start)
 {
 	struct resource *tmp;
 
 	for (tmp = root->child; tmp != 0; tmp = tmp->sibling) {
-		if (tmp->start <= hit && tmp->end >= hit)
+		if (tmp->start == start)
 			return tmp;
 	}
 	return NULL;
-- 
1.7.0.4

