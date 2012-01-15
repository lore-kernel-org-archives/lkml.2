Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab2AONkE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 08:40:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34789 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab2AONkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 08:40:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [PATCH] PM / MTD: Fix regressions related to mtd_suspend()
Date: Sun, 15 Jan 2012 14:43:30 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-mtd@lists.infradead.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201151443.30897.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Commit 3fe4bae88460869a8e553397cd9057a4ee7ca341 (mtd: introduce
mtd_suspend interface) introduced the mtd_suspend() routine
which didn't check whether or not mtd and mtd->suspend were
both valid pointers.  Later commit 079c985e7a6f4ce60f931cebfdd5ee3c3
(mtd: do not use mtd->suspend and mtd->resume directly) added the
check for mtd->suspend, but still it failed to check mtd.  Moreover,
it caused mtd_suspend() to return an error code for NULL
mtd->suspend, which makes system suspend fail on one of my test
systems on every attempt and which is a regression from v3.2.

Fix mtd_suspend() by making it check if mtd is not NULL and
return 0 if mtd or mtd->suspend is NULL, which shouldn't prevent
the system from suspending.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/mtd/mtd.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux/include/linux/mtd/mtd.h
===================================================================
--- linux.orig/include/linux/mtd/mtd.h
+++ linux/include/linux/mtd/mtd.h
@@ -427,9 +427,7 @@ static inline int mtd_is_locked(struct m
 
 static inline int mtd_suspend(struct mtd_info *mtd)
 {
-	if (!mtd->suspend)
-		return -EOPNOTSUPP;
-	return mtd->suspend(mtd);
+	return mtd && mtd->suspend ? mtd->suspend(mtd) : 0;
 }
 
 static inline void mtd_resume(struct mtd_info *mtd)
