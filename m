Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab0LHBqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:46:33 -0500
Received: from kroah.org ([198.145.64.141]:48728 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932136Ab0LHBAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:11 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:29 2010
Message-Id: <20101208005729.229892376@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [079/289] NFSv4: Fix open recovery
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 fs/nfs/nfs4proc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1117,6 +1117,7 @@ static int nfs4_open_recover(struct nfs4
 	clear_bit(NFS_DELEGATED_STATE, &state->flags);
 	smp_rmb();
 	if (state->n_rdwr != 0) {
+		clear_bit(NFS_O_RDWR_STATE, &state->flags);
 		ret = nfs4_open_recover_helper(opendata, FMODE_READ|FMODE_WRITE, &newstate);
 		if (ret != 0)
 			return ret;
@@ -1124,6 +1125,7 @@ static int nfs4_open_recover(struct nfs4
 			return -ESTALE;
 	}
 	if (state->n_wronly != 0) {
+		clear_bit(NFS_O_WRONLY_STATE, &state->flags);
 		ret = nfs4_open_recover_helper(opendata, FMODE_WRITE, &newstate);
 		if (ret != 0)
 			return ret;
@@ -1131,6 +1133,7 @@ static int nfs4_open_recover(struct nfs4
 			return -ESTALE;
 	}
 	if (state->n_rdonly != 0) {
+		clear_bit(NFS_O_RDONLY_STATE, &state->flags);
 		ret = nfs4_open_recover_helper(opendata, FMODE_READ, &newstate);
 		if (ret != 0)
 			return ret;


