Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab0G3R4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:56:08 -0400
Received: from kroah.org ([198.145.64.141]:58500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759959Ab0G3Rzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:55:38 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:41 2010
Message-Id: <20100730175141.053086103@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: [082/205] perf: Resurrect flat callchains
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Frederic Weisbecker <fweisbec@gmail.com>

commit 97aa1052739c6a06cb6b0467dbf410613d20bc97 upstream.

Initialize the callchain radix tree root correctly.

When we walk through the parents, we must stop after the root, but
since it wasn't well initialized, its parent pointer was random.

Also the number of hits was random because uninitialized, hence it
was part of the callchain while the root doesn't contain anything.

This fixes segfaults and percentages followed by empty callchains
while running:

	perf report -g flat

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 tools/perf/util/callchain.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -48,6 +48,9 @@ static inline void callchain_init(struct
 	INIT_LIST_HEAD(&node->brothers);
 	INIT_LIST_HEAD(&node->children);
 	INIT_LIST_HEAD(&node->val);
+
+	node->parent = NULL;
+	node->hit = 0;
 }
 
 static inline u64 cumul_hits(struct callchain_node *node)


