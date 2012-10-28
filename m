Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab2J1X3o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:29:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42243 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756988Ab2J1X2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:32 -0400
Message-Id: <20121028231544.102674653@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:15:59 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "J. Bruce Fields" <bfields@redhat.com>,
        "Cyril B." <cbay@excellency.fr>
Subject: [ 023/105] nfsd4: fix nfs4 stateid leak
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfs4state.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3673,6 +3673,7 @@ nfsd4_close(struct svc_rqst *rqstp, stru
 	memcpy(&close->cl_stateid, &stp->st_stid.sc_stateid, sizeof(stateid_t));
 
 	nfsd4_close_open_stateid(stp);
+	release_last_closed_stateid(oo);
 	oo->oo_last_closed_stid = stp;
 
 	/* place unused nfs4_stateowners on so_close_lru list to be


