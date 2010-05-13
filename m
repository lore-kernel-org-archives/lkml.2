Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab0EMHbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:31:43 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:58788 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755377Ab0EMHbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:31:41 -0400
Date: Thu, 13 May 2010 17:31:36 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andreas Dilger <andreas.dilger@oracle.com>, hch@infradead.org,
       viro@zeniv.linux.org.uk, adilger@Sun.COM, corbet@lwn.net,
       serue@us.ibm.com, neilb@suse.de, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V7 3/9] vfs: Add name to file handle conversion support
Message-ID: <20100513073136.GH13617@dastard>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1273679444-14903-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <E1DE62DE-D9E1-493B-8AEB-91E10D7D35B2@oracle.com>
 <20100513002038.GE13617@dastard>
 <87y6fo1fru.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y6fo1fru.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 11:53:33AM +0530, Aneesh Kumar K. V wrote:
> On Thu, 13 May 2010 10:20:38 +1000, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, May 12, 2010 at 03:49:49PM -0600, Andreas Dilger wrote:
> > > On 2010-05-12, at 09:50, Aneesh Kumar K.V wrote:
> > > > +static long do_sys_name_to_handle(struct path *path,
> > > > +			struct file_handle __user *ufh)
> > > > +{
> > > > +	if (handle_size <= f_handle.handle_size) {
> > > > +		/* get the uuid */
> > > > +		retval = sb->s_op->get_fsid(sb, &this_fs_id);
> > > > +		if (!retval) {
> > > > +			/*
> > > > +			 * Now verify whether we get the same vfsmount
> > > > +			 * if we lookup with uuid. In case we end up having
> > > > +			 * same uuid for the multiple file systems. When doing
> > > > +			 * uuid based lookup we would return the first one.So
> > > > +			 * with name_to_handle if we don't find the same
> > > > +			 * vfsmount with lookup return EOPNOTSUPP
> > > > +			 */
> > > > +			mnt = fs_get_vfsmount(current, &this_fs_id);
> > > > +			if (mnt != path->mnt) {
> > > > +				retval = -EOPNOTSUPP;
> > > > +				mntput(mnt);
> > > > +				goto err_free_out;
> > > > +			}
> > > 
> > > I don't see that this does anything for us except add overhead.
> > > This is no protection against mounting a second filesystem with
> > > the same UUID after the handle is returned, since there is no
> > > expiration for file handles.
> > > 
> > > At best I think we could start by changing the list-based UUID
> > > lookup with a hash-based one, and when adding a duplicate UUID at
> > > mount time start by printing out an error message to the console
> > > in case of duplicated UUIDs, and maybe at some point in the future
> > > this might cause the mount to fail (though I don't think we can
> > > make that decision lightly or quickly).
> > >
> > > That moves the overhead to mount time instead of for each
> > > name_to_handle() call (which would be brutal for a system with
> > > many filesystems mounted).
> > 
> > That will pretty much match exactly what XFS already does.  Can we
> > start by moving the XFS functionality (xfs_uuid_mount(), "nouuid"
> > mount option, etc) to the VFS level and then optimise from there?
> > 
> 
> I will do this. But should the uuid be unique in a system wide manner or
> should it be unique for a mount namespace ? With containers isn't it
> valid for the second container to mount a file system with same uuid of
> a file system in the first container, but uuid itself is unique in the
> second container ?

I don't know how containers and mount namespaces interact, so I
can't really comment with any authority. However, two different
filesystems with the same UUID means that someone or something
doesn't understand what unique means and that, I think, makes the
container issue moot.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
