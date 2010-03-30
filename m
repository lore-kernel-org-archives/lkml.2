Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab0C3JRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 05:17:01 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45557 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756005Ab0C3JOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 05:14:51 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 04/14] Allow CONFIG_MIGRATION to be set without CONFIG_NUMA or memory hot-remove
Date: Tue, 30 Mar 2010 10:14:39 +0100
Message-Id: <1269940489-5776-5-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1269940489-5776-1-git-send-email-mel@csn.ul.ie>
References: <1269940489-5776-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_MIGRATION currently depends on CONFIG_NUMA or on the architecture
being able to hot-remove memory. The main users of page migration such as
sys_move_pages(), sys_migrate_pages() and cpuset process migration are
only beneficial on NUMA so it makes sense.

As memory compaction will operate within a zone and is useful on both NUMA
and non-NUMA systems, this patch allows CONFIG_MIGRATION to be set if the
user selects CONFIG_COMPACTION as an option.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/Kconfig |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 9c61158..4fd75a0 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -172,6 +172,16 @@ config SPLIT_PTLOCK_CPUS
 	default "4"
 
 #
+# support for memory compaction
+config COMPACTION
+	bool "Allow for memory compaction"
+	def_bool y
+	select MIGRATION
+	depends on EXPERIMENTAL && HUGETLBFS && MMU
+	help
+	  Allows the compaction of memory for the allocation of huge pages.
+
+#
 # support for page migration
 #
 config MIGRATION
@@ -180,9 +190,11 @@ config MIGRATION
 	depends on NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE
 	help
 	  Allows the migration of the physical location of pages of processes
-	  while the virtual addresses are not changed. This is useful for
-	  example on NUMA systems to put pages nearer to the processors accessing
-	  the page.
+	  while the virtual addresses are not changed. This is useful in
+	  two situations. The first is on NUMA systems to put pages nearer
+	  to the processors accessing. The second is when allocating huge
+	  pages as migration can relocate pages to satisfy a huge page
+	  allocation instead of reclaiming.
 
 config PHYS_ADDR_T_64BIT
 	def_bool 64BIT || ARCH_PHYS_ADDR_T_64BIT
-- 
1.6.5

