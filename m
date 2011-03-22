Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab1CVNb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 09:31:28 -0400
Received: from linux-sh.org ([111.68.239.195]:33548 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab1CVNb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 09:31:26 -0400
Date: Tue, 22 Mar 2011 22:30:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: page allocator: Silence build_all_zonelists() section mismatch.
Message-ID: <20110322133045.GA24498@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memory hotplug case involves calling to build_all_zonelists() which
in turns calls in to setup_zone_pageset(). The latter is marked
__meminit while build_all_zonelists() itself has no particular
annotation. build_all_zonelists() is only handed a non-NULL pointer in
the case of memory hotplug through an existing __meminit path, so the
setup_zone_pageset() reference is always safe.

The options as such are either to flag build_all_zonelists() as __ref (as
per __build_all_zonelists()), or to simply discard the __meminit
annotation from setup_zone_pageset().

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

While discarding the __meminit annotation from setup_zone_pageset() is
probably cleanest I expected some people would take issue with this so
opted for the more visually offensive __ref route. I can resend for the
other way if people prefer, or someone else can do it given that it's a
trivial change.

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7945247..134e0b8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3110,7 +3110,7 @@ static __init_refok int __build_all_zonelists(void *data)
  * Called with zonelists_mutex held always
  * unless system_state == SYSTEM_BOOTING.
  */
-void build_all_zonelists(void *data)
+void __ref build_all_zonelists(void *data)
 {
 	set_zonelist_order();
 
