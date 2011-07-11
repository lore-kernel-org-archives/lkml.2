Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457Ab1GKS4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 14:56:35 -0400
Received: from smtp-out.google.com ([74.125.121.67]:33257 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758418Ab1GKS4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 14:56:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	message-id:user-agent:mime-version:content-type:x-system-of-record;
	b=e7+RtliBgX4A/uk93OS2QJ3LhvpMhj5/4Kcwv/Ll2n8gnEfTwhunbKofm0bIAcz7w
	QWOKK3o5qjz9rMsWFHpsQ==
Date: Mon, 11 Jul 2011 11:56:14 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH next/mmotm] slab: fix DEBUG_SLAB build
Message-ID: <alpine.LSU.2.00.1107111152290.13035@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1088314561-1310410587=:13035"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1088314561-1310410587=:13035
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: QUOTED-PRINTABLE

Fix CONFIG_SLAB=3Dy CONFIG_DEBUG_SLAB=3Dy build error and warnings.

Now that ARCH_SLAB_MINALIGN defaults to __alignof__(unsigned long long),
it is always defined (when slab.h included), but cannot be used in #if:
mm/slab.c: In function =A1cache_alloc_debugcheck_after=A2:
mm/slab.c:3156:5: warning: "__alignof__" is not defined
mm/slab.c:3156:5: error: missing binary operator before token "("
make[1]: *** [mm/slab.o] Error 1

So just remove the #if and #endif lines, but then 64-bit build warns:
mm/slab.c: In function =A1cache_alloc_debugcheck_after=A2:
mm/slab.c:3156:6: warning: cast from pointer to integer of different size
mm/slab.c:3158:10: warning: format =A1%d=A2 expects type =A1int=A2, but arg=
ument
                            3 has type =A1long unsigned int=A2
Fix those with casts, whatever the actual type of ARCH_SLAB_MINALIGN.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/slab.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- mmotm/mm/slab.c=092011-07-05 12:36:54.294718254 -0700
+++ linux/mm/slab.c=092011-07-05 14:19:24.942328542 -0700
@@ -3153,12 +3153,10 @@ static void *cache_alloc_debugcheck_afte
 =09objp +=3D obj_offset(cachep);
 =09if (cachep->ctor && cachep->flags & SLAB_POISON)
 =09=09cachep->ctor(objp);
-#if ARCH_SLAB_MINALIGN
-=09if ((u32)objp & (ARCH_SLAB_MINALIGN-1)) {
+=09if ((unsigned long)objp & (ARCH_SLAB_MINALIGN-1)) {
 =09=09printk(KERN_ERR "0x%p: not aligned to ARCH_SLAB_MINALIGN=3D%d\n",
-=09=09       objp, ARCH_SLAB_MINALIGN);
+=09=09       objp, (int)ARCH_SLAB_MINALIGN);
 =09}
-#endif
 =09return objp;
 }
 #else
--8323584-1088314561-1310410587=:13035--
