Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab2IYHP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 03:15:27 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46473 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2IYHPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 03:15:25 -0400
MIME-Version: 1.0
In-Reply-To: <1347137279-17568-5-git-send-email-elezegarcia@gmail.com>
References: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com>
	<1347137279-17568-5-git-send-email-elezegarcia@gmail.com>
Date: Tue, 25 Sep 2012 10:15:23 +0300
X-Google-Sender-Auth: ejiTR8kI8YL9c-OBTiGo2tV_IrQ
Message-ID: <CAOJsxLGf3Aburoqw5xxycbM8yOLQPoGVR+Hv9qcaaAo2k7EV_A@mail.gmail.com>
Subject: Re: [PATCH 05/10] mm, util: Use dup_user to duplicate user memory
From: Pekka Enberg <penberg@kernel.org>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 8, 2012 at 11:47 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> Previously the strndup_user allocation was being done through memdup_user,
> and the caller was wrongly traced as being strndup_user
> (the correct trace must report the caller of strndup_user).
>
> This is a common problem: in order to get accurate callsite tracing,
> a utils function can't allocate through another utils function,
> but instead do the allocation himself (or inlined).
>
> Here we fix this by creating an always inlined dup_user() function to
> performed the real allocation and to be used by memdup_user and strndup_user.
>
> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> ---
>  mm/util.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/mm/util.c b/mm/util.c
> index dc3036c..48d3ff8b 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -76,14 +76,14 @@ void *kmemdup(const void *src, size_t len, gfp_t gfp)
>  EXPORT_SYMBOL(kmemdup);
>
>  /**
> - * memdup_user - duplicate memory region from user space
> + * dup_user - duplicate memory region from user space
>   *
>   * @src: source address in user space
>   * @len: number of bytes to copy
>   *
>   * Returns an ERR_PTR() on failure.
>   */
> -void *memdup_user(const void __user *src, size_t len)
> +static __always_inline void *dup_user(const void __user *src, size_t len)
>  {
>         void *p;
>
> @@ -103,6 +103,11 @@ void *memdup_user(const void __user *src, size_t len)
>
>         return p;
>  }
> +
> +void *memdup_user(const void __user *src, size_t len)
> +{
> +       return dup_user(src, len);
> +}
>  EXPORT_SYMBOL(memdup_user);
>
>  static __always_inline void *__do_krealloc(const void *p, size_t new_size,
> @@ -214,7 +219,7 @@ char *strndup_user(const char __user *s, long n)
>         if (length > n)
>                 return ERR_PTR(-EINVAL);
>
> -       p = memdup_user(s, length);
> +       p = dup_user(s, length);
>
>         if (IS_ERR(p))
>                 return p;

Looks good to me. Andrew, do you want to pick this up?
