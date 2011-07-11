Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab1GKUfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 16:35:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52944 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498Ab1GKUfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 16:35:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=V5DI9Y3IkX8Tzj+cNjCON/EKCHuQlFKzwGjrSuL8wJgROBhdDe6jPMAaSmMsDZMYp
	bGUCjYifLK3fZLZorMkdA==
Date: Mon, 11 Jul 2011 13:35:08 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH next/mmotm] slab: fix DEBUG_SLAB build
In-Reply-To: <alpine.LSU.2.00.1107111152290.13035@sister.anvils>
Message-ID: <alpine.LSU.2.00.1107111330310.13668@sister.anvils>
References: <alpine.LSU.2.00.1107111152290.13035@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix CONFIG_SLAB=y CONFIG_DEBUG_SLAB=y build error and warnings.

Now that ARCH_SLAB_MINALIGN defaults to __alignof__(unsigned long long),
it is always defined (when slab.h included), but cannot be used in #if:
mm/slab.c: In function `cache_alloc_debugcheck_after':
mm/slab.c:3156:5: warning: "__alignof__" is not defined
mm/slab.c:3156:5: error: missing binary operator before token "("
make[1]: *** [mm/slab.o] Error 1

So just remove the #if and #endif lines, but then 64-bit build warns:
mm/slab.c: In function `cache_alloc_debugcheck_after':
mm/slab.c:3156:6: warning: cast from pointer to integer of different size
mm/slab.c:3158:10: warning: format `%d' expects type `int', but argument
                            3 has type `long unsigned int'
Fix those with casts, whatever the actual type of ARCH_SLAB_MINALIGN.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
Sorry, as akpm points out, the patch I sent first was mime-mangled:
compiler uses non-ASCII quotes in its messages, which mislead my mailer.

 mm/slab.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- mmotm/mm/slab.c	2011-07-05 12:36:54.294718254 -0700
+++ linux/mm/slab.c	2011-07-05 14:19:24.942328542 -0700
@@ -3153,12 +3153,10 @@ static void *cache_alloc_debugcheck_afte
 	objp += obj_offset(cachep);
 	if (cachep->ctor && cachep->flags & SLAB_POISON)
 		cachep->ctor(objp);
-#if ARCH_SLAB_MINALIGN
-	if ((u32)objp & (ARCH_SLAB_MINALIGN-1)) {
+	if ((unsigned long)objp & (ARCH_SLAB_MINALIGN-1)) {
 		printk(KERN_ERR "0x%p: not aligned to ARCH_SLAB_MINALIGN=%d\n",
-		       objp, ARCH_SLAB_MINALIGN);
+		       objp, (int)ARCH_SLAB_MINALIGN);
 	}
-#endif
 	return objp;
 }
 #else
