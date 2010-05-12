Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab0ELWn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 18:43:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:56643 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab0ELWnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 18:43:25 -0400
Date: Thu, 13 May 2010 08:43:10 +1000
From: Neil Brown <neilb@suse.de>
To: Andreas Dilger <andreas.dilger@oracle.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, hch@infradead.org,
       viro@zeniv.linux.org.uk, adilger@Sun.COM, corbet@lwn.net,
       serue@us.ibm.com, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V7 3/9] vfs: Add name to file handle conversion support
Message-ID: <20100513084310.5212728b@notabene.brown>
In-Reply-To: <E1DE62DE-D9E1-493B-8AEB-91E10D7D35B2@oracle.com>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1273679444-14903-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<E1DE62DE-D9E1-493B-8AEB-91E10D7D35B2@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 15:49:49 -0600
Andreas Dilger <andreas.dilger@oracle.com> wrote:

> On 2010-05-12, at 09:50, Aneesh Kumar K.V wrote:
> > +static long do_sys_name_to_handle(struct path *path,
> > +			struct file_handle __user *ufh)
> > +{
> > +	if (handle_size <= f_handle.handle_size) {
> > +		/* get the uuid */
> > +		retval = sb->s_op->get_fsid(sb, &this_fs_id);
> > +		if (!retval) {
> > +			/*
> > +			 * Now verify whether we get the same vfsmount
> > +			 * if we lookup with uuid. In case we end up having
> > +			 * same uuid for the multiple file systems. When doing
> > +			 * uuid based lookup we would return the first one.So
> > +			 * with name_to_handle if we don't find the same
> > +			 * vfsmount with lookup return EOPNOTSUPP
> > +			 */
> > +			mnt = fs_get_vfsmount(current, &this_fs_id);
> > +			if (mnt != path->mnt) {
> > +				retval = -EOPNOTSUPP;
> > +				mntput(mnt);
> > +				goto err_free_out;
> > +			}
> 
> I don't see that this does anything for us except add overhead.  This is no protection against mounting a second filesystem with the same UUID after the handle is returned, since there is no expiration for file handles.

I very much agree.
Further I have not yet seen a convincing argument that the UUID should be
part of the kernel interface for filehandle lookup.  That fact that including
the UUID suggests to you (Aneesh) that this sort of thing might be a good
idea seems to me to be a strong argument against including the UUID in the
lookup.

> 
> At best I think we could start by changing the list-based UUID lookup with a hash-based one, and when adding a duplicate UUID at mount time start by printing out an error message to the console in case of duplicated UUIDs, and maybe at some point in the future this might cause the mount to fail (though I don't think we can make that decision lightly or quickly).
> 
> That moves the overhead to mount time instead of for each name_to_handle() call (which would be brutal for a system with many filesystems mounted).
> 
> > +SYSCALL_DEFINE4(name_to_handle_at, int, dfd, const char __user *, name,
> > +		struct file_handle __user *, handle, int, flag)
> > +{
> > +	int follow;
> > +	long ret = -EINVAL;
> > +	struct path path;
> > +
> > +	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
> > +		goto err_out;
> 
> Won't this break the use of AT_FDCWD to get a relative file handle?

No, AT_FDCWD is a value passed in 'dfd', not a flag.

I wonder though if the default should be to not follow symlinks, and that
AT_SYMLINK_FOLLOW should be required if you really want to follow symlinks.
I suspect that in most cases you wouldn't want to follow symlinks.
It isn't a really important point though.

NeilBrown



> 
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Lustre Technical Lead
> Oracle Corporation Canada Inc.

