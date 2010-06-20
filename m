Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab0FTVRS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 17:17:18 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:43163 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab0FTVRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 17:17:15 -0400
X-Authority-Analysis: v=1.1 cv=8MuG1bpxLlSbaYWWtODGdBCK7StbFcRsMXhWm1NVx/I= c=1 sm=0 a=JXxh88mwcQEA:10 a=yQWWgrYGNuUA:10 a=kj9zAlcOel0A:10 a=ld/erqUjW76FpBUqCqkKeA==:17 a=pGLkceISAAAA:8 a=hGzw-44bAAAA:8 a=zOIkSwpEKedwHBwchBcA:9 a=gAan2K3hxlFFsCkt4TMA:7 a=L5WtgxJ4z4ScyziTEuG-5IasgKsA:4 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=dowx1zmaLagA:10 a=ld/erqUjW76FpBUqCqkKeA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 71.70.153.3
Date: Sun, 20 Jun 2010 17:17:13 -0400
From: Jeff Layton <jlayton@samba.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6 v2]cifs Fix warnings variables set but not used
Message-ID: <20100620171713.782e9104@tlielax.poochiereds.net>
In-Reply-To: <1276980427-24728-1-git-send-email-justinmattock@gmail.com>
References: <1276980427-24728-1-git-send-email-justinmattock@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jun 2010 13:47:07 -0700
"Justin P. Mattock" <justinmattock@gmail.com> wrote:

> This is a resend of the original, to fix whitespace issues
> and to maybe do a better job with the issue.
> 
> The patch below fixes the warning messages from
> gcc 4.6.0 and compiling the kernel.
>   CC [M]  fs/cifs/cifssmb.o
> fs/cifs/cifssmb.c: In function 'CIFSSMBSetFileSize':
> fs/cifs/cifssmb.c:4855:8: warning: variable 'data_offset' set but not used
>   CC [M]  fs/cifs/cifs_debug.o
> 
>   CC [M]  fs/cifs/dir.o
> fs/cifs/dir.c: In function 'cifs_lookup':
> fs/cifs/dir.c:641:15: warning: variable 'filp' set but not used
> 
>   CC [M]  fs/cifs/file.o
> fs/cifs/file.c: In function 'cifs_partialpagewrite':
> fs/cifs/file.c:1315:23: warning: variable 'pTcon' set but not used
> 
> 
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  fs/cifs/cifssmb.c |    2 +-
>  fs/cifs/dir.c     |    3 +--
>  fs/cifs/file.c    |    2 +-
>  3 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index c65c341..197349c 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -4852,7 +4852,7 @@ CIFSSMBSetFileSize(const int xid, struct cifsTconInfo *tcon, __u64 size,
>  		   __u16 fid, __u32 pid_of_opener, bool SetAllocation)
>  {
>  	struct smb_com_transaction2_sfi_req *pSMB  = NULL;
> -	char *data_offset;
> +	char *data_offset __attribute__((unused));

It would be better to just remove this variable and the place where it
gets set.

>  	struct file_end_of_file_info *parm_data;
>  	int rc = 0;
>  	__u16 params, param_offset, offset, byte_count, count;
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 391816b..b3d1be2 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -638,7 +638,6 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
>  	struct cifsTconInfo *pTcon;
>  	struct inode *newInode = NULL;
>  	char *full_path = NULL;
> -	struct file *filp;
>  
>  	xid = GetXid();
>  
> @@ -734,7 +733,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
>  			direntry->d_op = &cifs_dentry_ops;
>  		d_add(direntry, newInode);
>  		if (posix_open)
> -			filp = lookup_instantiate_filp(nd, direntry, NULL);
> +			lookup_instantiate_filp(nd, direntry, NULL);

This part of the patch will conflict with some changes that are coming
to this area. With those, "filp" will actually be used. You may want to
wait until Linus pulls the latest fixes from Steve F's tree (or just
base your patch on Steve's tree in the first place).


>  		/* since paths are not looked up by component - the parent
>  		   directories are presumed to be good here */
>  		renew_parental_timestamps(direntry);
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 75541af..73e540b 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1312,7 +1312,7 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
>  	int rc = -EFAULT;
>  	int bytes_written = 0;
>  	struct cifs_sb_info *cifs_sb;
> -	struct cifsTconInfo *pTcon;
> +	struct cifsTconInfo *pTcon __attribute__((unused));

This variable can just be removed (along with the spot where it gets
set later).
 
>  	struct inode *inode;
>  	struct cifsFileInfo *open_file;
>  


-- 
Jeff Layton <jlayton@samba.org>
