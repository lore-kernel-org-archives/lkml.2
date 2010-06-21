Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab0FUBk1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 21:40:27 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:51744 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231Ab0FUBkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 21:40:23 -0400
X-Authority-Analysis: v=1.1 cv=HJGB64tDiXfNBeA9z3R11jssoLv0dHjfv/jiYneYhOY= c=1 sm=0 a=326jW6N4VKsA:10 a=yQWWgrYGNuUA:10 a=kj9zAlcOel0A:10 a=ld/erqUjW76FpBUqCqkKeA==:17 a=pGLkceISAAAA:8 a=hGzw-44bAAAA:8 a=9ynN_3_v56Uur1XUl68A:9 a=cOe-oTQWW55M73oKIm3cyaYv7ZQA:4 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=dowx1zmaLagA:10 a=ld/erqUjW76FpBUqCqkKeA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 71.70.153.3
Date: Sun, 20 Jun 2010 21:42:25 -0400
From: Jeff Layton <jlayton@samba.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6 v3]cifs Fix warnings variables set but not used
Message-ID: <20100620214225.2cd9fc65@corrin.poochiereds.net>
In-Reply-To: <1277083401-6459-1-git-send-email-justinmattock@gmail.com>
References: <1277083401-6459-1-git-send-email-justinmattock@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jun 2010 18:23:21 -0700
"Justin P. Mattock" <justinmattock@gmail.com> wrote:

> Below is a redu from the original(or similar) fixing
> gcc warningds generated while compiling:
> 
>   CC [M]  fs/cifs/cifssmb.o
> fs/cifs/cifssmb.c: In function 'CIFSSMBSetFileSize':
> fs/cifs/cifssmb.c:4855:8: warning: variable 'data_offset' set but not used
>  
>   CC [M]  fs/cifs/file.o
> fs/cifs/file.c: In function 'cifs_partialpagewrite':
> fs/cifs/file.c:1315:23: warning: variable 'pTcon' set but not used
> 
> (the warning below is funky i.g. removing pTcon generates the warning below
> but if I use the __unused option there is no warning at all).
> 
>  CC [M]  fs/cifs/file.o
> fs/cifs/file.c: In function 'cifs_partialpagewrite':
> fs/cifs/file.c:1314:23: warning: variable 'cifs_sb' set but not used
> 
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  fs/cifs/cifssmb.c |    3 ---
>  fs/cifs/file.c    |    4 ----
>  2 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index c65c341..4653aaa 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -4852,7 +4852,6 @@ CIFSSMBSetFileSize(const int xid, struct cifsTconInfo *tcon, __u64 size,
>  		   __u16 fid, __u32 pid_of_opener, bool SetAllocation)
>  {
>  	struct smb_com_transaction2_sfi_req *pSMB  = NULL;
> -	char *data_offset;
>  	struct file_end_of_file_info *parm_data;
>  	int rc = 0;
>  	__u16 params, param_offset, offset, byte_count, count;
> @@ -4876,8 +4875,6 @@ CIFSSMBSetFileSize(const int xid, struct cifsTconInfo *tcon, __u64 size,
>  	param_offset = offsetof(struct smb_com_transaction2_sfi_req, Fid) - 4;
>  	offset = param_offset + params;
>  
> -	data_offset = (char *) (&pSMB->hdr.Protocol) + offset;
> -
>  	count = sizeof(struct file_end_of_file_info);
>  	pSMB->MaxParameterCount = cpu_to_le16(2);
>  	/* BB find exact max SMB PDU from sess structure BB */
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 75541af..661f868 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1311,8 +1311,6 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
>  	char *write_data;
>  	int rc = -EFAULT;
>  	int bytes_written = 0;
> -	struct cifs_sb_info *cifs_sb;
> -	struct cifsTconInfo *pTcon;
>  	struct inode *inode;
>  	struct cifsFileInfo *open_file;
>  
> @@ -1320,8 +1318,6 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
>  		return -EFAULT;
>  
>  	inode = page->mapping->host;
> -	cifs_sb = CIFS_SB(inode->i_sb);
> -	pTcon = cifs_sb->tcon;
>  
>  	offset += (loff_t)from;
>  	write_data = kmap(page);

Looks good to me.

Reviewed-by: Jeff Layton <jlayton@samba.org>
