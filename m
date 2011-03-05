Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab1CETPQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 14:15:16 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:16718 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab1CETPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 14:15:14 -0500
Message-ID: <4D728B8C.2080803@kernel.org>
Date: Sat, 05 Mar 2011 11:14:20 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-mm@kvack.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC] memblock; Properly handle overlaps
References: <1299297946.8833.931.camel@pasglop>	 <4D71CE24.1090302@kernel.org> <1299311788.8833.937.camel@pasglop>
In-Reply-To: <1299311788.8833.937.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D728BAE.0076,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2011 11:56 PM, Benjamin Herrenschmidt wrote:
>>
>> did you try remove and add tricks?
> 
> Yes, and it's a band-wait on top of a wooden leg... (didn't even work
> properly for some real cases I hit with bad FW data, ended up with two
> regions once reserving a portion of the previous one). It doesn't take
> long starting at the implementation of remove() to understand why :-)
> 
> Also, if something like that happens, you expose yourself to rampant
> corruption and other very hard to debug problems, because nothing will
> tell you that the array is corrupted (no longer a monotonic progression)
> and you might get overlapping allocations, allocations spanning reserved
> regions etc... all silently.
> 
> I think the whole thing was long overdue for an overhaul. Hopefully, my
> new code is -much- more robust under all circumstances of full overlap,
> partial overlap, freeing entire regions with multiple blocks in them or
> reserving regions with multiple holes, etc...
> 
> Note that my patch really only rewrite those two low level functions
> (add and remove of a region to a list), so it's reasonably contained and
> should be easy to audit.
> 
> I want to spend a bit more time next week throwing at my userspace
> version some nasty test cases involving non-coalesce boundaries, and
> once that's done, and unless I have some massive bug I haven't seen, I
> think we should just merge the patch.

please check changes on top your patch regarding memblock_add_region
1. after check with bottom, we need to update the size. otherwise when we checking with top, we could use wrong size, and increase to extra big.
2. before we calling memblock_remove_region() in the loop, it could render blank array. So need to move the special case handle down.

Thanks

Yinghai

---
 mm/memblock.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

Index: linux-2.6/mm/memblock.c
===================================================================
--- linux-2.6.orig/mm/memblock.c
+++ linux-2.6/mm/memblock.c
@@ -279,15 +279,6 @@ static long __init_memblock memblock_add
 	phys_addr_t end = base + size;
 	long i;
 
-	/* If the array is empty, special case, replace the fake
-	 * filler region and return
-	 */
-	if ((type->cnt == 1) && (type->regions[0].size == 0)) {
-		type->regions[0].base = base;
-		type->regions[0].size = size;
-		return 0;
-	}
-
 	/* First try and coalesce this MEMBLOCK with others */
 	for (i = 0; i < type->cnt; i++) {
 		struct memblock_region *rgn = &type->regions[i];
@@ -330,11 +321,17 @@ static long __init_memblock memblock_add
 			 * coalesced block.
 			 */
 			base = rgn->base + rgn->size;
-		}
 
-		/* Check if e have nothing else to allocate (fully coalesced) */
-		if (base >= end)
-			return 0;
+			/*
+			 * Check if We have nothing else to allocate
+			 * (fully coalesced)
+			 */
+			if (base >= end)
+				return 0;
+
+			/* Update left over size */
+			size = end - base;
+		}
 
 		/* Now check if we overlap or are adjacent with the
 		 * top of a block
@@ -360,6 +357,15 @@ static long __init_memblock memblock_add
 		}
 	}
 
+	/* If the array is empty, special case, replace the fake
+	 * filler region and return
+	 */
+	if ((type->cnt == 1) && (type->regions[0].size == 0)) {
+		type->regions[0].base = base;
+		type->regions[0].size = size;
+		return 0;
+	}
+
  new_block:
 	/* If we are out of space, we fail. It's too late to resize the array
 	 * but then this shouldn't have happened in the first place.
