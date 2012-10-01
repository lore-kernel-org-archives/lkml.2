Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761Ab2JAXhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:37:06 -0400
Received: from 1wt.eu ([62.212.114.60]:35067 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932577Ab2JAXAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:00 -0400
Message-Id: <20121001225201.204652289@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:22 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jonathan Nieder <jrnieder@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 085/180] NFSv4: Revalidate uid/gid after open
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Nieder <jrnieder@gmail.com>

This is a shorter (and more appropriate for stable kernels) analog to
the following upstream commit:

commit 6926afd1925a54a13684ebe05987868890665e2b
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Sat Jan 7 13:22:46 2012 -0500

    NFSv4: Save the owner/group name string when doing open

    ...so that we can do the uid/gid mapping outside the asynchronous RPC
    context.
    This fixes a bug in the current NFSv4 atomic open code where the client
    isn't able to determine what the true uid/gid fields of the file are,
    (because the asynchronous nature of the OPEN call denies it the ability
    to do an upcall) and so fills them with default values, marking the
    inode as needing revalidation.
    Unfortunately, in some cases, the VFS will do some additional sanity
    checks on the file, and may override the server's decision to allow
    the open because it sees the wrong owner/group fields.

    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

Without this patch, logging into two different machines with home
directories mounted over NFS4 and then running "vim" and typing ":q"
in each reliably produces the following error on the second machine:

	E137: Viminfo file is not writable: /users/system/rtheys/.viminfo

This regression was introduced by 80e52aced138 ("NFSv4: Don't do
idmapper upcalls for asynchronous RPC calls", merged during the 2.6.32
cycle) --- after the OPEN call, .viminfo has the default values for
st_uid and st_gid (0xfffffffe) cached because we do not want to let
rpciod wait for an idmapper upcall to fill them in.

The fix used in mainline is to save the owner and group as strings and
perform the upcall in _nfs4_proc_open outside the rpciod context,
which takes about 600 lines.  For stable, we can do something similar
with a one-liner: make open check for the stale fields and make a
(synchronous) GETATTR call to fill them when needed.

Trond dictated the patch, I typed it in, and Rik tested it.

Addresses http://bugs.debian.org/659111 and
          https://bugzilla.redhat.com/789298

Reported-by: Rik Theys <Rik.Theys@esat.kuleuven.be>
Explained-by: David Flyn <davidf@rd.bbc.co.uk>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Tested-by: Rik Theys <Rik.Theys@esat.kuleuven.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/nfs/nfs4proc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 3c759df..21c7190 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1586,6 +1586,7 @@ static int _nfs4_do_open(struct inode *dir, struct path *path, fmode_t fmode, in
 		goto err_opendata_put;
 	if (server->caps & NFS_CAP_POSIX_LOCK)
 		set_bit(NFS_STATE_POSIX_LOCKS, &state->flags);
+	nfs_revalidate_inode(server, state->inode);
 	nfs4_opendata_put(opendata);
 	nfs4_put_state_owner(sp);
 	*res = state;
-- 
1.7.2.1.45.g54fbc



