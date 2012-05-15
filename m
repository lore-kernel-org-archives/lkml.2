Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965511Ab2EOCcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:32:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:49852 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965464Ab2EOCSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:05 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 154/179] powerpc: Fix device tree claim code
Date: Mon, 14 May 2012 22:14:10 -0400
Message-ID: <1337048075-6132-155-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 966728dd88b4026ec58fee169ccceaeaf56ef120 upstream.

I have a box that fails in OF during boot with:

DEFAULT CATCH!, exception-handler=fff00400
at   %SRR0: 49424d2c4c6f6768   %SRR1: 800000004000b002

ie "IBM,Logh". OF got corrupted with a device tree string.

Looking at make_room and alloc_up, we claim the first chunk (1 MB)
but we never claim any more. mem_end is always set to alloc_top
which is the top of our available address space, guaranteeing we will
never call alloc_up and claim more memory.

Also alloc_up wasn't setting alloc_bottom to the bottom of the
available address space.

This doesn't help the box to boot, but we at least fail with
an obvious error. We could relocate the device tree in a future
patch.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/powerpc/kernel/prom_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 97d4bd9..2731a27 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -968,7 +968,7 @@ static unsigned long __init alloc_up(unsigned long size, unsigned long align)
 	}
 	if (addr == 0)
 		return 0;
-	RELOC(alloc_bottom) = addr;
+	RELOC(alloc_bottom) = addr + size;
 
 	prom_debug(" -> %x\n", addr);
 	prom_debug("  alloc_bottom : %x\n", RELOC(alloc_bottom));
@@ -1782,7 +1782,7 @@ static void __init *make_room(unsigned long *mem_start, unsigned long *mem_end,
 		chunk = alloc_up(room, 0);
 		if (chunk == 0)
 			prom_panic("No memory for flatten_device_tree (claim failed)");
-		*mem_end = RELOC(alloc_top);
+		*mem_end = chunk + room;
 	}
 
 	ret = (void *)*mem_start;
@@ -2001,7 +2001,7 @@ static void __init flatten_device_tree(void)
 	mem_start = (unsigned long)alloc_up(room, PAGE_SIZE);
 	if (mem_start == 0)
 		prom_panic("Can't allocate initial device-tree chunk\n");
-	mem_end = RELOC(alloc_top);
+	mem_end = mem_start + room;
 
 	/* Get root of tree */
 	root = call_prom("peer", 1, 1, (phandle)0);
-- 
1.7.9.6

