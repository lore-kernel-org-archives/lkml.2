Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab0EZP7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:59:00 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:40779 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399Ab0EZP66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:58:58 -0400
Date: Wed, 26 May 2010 17:58:53 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>,
       ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 15/17] fs/ocfs2/dlm: Add missing spin_unlock
Message-ID: <Pine.LNX.4.64.1005261758290.23743@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add a spin_unlock missing on the error path.  Unlock as in the other code
that leads to the leave label.

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
 fs/ocfs2/dlm/dlmdomain.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 6b5a492..2ccad86 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1709,6 +1709,7 @@ retry:
 		}
 
 		if (dlm_protocol_compare(&dlm->fs_locking_proto, fs_proto)) {
+			spin_unlock(&dlm_domain_lock);
 			mlog(ML_ERROR,
 			     "Requested locking protocol version is not "
 			     "compatible with already registered domain "
