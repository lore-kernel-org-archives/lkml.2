Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab2AHW3c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 17:29:32 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:42191 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab2AHW3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 17:29:30 -0500
Subject: Re: [PATCH] audit: treat s_id as an untrusted string
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Kees Cook <keescook@chromium.org>
Cc: James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mimi Zohar <zohar@us.ibm.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 08 Jan 2012 17:26:35 -0500
In-Reply-To: <20120107184104.GF2618@outflux.net>
References: <20120107184104.GF2618@outflux.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1326061596.19953.7.camel@falcor>
Mime-Version: 1.0
x-cbid: 12010822-3352-0000-0000-000001CB54EB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-01-07 at 10:41 -0800, Kees Cook wrote:
> The use of s_id should go through the untrusted string path, just to be
> extra careful.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Mimi Zohar <zohar@us.ibm.com>

thanks,
Mimi

> ---
> applies on top of http://lkml.org/lkml/2012/1/6/308
> ---
>  security/integrity/ima/ima_audit.c |    8 +++++---
>  security/lsm_audit.c               |   23 +++++++++++++----------
>  2 files changed, 18 insertions(+), 13 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_audit.c b/security/integrity/ima/ima_audit.c
> index c5c5a72..2ad942f 100644
> --- a/security/integrity/ima/ima_audit.c
> +++ b/security/integrity/ima/ima_audit.c
> @@ -56,9 +56,11 @@ void integrity_audit_msg(int audit_msgno, struct inode *inode,
>  		audit_log_format(ab, " name=");
>  		audit_log_untrustedstring(ab, fname);
>  	}
> -	if (inode)
> -		audit_log_format(ab, " dev=%s ino=%lu",
> -				 inode->i_sb->s_id, inode->i_ino);
> +	if (inode) {
> +		audit_log_format(ab, " dev=");
> +		audit_log_untrustedstring(ab, inode->i_sb->s_id);
> +		audit_log_format(ab, " ino=%lu", inode->i_ino);
> +	}
>  	audit_log_format(ab, " res=%d", !result ? 0 : 1);
>  	audit_log_end(ab);
>  }
> diff --git a/security/lsm_audit.c b/security/lsm_audit.c
> index 5f3b532..293b8c4 100644
> --- a/security/lsm_audit.c
> +++ b/security/lsm_audit.c
> @@ -235,10 +235,11 @@ static void dump_common_audit_data(struct audit_buffer *ab,
>  		audit_log_d_path(ab, " path=", &a->u.path);
> 
>  		inode = a->u.path.dentry->d_inode;
> -		if (inode)
> -			audit_log_format(ab, " dev=%s ino=%lu",
> -					inode->i_sb->s_id,
> -					inode->i_ino);
> +		if (inode) {
> +			audit_log_format(ab, " dev=");
> +			audit_log_untrustedstring(ab, inode->i_sb->s_id);
> +			audit_log_format(ab, " ino=%lu", inode->i_ino);
> +		}
>  		break;
>  	}
>  	case LSM_AUDIT_DATA_DENTRY: {
> @@ -248,10 +249,11 @@ static void dump_common_audit_data(struct audit_buffer *ab,
>  		audit_log_untrustedstring(ab, a->u.dentry->d_name.name);
> 
>  		inode = a->u.dentry->d_inode;
> -		if (inode)
> -			audit_log_format(ab, " dev=%s ino=%lu",
> -					inode->i_sb->s_id,
> -					inode->i_ino);
> +		if (inode) {
> +			audit_log_format(ab, " dev=");
> +			audit_log_untrustedstring(ab, inode->i_sb->s_id);
> +			audit_log_format(ab, " ino=%lu", inode->i_ino);
> +		}
>  		break;
>  	}
>  	case LSM_AUDIT_DATA_INODE: {
> @@ -266,8 +268,9 @@ static void dump_common_audit_data(struct audit_buffer *ab,
>  					 dentry->d_name.name);
>  			dput(dentry);
>  		}
> -		audit_log_format(ab, " dev=%s ino=%lu", inode->i_sb->s_id,
> -				 inode->i_ino);
> +		audit_log_format(ab, " dev=");
> +		audit_log_untrustedstring(ab, inode->i_sb->s_id);
> +		audit_log_format(ab, " ino=%lu", inode->i_ino);
>  		break;
>  	}
>  	case LSM_AUDIT_DATA_TASK:
> -- 
> 1.7.4.1
> 
> 


