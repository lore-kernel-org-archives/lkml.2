Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab1GKTje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 15:39:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35159 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757639Ab1GKTjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 15:39:32 -0400
Subject: Re: [PATCH next/mmotm] slub: partly fix freeze in __slab_free
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LSU.2.00.1107111156310.13035@sister.anvils>
References: <alpine.LSU.2.00.1107111156310.13035@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jul 2011 21:39:27 +0200
Message-ID: <1310413167.2860.3.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 11 juillet 2011 à 11:58 -0700, Hugh Dickins a écrit :
> My load tests on PowerPC freeze within minutes in __slab_free().
> I happened to try PPC first, didn't try without this fix on x86.
> 
> It looks as if the author was interrupted while devising the new
> cmpxchg_double_slab() version of __slab_free(): its decision to
> spin_lock_irqsave() depends on several uninitialized fields,
> and fixing that (by copying page to new) mostly fixes it.
> 
> But I didn't think about it very much, and this may well not be what
> the author intends; and I have seen a couple of much rarer freezes
> in __slab_free() on PPC (not yet on x86) even after applying this.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---
>  mm/slub.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- mmotm/mm/slub.c	2011-07-08 18:59:44.135443127 -0700
> +++ linux/mm/slub.c	2011-07-10 05:07:08.000000000 -0700
> @@ -2217,6 +2217,7 @@ static void __slab_free(struct kmem_cach
>  		return;
>  
>  	do {
> +		new = *page;
>  		prior = page->freelist;
>  		counters = page->counters;
>  		set_freepointer(s, object, prior);
> --

I suspect you hit the bug on 32bit arch ?

What about following patch instead ?

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 3d76a43..1351d28 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -62,7 +62,7 @@ struct page {
 		struct {			/* SLUB cmpxchg_double area */
 			void *freelist;
 			union {
-				unsigned long counters;
+				u64	counters;
 				struct {
 					unsigned inuse:16;
 					unsigned objects:15;


