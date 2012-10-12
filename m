Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab2JLTQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 15:16:00 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:42707 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989Ab2JLTP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 15:15:58 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Oct 2012 15:15:58 EDT
Message-ID: <1350068629.7065.58.camel@rhapsody>
Subject: Re: [PATCH 2/5] efivarfs: efivarfs_create() ensure we drop our
 reference on inode on error
From: Khalid Aziz <khalid@gonehiking.org>
To: Andy Whitcroft <apw@canonical.com>
Cc: Matthew Garrett <mjg@redhat.com>, Jeremy Kerr <jeremy.kerr@canonical.com>,
        Matt Fleming <matt.fleming@intel.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 12 Oct 2012 13:03:49 -0600
In-Reply-To: <1349951541-20498-3-git-send-email-apw@canonical.com>
References: <1349416496.810727.310563927016.1.gpush@pecola>
	 <1349951541-20498-1-git-send-email-apw@canonical.com>
	 <1349951541-20498-3-git-send-email-apw@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-11 at 11:32 +0100, Andy Whitcroft wrote:
> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> ---
>  drivers/firmware/efivars.c |   14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index ae50d2f..0bbf742 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -866,7 +866,7 @@ static void efivarfs_hex_to_guid(const char *str, efi_guid_t *guid)
>  static int efivarfs_create(struct inode *dir, struct dentry *dentry,
>  			  umode_t mode, bool excl)
>  {
> -	struct inode *inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0);
> +	struct inode *inode;
>  	struct efivars *efivars = &__efivars;
>  	struct efivar_entry *var;
>  	int namelen, i = 0, err = 0;
> @@ -874,13 +874,15 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
>  	if (dentry->d_name.len < 38)
>  		return -EINVAL;
>  
> +	inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0);
>  	if (!inode)
>  		return -ENOSPC;
>  
>  	var = kzalloc(sizeof(struct efivar_entry), GFP_KERNEL);
> -
> -	if (!var)
> -		return -ENOMEM;
> +	if (!var) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
>  

This does not read right. If kzalloc() fails, var will be a NULL
pointer. This code will set err to -ENOMEM and jump to out: where since
err is non-zero, this code will call kfree(Var) but var is a NULL
pointer at this point. Now kfree() does check for NULL pointer and this
will not cause any serious problems but why call kfree for a NULL
pointer?


>  	namelen = dentry->d_name.len - GUID_LEN;
>  
> @@ -908,8 +910,10 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
>  	d_instantiate(dentry, inode);
>  	dget(dentry);
>  out:
> -	if (err)
> +	if (err) {
>  		kfree(var);
> +		iput(inode);
> +	}
>  	return err;
>  }
>  

--
Khalid


