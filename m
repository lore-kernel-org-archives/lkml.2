Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab0KKOv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 09:51:29 -0500
Received: from mx2.netapp.com ([216.240.18.37]:7837 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756863Ab0KKOv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 09:51:28 -0500
X-IronPort-AV: E=Sophos;i="4.59,183,1288594800"; 
   d="scan'208";a="480774752"
Message-ID: <4CDC02DE.6060700@netapp.com>
Date: Thu, 11 Nov 2010 09:51:10 -0500
From: Bryan Schumaker <bjschuma@netapp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101028 Lightning/1.0b2 Lanikai/3.1.6
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH] nfs: Ignore kmemleak false positive in nfs_readdir_make_qstr
References: <1289480027-7361-1-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1289480027-7361-1-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!  The patch works for me.

Bryan

On 11/11/2010 07:53 AM, Catalin Marinas wrote:
> Strings allocated via kmemdup() in nfs_readdir_make_qstr() are
> referenced from the nfs_cache_array which is stored in a page cache
> page. Kmemleak does not scan such pages and it reports several false
> positives. This patch annotates the string->name pointer so that
> kmemleak does not consider it a real leak.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Bryan Schumaker <bjschuma@netapp.com>
> Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
> ---
>  fs/nfs/dir.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
> index 07ac384..a9f9e14 100644
> --- a/fs/nfs/dir.c
> +++ b/fs/nfs/dir.c
> @@ -34,6 +34,7 @@
>  #include <linux/mount.h>
>  #include <linux/sched.h>
>  #include <linux/vmalloc.h>
> +#include <linux/kmemleak.h>
>  
>  #include "delegation.h"
>  #include "iostat.h"
> @@ -231,6 +232,11 @@ int nfs_readdir_make_qstr(struct qstr *string, const char *name, unsigned int le
>  	string->name = kmemdup(name, len, GFP_KERNEL);
>  	if (string->name == NULL)
>  		return -ENOMEM;
> +	/*
> +	 * Avoid a kmemleak false positive. The pointer to the name is stored
> +	 * in a page cache page which kmemleak does not scan.
> +	 */
> +	kmemleak_not_leak(string->name);
>  	string->hash = full_name_hash(name, len);
>  	return 0;
>  }

