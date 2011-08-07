Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab1HGS60 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 14:58:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57011 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab1HGS6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 14:58:25 -0400
Date: Sun, 7 Aug 2011 21:58:16 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: list corruption in the last few days. (block ? crypto ?)
In-Reply-To: <CA+55aFwGSJM6g+YXfy_Oyb0OpQP5kH=OxCR-pnBk7RUshL+mXg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1108072155240.9480@tiger>
References: <20110805010038.GA18148@redhat.com> <20110805084614.GA1588@x4.trippels.de> <CAOJsxLEMf8SbSmJv5u6GZtq_OYH3fpmomT-ioWXQGp83veK7wQ@mail.gmail.com> <alpine.DEB.2.00.1108051131440.28580@router.home> <20110805163948.GA11113@redhat.com>
 <alpine.DEB.2.00.1108051146180.28580@router.home> <20110805165119.GA11593@redhat.com> <alpine.DEB.2.00.1108051158400.28580@router.home> <20110805171607.GA11703@redhat.com> <alpine.DEB.2.00.1108051312090.28580@router.home> <20110805182008.GA22314@redhat.com>
 <CA+55aFwGSJM6g+YXfy_Oyb0OpQP5kH=OxCR-pnBk7RUshL+mXg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Aug 2011, Linus Torvalds wrote:
> Anybody has any ideas on this one? I'm back home, no more diving :(,
> ready to make -rc1, but I'd *prefer* to have a handle on this one.
>
> Of course, the fact that it apparently only happens with SLUB
> debugging on means that the impact is less, but on the other hand I
> really like all the people who enable debug features and help us test
> with those on. So..

Christoph, I've been reading the code and spotted two potential issues in 
__slab_free(). The first one seems like an off-by-one where our comparison 
in deactivate_slab() doesn't match __slab_free.

The other one is remove_full() call in __slab_free() that can get called 
even if cache debugging is not enabled.

Hmm?

 			Pekka

diff --git a/mm/slub.c b/mm/slub.c
index eb5a8f9..cee8c20 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2368,7 +2368,7 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
  	if (was_frozen)
  		stat(s, FREE_FROZEN);
  	else {
-		if (unlikely(!inuse && n->nr_partial > s->min_partial))
+		if (unlikely(!inuse && n->nr_partial >= s->min_partial))
                          goto slab_empty;

  		/*
@@ -2376,7 +2376,8 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
  		 * then add it.
  		 */
  		if (unlikely(!prior)) {
-			remove_full(s, page);
+			if (kmem_cache_debug(s))
+				remove_full(s, page);
  			add_partial(n, page, 0);
  			stat(s, FREE_ADD_PARTIAL);
  		}
