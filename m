Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab2ACW7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:59:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755708Ab2ACWiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:38:02 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:37 2012
Message-Id: <20120103223036.955245541@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:30:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [67/67] xen/swiotlb: Use page alignment for early buffer allocation.
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 63a741757d15320a25ebf5778f8651cce2ed0611 upstream.

This fixes an odd bug found on a Dell PowerEdge 1850/0RC130
(BIOS A05 01/09/2006) where all of the modules doing pci_set_dma_mask
would fail with:

ata_piix 0000:00:1f.1: enabling device (0005 -> 0007)
ata_piix 0000:00:1f.1: can't derive routing for PCI INT A
ata_piix 0000:00:1f.1: BMDMA: failed to set dma mask, falling back to PIO

The issue was the Xen-SWIOTLB was allocated such as that the end of
buffer was stradling a page (and also above 4GB). The fix was
spotted by Kalev Leonid  which was to piggyback on git commit
e79f86b2ef9c0a8c47225217c1018b7d3d90101c "swiotlb: Use page alignment
for early buffer allocation" which:

	We could call free_bootmem_late() if swiotlb is not used, and
	it will shrink to page alignment.

	So alloc them with page alignment at first, to avoid lose two pages

And doing that fixes the outstanding issue.

Suggested-by: "Kalev, Leonid" <Leonid.Kalev@ca.com>
Reported-and-Tested-by: "Taylor, Neal E" <Neal.Taylor@ca.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/xen/swiotlb-xen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -162,7 +162,7 @@ void __init xen_swiotlb_init(int verbose
 	/*
 	 * Get IO TLB memory from any location.
 	 */
-	xen_io_tlb_start = alloc_bootmem(bytes);
+	xen_io_tlb_start = alloc_bootmem_pages(PAGE_ALIGN(bytes));
 	if (!xen_io_tlb_start)
 		panic("Cannot allocate SWIOTLB buffer");
 


