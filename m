Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab0GASgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:36:08 -0400
Received: from kroah.org ([198.145.64.141]:40664 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758028Ab0GASXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:23:55 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:15 2010
Message-Id: <20100701173215.073634832@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 098/149] sata_nv: dont diddle with nIEN on mcp55
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit f3faf8fc3fab45c3526efe8c9e99bb23f8723350 upstream.

On mcp55, nIEN gets stuck once set and liteon blueray rom iHOS104-08
violates ATA specification and fails to set I on D2H Reg FIS if nIEN
is set when the command was issued.  When the other party is following
the spec, both devices can work fine but when the two flaws are put
together, they can't talk to each other.

mcp55 has its own IRQ masking mechanism and there's no reason to mess
with nIEN in the first place.  Fix it by dropping nIEN diddling from
nv_mcp55_freeze/thaw().

This was originally reported by Cengiz.  Although Cengiz hasn't
verified the fix yet, I could reproduce this problem and verfiy the
fix.  Even if Cengiz is experiencing different or additional problems,
this patch is needed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Cengiz Günay <cgunay@emory.edu>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/sata_nv.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1673,7 +1673,6 @@ static void nv_mcp55_freeze(struct ata_p
 	mask = readl(mmio_base + NV_INT_ENABLE_MCP55);
 	mask &= ~(NV_INT_ALL_MCP55 << shift);
 	writel(mask, mmio_base + NV_INT_ENABLE_MCP55);
-	ata_sff_freeze(ap);
 }
 
 static void nv_mcp55_thaw(struct ata_port *ap)
@@ -1687,7 +1686,6 @@ static void nv_mcp55_thaw(struct ata_por
 	mask = readl(mmio_base + NV_INT_ENABLE_MCP55);
 	mask |= (NV_INT_MASK_MCP55 << shift);
 	writel(mask, mmio_base + NV_INT_ENABLE_MCP55);
-	ata_sff_thaw(ap);
 }
 
 static void nv_adma_error_handler(struct ata_port *ap)


