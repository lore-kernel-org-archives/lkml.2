Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935152Ab1ESWG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 18:06:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38720 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933084Ab1ESWGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 18:06:51 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=wom5GMh1gUkA:10 a=fXUj1uqOk9AA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=g3F5VGk0NOMZWSIEWMgijA==:17 a=VnNF1IyMAAAA:8 a=fxJcL_dCAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=hZdPjK-OnC-iyLbKUKoA:9 a=MAez6ymxERvYUFGDqPQA:7 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=2eKvNQJKnqYA:10 a=g3F5VGk0NOMZWSIEWMgijA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.158.191
Date: Thu, 19 May 2011 17:06:49 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v5 05/21] ima: move ima_file_free before releasing the
 file
Message-ID: <20110519220649.GA4332@mail.hallyn.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1305557115-15652-6-git-send-email-zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305557115-15652-6-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> Integrity appraisal measures files on file_free and stores the file
> measurement as an xattr.  Measure the file before releasing it.

Can you put a bit more in the commit msg about why?  What's magic
about the fs-specific release function?

> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>
> ---
>  fs/file_table.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/file_table.c b/fs/file_table.c
> index 01e4c1e..33f54a1 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -243,10 +243,10 @@ static void __fput(struct file *file)
>  		if (file->f_op && file->f_op->fasync)
>  			file->f_op->fasync(-1, file, 0);
>  	}
> +	ima_file_free(file);
>  	if (file->f_op && file->f_op->release)
>  		file->f_op->release(inode, file);
>  	security_file_free(file);
> -	ima_file_free(file);
>  	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL &&
>  		     !(file->f_mode & FMODE_PATH))) {
>  		cdev_put(inode->i_cdev);
> -- 
> 1.7.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
