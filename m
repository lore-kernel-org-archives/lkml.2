Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab2B1BGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:06:16 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46792 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab2B1BGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:06:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.240.135 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010206.388400888@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:02:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 14/73] NFSv4: Ensure we throw out bad delegation stateids on NFS4ERR_BAD_STATEID
In-Reply-To: <20120228010246.GA24299@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit b9f9a03150969e4bd9967c20bce67c4de769058f upstream.

To ensure that we don't just reuse the bad delegation when we attempt to
recover the nfs4_state that received the bad stateid error.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4state.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1065,6 +1065,8 @@ void nfs4_schedule_stateid_recovery(cons
 {
 	struct nfs_client *clp = server->nfs_client;
 
+	if (test_and_clear_bit(NFS_DELEGATED_STATE, &state->flags))
+		nfs_async_inode_return_delegation(state->inode, &state->stateid);
 	nfs4_state_mark_reclaim_nograce(clp, state);
 	nfs4_schedule_state_manager(clp);
 }


