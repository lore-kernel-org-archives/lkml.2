Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab0EZP5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:57:31 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:46260 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491Ab0EZP52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:57:28 -0400
Date: Wed, 26 May 2010 17:57:23 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 11/17] fs/xfs/quota: Add missing mutex_unlock
Message-ID: <Pine.LNX.4.64.1005261757050.23743@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add a mutex_unlock missing on the error path.  The use of this lock is
balanced elsewhere in the file.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1;
@@

* mutex_lock(E1,...);
  <+... when != E1
  if (...) {
    ... when != E1
*   return ...;
  }
  ...+>
* mutex_unlock(E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
The use of ENOMEM rather than -ENOMEM is also a bit odd.

 fs/xfs/quota/xfs_qm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
index 38e7641..2d8b7bc 100644
--- a/fs/xfs/quota/xfs_qm.c
+++ b/fs/xfs/quota/xfs_qm.c
@@ -249,8 +249,10 @@ xfs_qm_hold_quotafs_ref(
 
 	if (!xfs_Gqm) {
 		xfs_Gqm = xfs_Gqm_init();
-		if (!xfs_Gqm)
+		if (!xfs_Gqm) {
+			mutex_unlock(&xfs_Gqm_lock);
 			return ENOMEM;
+		}
 	}
 
 	/*
