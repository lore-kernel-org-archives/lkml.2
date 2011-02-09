Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab1BILxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 06:53:46 -0500
Received: from bar.sig21.net ([80.81.252.164]:47269 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab1BILxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 06:53:45 -0500
Date: Wed, 9 Feb 2011 12:53:37 +0100
From: Johannes Stezenbach <js@sig21.net>
To: anders franzen <anders.franzen@yahoo.se>
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -v3] Only honor the FIGETBSZ ioctl for regular files
 and directories
Message-ID: <20110209115336.GA4345@sig21.net>
References: <4D524CBE.2020300@yahoo.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D524CBE.2020300@yahoo.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.7 (---)
X-Spam-21-Report: No, score=-3.7 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.663,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(restore Cc:s)

On Wed, Feb 09, 2011 at 09:13:50AM +0100, anders franzen wrote:
> 
> Vad happened with the patch below. It was ''signed off'' more than
> half a year ago, and it is not in any of the latest kernel yet.
> 
> I ask, because I spend a week debugging the 'dvbloopback' driver,
> which uses '2' as a private ioctl for a read command. Not easy to
> find.
> 
> Can a driver not have private ioctls?
> Should this be fixed in the driver?, I have now RESERVED the value 2
> in the driver. But this does not
> guarantee that someone invents FIGETBSZ_V2 and assigned the value 3 to it.
> 
> Regards
>   /Anders
> 
> 
> 
> 
> FIGETBSZ has an ioctl number of _IO(0x00,2) == 2, which can conflict
> with device driver ioctls. Let's avoid the potential for problems by
> only honoring the ioctl number for files where this ioctl is likely
> going to be useful: for regular files and directories
> 
> Thanks to Johannes Stezenbach for pointing this consequence of commit
> 19ba0559.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@xxxxxxx>
> Cc: Al Viro <viro@xxxxxxxxxxxxxxxxxx>
> Cc: "Aneesh Kumar K.V" <aneesh.kumar@xxxxxxxxxxxxxxxxxx>
> Cc: Johannes Stezenbach <js@xxxxxxxxx>
> ---
> 
> Fixed up commit description
> 
> fs/compat_ioctl.c | 6 +++++-
> fs/ioctl.c | 5 ++++-
> 2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> index 641640d..b8607fe 100644
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c
> @@ -1715,8 +1715,12 @@ asmlinkage long compat_sys_ioctl(unsigned int
> fd, unsigned int cmd,
> goto out_fput;
> #endif
> - case FIBMAP:
> case FIGETBSZ:
> + if (S_ISDIR(filp->f_path.dentry->d_inode->i_mode))
> + break;
> + /*FALL THROUGH */
> +
> + case FIBMAP:
> case FIONREAD:
> if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
> break;
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 2d140a7..e578dab 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -597,7 +597,10 @@ int do_vfs_ioctl(struct file *filp, unsigned
> int fd, unsigned int cmd,
> {
> struct inode *inode = filp->f_path.dentry->d_inode;
> int __user *p = (int __user *)arg;
> - return put_user(inode->i_sb->s_blocksize, p);
> +
> + if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))
> + return put_user(inode->i_sb->s_blocksize, p);
> + /* FALL THROUGH */
> }
> 
> default:
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
