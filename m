Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab2EKMCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 08:02:34 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63162 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab2EKMCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 08:02:31 -0400
X-Nat-Received: from [202.181.97.72]:51967 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1336737715.11955
To: snijsure@grid-net.com
Cc: linux-mtd@lists.infradead.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Add security.* XATTR support for the UBIFS
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1336691842-32281-1-git-send-email-snijsure@grid-net.com>
In-Reply-To: <1336691842-32281-1-git-send-email-snijsure@grid-net.com>
Message-Id: <201205112101.AGA05306.JOOFFSHOQMLFtV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 11 May 2012 21:01:55 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 11052012 #7964500, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subodh Nijsure wrote:
> diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
> index ad6e550..cec3ffab 100644
> --- a/fs/ubifs/dir.c
> +++ b/fs/ubifs/dir.c
> @@ -292,6 +292,14 @@ static int ubifs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
>  
According to 3.4-rc6,

	mutex_unlock() is here.

>  	ubifs_release_budget(c, &req);
>  	insert_inode_hash(inode);
> +
> +	err = ubifs_init_security(dir, inode, &dentry->d_name);
> +	if (err) {
> +		ubifs_err("cannot initialize extended attribute, error %d",
> +			  err);
> +		goto out_cancel;
> +	}
> +
>  	d_instantiate(dentry, inode);
>  	return 0;

out_cancel:
	mutex_unlock() is also here...

Same for the rest.

> diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
> index 85b2722..49c426a 100644
> --- a/fs/ubifs/xattr.c
> +++ b/fs/ubifs/xattr.c
> @@ -568,3 +600,91 @@ out_free:
>  	kfree(xent);
>  	return err;
>  }
> +
> +size_t
> +ubifs_security_listxattr(struct dentry *d, char *list, size_t list_size,
> +			 const char *name, size_t name_len, int flags)
> +{
> +	const int prefix_len = XATTR_SECURITY_PREFIX_LEN;
> +	const size_t total_len = prefix_len + name_len + 1;
> +	if (list && total_len <= list_size) {
> +		memcpy(list, XATTR_SECURITY_PREFIX, prefix_len);
> +		memcpy(list+prefix_len, name, name_len);
> +		list[prefix_len + name_len] = '\0';
> +	}

If (list && total_len > list_size), the caller will see total_len
but no data is copied to list. Is it OK?

> +	return total_len;
> +}

> +static int ubifs_initxattrs(struct inode *inode,
> +			    const struct xattr *xattr_array, void *fs_info)
> +{
> +	const struct xattr *xattr;
> +	char *name;
> +	int err = 0;
> +
> +	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
> +		name = kmalloc(XATTR_SECURITY_PREFIX_LEN +
> +			       strlen(xattr->name) + 1, GFP_NOFS);

Maybe nice to have kstrdup2(const char *str1, const char *str2, gfp_t flags).

> +		if (!name) {
> +			err = -ENOMEM;
> +			break;
> +		}
> +		strcpy(name, XATTR_SECURITY_PREFIX);
> +		strcpy(name + XATTR_SECURITY_PREFIX_LEN, xattr->name);
> +		err = __ubifs_setxattr(inode, name, xattr->value,
> +				       xattr->value_len, 0);
> +		kfree(name);
> +		if (err < 0)
> +			break;
> +	}
> +	return err;
> +}
