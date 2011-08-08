Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab1HHLSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 07:18:15 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:53547 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab1HHLSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 07:18:11 -0400
From: Julia Lawall <julia@diku.dk>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: kernel-janitors@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 3/9] drivers/ata/sata_dwc_460ex.c: add missing kfree
Date: Mon,  8 Aug 2011 13:17:57 +0200
Message-Id: <1312802283-9107-3-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Currently, error handling code in this function calls the function
sata_dwc_port_stop, but this function has essentially no effect if hsdevp
has not been stored in ap, which is the case throughout this function.  The
only effect is to print a debugging message including ap->print_id.

The code is rewritten to not call sata_dwc_port_stop, but instead to jump
to a local label that prints the original error message and the print_id
information.  In the case where hsdevp has been already allocated (but not
yet stored in ap), this value is freed as well.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@exists@
local idexpression x;
statement S,S1;
expression E;
identifier fl;
expression *ptr != NULL;
@@

x = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...kfree(x)...+> }
     when any
     when != true x == NULL
x->fl
...>
(
if (x == NULL) S1
|
if (...) { ... when != x
               when forall
(
 return \(0\|<+...x...+>\|ptr\);
|
* return ...;
)
}
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/ata/sata_dwc_460ex.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 0a9a774..5c42374 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1329,7 +1329,7 @@ static int sata_dwc_port_start(struct ata_port *ap)
 			dev_err(ap->dev, "%s: dma_alloc_coherent failed\n",
 				 __func__);
 			err = -ENOMEM;
-			goto CLEANUP;
+			goto CLEANUP_ALLOC;
 		}
 	}
 
@@ -1349,15 +1349,13 @@ static int sata_dwc_port_start(struct ata_port *ap)
 	/* Clear any error bits before libata starts issuing commands */
 	clear_serror();
 	ap->private_data = hsdevp;
+	dev_dbg(ap->dev, "%s: done\n", __func__);
+	return 0;
 
+CLEANUP_ALLOC:
+	kfree(hsdevp);
 CLEANUP:
-	if (err) {
-		sata_dwc_port_stop(ap);
-		dev_dbg(ap->dev, "%s: fail\n", __func__);
-	} else {
-		dev_dbg(ap->dev, "%s: done\n", __func__);
-	}
-
+	dev_dbg(ap->dev, "%s: fail. ap->id = %d\n", __func__, ap->print_id);
 	return err;
 }
 
