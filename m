Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab0EMAUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 20:20:45 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:46680 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752780Ab0EMAUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 20:20:44 -0400
Date: Thu, 13 May 2010 10:20:38 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andreas Dilger <andreas.dilger@oracle.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, hch@infradead.org,
       viro@zeniv.linux.org.uk, adilger@Sun.COM, corbet@lwn.net,
       serue@us.ibm.com, neilb@suse.de, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V7 3/9] vfs: Add name to file handle conversion support
Message-ID: <20100513002038.GE13617@dastard>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1273679444-14903-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <E1DE62DE-D9E1-493B-8AEB-91E10D7D35B2@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1DE62DE-D9E1-493B-8AEB-91E10D7D35B2@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 03:49:49PM -0600, Andreas Dilger wrote:
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
> I don't see that this does anything for us except add overhead.
> This is no protection against mounting a second filesystem with
> the same UUID after the handle is returned, since there is no
> expiration for file handles.
> 
> At best I think we could start by changing the list-based UUID
> lookup with a hash-based one, and when adding a duplicate UUID at
> mount time start by printing out an error message to the console
> in case of duplicated UUIDs, and maybe at some point in the future
> this might cause the mount to fail (though I don't think we can
> make that decision lightly or quickly).
>
> That moves the overhead to mount time instead of for each
> name_to_handle() call (which would be brutal for a system with
> many filesystems mounted).

That will pretty much match exactly what XFS already does.  Can we
start by moving the XFS functionality (xfs_uuid_mount(), "nouuid"
mount option, etc) to the VFS level and then optimise from there?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
