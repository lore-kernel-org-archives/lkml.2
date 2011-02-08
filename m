Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab1BHPCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 10:02:13 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:44129 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753937Ab1BHPCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 10:02:12 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Vgm5dNwVM1lBmF6A7Ix62180vLaxAbN7KpQ.olYXv0us4An
 0liBeopV2..lefZzzc5Gq9UwyOzUu1XsHJjVzQhyiGGDcPkjh5Gc9IvMdTu_
 Ttx89S1LObIO8r7YCl5EEhqrTUIwu_nbLLdDwg._69wxyfryJXCYr44V58EG
 GQlR6Xp5xVlECDkS04uvuPnmTQZ0cjxOW_sKz8aRHWJ3_90fsHoMKh3wnUhh
 yLZgGzAeaAJZbR8iGzlmRZFAO5IvyL76mvhP6R2fHi7uIRJR63cZV7iejQ1t
 KuH8Fikje_bO8iY.HOVJ63n_4nRybkgT_47U_kKgUdVcwREQ-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 8 Feb 2011 09:02:09 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Russell King <rmk@arm.linux.org.uk>
cc: Pekka Enberg <penberg@kernel.org>, Shiyong Li <shi-yong.li@motorola.com>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: "slab: Fix missing DEBUG_SLAB last user" breaks ARM
In-Reply-To: <20110208125546.GA4286@flint.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1102080856020.12521@router.home>
References: <20110207180606.GB2966@flint.arm.linux.org.uk> <AANLkTi=Lftr41mHDXzK0c=pf7JYYOVWMjLX65JCLqDsU@mail.gmail.com> <20110208125546.GA4286@flint.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Feb 2011, Russell King wrote:

> > I thought the fix was for ARM, actually, but unfortunately the
> > changelog is somewhat terse (shame on me). Hmm?
>
> As you say, the changelog is soo terse that we now have no idea why this
> commit was created.
>
> So, what's the fix here?  It looks to me like a revert is in order.
>
> I suggest that if it does get reverted, a copy of my original bug report
> is included in the revert commit so that all the details are available if
> it needs revisiting.

Uhh.. That first hunk in commit 5c5e3b33b7cb959a401f823707bee006caadd76e
looks wrong to me. ralign is usually a power of two and greater than
alignof(unsigned long long). The & operation will result in 0 and never
exempt any caches.

diff --git a/mm/slab.c b/mm/slab.c
index bac0f4f..525c664 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2220,8 +2220,8 @@ kmem_cache_create (const char *name, size_t size,
size_t align,
        if (ralign < align) {
                ralign = align;
        }
-       /* disable debug if necessary */
-       if (ralign > __alignof__(unsigned long long))
+       /* disable debug if not aligning with REDZONE_ALIGN */
+       if (ralign & (__alignof__(unsigned long long) - 1))
                flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
        /*
         * 4) Store it.


Did you mean

	if (ralign > REDZONE_ALIGN) ...

?


