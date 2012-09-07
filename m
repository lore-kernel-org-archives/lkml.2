Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab2IGGfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:35:39 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34788 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2IGGfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:35:37 -0400
MIME-Version: 1.0
X-Originating-IP: [94.21.92.250]
In-Reply-To: <1346946994-21286-1-git-send-email-apw@canonical.com>
References: <1346946994-21286-1-git-send-email-apw@canonical.com>
Date: Fri, 7 Sep 2012 08:35:36 +0200
Message-ID: <CAJfpegsCQKX==v-8NqO5tLDsEed7KhBFWpoeWLDjxT1vuMSokg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] issues with NFS filesystems as lower layer
From: Miklos Szeredi <miklos@szeredi.hu>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 6, 2012 at 5:56 PM, Andy Whitcroft <apw@canonical.com> wrote:
> During some testing here we discovered that we could not successfully
> use a NFS as the lower layer for overlayfs.  There are two separate issues:
>
> Firstly when using an NFSv4 lower layer we tickle an issue when copying
> up the xattrs for the underlying file.  NFS uses an xattr system.nfs4_acl
> which the upper layer will not store (ext4 for example).  This triggers
> an EOPNOTSUPP error when trying to copy up the xattrs for the file,
> preventing the file being written.  I am a little unclear as to whether it
> makes sense to generally ignore xattrs we cannot store in the upper layer,
> this is based on the assumption the person creating the mount knew what
> they were combining.  The first patch (for discussion) following this
> email avoids this issue by ignoring the xattr if it is not storable.

I don't know much about NFSv4 ACL's but I think it may be incompatible
with POSIX ACLs in which case copying them up is not possible and
ignoring them should be the right thing to do.

>
> Secondly when using an NFSv3 R/O lower layer the filesystem permissions
> check refuses permission to write to the inode which prevents us from
> copying it up even though we have a writable upper layer.  (With an ext4
> lower layer the inode check will succeed if the inode  is writable even
> if the filesystem is not.)  It is not clear what the right solution is
> here.  One approach is to check the inode permissions only (avoiding the
> filesystem specific permissions op), but it is not clear we can rely on
> these for all underlying filesystems.  Perhaps this check should only be
> used for NFS.  Perhaps it needs to be a mount option.  The second patch
> (for discussion) following this email implements this, using the inode
> permissions when the lowerlayer is read-only.  This seems to work as
> expected in my limited testing.

I fear that will create an inconsistency between the read-only and the
non-read-only case, even though both should behave the same.

I think the cleanest would be to create a mount option to always use
generic_permission (on both the lower and the upper fs).  That would
give us two, slightly different, operating modes but each would be
self consistent.

Thanks,
Miklos
