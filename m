Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab2KZRBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:01:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47076 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab2KZRA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:00:59 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 020/270] nfsd4: fix nfs4 stateid leak
Date: Mon, 26 Nov 2012 14:55:10 -0200
Message-Id: <1353949160-26803-21-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit cf9182e90b2af04245ac4fae497fe73fc71285b4 upstream.

Processes that open and close multiple files may end up setting this
oo_last_closed_stid without freeing what was previously pointed to.
This can result in a major leak, visible for example by watching the
nfsd4_stateids line of /proc/slabinfo.

Reported-by: Cyril B. <cbay@excellency.fr>
Tested-by: Cyril B. <cbay@excellency.fr>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/nfsd/nfs4state.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index e8ead04..be324aa 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3748,6 +3748,7 @@ nfsd4_close(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	memcpy(&close->cl_stateid, &stp->st_stid.sc_stateid, sizeof(stateid_t));
 
 	nfsd4_close_open_stateid(stp);
+	release_last_closed_stateid(oo);
 	oo->oo_last_closed_stid = stp;
 
 	/* place unused nfs4_stateowners on so_close_lru list to be
-- 
1.7.9.5

