Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634Ab2BNIw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 03:52:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab2BNIw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 03:52:56 -0500
Date: Tue, 14 Feb 2012 00:53:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yang Bai <hamo.by@gmail.com>
Cc: cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: warning if total alloc size overflow
Message-Id: <20120214005301.a9d5be1a.akpm@linux-foundation.org>
In-Reply-To: <1329204499-2671-1-git-send-email-hamo.by@gmail.com>
References: <1329204499-2671-1-git-send-email-hamo.by@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012 15:28:19 +0800 Yang Bai <hamo.by@gmail.com> wrote:

> Before, if the total alloc size is overflow,
> we just return NULL like alloc fail. But they
> are two different type problems. The former looks
> more like a programming problem. So add a warning
> here.
> 
> Signed-off-by: Yang Bai <hamo.by@gmail.com>
> ---
>  include/linux/slab.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 573c809..5865237 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -242,8 +242,10 @@ size_t ksize(const void *);
>   */
>  static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
>  {
> -	if (size != 0 && n > ULONG_MAX / size)
> +	if (size != 0 && n > ULONG_MAX / size) {
> +		WARN(1, "Alloc memory size (%lu * %lu) overflow.", n, size);
>  		return NULL;
> +	}
>  	return __kmalloc(n * size, flags | __GFP_ZERO);
>  }

One of the applications of kcalloc() is to prevent userspace from
causing a multiplicative overflow (and then perhaps causing an
overwrite beyond the end of the allocated memory).

With this patch, we've just handed the user a way of spamming the logs
at 1MHz.  This is bad.


Also, please let's not randomly add debug stuff in places where we've
never demonstrated a need for it.
