Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964786Ab2JSCsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:48:32 -0400
Received: from mail.kernel.org ([198.145.19.201]:51842 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757504Ab2JSCsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:48:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Bryan Schumaker <bjschuma@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 04/76] NFS: Remove bad delegations during open recovery
Date: Thu, 18 Oct 2012 19:46:28 -0700
Message-Id: <20121019024350.793373325@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan Schumaker <bjschuma@netapp.com>

commit 6938867edba929a65a167a97581231e76aeb10b4 upstream.

I put the client into an open recovery loop by:
	Client: Open file
		read half
	Server: Expire client (echo 0 > /sys/kernel/debug/nfsd/forget_clients)
	Client: Drop vm cache (echo 3 > /proc/sys/vm/drop_caches)
		finish reading file

This causes a loop because the client never updates the nfs4_state after
discovering that the delegation is invalid.  This means it will keep
trying to read using the bad delegation rather than attempting to re-open
the file.

Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1774,7 +1774,11 @@ static void nfs41_clear_delegation_state
 		 * informs us the stateid is unrecognized. */
 		if (status != -NFS4ERR_BAD_STATEID)
 			nfs41_free_stateid(server, stateid);
+		nfs_remove_bad_delegation(state->inode);
 
+		write_seqlock(&state->seqlock);
+		nfs4_stateid_copy(&state->stateid, &state->open_stateid);
+		write_sequnlock(&state->seqlock);
 		clear_bit(NFS_DELEGATED_STATE, &state->flags);
 	}
 }


