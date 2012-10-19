Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab2JSCqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:46:49 -0400
Received: from mail.kernel.org ([198.145.19.201]:50978 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab2JSCqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:46:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Cyril B." <cbay@excellency.fr>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 02/62] nfsd4: fix nfs4 stateid leak
Date: Thu, 18 Oct 2012 19:44:30 -0700
Message-Id: <20121019024256.319019527@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024255.944999470@linuxfoundation.org>
References: <20121019024255.944999470@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4state.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3783,6 +3783,7 @@ nfsd4_close(struct svc_rqst *rqstp, stru
 	memcpy(&close->cl_stateid, &stp->st_stid.sc_stateid, sizeof(stateid_t));
 
 	nfsd4_close_open_stateid(stp);
+	release_last_closed_stateid(oo);
 	oo->oo_last_closed_stid = stp;
 
 	/* place unused nfs4_stateowners on so_close_lru list to be


