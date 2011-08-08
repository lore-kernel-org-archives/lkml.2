Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab1HHFSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 01:18:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50988 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab1HHFSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 01:18:52 -0400
Date: Mon, 8 Aug 2011 08:18:45 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>, xtfeng@gmail.com
Subject: Re: list corruption in the last few days. (block ? crypto ?)
In-Reply-To: <CA+55aFzdp+7+AcCFbx3dCkfqERzYvOZG3c3SUuNAw+X0MJ8iNw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1108080817050.25955@tiger>
References: <20110805010038.GA18148@redhat.com> <20110805084614.GA1588@x4.trippels.de> <CAOJsxLEMf8SbSmJv5u6GZtq_OYH3fpmomT-ioWXQGp83veK7wQ@mail.gmail.com> <alpine.DEB.2.00.1108051131440.28580@router.home> <20110805163948.GA11113@redhat.com>
 <alpine.DEB.2.00.1108051146180.28580@router.home> <20110805165119.GA11593@redhat.com> <alpine.DEB.2.00.1108051158400.28580@router.home> <20110805171607.GA11703@redhat.com> <alpine.DEB.2.00.1108051312090.28580@router.home> <20110805182008.GA22314@redhat.com>
 <CA+55aFwGSJM6g+YXfy_Oyb0OpQP5kH=OxCR-pnBk7RUshL+mXg@mail.gmail.com> <alpine.DEB.2.00.1108072155240.9480@tiger> <CA+55aFzdp+7+AcCFbx3dCkfqERzYvOZG3c3SUuNAw+X0MJ8iNw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sun, Aug 7, 2011 at 11:58 AM, Pekka Enberg <penberg@kernel.org> wrote:
>>
>> Christoph, I've been reading the code and spotted two potential issues in
>> __slab_free(). The first one seems like an off-by-one where our comparison
>> in deactivate_slab() doesn't match __slab_free.
>>
>> The other one is remove_full() call in __slab_free() that can get called
>> even if cache debugging is not enabled.
>>
>> Hmm?

On Sun, 7 Aug 2011, Linus Torvalds wrote:
> I'd like to do -rc1 today, regardless of whether this fixes things or
> not (-rc1 is already a few days delayed).
>
> The patch seems to be a good fix, and a likely candidate for the
> corruption. Commit log and sign-off? I assume you've given it some
> testing, even if you couldn't reproduce the original issue?

No, I haven't tested the patch myself but here's one in proper format in 
case someone wants to test it.

 			Pekka

>From 85380c605764927576d6ef54e4e8a3354df05d47 Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@kernel.org>
Date: Mon, 8 Aug 2011 07:56:49 +0300
Subject: [PATCH] slub: Fix partial and full list handling in __slab_free

Dave Jones and Xiaotian Feng reported SLUB list corruption:

   https://lkml.org/lkml/2011/8/4/375

   https://lkml.org/lkml/2011/8/3/37

While I haven't able to reproduce the issue, I spotted two problems in
__slab_free() during code review:

   - The ->nr_partial check in __slab_free() has an off-by-one bug
     when compared to similar check in deactivate_slab()

   - remove_full() is called even if cache debugging has not been enabled

Reported-by: Dave Jones <davej@redhat.com>
Reported-by: Xiaotian Feng <xtfeng@gmail.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
  mm/slub.c |    5 +++--
  1 files changed, 3 insertions(+), 2 deletions(-)

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
-- 
1.7.0.4

