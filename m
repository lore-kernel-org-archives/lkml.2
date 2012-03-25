Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab2CYU2P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 16:28:15 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51470 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060Ab2CYU2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 16:28:11 -0400
Date: Sun, 25 Mar 2012 16:28:08 -0400 (EDT)
Message-Id: <20120325.162808.1311176271259118121.davem@davemloft.net>
To: acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] perf: Validate address in symbol__inc_addr_samples().
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 25 Mar 2012 13:28:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If addr < sym->start then we are going to access past the end of the
h->addr[] array, since the offset calculated will be huge.

Trigger an assertion instead of randomly scribbling memory when this
situation occurs.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 tools/perf/util/annotate.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index e5a462f..734a503 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -15,6 +15,7 @@
 #include "debug.h"
 #include "annotate.h"
 #include <pthread.h>
+#include <assert.h>
 
 const char 	*disassembler_style;
 
@@ -64,6 +65,7 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 
 	pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map, addr));
 
+	assert(addr >= sym->start);
 	if (addr >= sym->end)
 		return 0;
 
-- 
1.7.9.1

