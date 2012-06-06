Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab2FFOwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:52:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756040Ab2FFOwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:52:33 -0400
Date: Wed, 6 Jun 2012 16:50:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] uprobes: change build_map_info() to try
	kmalloc(GFP_NOWAIT) first
Message-ID: <20120606145009.GC24078@redhat.com>
References: <20120604145238.GA6408@redhat.com> <20120606144933.GA24078@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120606144933.GA24078@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

build_map_info() doesn't allocate the memory under i_mmap_mutex
to avoid the deadlock with page reclaim. But it can try GFP_NOWAIT
first, it should work in the likely case and thus we almost never
need the pre-alloc-and-retry path.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index a1bbcab..88e903d 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -771,6 +771,16 @@ build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
 		if (!valid_vma(vma, is_register))
 			continue;
 
+		if (!prev && !more) {
+			/*
+			 * Needs GFP_NOWAIT to avoid i_mmap_mutex recursion through
+			 * reclaim. This is optimistic, no harm done if it fails.
+			 */
+			prev = kmalloc(sizeof(struct map_info),
+					GFP_NOWAIT | __GFP_NOMEMALLOC | __GFP_NOWARN);
+			if (prev)
+				prev->next = NULL;
+		}
 		if (!prev) {
 			more++;
 			continue;
-- 
1.5.5.1


