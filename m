Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab1LGQUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:20:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757606Ab1LGQUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:20:08 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:27 2011
Message-Id: <20111207160827.280105886@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:07:17 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Andiry Xu <andiry.xu@amd.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [57/80] xHCI: fix bug in xhci_clear_command_ring()
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andiry Xu <andiry.xu@amd.com>

commit 158886cd2cf4599e04f9b7e10cb767f5f39b14f1 upstream.

When system enters suspend, xHCI driver clears command ring by writing zero
to all the TRBs. However, this also writes zero to the Link TRB, and the ring
is mangled. This may cause driver accesses wrong memory address and the
result is unpredicted.

When clear the command ring, keep the last Link TRB intact, only clear its
cycle bit. This should fix the "command ring full" issue reported by Oliver
Neukum.

This should be backported to stable kernels as old as 2.6.37, since the
commit 89821320 "xhci: Fix command ring replay after resume" is merged.

Signed-off-by: Andiry Xu <andiry.xu@amd.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -657,7 +657,10 @@ static void xhci_clear_command_ring(stru
 	ring = xhci->cmd_ring;
 	seg = ring->deq_seg;
 	do {
-		memset(seg->trbs, 0, SEGMENT_SIZE);
+		memset(seg->trbs, 0,
+			sizeof(union xhci_trb) * (TRBS_PER_SEGMENT - 1));
+		seg->trbs[TRBS_PER_SEGMENT - 1].link.control &=
+			cpu_to_le32(~TRB_CYCLE);
 		seg = seg->next;
 	} while (seg != ring->deq_seg);
 


