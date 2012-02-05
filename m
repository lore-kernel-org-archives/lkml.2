Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab2BEW0z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:26:55 -0500
Received: from 1wt.eu ([62.212.114.60]:62069 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459Ab2BEW0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:52 -0500
Message-Id: <20120205220951.120047847@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:28 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 39/91] powerpc: Fix device tree claim code
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/kernel/prom_init.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

Index: longterm-2.6.27/arch/powerpc/kernel/prom_init.c
===================================================================
--- longterm-2.6.27.orig/arch/powerpc/kernel/prom_init.c	2012-02-05 22:34:33.840914904 +0100
+++ longterm-2.6.27/arch/powerpc/kernel/prom_init.c	2012-02-05 22:34:40.385916495 +0100
@@ -880,7 +880,7 @@
 	}
 	if (addr == 0)
 		return 0;
-	RELOC(alloc_bottom) = addr;
+	RELOC(alloc_bottom) = addr + size;
 
 	prom_debug(" -> %x\n", addr);
 	prom_debug("  alloc_bottom : %x\n", RELOC(alloc_bottom));
@@ -1680,7 +1680,7 @@
 		chunk = alloc_up(room, 0);
 		if (chunk == 0)
 			prom_panic("No memory for flatten_device_tree (claim failed)");
-		*mem_end = RELOC(alloc_top);
+		*mem_end = chunk + room;
 	}
 
 	ret = (void *)*mem_start;
@@ -1899,7 +1899,7 @@
 	mem_start = (unsigned long)alloc_up(room, PAGE_SIZE);
 	if (mem_start == 0)
 		prom_panic("Can't allocate initial device-tree chunk\n");
-	mem_end = RELOC(alloc_top);
+	mem_end = mem_start + room;
 
 	/* Get root of tree */
 	root = call_prom("peer", 1, 1, (phandle)0);


