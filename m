Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355Ab2ILXoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:44:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64318 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933339Ab2ILXn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:43:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Boaz Harrosh <bharrosh@panasas.com>,
        Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 16/46] NFSv4.1: Remove a bogus BUG_ON() in nfs4_layoutreturn_done
Date: Wed, 12 Sep 2012 16:39:06 -0700
Message-Id: <20120912233819.364182315@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233817.662663809@linuxfoundation.org>
References: <20120912233817.662663809@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 47fbf7976e0b7d9dcdd799e2a1baba19064d9631 upstream.

Ever since commit 0a57cdac3f (NFSv4.1 send layoutreturn to fence
disconnected data server) we've been sending layoutreturn calls
while there is potentially still outstanding I/O to the data
servers. The reason we do this is to avoid races between replayed
writes to the MDS and the original writes to the DS.

When this happens, the BUG_ON() in nfs4_layoutreturn_done can
be triggered because it assumes that we would never call
layoutreturn without knowing that all I/O to the DS is
finished. The fix is to remove the BUG_ON() now that the
assumptions behind the test are obsolete.

Reported-by: Boaz Harrosh <bharrosh@panasas.com>
Reported-by: Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5766,12 +5766,8 @@ static void nfs4_layoutreturn_done(struc
 		return;
 	}
 	spin_lock(&lo->plh_inode->i_lock);
-	if (task->tk_status == 0) {
-		if (lrp->res.lrs_present) {
-			pnfs_set_layout_stateid(lo, &lrp->res.stateid, true);
-		} else
-			BUG_ON(!list_empty(&lo->plh_segs));
-	}
+	if (task->tk_status == 0 && lrp->res.lrs_present)
+		pnfs_set_layout_stateid(lo, &lrp->res.stateid, true);
 	lo->plh_block_lgets--;
 	spin_unlock(&lo->plh_inode->i_lock);
 	dprintk("<-- %s\n", __func__);


