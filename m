Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab0C2Pdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 11:33:42 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:43408 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab0C2Pdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 11:33:40 -0400
Date: Mon, 29 Mar 2010 17:33:34 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/12] arch/powerpc/kernel: Add missing unlock
Message-ID: <Pine.LNX.4.64.1003291733150.21896@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add an unlock before exiting the function.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E1;
identifier f;
@@

f (...) { <+...
* spin_lock_irq (E1,...);
... when != E1
* return ...;
...+> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/powerpc/kernel/vio.c           |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index 77f6421..2ca69fa 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -644,8 +644,10 @@ void vio_cmo_set_dev_desired(struct vio_dev *viodev, size_t desired)
 			found = 1;
 			break;
 		}
-	if (!found)
+	if (!found) {
+		spin_unlock_irqrestore(&vio_cmo.lock, flags);
 		return;
+	}
 
 	/* Increase/decrease in desired device entitlement */
 	if (desired >= viodev->cmo.desired) {
