Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab0GAUw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:52:28 -0400
Received: from kroah.org ([198.145.64.141]:47743 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932625Ab0GAUux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:53 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:35 2010
Message-Id: <20100701173435.730451440@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:34:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Julia Lawall <julia@diku.dk>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [patch 106/164] arch/x86/kernel: Add missing spin_unlock
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julia Lawall <julia@diku.dk>

commit 84fe6c19e4a598e8071e3bd1b2c923454eae1268 upstream.

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
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1419,6 +1419,7 @@ static int __attach_device(struct device
 			   struct protection_domain *domain)
 {
 	struct iommu_dev_data *dev_data, *alias_data;
+	int ret;
 
 	dev_data   = get_dev_data(dev);
 	alias_data = get_dev_data(dev_data->alias);
@@ -1430,13 +1431,14 @@ static int __attach_device(struct device
 	spin_lock(&domain->lock);
 
 	/* Some sanity checks */
+	ret = -EBUSY;
 	if (alias_data->domain != NULL &&
 	    alias_data->domain != domain)
-		return -EBUSY;
+		goto out_unlock;
 
 	if (dev_data->domain != NULL &&
 	    dev_data->domain != domain)
-		return -EBUSY;
+		goto out_unlock;
 
 	/* Do real assignment */
 	if (dev_data->alias != dev) {
@@ -1452,10 +1454,14 @@ static int __attach_device(struct device
 
 	atomic_inc(&dev_data->bind);
 
+	ret = 0;
+
+out_unlock:
+
 	/* ready */
 	spin_unlock(&domain->lock);
 
-	return 0;
+	return ret;
 }
 
 /*


