Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab2HOUQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:16:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36512 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310Ab2HOUQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 16:16:49 -0400
Date: Wed, 15 Aug 2012 15:16:35 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: zohar@linux.vnet.ibm.com, jmorris@namei.org, rusty@rustcorp.com.au,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 4/7] modsig: add integrity_module_check hook
Message-ID: <20120815201635.GB10088@amd1>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
 <68a6f647ca1d4429d6b781b6cfeed9c93a346c14.1345055639.git.dmitry.kasatkin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68a6f647ca1d4429d6b781b6cfeed9c93a346c14.1345055639.git.dmitry.kasatkin@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dmitry Kasatkin (dmitry.kasatkin@intel.com):
> IMA measures/appraises modules when modprobe or insmod opens and read them.
> Unfortunately, there are no guarantees between what is read by userspace and
> what is passed to the kernel via load_module system call. This patch adds a
> hook called integrity_module_check() to verify the integrity of the module
> being loaded.
> 
> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> ---
>  include/linux/integrity.h |   10 ++++++++++
>  kernel/module.c           |    9 +++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/include/linux/integrity.h b/include/linux/integrity.h
> index 66c5fe9..a80ec06 100644
> --- a/include/linux/integrity.h
> +++ b/include/linux/integrity.h
> @@ -37,4 +37,14 @@ static inline void integrity_inode_free(struct inode *inode)
>  	return;
>  }
>  #endif /* CONFIG_INTEGRITY_H */
> +
> +#ifdef CONFIG_INTEGRITY_MODULES
> +int integrity_module_check(const void *hdr, const unsigned long len);

sadly not bisect-safe, since integrity_module_check() is defined in
the next patch.

> +#else
> +static inline int integrity_module_check(const void *buf, unsigned long len)
> +{
> +	return 0;
> +}
> +#endif
> +
>  #endif /* _LINUX_INTEGRITY_H */
> diff --git a/kernel/module.c b/kernel/module.c
> index 4edbd9c..791da47 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -58,6 +58,7 @@
>  #include <linux/jump_label.h>
>  #include <linux/pfn.h>
>  #include <linux/bsearch.h>
> +#include <linux/integrity.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/module.h>
> @@ -2437,6 +2438,14 @@ static int copy_and_check(struct load_info *info,
>  
>  	info->hdr = hdr;
>  	info->len = len;
> +
> +	err = integrity_module_check(hdr, len);
> +	if (err < 0)
> +		goto free_hdr;
> +
> +	/* cut signature tail */
> +	info->len = err;
> +
>  	return 0;
>  
>  free_hdr:
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
