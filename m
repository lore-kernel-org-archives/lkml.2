Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965015Ab2DKXVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:21:40 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:51108 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933387Ab2DKXVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:21:38 -0400
Message-Id: <20120411231036.581670888@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Kenth Eriksson <kenth.eriksson@transmode.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 06/59] Fix non TBI PHY access; a bad merge undid bug fix in a previous commit.
In-Reply-To: <20120411231213.GA13124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Kenth Eriksson <kenth.eriksson@transmode.com>

[ Upstream commit 464b57da56910c8737ede75ad820b9a7afc46b3e ]

The merge done in commit b26e478f undid bug fix in commit c3e072f8
("net: fsl_pq_mdio: fix non tbi phy access"), with the result that non
TBI (e.g. MDIO) PHYs cannot be accessed.

Signed-off-by: Kenth Eriksson <kenth.eriksson@transmode.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fsl_pq_mdio.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/freescale/fsl_pq_mdio.c
+++ b/drivers/net/ethernet/freescale/fsl_pq_mdio.c
@@ -356,16 +356,15 @@ static int fsl_pq_mdio_probe(struct plat
 
 		if (prop)
 			tbiaddr = *prop;
-	}
-
-	if (tbiaddr == -1) {
-		err = -EBUSY;
 
-		goto err_free_irqs;
+		if (tbiaddr == -1) {
+			err = -EBUSY;
+			goto err_free_irqs;
+		} else {
+			out_be32(tbipa, tbiaddr);
+		}
 	}
 
-	out_be32(tbipa, tbiaddr);
-
 	err = of_mdiobus_register(new_bus, np);
 	if (err) {
 		printk (KERN_ERR "%s: Cannot register as MDIO bus\n",


