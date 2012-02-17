Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab2BQX7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 18:59:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab2BQX7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 18:59:23 -0500
Date: Fri, 17 Feb 2012 15:59:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cesar Eduardo Barros <cesarb@cesarb.net>,
        Nick Bowler <nbowler@elliptictech.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 01/60] highmem: mark k[un]map_atomic() with two
 arguments as deprecated
Message-Id: <20120217155922.0826ca48.akpm@linux-foundation.org>
In-Reply-To: <1328852421-19678-2-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
	<1328852421-19678-2-git-send-email-amwang@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Feb 2012 13:39:22 +0800
Cong Wang <amwang@redhat.com> wrote:

> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -109,20 +109,60 @@ static inline void kmap_atomic_idx_pop(void)
>  #endif
>  
>  /*
> - * Make both: kmap_atomic(page, idx) and kmap_atomic(page) work.
> + * NOTE:
> + * kmap_atomic() and kunmap_atomic() with two arguments are deprecated.
> + * We only keep them for backward compatibility, any usage of them
> + * are now warned.
>   */
> -#define kmap_atomic(page, args...) __kmap_atomic(page)
> +
> +#define PASTE(a, b) a ## b
> +#define PASTE2(a, b) PASTE(a, b)
> +
> +#define NARG_(_2, _1, n, ...) n
> +#define NARG(...) NARG_(__VA_ARGS__, 2, 1, :)
> +
> +static inline void *kmap_atomic(struct page *page)
> +{
> +	return __kmap_atomic(page);
> +}
> +
> +static inline void __deprecated *kmap_atomic_deprecated(struct page *page,
> +							enum km_type km)
> +{
> +	return __kmap_atomic(page);
> +}
> +
> +#define kmap_atomic1(...) kmap_atomic(__VA_ARGS__)
> +#define kmap_atomic2(...) kmap_atomic_deprecated(__VA_ARGS__)
> +#define kmap_atomic(...) PASTE2(kmap_atomic, NARG(__VA_ARGS__)(__VA_ARGS__))
> +
> +static inline void __deprecated __kunmap_atomic_deprecated(void *addr,
> +							enum km_type km)
> +{
> +	__kunmap_atomic(addr);
> +}

Boggle.



I can't merge these patches because they're already in linux-next.

This is silly.  Please send Linus the pull request for 3.4 and be sure to cc
myself on it.

