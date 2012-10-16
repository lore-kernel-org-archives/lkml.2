Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab2JPLRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 07:17:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52679 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab2JPLRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 07:17:31 -0400
From: Matthieu CASTET <matthieu.castet@parrot.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel'" <linux-arm-kernel@lists.infradead.org>
Cc: Matthieu CASTET <castet.matthieu@free.fr>,
        Matthieu Castet <matthieu.castet@parrot.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] slab : allow SLAB_RED_ZONE and SLAB_STORE_USER to work on arm
Date: Tue, 16 Oct 2012 13:17:11 +0200
Message-Id: <1350386231-770-1-git-send-email-matthieu.castet@parrot.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthieu CASTET <castet.matthieu@free.fr>

on cortexA8 (omap3) ralign is 64 and __alignof__(unsigned long long) is 8.
So we always disable debug.

This patch is based on 5c5e3b33b7cb959a401f823707bee006caadd76e, but fix
case were align < sizeof(unsigned long long).

Signed-off-by: Matthieu Castet <matthieu.castet@parrot.com>
CC: Russell King <rmk@arm.linux.org.uk>
CC: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slab.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index c685475..8427901 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2462,9 +2462,6 @@ __kmem_cache_create (const char *name, size_t size, size_t align,
 	if (ralign < align) {
 		ralign = align;
 	}
-	/* disable debug if necessary */
-	if (ralign > __alignof__(unsigned long long))
-		flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
 	/*
 	 * 4) Store it.
 	 */
@@ -2491,8 +2488,9 @@ __kmem_cache_create (const char *name, size_t size, size_t align,
 	 */
 	if (flags & SLAB_RED_ZONE) {
 		/* add space for red zone words */
-		cachep->obj_offset += sizeof(unsigned long long);
-		size += 2 * sizeof(unsigned long long);
+		int offset = max(align, sizeof(unsigned long long));
+		cachep->obj_offset += offset;
+		size += offset + sizeof(unsigned long long);
 	}
 	if (flags & SLAB_STORE_USER) {
 		/* user store requires one word storage behind the end of
-- 
1.7.10.4

