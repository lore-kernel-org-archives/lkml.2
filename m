Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab0IZJ6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 05:58:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59803 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757439Ab0IZJ6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 05:58:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=iZdy7noBfshe4s7zo0LUzrOOIOEuIppg1RNO8OUs6Mgv5+G9N+uhB1qgPLuO+nBbum
         Nmn7bGH629360bMBemf8lu9ECkuK8+XWXRueO5SoQTaocRU5/AUBc814N0Uz2n6EYJRr
         fB4XEFH2MK3/BSb4rIE72Fja7NDrjhw1PMYJw=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Denis Kirjanov <dkirjanov@kernel.org>,
        Kulikov Vasiliy <segooon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jpirko@redhat.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] staging: slicoss: use free_netdev(netdev) instead of kfree()
Date: Sun, 26 Sep 2010 13:58:28 +0400
Message-Id: <1285495108-22196-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Freeing netdev without free_netdev() leads to net, tx leaks.
I might lead to dereferencing freed pointer.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

@@
struct net_device* dev;
@@

-kfree(dev)
+free_netdev(dev)
---
 Compile tested.

 drivers/staging/slicoss/slicoss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 58ff123..18f1103 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -3233,7 +3233,7 @@ static void __devexit slic_entry_remove(struct pci_dev *pcidev)
 		slic_global.num_slic_cards--;
 		slic_card_cleanup(card);
 	}
-	kfree(dev);
+	free_netdev(dev);
 	pci_release_regions(pcidev);
 }
 
-- 
1.7.0.4

