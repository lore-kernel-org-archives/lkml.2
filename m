Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946455Ab2ERXEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:04:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53122 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946441Ab2ERXEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:04:41 -0400
Message-Id: <20120518211603.202576643@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Rik Theys <Rik.Theys@esat.kuleuven.be>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 41/54] NFSv4: Revalidate uid/gid after open
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 fs/nfs/nfs4proc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1771,6 +1771,7 @@ static int _nfs4_do_open(struct inode *d
 			nfs_setattr_update_inode(state->inode, sattr);
 		nfs_post_op_update_inode(state->inode, opendata->o_res.f_attr);
 	}
+	nfs_revalidate_inode(server, state->inode);
 	nfs4_opendata_put(opendata);
 	nfs4_put_state_owner(sp);
 	*res = state;


