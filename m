Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab0CaACN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:02:13 -0400
Received: from kroah.org ([198.145.64.141]:45397 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932303Ab0C3XSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:45 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:57 2010
Message-Id: <20100330225657.012198937@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:56:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       575726@bugs.debian.org, linux-wireless <linux-wireless@vger.kernel.org>,
       John Halton <johnhalton@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ben Hutchings <ben@decadent.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [088/116] rt2860sta: Fix argument to linux_pci_unmap_single()
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

John Halton wrote in <http://bugs.debian.org/575726>:
> Whenever wpa_supplicant is deactivated (whether by killing the process or
> during a normal shutdown) I am getting a kerneloops that prevents the
> computer from completing shutdown. Here is the relevant syslog output:

The backtrace points to an incorrect call from RTMPFreeTxRxRingMemory()
into linux_pci_unmap_single().  This appears to have been fixed in Linux
2.6.33 by this change:

commit ca97b8388838ee9ea4b4bad04948f8f7f8a607a3
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Tue Sep 22 20:44:07 2009 +0200

    Staging: rt28x0: updates from vendor's V2.1.0.0 drivers

For stable-2.6.32, just fix this one function call.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rt2860/common/2860_rtmp_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rt2860/common/2860_rtmp_init.c
+++ b/drivers/staging/rt2860/common/2860_rtmp_init.c
@@ -716,7 +716,7 @@ VOID RTMPFreeTxRxRingMemory(
 	{
 		if ((pAd->RxRing.Cell[index].DmaBuf.AllocVa) && (pAd->RxRing.Cell[index].pNdisPacket))
 		{
-			PCI_UNMAP_SINGLE(pObj->pci_dev, pAd->RxRing.Cell[index].DmaBuf.AllocPa, pAd->RxRing.Cell[index].DmaBuf.AllocSize, PCI_DMA_FROMDEVICE);
+			PCI_UNMAP_SINGLE(pAd, pAd->RxRing.Cell[index].DmaBuf.AllocPa, pAd->RxRing.Cell[index].DmaBuf.AllocSize, PCI_DMA_FROMDEVICE);
 			RELEASE_NDIS_PACKET(pAd, pAd->RxRing.Cell[index].pNdisPacket, NDIS_STATUS_SUCCESS);
 		}
 	}


