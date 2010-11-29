Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab0K2UXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 15:23:37 -0500
Received: from fieldses.org ([174.143.236.118]:40877 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab0K2UXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 15:23:34 -0500
Date: Mon, 29 Nov 2010 15:23:29 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Dave Quigley <dpquigl@davequigley.com>
Cc: David Quigley <merlin@countercultured.net>, Eric Paris <eparis@redhat.com>,
        Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>, Steve French <sfrench@samba.org>
Subject: Re: [PATCH] fs: call security_d_instantiate in d_obtain_alias
Message-ID: <20101129202329.GC9897@fieldses.org>
References: <1290016263-1637-1-git-send-email-josef@redhat.com>
 <20101117191817.GA26575@fieldses.org>
 <20101117192822.GB3818@localhost.localdomain>
 <20101117202617.GA31009@fieldses.org>
 <1290031941.14282.101.camel@localhost.localdomain>
 <4CE60AE9.2070101@countercultured.net>
 <20101119164236.GA29148@fieldses.org>
 <4CE7F97E.4040305@davequigley.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE7F97E.4040305@davequigley.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 11:38:22AM -0500, Dave Quigley wrote:
> On 11/19/2010 11:42 AM, J. Bruce Fields wrote:
> >On Fri, Nov 19, 2010 at 12:28:09AM -0500, David Quigley wrote:
> >>[snip]
> >>>If you have persistent xattr support we need the dentry since the xattr
> >>>code requires a dentry.  I have no idea why but that's what
> >>>inode->i_op->getxattr() requires.
> >>>
> >>The original reason that the xattr operations take dentries is
> >>because of p9fs and CIFS. CIFS uses the name of the file to grab the
> >>extended attributes and so does p9fs. I had tried to remove this a
> >>while ago but couldn't find a way around that.
> >Both CIFS and FUSE are NFS-exportable, so both allow lookup by
> >filehandle, so neither can count on getting a filename at this point.
> >
> >So, out of curiosity, do we know what will happen when selinux asks one
> >of them for an xattr on a DCACHE_DISCONNECTED dentry?
> >
> 
> SELinux uses several methods to determine file labeling. In the
> policy filesystems such as xfs and the ext* series of filesystems
> are marked as fs_use_xattr. In this process the file label is pulled
> from the security.selinux xattr on disk. However CIFS and FUSE (and
> NFS but our Labeled NFS changes are trying to fix this) all have the
> filesystem marked as genfs.

OK, fair enough.  It seems a little fragile to me, but it sounds like
that works....

> When mounting the filesystem the fs_type
> is looked at to determine its labeling type. Since its genfs we
> lookup what label was determined to be the default for that
> filesystem type. In NFS's current state all NFS mounts regardless of
> version get the uniform label of nfs_t for everything listed on an
> nfs mount point. We have a similar situation for cifs and fuse. So
> in this case SELinux should not be asking for the security.selinux
> xattr from these file systems. However if a getxattr call to the
> security.selinux xattr is made on these filesystems it will still
> work I might be wrong but my understanding is just the a dentry in
> the DCACHE_DISCONNECTED state is not negative but just isn't in the
> tree anymore.

More  like "yet" than "anymore"; we've looked up the inode by inode
number (or something similar), not by name, so the dentry in this case
ends up having a name "" and parent itself (like a root dentry).

--b.

> So looking at vfs_getxattr I had made some
> modifications a while back to it. Assuming we have permissions to
> access the file determined by xattr_permission and
> security_inode_getxattr we check to see if it is in the security
> namespace.  If it is in the security namespace we call
> xattr_getsecurity which will attempt to get the security label from
> the inode first (security_inode_getsecurity). Because the convention
> is to call d_instantiate on inode create this should always work
> assuming an LSM is loaded. If it fails and we don't have an lsm
> loaded we fall back to checking the getxattr i_op and if that
> doesn't exist we fail with EOPNOTSUPP. That is what should happen on
> the getxattr call. I don't know if something is happening higher up
> that makes it so we never get to vfs_getxattr in the event that the
> dentry is in the DCACHE_DISCONNECTED state. If the DENTRY is
> disconnected though I'm not sure how getxattr from userspace would
> be able to have access to it except through a different name in the
> namespace.
> 
> >>When trying to find a
> >>solution I also got push back from Miklos (FUSE) as he views a
> >>filesystem being able to make xattr decisions based on the path name
> >>being a valid use-case.
> >So selinux may initialize an inode differently depending on which
> >pathname it happened to be looked up under first?
> >
> >Factoring the name into the xattr return sounds scary to me.
> >
> 
> The only current use of determining file label from path name is the
> situation that Eric Paris described with proc. I personally don't
> agree with miklos that the path to the xattr should make it return
> different information (unless im understanding him wrong). However
> the same thing is at work for CIFS as it exposes the windows
> alternate file streams which are accessed by adding the stream name
> to the end of the filename with a separator which I can't remember
> at the moment. If it was the situation that two fuse files shared
> the same inode and the security.selinux xattr was filled differently
> if it was accessed via /fuse/foo and /fuse/bar then yes the
> situation you described might happen. Normally this isn't a problem
> because file systems don't take the path into account so a hardlink
> to the same inode will still obtain the same security label. In
> reality the xattr is a piece of inode metadata and not a piece of
> dentry metadata.
> 
> >--b.
> >
> 
