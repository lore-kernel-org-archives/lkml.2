Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab2DXWeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:34:18 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:49931 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211Ab2DXWeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:34:15 -0400
Message-Id: <20120424223242.513711422@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:32:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
        Valere Monseur <valere.monseur@ymail.com>,
        Joseph Freeman <jfree143dev@gmail.com>
Subject: [ 06/62] memblock: memblock should be able to handle zero length operations
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit b3dc627cabb33fc95f93da78457770c1b2a364d2 upstream.

Commit 24aa07882b ("memblock, x86: Replace memblock_x86_reserve/
free_range() with generic ones") replaced x86 specific memblock
operations with the generic ones; unfortunately, it lost zero length
operation handling in the process making the kernel panic if somebody
tries to reserve zero length area.

There isn't much to be gained by being cranky to zero length operations
and panicking is almost the worst response.  Drop the BUG_ON() in
memblock_reserve() and update memblock_add_region/isolate_range() so
that all zero length operations are handled as noops.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Valere Monseur <valere.monseur@ymail.com>
Bisected-by: Joseph Freeman <jfree143dev@gmail.com>
Tested-by: Joseph Freeman <jfree143dev@gmail.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43098
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memblock.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -330,6 +330,9 @@ static int __init_memblock memblock_add_
 	phys_addr_t end = base + memblock_cap_size(base, &size);
 	int i, nr_new;
 
+	if (!size)
+		return 0;
+
 	/* special case for empty array */
 	if (type->regions[0].size == 0) {
 		WARN_ON(type->cnt != 1 || type->total_size);
@@ -430,6 +433,9 @@ static int __init_memblock memblock_isol
 
 	*start_rgn = *end_rgn = 0;
 
+	if (!size)
+		return 0;
+
 	/* we'll create at most two more regions */
 	while (type->cnt + 2 > type->max)
 		if (memblock_double_array(type) < 0)
@@ -514,7 +520,6 @@ int __init_memblock memblock_reserve(phy
 		     (unsigned long long)base,
 		     (unsigned long long)base + size,
 		     (void *)_RET_IP_);
-	BUG_ON(0 == size);
 
 	return memblock_add_region(_rgn, base, size, MAX_NUMNODES);
 }


