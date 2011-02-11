Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab1BKHCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 02:02:47 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46130 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab1BKHCq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 02:02:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DPtAd49lvR2mtxqa411wYx3LfMDTycFOgoPaR1Az5GXRRUvrudA+DqapEqrZGehYeE
         Yi9IUFe9NDreYQehArBQZQlWFL1Y4kC7MgV0GTyj405HlJBQVGN8aiKmeqCzbX3dMw4N
         bZcmxi1/Dz3RB8cL2gDgFkcyxVPKSu9pDJ+bs=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1102080856020.12521@router.home>
References: <20110207180606.GB2966@flint.arm.linux.org.uk>
	<AANLkTi=Lftr41mHDXzK0c=pf7JYYOVWMjLX65JCLqDsU@mail.gmail.com>
	<20110208125546.GA4286@flint.arm.linux.org.uk>
	<alpine.DEB.2.00.1102080856020.12521@router.home>
Date: Fri, 11 Feb 2011 09:02:45 +0200
X-Google-Sender-Auth: uC6n3KcGGLfTiFibsBnAGiaJDgY
Message-ID: <AANLkTimFDZFcO=J6PEOOo5RBdr0m7fjCKzWh1M_NaiLx@mail.gmail.com>
Subject: Re: "slab: Fix missing DEBUG_SLAB last user" breaks ARM
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Russell King <rmk@arm.linux.org.uk>, Shiyong Li <shi-yong.li@motorola.com>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 8, 2011 at 5:02 PM, Christoph Lameter <cl@linux.com> wrote:
> On Tue, 8 Feb 2011, Russell King wrote:
>
>> > I thought the fix was for ARM, actually, but unfortunately the
>> > changelog is somewhat terse (shame on me). Hmm?
>>
>> As you say, the changelog is soo terse that we now have no idea why this
>> commit was created.
>>
>> So, what's the fix here?  It looks to me like a revert is in order.
>>
>> I suggest that if it does get reverted, a copy of my original bug report
>> is included in the revert commit so that all the details are available if
>> it needs revisiting.
>
> Uhh.. That first hunk in commit 5c5e3b33b7cb959a401f823707bee006caadd76e
> looks wrong to me. ralign is usually a power of two and greater than
> alignof(unsigned long long). The & operation will result in 0 and never
> exempt any caches.
>
> diff --git a/mm/slab.c b/mm/slab.c
> index bac0f4f..525c664 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2220,8 +2220,8 @@ kmem_cache_create (const char *name, size_t size,
> size_t align,
>        if (ralign < align) {
>                ralign = align;
>        }
> -       /* disable debug if necessary */
> -       if (ralign > __alignof__(unsigned long long))
> +       /* disable debug if not aligning with REDZONE_ALIGN */
> +       if (ralign & (__alignof__(unsigned long long) - 1))
>                flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
>        /*
>         * 4) Store it.
>
>
> Did you mean
>
>        if (ralign > REDZONE_ALIGN) ...
>
> ?

Ping. Any arm-capable tester out there that can verify this fix? OTOH,
since Shiyong Li hasn't showed up, I'm inclined to just revert the
commit...
