Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab0EMF5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 01:57:06 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:44396 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab0EMF5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 01:57:02 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andreas Dilger <andreas.dilger@oracle.com>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@Sun.COM,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de,
       linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V7 3/9] vfs: Add name to file handle conversion support
In-Reply-To: <E1DE62DE-D9E1-493B-8AEB-91E10D7D35B2@oracle.com>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1273679444-14903-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <E1DE62DE-D9E1-493B-8AEB-91E10D7D35B2@oracle.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Thu, 13 May 2010 11:26:53 +0530
Message-ID: <874oic2vkq.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 15:49:49 -0600, Andreas Dilger <andreas.dilger@oracle.com> wrote:
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
> 
> At best I think we could start by changing the list-based UUID lookup
> with a hash-based one, and when adding a duplicate UUID at mount time
> start by printing out an error message to the console in case of
> duplicated UUIDs, and maybe at some point in the future this might
> cause the mount to fail (though I don't think we can make that
> decision lightly or quickly).

I actually was looking at doing this. That is something in line of

register_for_handle_lookup(struct vfsmount *mnt);

Each file system will call this in their gets_sb callback after calling
get_sb_bdev. ie 

static int ext4_get_sb(struct file_system_type *fs_type, int flags,
		       const char *dev_name, void *data, struct vfsmount *mnt)
{
        int retval;
	retval = get_sb_bdev(fs_type, flags, dev_name, data,
		       ext4_fill_super,mnt);

         if (register_for_handle_lookup(mnt)) {
            printk(KERN_INFO, "File system won't be available or handle lookup");
         }
         return retval;              
}


-aneesh
