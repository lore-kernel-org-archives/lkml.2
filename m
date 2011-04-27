Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab1D0USm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:18:42 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37143 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751954Ab1D0USl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:18:41 -0400
Subject: [GIT PULL] parisc fixes for 2.6.39-rc5
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Apr 2011 15:18:38 -0500
Message-ID: <1303935518.2583.27.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two fixes contain the agreed fix for our slub panic (agreed with
the mm folks that we'll define SLUB broken in the !NUMA && DISCONTIGMEM
case, which should fix m86k as well) and another buglet that turned up
examining the parisc discontigmem code.

The patches are here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/parisc-2.6.git#fixes

The short changelog is:

David Rientjes (1):
      [PARISC] set memory ranges in N_NORMAL_MEMORY when onlined

James Bottomley (1):
      [PARISC] slub: fix panic with DISCONTIGMEM

The diffstat is:

 arch/parisc/mm/init.c |    4 +++-
 init/Kconfig          |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

And the full diff are below.

James

---

diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index b7ed8d7..b1d1262 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -266,8 +266,10 @@ static void __init setup_bootmem(void)
 	}
 	memset(pfnnid_map, 0xff, sizeof(pfnnid_map));
 
-	for (i = 0; i < npmem_ranges; i++)
+	for (i = 0; i < npmem_ranges; i++) {
+		node_set_state(i, N_NORMAL_MEMORY);
 		node_set_online(i);
+	}
 #endif
 
 	/*
diff --git a/init/Kconfig b/init/Kconfig
index 56240e7..a7ad8fb 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1226,6 +1226,7 @@ config SLAB
 	  per cpu and per node queues.
 
 config SLUB
+	depends on BROKEN || NUMA || !DISCONTIGMEM
 	bool "SLUB (Unqueued Allocator)"
 	help
 	   SLUB is a slab allocator that minimizes cache line usage


