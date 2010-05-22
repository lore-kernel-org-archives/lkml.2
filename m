Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab0EVJEy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 05:04:54 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:34204 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0EVJEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 05:04:51 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de, hooanon05@yahoo.co.jp,
       linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V11 2/9] vfs: Add name to file handle conversion support
In-Reply-To: <20100521221507.GC13227@fieldses.org>
References: <1274340938-29628-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1274340938-29628-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100521221507.GC13227@fieldses.org>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Sat, 22 May 2010 14:34:43 +0530
Message-ID: <871vd42tp0.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010 18:15:07 -0400, "J. Bruce Fields" <bfields@fieldses.org> wrote:
> On Thu, May 20, 2010 at 01:05:31PM +0530, Aneesh Kumar K.V wrote:
> > This patch add a new superblock field unsigned char s_uuid[16]
> > to store UUID mapping for the file system. The s_uuid[16] is used to
> > identify the file system apart of file_handle
> 
> Sorry, I lost track of the previous argument.  I thought that the
> decision was to return just the file-identifying part of the filehandle
> and let userspace tack on the uuid if that's what it wants?  That seems
> the more flexible approach at least.

Having UUID as a part of a handle enables us to use the handle directly
in the userspace as a file identifier. In most case UUID should work as
a identifier for the file system. What is changed now is even though in
name to handle conversion we add UUID, we don't use UUID to identify the
file system in handle to open path. Rather userspace should map UUID or
what ever unique identifier for the file system it have decided to use
to a mountdir fd and use that to identify the file system in
sys_open_by_handle_at syscall.

UUID is now a part of handle only as a easy way to get the 16 byte
unique handler for the file system. Userspace applications like NFS
server still have to make sure that for the list of exported file system
whether UUID is the correct unique identifier. If yes, they can directly
use the file handle returned from the syscall. If not NFS server will
have to find an alternative to uniquely identify the file system.

So instead of doing

sys_name_to_handle("/tmp/a", handle);
statfs("/tmp/a")
memcpy(handle.f_fsid, statfs.f_fsid);

we can now do 

sys_name_to_handle("/tmp/a, handle);


> 
> > 
> > Acked-by: Serge Hallyn <serue@us.ibm.com>
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  fs/exportfs/expfs.c      |    2 +-
> >  fs/open.c                |  100 ++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/fs.h       |   11 +++++
> >  include/linux/syscalls.h |    3 +
> >  4 files changed, 115 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
> > index cfee0f0..d103c31 100644
> > --- a/fs/exportfs/expfs.c
> > +++ b/fs/exportfs/expfs.c
> > @@ -352,7 +352,7 @@ int exportfs_encode_fh(struct dentry *dentry, struct fid *fid, int *max_len,
> >  	const struct export_operations *nop = dentry->d_sb->s_export_op;
> >  	int error;
> >  
> > -	if (nop->encode_fh)
> > +	if (nop && nop->encode_fh)
> 
> Is there any legitimate reason to call this with nop == NULL?  If not,
> this should be a BUG() if we want to test for the case at all.

For name_to_handle i have added a check to make sure we return
-EOPNOTSUPP. 

       if (!path.mnt->mnt_sb->s_export_op ||
		!path.mnt->mnt_sb->s_export_op->fh_to_dentry) {
		ret = -EOPNOTSUPP;
		goto out_path;
	}

So may be i can drop that nop == NULL check. 

We want to retain the null check in exportfs_decode_fh because
application can call open_by_handle with any mountdirfd that can be for
a file system that doesn't support export operations. 

> 
> Some user documentation for the new interface would be helpful.  (The
> sort of information that would go into the man page eventually, if not
> actually in man page format.)


Will add that in the next iteration.

> 
> >  		error = nop->encode_fh(dentry, fid->raw, max_len, connectable);
> >  	else
> >  		error = export_encode_fh(dentry, fid, max_len, connectable);
> > diff --git a/fs/open.c b/fs/open.c
> > index 74e5cd9..c4c2577 100644
> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -30,6 +30,7 @@
> >  #include <linux/falloc.h>
> >  #include <linux/fs_struct.h>
> >  #include <linux/ima.h>
> > +#include <linux/exportfs.h>
> >  
> >  #include "internal.h"
> >  
> > @@ -1206,3 +1207,102 @@ int nonseekable_open(struct inode *inode, struct file *filp)
> >  }
> >  
> >  EXPORT_SYMBOL(nonseekable_open);
> > +
> > +#ifdef CONFIG_EXPORTFS
> > +/* limit the handle size to some value */
> > +#define MAX_HANDLE_SZ 4096
> > +static long do_sys_name_to_handle(struct path *path,
> > +			struct file_handle __user *ufh)
> > +{
> > +	int retval;
> > +	int handle_size;
> > +	struct super_block *sb;
> > +	struct file_handle f_handle;
> > +	struct file_handle *handle = NULL;
> > +
> > +	if (copy_from_user(&f_handle, ufh, sizeof(struct file_handle))) {
> > +		retval = -EFAULT;
> > +		goto err_out;
> > +	}
> > +	if (f_handle.handle_size > MAX_HANDLE_SZ) {
> > +		retval = -EINVAL;
> > +		goto err_out;
> > +	}
> > +	handle = kmalloc(sizeof(struct file_handle) + f_handle.handle_size,
> > +			GFP_KERNEL);
> > +	if (!handle) {
> > +		retval = -ENOMEM;
> > +		goto err_out;
> > +	}
> > +	handle_size = f_handle.handle_size;
> > +
> > +	/* we ask for a non connected handle */
> > +	retval = exportfs_encode_fh(path->dentry,
> > +				(struct fid *)handle->f_handle,
> > +				&handle_size,  0);
> > +	/* convert handle size to bytes */
> > +	handle_size *= sizeof(u32);
> 
> I'm confused about units:
> 
> 	- the max_len parameter is in 4-byte units.
> 	- So handle_size was also in 4-byte units before the above line.
> 	- So f_handle->handle_size was also in 4-byte units?  Then why
> 	  were we passing it to kmalloc?  And isn't that a confusing
> 	  convention for the length passed in from userspace?

The units passed from userpace should be in bytes. So yes i missed a 

handle_size = f_handle.handle_size >> 2;


> 
> > +	handle->handle_type = retval;
> 
> Don't we need to check for the special case retval == 255?

encode_f returns retval == 255 when we don't have enough space to copy the handle right ?
which should be captured by 

if (handle_size <= f_handle.handle_size) 

Are there any other error condition indicated by retval == 255 ? IIUC
encode_fh have two possible returns

a) retval == 255 if handle_size is small. I updated to put the required
handle_size in max_len. So i am capture this via a handle_size check.
b) Successfully copied the handle 

did i miss any other return ?


Thanks for reviewing the patches

-aneesh
