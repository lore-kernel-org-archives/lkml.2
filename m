Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab0JFG3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 02:29:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:34869 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758571Ab0JFG3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 02:29:13 -0400
Date: Wed, 6 Oct 2010 06:29:00 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de
In-Reply-To: <4CAA4DEC.4000401@kernel.org>
References: <4CAA4DEC.4000401@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/memblock] x86, memblock: Remove __memblock_x86_find_in_range_size()
Message-ID: <tip-16c36f743bf8481d0ba40a6de0af11736095d7cf@git.kernel.org>
Git-Commit-ID: 16c36f743bf8481d0ba40a6de0af11736095d7cf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 06 Oct 2010 06:29:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  16c36f743bf8481d0ba40a6de0af11736095d7cf
Gitweb:     http://git.kernel.org/tip/16c36f743bf8481d0ba40a6de0af11736095d7cf
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 4 Oct 2010 14:58:04 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 5 Oct 2010 21:45:43 -0700

x86, memblock: Remove __memblock_x86_find_in_range_size()

Fold it into memblock_x86_find_in_range(), and change bad_addr_size()
to check_reserve_memblock().

So whole memblock_x86_find_in_range_size() code is more readable.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4CAA4DEC.4000401@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/memblock.c |   39 +++++++++++----------------------------
 1 files changed, 11 insertions(+), 28 deletions(-)

diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
index fd7a040..aa11693 100644
--- a/arch/x86/mm/memblock.c
+++ b/arch/x86/mm/memblock.c
@@ -8,7 +8,7 @@
 #include <linux/range.h>
 
 /* Check for already reserved areas */
-static inline bool __init bad_addr_size(u64 *addrp, u64 *sizep, u64 align)
+static bool __init check_with_memblock_reserved_size(u64 *addrp, u64 *sizep, u64 align)
 {
 	struct memblock_region *r;
 	u64 addr = *addrp, last;
@@ -30,7 +30,7 @@ again:
 			goto again;
 		}
 		if (last <= (r->base + r->size) && addr >= r->base) {
-			(*sizep)++;
+			*sizep = 0;
 			return false;
 		}
 	}
@@ -41,29 +41,6 @@ again:
 	return changed;
 }
 
-static u64 __init __memblock_x86_find_in_range_size(u64 ei_start, u64 ei_last, u64 start,
-			 u64 *sizep, u64 align)
-{
-	u64 addr, last;
-
-	addr = round_up(ei_start, align);
-	if (addr < start)
-		addr = round_up(start, align);
-	if (addr >= ei_last)
-		goto out;
-	*sizep = ei_last - addr;
-	while (bad_addr_size(&addr, sizep, align) && addr + *sizep <= ei_last)
-		;
-	last = addr + *sizep;
-	if (last > ei_last)
-		goto out;
-
-	return addr;
-
-out:
-	return MEMBLOCK_ERROR;
-}
-
 /*
  * Find next free range after start, and size is returned in *sizep
  */
@@ -76,10 +53,16 @@ u64 __init memblock_x86_find_in_range_size(u64 start, u64 *sizep, u64 align)
 		u64 ei_last = ei_start + r->size;
 		u64 addr;
 
-		addr = __memblock_x86_find_in_range_size(ei_start, ei_last, start,
-					 sizep, align);
+		addr = round_up(ei_start, align);
+		if (addr < start)
+			addr = round_up(start, align);
+		if (addr >= ei_last)
+			continue;
+		*sizep = ei_last - addr;
+		while (check_with_memblock_reserved_size(&addr, sizep, align))
+			;
 
-		if (addr != MEMBLOCK_ERROR)
+		if (*sizep)
 			return addr;
 	}
 
