Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab2HPMrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 08:47:09 -0400
Received: from fieldses.org ([174.143.236.118]:35057 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972Ab2HPMrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 08:47:07 -0400
Date: Thu, 16 Aug 2012 08:47:03 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
Message-ID: <20120816124703.GE28054@fieldses.org>
References: <20120815092116.700948346@openvz.org>
 <20120815092409.591460800@openvz.org>
 <20120815204546.GC25062@fieldses.org>
 <20120815210237.GF25421@moon>
 <20120815220622.GA28054@fieldses.org>
 <20120816062448.GA32081@moon>
 <20120816123814.GD1209@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816123814.GD1209@moon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 04:38:14PM +0400, Cyrill Gorcunov wrote:
> On Thu, Aug 16, 2012 at 10:24:48AM +0400, Cyrill Gorcunov wrote:
> > > > > On the other hand, if you want a real filehandle then wouldn't you want
> > > > > to e.g. call the filesystem's ->encode_fh() if necessary, as
> > > > > exportfs_encode_fh() does?
> > > > 
> > > > Well, one of the problem I hit when I've been trying to use encode_fh
> > > > is that every new implementation of encode_fh will require some size
> > > > (even unknown) in buffer where encoded data pushed. Correct me please
> > > > if I'm wrong. But with export_encode_inode_fh there is a small buffer
> > > > with pretty known size needed on stack needed for printing data in
> > > > fdinfo.
> > > 
> > > You can just give encode_fh a too-small data and let it fail if it's not
> > > big enough.
> > > 
> > > (In practice I think everyone supports NFSv3 filehandles which have a
> > > maximum size of 64 bytes.)
> > 
> > I'll think about it, thanks!
> 
> Hi Bruce, thinking a bit more I guess using general encode_fh is not that
> convenient since it operates with dentries while our fdinfo output deals
> with inodes. Thus I should either provide some new encode_fh variant
> which would deal with inodes directly without "parents".

I can't see why that wouldn't work.

> Which doesn't
> look for me anyhow better than the new export_encode_inode_fh helper.

That isn't going to work for filesystems that define their own
encode_fh:

	$ git grep '\.encode_fh'
	fs/btrfs/export.c:      .encode_fh      = btrfs_encode_fh,
	fs/ceph/export.c:       .encode_fh = ceph_encode_fh,
	fs/fat/inode.c: .encode_fh      = fat_encode_fh,
	fs/fuse/inode.c:        .encode_fh      = fuse_encode_fh,
	fs/gfs2/export.c:       .encode_fh = gfs2_encode_fh,
	fs/isofs/export.c:      .encode_fh      = isofs_export_encode_fh,
	fs/nilfs2/namei.c:      .encode_fh = nilfs_encode_fh,
	fs/ocfs2/export.c:      .encode_fh      = ocfs2_encode_fh,
	fs/reiserfs/super.c:    .encode_fh = reiserfs_encode_fh,
	fs/udf/namei.c: .encode_fh      = udf_encode_fh,
	fs/xfs/xfs_export.c:    .encode_fh              = xfs_fs_encode_fh,
	mm/shmem.c:     .encode_fh      = shmem_encode_fh,

--b.

> After all, if the use of encode_fh become a mandatory rule we can easily
> extend fsnotify fdinfo output to support new scheme without breaking
> user space, because output looks like
> 
>  | fhandle-type:        1 f_handle: 49b1060023552153
> 
> (ie if something is changed than these fields will be simply updated).
> 
> Or maybe I miss something?
> 
> 	Cyrill
