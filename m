Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab0ESJ04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:26:56 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:48185 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab0ESJ0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:26:54 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Dave Chinner <david@fromorbit.com>, hch@infradead.org,
       viro@zeniv.linux.org.uk, adilger@sun.com, corbet@lwn.net,
       serue@us.ibm.com, neilb@suse.de, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V8 2/9] vfs: Add name to file handle conversion support
In-Reply-To: <87d3wsl1dl.fsf@linux.vnet.ibm.com>
References: <1274074432-29695-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1274074432-29695-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <7252.1274150030@jrobl> <87fx1ppy21.fsf@linux.vnet.ibm.com> <20100518064336.GE2150@dastard> <877hn1pl97.fsf@linux.vnet.ibm.com> <9972.1274253351@jrobl> <87d3wsl1dl.fsf@linux.vnet.ibm.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Wed, 19 May 2010 14:56:37 +0530
Message-ID: <87aarwkzsi.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010 14:22:22 +0530, "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Wed, 19 May 2010 16:15:51 +0900, "J. R. Okajima" <hooanon05@yahoo.co.jp> wrote:
> > 
> > "Aneesh Kumar K. V":
> > > Now that we are not doing UUID based vfsmount lookup this make
> > > sense. Will update in the next iteration with UUID to be part of
> > > super_block.
> > 
> > Because this UUID is just for some FS's userspace helpers (in other
> > words, returning UUID is FS specific behaviour), I am afraid it is not a
> > good ideat to put the array into generic super_block.
> 
> UUID should be looked at as the file system identifier and IMHO struct
> super_block is the right place to hold it. For ex: ext*  put then in
> ext*_super_block. File system that doesn't support UUID can leave the
> superblock field zero filled.
> 
> 
> > 
> > About the design or approach, this might have been discussed earlier,
> > but I'd like to suggest to clarify some points here.
> > - While these new systemcalls provide generic features, the
> >   implementation depends upon s_export_op, ie. NFS-exporting.
> >   It means there are two requirements for these systemcalls, enabling
> >   CONFIG_EXPORTFS and FS has to set s_export_op.
> >   Is this acceptable?
> 
> 
> I think exportfs is the right interface we want to depend on for
> generating a handle. We should not be having another parallel interface for file
> handle generation. But agreed that we should return -EOPNOTSUPP in case
> EXPORTFS is disabled.
> 
> 
> > 
> > - exportfs_encode_fh() supports the default encoding
> >   export_encode_fh(), but exportfs_decode_fh() doesn't.
> >   The latest patch series modifes exportfs_decode_fh() to return ESTALE,
> >   but I'd suggest to make the caller of export_encode_fh() to check
> >   s_export_op->fh_to_dentry() and return ENOSYS.
> 
> I will fix to make the syscall return EOPNOTSUPP in case fh_to_dentry is
> not supported. But i guess we still need to keep the change in
> exportfs_decode_fh to return -ESTALE in case these operations are not definied.
> 
> 
> 
> >   Or implement the default decode routine as a contrast of
> >   export_encode_fh().
> > 
> > - Some FS (or its userspace helper) may want to put UUID into the
> >   handle. If those FS already have UUID in their fs private_data, then
> >   putting a pointer (instead of an array) is better.
> >   Or creating two new operations in s_op to encode/decode handle
> >   may be good too (regardless CONFIG_EXPORTFS). The generic
> >   implementations should be provided, and when these function pointers
> >   in s_op are not set, they should be called as default. These generic
> >   implementaions will be able to be used by expfs.c too. And UUID in
> >   super_block will be unnecessary.
> 
> 
> IMHO that would be over design. We can depend on exportfs
> interfaces and if not defined return EOPNOTSUPP.
> 

How about the below patch ?

commit 5f421ffbe9dd7bb84c5992b1725c06b511bc76d8
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Wed May 19 14:52:44 2010 +0530

    vfs: Return ENOSYS if CONFIG_EXPORTFS is not enabled
    
    Both the syscalls need exportfs support enabled. So if CONFIG_EXPORTFS
    is not enabled return ENOSYS. While converting name to handle check
    whether the filesystem support handle decode. If not return EOPNOTSUPP.
    We don't do a similar check in open by handle because exportfs_decode_fh
    will return ESTALE if file system doesn't support fh_to_dentry callback.
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/open.c b/fs/open.c
index 14e6d3c..b5fc067 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1274,6 +1274,9 @@ SYSCALL_DEFINE4(name_to_handle_at, int, dfd, const char __user *, name,
 	long ret = -EINVAL;
 	struct path path;
 
+#ifndef CONFIG_EXPORTFS
+	return -ENOSYS;
+#endif
 	if ((flag & ~AT_SYMLINK_FOLLOW) != 0)
 		goto err_out;
 
@@ -1281,6 +1284,14 @@ SYSCALL_DEFINE4(name_to_handle_at, int, dfd, const char __user *, name,
 	ret = user_path_at(dfd, name, follow, &path);
 	if (ret)
 		goto err_out;
+	/*
+	 * We need t make sure wether the file system
+	 * support decoding of the file handle
+	 */
+	if (!path.mnt->mnt_sb->s_export_op ||
+		!path.mnt->mnt_sb->s_export_op->fh_to_dentry)
+		return -EOPNOTSUPP;
+
 	ret = do_sys_name_to_handle(&path, handle);
 	path_put(&path);
 err_out:
@@ -1450,6 +1461,9 @@ SYSCALL_DEFINE3(open_by_handle, int, mountdirfd,
 {
 	long ret;
 
+#ifndef CONFIG_EXPORTFS
+	return -ENOSYS;
+#endif
 	if (force_o_largefile())
 		flags |= O_LARGEFILE;
 
