Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab0JDV7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 17:59:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59950 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab0JDV7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 17:59:14 -0400
Message-ID: <4CAA4DEC.4000401@kernel.org>
Date: Mon, 04 Oct 2010 14:58:04 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 3/4] x86, memblock: Remove __memblock_x86_find_in_range_size()
References: <4CAA4BD5.4020505@kernel.org>
In-Reply-To: <4CAA4BD5.4020505@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fold it into memblock_x86_find_in_range(), and change bad_addr_size()
to check_reserve_memblock().

So whole memblock_x86_find_in_range_size() code is  more readable.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/memblock.c |   39 +++++++++++----------------------------
 1 file changed, 11 insertions(+), 28 deletions(-)

Index: linux-2.6/arch/x86/mm/memblock.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/memblock.c
+++ linux-2.6/arch/x86/mm/memblock.c
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
@@ -76,10 +53,16 @@ u64 __init memblock_x86_find_in_range_si
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
 
