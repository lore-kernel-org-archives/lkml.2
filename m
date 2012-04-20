Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab2DTPbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:31:49 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:33268 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab2DTPbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:31:44 -0400
Date: Fri, 20 Apr 2012 08:31:34 -0700
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org, Valere Monseur <valere.monseur@ymail.com>,
        Joseph Freeman <jfree143dev@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3.4-rc3] memblock: memblock should be able to handle zero
 length operations
Message-ID: <20120420153134.GA32324@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

24aa07882b "memblock, x86: Replace memblock_x86_reserve/free_range()
with generic ones" replaced x86 specific memblock operations with the
generic ones; unfortunately, it lost zero length operation handling in
the process making the kernel panic if somebody tries to reserve zero
length area.

There isn't much to be gained by being cranky to zero length
operations and panicking is almost the worst response.  Drop the
BUG_ON() in memblock_reserve() and update
memblock_add_region/isolate_range() so that all zero length operations
are handled as noops.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org
Reported-by: Valere Monseur <valere.monseur@ymail.com>
Bisected-by: Joseph Freeman <jfree143dev@gmail.com>
Tested-by: Joseph Freeman <jfree143dev@gmail.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43098
---
This is causing early panics if anyone tries to reserve zero len area,
which unfortunately isn't too uncommon depending on BIOS.  The fix is
fairly safe.  Unsure which tree it should go through.  Cc'ing Linus
and Ingo.

Thanks.

 mm/memblock.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 99f2855..a44eab3 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -330,6 +330,9 @@ static int __init_memblock memblock_add_region(struct memblock_type *type,
 	phys_addr_t end = base + memblock_cap_size(base, &size);
 	int i, nr_new;
 
+	if (!size)
+		return 0;
+
 	/* special case for empty array */
 	if (type->regions[0].size == 0) {
 		WARN_ON(type->cnt != 1 || type->total_size);
@@ -430,6 +433,9 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
 
 	*start_rgn = *end_rgn = 0;
 
+	if (!size)
+		return 0;
+
 	/* we'll create at most two more regions */
 	while (type->cnt + 2 > type->max)
 		if (memblock_double_array(type) < 0)
@@ -514,7 +520,6 @@ int __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
 		     (unsigned long long)base,
 		     (unsigned long long)base + size,
 		     (void *)_RET_IP_);
-	BUG_ON(0 == size);
 
 	return memblock_add_region(_rgn, base, size, MAX_NUMNODES);
 }
