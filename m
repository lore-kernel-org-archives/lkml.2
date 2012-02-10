Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291Ab2BJWu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:50:29 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51143 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933278Ab2BJWu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:50:26 -0500
MIME-Version: 1.0
Message-Id: <20120210224851.424806592@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:47:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sachin Prabhu <sprabhu@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [07/21] NFSv4: Fix open recovery
In-Reply-To: <20120210224858.GA30752@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit b0ed9dbc24f1fd912b2dd08b995153cafc1d5b1c upstream.

NFSv4 open recovery is currently broken: since we do not clear the
state->flags states before attempting recovery, we end up with the
'can_open_cached()' function triggering. This again leads to no OPEN call
being put on the wire.

Reported-by: Sachin Prabhu <sprabhu@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1067,6 +1067,7 @@ static int nfs4_open_recover(struct nfs4
 	clear_bit(NFS_DELEGATED_STATE, &state->flags);
 	smp_rmb();
 	if (state->n_rdwr != 0) {
+		clear_bit(NFS_O_RDWR_STATE, &state->flags);
 		ret = nfs4_open_recover_helper(opendata, FMODE_READ|FMODE_WRITE, &newstate);
 		if (ret != 0)
 			return ret;
@@ -1074,6 +1075,7 @@ static int nfs4_open_recover(struct nfs4
 			return -ESTALE;
 	}
 	if (state->n_wronly != 0) {
+		clear_bit(NFS_O_WRONLY_STATE, &state->flags);
 		ret = nfs4_open_recover_helper(opendata, FMODE_WRITE, &newstate);
 		if (ret != 0)
 			return ret;
@@ -1081,6 +1083,7 @@ static int nfs4_open_recover(struct nfs4
 			return -ESTALE;
 	}
 	if (state->n_rdonly != 0) {
+		clear_bit(NFS_O_RDONLY_STATE, &state->flags);
 		ret = nfs4_open_recover_helper(opendata, FMODE_READ, &newstate);
 		if (ret != 0)
 			return ret;


