Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab1FNG72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 02:59:28 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:39680 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab1FNG71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 02:59:27 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V9fs-developer] [PATCH 3/3] 9p: add 9P2000.L unlinkat operation
In-Reply-To: <BANLkTinevUGj7QYY2aodOWUtObaoUaHydA@mail.gmail.com>
References: <1307383308-5773-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1307383308-5773-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <BANLkTinevUGj7QYY2aodOWUtObaoUaHydA@mail.gmail.com>
User-Agent: Notmuch/0.5-215-g5143e5e (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Tue, 14 Jun 2011 12:29:12 +0530
Message-ID: <87oc20ew5b.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jun 2011 16:12:52 -0500, Eric Van Hensbergen <ericvh@gmail.com> wrote:
> Could be wrong, but a quick regression check of your patches fails
> against a legacy server.  Are you making sure the new operations are
> properly protected by a .L flag?

How about below diff

[3.0-pending@v9fs]$ git diff
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index f40fdc3..436699e 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -499,13 +499,15 @@ v9fs_inode_from_fid(struct v9fs_session_info *v9ses, struct p9_fid *fid,

 static int v9fs_remove(struct inode *dir, struct dentry *dentry, int flags)
 {
-       int retval;
        struct inode *inode;
+       int retval = -EOPNOTSUPP;
        struct p9_fid *v9fid, *dfid;
+       struct v9fs_session_info *v9ses;

        P9_DPRINTK(P9_DEBUG_VFS, "inode: %p dentry: %p rmdir: %x\n",
                   dir, dentry, flags);

+       v9ses = v9fs_inode2v9ses(dir);
        inode = dentry->d_inode;
        dfid = v9fs_fid_lookup(dentry->d_parent);
        if (IS_ERR(dfid)) {
@@ -513,7 +515,8 @@ static int v9fs_remove(struct inode *dir, struct dentry *dentry, int flags)
                P9_DPRINTK(P9_DEBUG_VFS, "fid lookup failed %d\n", retval);
                return retval;
        }
-       retval = p9_client_unlinkat(dfid, dentry->d_name.name, flags);
+       if (v9fs_proto_dotl(v9ses))
+               retval = p9_client_unlinkat(dfid, dentry->d_name.name, flags);
        if (retval == -EOPNOTSUPP) {
                /* Try the one based on path */
                v9fid = v9fs_fid_clone(dentry);


related to renameat i have updated to check for -EOPNOTSUPP instead of
-ENOSYS. I am not sure any other dotl server out there is returning
-ENOSYS. We haven't documented what the server should return in case it
doesn't support any specific operation. 

-aneesh

