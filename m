Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195Ab2ILPlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:41:37 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47699 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab2ILPlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:41:35 -0400
Date: Wed, 12 Sep 2012 18:40:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Fengguang Wu <fengguang.wu@intel.com>, kernel-janitors@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH] module: report -EFAULT on bytes remaining
Message-ID: <20120912154023.GL19410@mwanda>
References: <20120912150616.GA27343@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912150616.GA27343@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 08:06:16AM -0700, Kees Cook wrote:
> Caught by smatch:
> kernel/module.c:2450 copy_module_from_user() warn: maybe return -EFAULT instead of the bytes remaining?  
> 
> Clean up the copy_from_user() call to not report a positive value.
> With this patch, init_module() will report errors from copy_from_user
> (before it would always only report -EFAULT when err != 0).
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> This change is on top of the finit_module patch series.
> ---
>  kernel/module.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 0ad03c4..05b8dde 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2441,8 +2441,11 @@ int copy_module_from_user(const void __user *umod, unsigned long len,
>  		return -ENOMEM;
>  
>  	err = copy_from_user(info->hdr, umod, info->len);
> -	if (err)
> +	if (err) {
> +		if (err > 0)
                ^^^^^^^^^^^
This condition is always true because copy_to/from_user() returns
the number of bytes remaining to be copied.  (It never returns a
negative error code).

> +			err = -EFAULT;
>  		goto free_hdr;
> +	}

regards,
dan carpenter


