Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab0I1UbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 16:31:12 -0400
Received: from fieldses.org ([174.143.236.118]:47991 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab0I1UbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 16:31:10 -0400
Date: Tue, 28 Sep 2010 16:30:45 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, miklos@szeredi.hu,
        linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V20 02/12] vfs: Add name to file handle conversion
 support
Message-ID: <20100928203045.GC10548@fieldses.org>
References: <1285702610-32733-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1285702610-32733-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285702610-32733-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 01:06:40AM +0530, Aneesh Kumar K.V wrote:
> @@ -1042,3 +1043,131 @@ int nonseekable_open(struct inode *inode, struct file *filp)
>  }
>  
>  EXPORT_SYMBOL(nonseekable_open);
> +
> +#ifdef CONFIG_EXPORTFS
> +static long do_sys_name_to_handle(struct path *path,
> +				  struct file_handle __user *ufh,
> +				  int __user *mnt_id)
> +{
> +	long retval;
> +	int handle_size;
> +	struct file_handle f_handle;
> +	struct file_handle *handle = NULL;
> +
> +	if (copy_from_user(&f_handle, ufh, sizeof(struct file_handle))) {
> +		retval = -EFAULT;
> +		goto err_out;
> +	}
> +	if (f_handle.handle_size > MAX_HANDLE_SZ) {

Couldn't handle_size also be negative?:

> +struct file_handle {
> +	int handle_size;

Say the user passes in -1.

> +		retval = -EINVAL;
> +		goto err_out;
> +	}
> +	handle = kmalloc(sizeof(struct file_handle) + f_handle.handle_size,
> +			 GFP_KERNEL);

This succeeds, but allocates too little memory.

> +	if (!handle) {
> +		retval = -ENOMEM;
> +		goto err_out;
> +	}
> +
> +	/* convert handle size to  multiple of sizeof(u32) */
> +	handle_size = f_handle.handle_size >> 2;

Now handle_size is a large positive number.

> +
> +	/* we ask for a non connected handle */
> +	retval = exportfs_encode_fh(path->dentry,
> +				    (struct fid *)handle->f_handle,
> +				    &handle_size,  0);

So this succeeds, and writes past the end of the allocated handle.

As long as the interface is privileged hopefully this would be hard to
abuse.  But how about just defining handle.handle_size and handle_size
as unsigned?

The u32/bytes thing seems an easy source of mistakes.  Would it be
possible to use "bytes" or "words" everywhere in place of "size" or
"SZ"?  And, where possible, store only one or other other in a given
variable.  (So do stuff like:

	handle_words = f_handle_size >> 2;
	retval = exportfs_encode_fh(.,., &handle_words,.);
	handle->handle_type = retval;
	handle->handle_bytes = handle_words << 2;
	if (handle->handle_bytes > f_handle.handle_bytes) {
		...
)

By the way, apologies, I can't remember from last time: did you decide
that overflow was really the only case when 255 would be returned from
exportfs_encode_fs()?

--b.
> +	/* convert handle size to bytes */
> +	handle_size *= sizeof(u32);
> +	handle->handle_type = retval;
> +	handle->handle_size = handle_size;
> +	if (handle_size > f_handle.handle_size) {
> +		/*
> +		 * set the handle_size to zero so we copy only
> +		 * non variable part of the file_handle
> +		 */
> +		handle_size = 0;
> +		retval = -EOVERFLOW;
> +	} else
> +		retval = 0;
> +	/* copy the mount id */
> +	if (copy_to_user(mnt_id, &path->mnt->mnt_id, sizeof(*mnt_id))) {
> +		retval = -EFAULT;
> +		goto err_free_out;
> +	}
> +	if (copy_to_user(ufh, handle,
> +			 sizeof(struct file_handle) + handle_size))
> +		retval = -EFAULT;
> +err_free_out:
> +	kfree(handle);
> +err_out:
> +	return retval;
> +}
