Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab2IAUEA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 16:04:00 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:45074 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab2IAUD6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 16:03:58 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH 19/21] ntfs: drop vmtruncate
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1486\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <anton@tuxera.com>
In-Reply-To: <5040C411.8080207@gmail.com>
Date: Sat, 1 Sep 2012 21:04:00 +0100
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <9A07B441-2157-4A3C-9C74-6120E5447026@tuxera.com>
References: <5040C411.8080207@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
X-Mailer: Apple Mail (2.1486)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looks good though if you call ntfs_truncate() rather than ntfs_truncate_vfs() you can use it to return an error code in the case that ntfs_truncate() fails.  That could be done as a separate patch of course.

You can add my Reviewed-by: or Signed-off-by: to this patch.

Best regards,

	Anton

On 31 Aug 2012, at 15:02, Marco Stornelli <marco.stornelli@gmail.com> wrote:

> Removed vmtruncate.
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
> fs/ntfs/file.c  |    8 +++++---
> fs/ntfs/inode.c |   11 +++++++++--
> fs/ntfs/inode.h |    4 ++++
> 3 files changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
> index 1ecf464..5332e90 100644
> --- a/fs/ntfs/file.c
> +++ b/fs/ntfs/file.c
> @@ -2022,8 +2022,11 @@ static ssize_t ntfs_file_buffered_write(struct kiocb *iocb,
> 				 * allocated space, which is not a disaster.
> 				 */
> 				i_size = i_size_read(vi);
> -				if (pos + bytes > i_size)
> -					vmtruncate(vi, i_size);
> +				if ((pos + bytes > i_size) &&
> +					inode_newsize_ok(vi, i_size) == 0) {
> +					truncate_setsize(vi, i_size);
> +					ntfs_truncate_vfs(vi);
> +				}
> 				break;
> 			}
> 		}
> @@ -2227,7 +2230,6 @@ const struct file_operations ntfs_file_ops = {
> 
> const struct inode_operations ntfs_file_inode_ops = {
> #ifdef NTFS_RW
> -	.truncate	= ntfs_truncate_vfs,
> 	.setattr	= ntfs_setattr,
> #endif /* NTFS_RW */
> };
> diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
> index c6dbd3d..fe05a92 100644
> --- a/fs/ntfs/inode.c
> +++ b/fs/ntfs/inode.c
> @@ -2865,9 +2865,11 @@ conv_err_out:
>  *
>  * See ntfs_truncate() description above for details.
>  */
> +#ifdef NTFS_RW
> void ntfs_truncate_vfs(struct inode *vi) {
> 	ntfs_truncate(vi);
> }
> +#endif
> 
> /**
>  * ntfs_setattr - called from notify_change() when an attribute is being changed
> @@ -2913,8 +2915,13 @@ int ntfs_setattr(struct dentry *dentry, struct iattr *attr)
> 						NInoCompressed(ni) ?
> 						"compressed" : "encrypted");
> 				err = -EOPNOTSUPP;
> -			} else
> -				err = vmtruncate(vi, attr->ia_size);
> +			} else {
> +				err = inode_newsize_ok(vi, attr->ia_size);
> +				if (!err) {
> +					truncate_setsize(vi, attr->ia_size);
> +					ntfs_truncate_vfs(vi);
> +				}
> +			}
> 			if (err || ia_valid == ATTR_SIZE)
> 				goto out;
> 		} else {
> diff --git a/fs/ntfs/inode.h b/fs/ntfs/inode.h
> index db29695..76b6cfb 100644
> --- a/fs/ntfs/inode.h
> +++ b/fs/ntfs/inode.h
> @@ -316,6 +316,10 @@ static inline void ntfs_commit_inode(struct inode *vi)
> 	return;
> }
> 
> +#else
> +
> +static inline void ntfs_truncate_vfs(struct inode *vi) {}
> +
> #endif /* NTFS_RW */
> 
> #endif /* _LINUX_NTFS_INODE_H */
> -- 
> 1.7.3.4

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

