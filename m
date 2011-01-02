Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1ABH5B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:57:01 -0500
Received: from mail.windriver.com ([147.11.1.11]:35316 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab1ABHXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:08 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 074/260] perf: Initialize callchains roots's childen hits
Date: Sun,  2 Jan 2011 02:16:10 -0500
Message-Id: <1293952756-15010-75-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:28.0726 (UTC) FILETIME=[AC215360:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

commit 5225c45899e872383ca39f5533d28ec63c54b39e upstream.

Each histogram entry has a callchain root that stores the
callchain samples. However we forgot to initialize the
tracking of children hits of these roots, which then got
random values on their creation.

The root children hits is multiplied by the minimum percentage
of hits provided by the user, and the result becomes the minimum
hits expected from children branches. If the random value due
to the uninitialization is big enough, then this minimum number
of hits can be huge and eventually filter every children branches.

The end result was invisible callchains. All we need to
fix this is to initialize the children hits of the root.

Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 tools/perf/util/callchain.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 1b7a389..1121303 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -49,6 +49,7 @@ static inline void callchain_init(struct callchain_node *node)
 	INIT_LIST_HEAD(&node->children);
 	INIT_LIST_HEAD(&node->val);
 
+	node->children_hit = 0;
 	node->parent = NULL;
 	node->hit = 0;
 }
-- 
1.7.3.3

