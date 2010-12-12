Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab0LMAZf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:25:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44787 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab0LLXpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:40 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: Trond.Myklebust@netapp.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [42/223] NFSv4: Fix open recovery
Message-Id: <20101212234539.188ABB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:39 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit b0ed9dbc24f1fd912b2dd08b995153cafc1d5b1c upstream.

NFSv4 open recovery is currently broken: since we do not clear the
state->flags states before attempting recovery, we end up with the
'can_open_cached()' function triggering. This again leads to no OPEN call
being put on the wire.

Reported-by: Sachin Prabhu <sprabhu@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/nfs/nfs4proc.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/fs/nfs/nfs4proc.c
===================================================================
--- linux.orig/fs/nfs/nfs4proc.c
+++ linux/fs/nfs/nfs4proc.c
@@ -1099,6 +1099,7 @@ static int nfs4_open_recover(struct nfs4
 	clear_bit(NFS_DELEGATED_STATE, &state->flags);
 	smp_rmb();
 	if (state->n_rdwr != 0) {
+		clear_bit(NFS_O_RDWR_STATE, &state->flags);
 		ret = nfs4_open_recover_helper(opendata, FMODE_READ|FMODE_WRITE, &newstate);
 		if (ret != 0)
 			return ret;
@@ -1106,6 +1107,7 @@ static int nfs4_open_recover(struct nfs4
 			return -ESTALE;
 	}
 	if (state->n_wronly != 0) {
+		clear_bit(NFS_O_WRONLY_STATE, &state->flags);
 		ret = nfs4_open_recover_helper(opendata, FMODE_WRITE, &newstate);
 		if (ret != 0)
 			return ret;
@@ -1113,6 +1115,7 @@ static int nfs4_open_recover(struct nfs4
 			return -ESTALE;
 	}
 	if (state->n_rdonly != 0) {
+		clear_bit(NFS_O_RDONLY_STATE, &state->flags);
 		ret = nfs4_open_recover_helper(opendata, FMODE_READ, &newstate);
 		if (ret != 0)
 			return ret;
