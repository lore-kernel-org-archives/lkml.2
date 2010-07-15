Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933445Ab0GOO5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 10:57:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38386 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933408Ab0GOO5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 10:57:33 -0400
X-Authority-Analysis: v=1.1 cv=kjawQlkT3vujM0lFy4b69hWxQTW3SR1XdVtFii1ut0g= c=1 sm=0 a=eV16w_T9sSgA:10 a=yQWWgrYGNuUA:10 a=kj9zAlcOel0A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:17 a=JgcoIjaUAAAA:8 a=hBqU3vQJAAAA:8 a=VwQbUJbxAAAA:8 a=f2Qq5J2lTt0Lvr-eisgA:9 a=LNrrsgh-hWVC6peRqtEA:7 a=q50wvE5ZsZFkyy_YD4Msvi7FRD0A:4 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=gGuMuyKI_i0A:10 a=4gZ4WExUoD4A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.120.198.24
Date: Thu, 15 Jul 2010 09:59:46 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: James Morris <jmorris@namei.org>, "greg@kroah.com" <greg@kroah.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH][securityfs][2.6.34] Drop dentry reference count when
 mknod fails
Message-ID: <20100715145946.GA26067@hallyn.com>
References: <201007151325.06942.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007151325.06942.tvrtko.ursulin@sophos.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tvrtko Ursulin (tvrtko.ursulin@sophos.com):
> 
> lookup_one_len increments dentry reference count which is not decremented
> when the create operation fails. This can cause a kernel BUG at
> fs/dcache.c:676 at unmount time. Also error code returned when new_inode()
> fails was replaced with more appropriate -ENOMEM.
> 
> 
> Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>

Looks right.

Acked-by: Serge E. Hallyn <serge@hallyn.com>

thanks,
-serge

> ---
>  inode.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff -upr linux-2.6.34/security/inode.c linux-2.6.34-new/security/inode.c
> --- linux-2.6.34/security/inode.c       2010-05-16 22:17:36.000000000 +0100
> +++ linux-2.6.34-new/security/inode.c   2010-07-15 13:20:38.133783253 +0100
> @@ -86,7 +86,7 @@ static int mknod(struct inode *dir, stru
>                          int mode, dev_t dev)
>  {
>         struct inode *inode;
> -       int error = -EPERM;
> +       int error = -ENOMEM;
> 
>         if (dentry->d_inode)
>                 return -EEXIST;
> @@ -166,6 +166,8 @@ static int create_by_name(const char *na
>                         error = mkdir(parent->d_inode, *dentry, mode);
>                 else
>                         error = create(parent->d_inode, *dentry, mode);
> +               if (error)
> +                       dput(dentry);
>         } else
>                 error = PTR_ERR(*dentry);
>         mutex_unlock(&parent->d_inode->i_mutex);
> 
> 
> 
> Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
> Company Reg No 2096520. VAT Reg No GB 348 3873 20.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
