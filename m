Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965258Ab2JCQWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:22:35 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:56583 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965046Ab2JCQWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:22:21 -0400
Date: Wed, 3 Oct 2012 16:24:12 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] proc: don't show nonexistent capabilities
Message-ID: <20121003162410.GA6692@mail.hallyn.com>
References: <1349209832-279922-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349209832-279922-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Vagin (avagin@openvz.org):
> Without this patch it is really hard to interpret a bounding set,
> if CAP_LAST_CAP is unknown for a current kernel.
> 
> Non-existant capabilities can not be deleted from a bounding set
> with help of prctl.
> 
> E.g.: Here are two examples without/with this patch.
> CapBnd:	ffffffe0fdecffff
> CapBnd:	00000000fdecffff
> 
> I suggest to hide non-existent capabilities. Here is two reasons.
> * It's logically and easier for using.
> * It helps to checkpoint-restore capabilities of tasks, because tasks
> can be restored on another kernel, where CAP_LAST_CAP is bigger.
> 
> Cc: Serge Hallyn <serge.hallyn@canonical.com>

Hm, I don't object to this patch.  Sounds useful indeed.  I can't
help shake the feeling though that something somewhere will get
confused by this (though it shouldn't), so I'd like to do some
testing.  Have you run ltp against this?  Are you running this
daily with your distro?

> Cc: Pavel Emelyanov <xemul@parallels.com>
> Signed-off-by: Andrew Vagin <avagin@openvz.org>
> ---
>  include/linux/capability.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index d10b7ed..1642778 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -420,7 +420,8 @@ extern const kernel_cap_t __cap_init_eff_set;
>  #else /* HAND-CODED capability initializers */
>  
>  # define CAP_EMPTY_SET    ((kernel_cap_t){{ 0, 0 }})
> -# define CAP_FULL_SET     ((kernel_cap_t){{ ~0, ~0 }})
> +# define CAP_FULL_SET     ((kernel_cap_t){{ ~0, \
> +					CAP_TO_MASK(CAP_LAST_CAP + 1) - 1 } })
>  # define CAP_FS_SET       ((kernel_cap_t){{ CAP_FS_MASK_B0 \
>  				    | CAP_TO_MASK(CAP_LINUX_IMMUTABLE), \
>  				    CAP_FS_MASK_B1 } })
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
