Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab1H0O42 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:56:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab1H0O4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:56:23 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 15:01:20 2011
Message-Id: <20110826220120.404233543@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:58:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Clemens Ladisch <clemens@ladisch.de>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Nick Piggin <npiggin@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: [08/19] mm: fix wrong vmap address calculations with odd NR_CPUS values
In-Reply-To: <20110826220137.GA14059@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit f982f91516fa4cfd9d20518833cd04ad714585be upstream.

Commit db64fe02258f ("mm: rewrite vmap layer") introduced code that does
address calculations under the assumption that VMAP_BLOCK_SIZE is a
power of two.  However, this might not be true if CONFIG_NR_CPUS is not
set to a power of two.

Wrong vmap_block index/offset values could lead to memory corruption.
However, this has never been observed in practice (or never been
diagnosed correctly); what caught this was the BUG_ON in vb_alloc() that
checks for inconsistent vmap_block indices.

To fix this, ensure that VMAP_BLOCK_SIZE always is a power of two.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=31572
Reported-by: Pavel Kysilka <goldenfish@linuxsoft.cz>
Reported-by: Matias A. Fonzo <selk@dragora.org>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/vmalloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -671,9 +671,10 @@ static void free_unmap_vmap_area_addr(un
 #define VMAP_BBMAP_BITS_MIN	(VMAP_MAX_ALLOC*2)
 #define VMAP_MIN(x, y)		((x) < (y) ? (x) : (y)) /* can't use min() */
 #define VMAP_MAX(x, y)		((x) > (y) ? (x) : (y)) /* can't use max() */
-#define VMAP_BBMAP_BITS		VMAP_MIN(VMAP_BBMAP_BITS_MAX,		\
-					VMAP_MAX(VMAP_BBMAP_BITS_MIN,	\
-						VMALLOC_PAGES / NR_CPUS / 16))
+#define VMAP_BBMAP_BITS		\
+		VMAP_MIN(VMAP_BBMAP_BITS_MAX,	\
+		VMAP_MAX(VMAP_BBMAP_BITS_MIN,	\
+			VMALLOC_PAGES / roundup_pow_of_two(NR_CPUS) / 16))
 
 #define VMAP_BLOCK_SIZE		(VMAP_BBMAP_BITS * PAGE_SIZE)
 


