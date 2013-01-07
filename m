Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab3AGVd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 16:33:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38587 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab3AGVdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 16:33:55 -0500
Date: Mon, 7 Jan 2013 13:33:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Jason Liu <r64343@freescale.com>, linux-kernel@vger.kernel.org,
        riel@redhat.com, minchan@kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: compaction: fix echo 1 > compact_memory return
 error issue
Message-Id: <20130107133354.03f2ba80.akpm@linux-foundation.org>
In-Reply-To: <20130107135721.GD3885@suse.de>
References: <1357458273-28558-1-git-send-email-r64343@freescale.com>
	<20130107135721.GD3885@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2013 13:57:21 +0000
Mel Gorman <mgorman@suse.de> wrote:

> On Sun, Jan 06, 2013 at 03:44:33PM +0800, Jason Liu wrote:
> > when run the folloing command under shell, it will return error
> > sh/$ echo 1 > /proc/sys/vm/compact_memory
> > sh/$ sh: write error: Bad address
> > 
> > After strace, I found the following log:
> > ...
> > write(1, "1\n", 2)               = 3
> > write(1, "", 4294967295)         = -1 EFAULT (Bad address)
> > write(2, "echo: write error: Bad address\n", 31echo: write error: Bad address
> > ) = 31
> > 
> > This tells system return 3(COMPACT_COMPLETE) after write data to compact_memory.
> > 
> > The fix is to make the system just return 0 instead 3(COMPACT_COMPLETE) from
> > sysctl_compaction_handler after compaction_nodes finished.
> > 
> > Suggested-by:David Rientjes <rientjes@google.com>
> > Cc:Mel Gorman <mgorman@suse.de>
> > Cc:Andrew Morton <akpm@linux-foundation.org>
> > Cc:Rik van Riel <riel@redhat.com>
> > Cc:Minchan Kim <minchan@kernel.org>
> > Cc:KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Signed-off-by: Jason Liu <r64343@freescale.com>
> 
> Acked-by: Mel Gorman <mgorman@suse.de>

We have a whole pile of things around there which return
information-free integers.  Should we do this?

--- a/mm/compaction.c~mm-compaction-fix-echo-1-compact_memory-return-error-issue-fix
+++ a/mm/compaction.c
@@ -1150,7 +1150,7 @@ unsigned long try_to_compact_pages(struc
 
 
 /* Compact all zones within a node */
-static int __compact_pgdat(pg_data_t *pgdat, struct compact_control *cc)
+static void __compact_pgdat(pg_data_t *pgdat, struct compact_control *cc)
 {
 	int zoneid;
 	struct zone *zone;
@@ -1183,11 +1183,9 @@ static int __compact_pgdat(pg_data_t *pg
 		VM_BUG_ON(!list_empty(&cc->freepages));
 		VM_BUG_ON(!list_empty(&cc->migratepages));
 	}
-
-	return 0;
 }
 
-int compact_pgdat(pg_data_t *pgdat, int order)
+void compact_pgdat(pg_data_t *pgdat, int order)
 {
 	struct compact_control cc = {
 		.order = order,
@@ -1195,10 +1193,10 @@ int compact_pgdat(pg_data_t *pgdat, int 
 		.page = NULL,
 	};
 
-	return __compact_pgdat(pgdat, &cc);
+	__compact_pgdat(pgdat, &cc);
 }
 
-static int compact_node(int nid)
+static void compact_node(int nid)
 {
 	struct compact_control cc = {
 		.order = -1,
@@ -1206,7 +1204,7 @@ static int compact_node(int nid)
 		.page = NULL,
 	};
 
-	return __compact_pgdat(NODE_DATA(nid), &cc);
+	__compact_pgdat(NODE_DATA(nid), &cc);
 }
 
 /* Compact all nodes in the system */
diff -puN include/linux/compaction.h~mm-compaction-fix-echo-1-compact_memory-return-error-issue-fix include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-fix-echo-1-compact_memory-return-error-issue-fix
+++ a/include/linux/compaction.h
@@ -23,7 +23,7 @@ extern int fragmentation_index(struct zo
 extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *mask,
 			bool sync, bool *contended, struct page **page);
-extern int compact_pgdat(pg_data_t *pgdat, int order);
+extern void compact_pgdat(pg_data_t *pgdat, int order);
 extern void reset_isolation_suitable(pg_data_t *pgdat);
 extern unsigned long compaction_suitable(struct zone *zone, int order);
 
@@ -80,9 +80,8 @@ static inline unsigned long try_to_compa
 	return COMPACT_CONTINUE;
 }
 
-static inline int compact_pgdat(pg_data_t *pgdat, int order)
+static inline void compact_pgdat(pg_data_t *pgdat, int order)
 {
-	return COMPACT_CONTINUE;
 }
 
 static inline void reset_isolation_suitable(pg_data_t *pgdat)
_


