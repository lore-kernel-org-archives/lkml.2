Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab0EZP4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:56:08 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:40711 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439Ab0EZP4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:56:04 -0400
Date: Wed, 26 May 2010 17:55:59 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Joerg Roedel <joerg.roedel@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 6/17] arch/x86/kernel: Add missing spin_unlock
Message-ID: <Pine.LNX.4.64.1005261755260.23743@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add a spin_unlock missing on the error path.  The locks and unlocks are
balanced in other functions, so it seems that the same should be the case
here.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1;
@@

* spin_lock(E1,...);
  <+... when != E1
  if (...) {
    ... when != E1
*   return ...;
  }
  ...+>
* spin_unlock(E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/x86/kernel/amd_iommu.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index fa5a147..b98e1cd 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1499,12 +1499,16 @@ static int __attach_device(struct device *dev,
 
 	/* Some sanity checks */
 	if (alias_data->domain != NULL &&
-	    alias_data->domain != domain)
+	    alias_data->domain != domain) {
+		spin_unlock(&domain->lock);
 		return -EBUSY;
+	}
 
 	if (dev_data->domain != NULL &&
-	    dev_data->domain != domain)
+	    dev_data->domain != domain) {
+		spin_unlock(&domain->lock);
 		return -EBUSY;
+	}
 
 	/* Do real assignment */
 	if (dev_data->alias != dev) {
