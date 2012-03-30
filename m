Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935113Ab2C3WvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:51:17 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41906 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934994Ab2C3VGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:06:12 -0400
Message-Id: <201203302105.q2UL58Z8006306@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 30 Mar 2012 15:46:29 -0400
Subject: [PATCH] arch/tile: use atomic exchange in arch_write_unlock()
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:08.0772 (UTC) FILETIME=[C9E6A640:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This idiom is used elsewhere when we do an unlock by writing a zero,
but I missed it here.  Using an atomic operation avoids waiting
on the write buffer for the unlocking write to be sent to the home cache.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/spinlock_64.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/tile/include/asm/spinlock_64.h b/arch/tile/include/asm/spinlock_64.h
index 72be590..5f8b6a0 100644
--- a/arch/tile/include/asm/spinlock_64.h
+++ b/arch/tile/include/asm/spinlock_64.h
@@ -137,7 +137,7 @@ static inline void arch_read_unlock(arch_rwlock_t *rw)
 static inline void arch_write_unlock(arch_rwlock_t *rw)
 {
 	__insn_mf();
-	rw->lock = 0;
+	__insn_exch4(&rw->lock, 0);  /* Avoid waiting in the write buffer. */
 }
 
 static inline int arch_read_trylock(arch_rwlock_t *rw)
-- 
1.6.5.2

