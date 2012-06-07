Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910Ab2FGVDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 17:03:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121Ab2FGVDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 17:03:02 -0400
Date: Thu, 7 Jun 2012 23:02:49 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Boyer <jwboyer@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ulrich Obergfell <uobergfe@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Larry Woodman <lwoodman@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [ 08/82] mm: pmd_read_atomic: fix 32bit PAE pmd walk vs
 pmd_populate SMP race condition
Message-ID: <20120607210249.GI21339@redhat.com>
References: <20120607041406.GA13233@kroah.com>
 <20120607040337.622672845@linuxfoundation.org>
 <CA+5PVA6A0K3WYBQJH8z3ddd2X3=fQm1a34z+fWSYGcUg4TR9+A@mail.gmail.com>
 <20120607144204.GD21339@redhat.com>
 <CA+55aFzv-z0njtAnpgOsVES70+igwV7HCteQbQ6M6uTsYvn5WQ@mail.gmail.com>
 <20120607190414.GF21339@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120607190414.GF21339@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 09:04:14PM +0200, Andrea Arcangeli wrote:
>  #ifndef CONFIG_TRANSPARENT_HUGEPAGE
> +#define pmd_read_atomic pmd_read_atomic
>  static inline pmd_t pmd_read_atomic(pmd_t *pmdp)
>  {
>  	pmdval_t ret;
> @@ -74,11 +81,6 @@ static inline pmd_t pmd_read_atomic(pmd_t *pmdp)
>  
>  	return (pmd_t) { ret };
>  }
> -#else /* CONFIG_TRANSPARENT_HUGEPAGE */
> -static inline pmd_t pmd_read_atomic(pmd_t *pmdp)
> -{
> -	return (pmd_t) { atomic64_read((atomic64_t *)pmdp) };
> -}
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>  
>  static inline void native_set_pte_atomic(pte_t *ptep, pte_t pte)

This actually wasn't safe because if the high part wasn't none and the
low part was none, the pmd_none check would fail. I sent an updated
version that will fix this hopefully for good and it turns out the
same pmd_read_atomic will work for THP=n/y without need of cmpxchg8b
even if it's slightly less obviously safe than if we used
atomic64_read for THP=y. Still safe that is...
