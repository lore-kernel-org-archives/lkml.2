Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab2KVTb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:31:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756144Ab2KVTbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:31:23 -0500
Subject: Re: [PATCH v4 27/31] gfs2: Convert aio_read/write ops to
 read/write_iter
From: Steven Whitehouse <swhiteho@redhat.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        cluster-devel@redhat.com
In-Reply-To: <1353537671-26284-28-git-send-email-dave.kleikamp@oracle.com>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
	 <1353537671-26284-28-git-send-email-dave.kleikamp@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 22 Nov 2012 09:51:33 +0000
Message-ID: <1353577893.2757.14.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2012-11-21 at 16:41 -0600, Dave Kleikamp wrote:
> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> Cc: Steven Whitehouse <swhiteho@redhat.com>
> Cc: cluster-devel@redhat.com
> ---
>  fs/gfs2/file.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
> index e056b4c..bcea69e 100644
> --- a/fs/gfs2/file.c
> +++ b/fs/gfs2/file.c
> @@ -655,10 +655,9 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
>  }
>  
>  /**
> - * gfs2_file_aio_write - Perform a write to a file
> + * gfs2_file_write_iter - Perform a write to a file
>   * @iocb: The io context
> - * @iov: The data to write
> - * @nr_segs: Number of @iov segments
> + * @iter: The data to write
>   * @pos: The file position
>   *
>   * We have to do a lock/unlock here to refresh the inode size for
> @@ -668,11 +667,11 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
>   *
>   */
>  
> -static ssize_t gfs2_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
> -				   unsigned long nr_segs, loff_t pos)
> +static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *iter,
> +				    loff_t pos)
>  {
>  	struct file *file = iocb->ki_filp;
> -	size_t writesize = iov_length(iov, nr_segs);
> +	size_t writesize = iov_iter_count(iter);
Hmm, I'm not sure that length isn't a better name than count for this
function. What we want is the total length of the i/o request and count
sounds to me as if it would refer to the number of segments. So could we
have a iov_iter_length() function instead perhaps?

Otherwise this looks good from a GFS2 perspective,

Steve.

>  	struct dentry *dentry = file->f_dentry;
>  	struct gfs2_inode *ip = GFS2_I(dentry->d_inode);
>  	int ret;
> @@ -692,7 +691,7 @@ static ssize_t gfs2_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
>  		gfs2_glock_dq_uninit(&gh);
>  	}
>  
> -	return generic_file_aio_write(iocb, iov, nr_segs, pos);
> +	return generic_file_write_iter(iocb, iter, pos);
>  }
>  
>  static int fallocate_chunk(struct inode *inode, loff_t offset, loff_t len,
> @@ -1021,9 +1020,9 @@ static int gfs2_flock(struct file *file, int cmd, struct file_lock *fl)
>  const struct file_operations gfs2_file_fops = {
>  	.llseek		= gfs2_llseek,
>  	.read		= do_sync_read,
> -	.aio_read	= generic_file_aio_read,
> +	.read_iter	= generic_file_read_iter,
>  	.write		= do_sync_write,
> -	.aio_write	= gfs2_file_aio_write,
> +	.write_iter	= gfs2_file_write_iter,
>  	.unlocked_ioctl	= gfs2_ioctl,
>  	.mmap		= gfs2_mmap,
>  	.open		= gfs2_open,
> @@ -1053,9 +1052,9 @@ const struct file_operations gfs2_dir_fops = {
>  const struct file_operations gfs2_file_fops_nolock = {
>  	.llseek		= gfs2_llseek,
>  	.read		= do_sync_read,
> -	.aio_read	= generic_file_aio_read,
> +	.read_iter	= generic_file_read_iter,
>  	.write		= do_sync_write,
> -	.aio_write	= gfs2_file_aio_write,
> +	.write_iter	= gfs2_file_write_iter,
>  	.unlocked_ioctl	= gfs2_ioctl,
>  	.mmap		= gfs2_mmap,
>  	.open		= gfs2_open,


