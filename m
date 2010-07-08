Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab0GHEhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 00:37:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42753 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab0GHEhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 00:37:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=k1HyyUo85IWJoozJrfbbTc3KzaRGpzHhAAlCr6VGjCIsn4feVG9j57Podc4bFiGb5V
         r3xdemzbGGyEWW4eWYTZbMIRLq338pcxspRZEjrwMS5XQa7j/RanazAp5tp8L9wTXHaB
         60SD5Pg2tjIWgyjsGqJ7pshTB5LgDNZoVSEfE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       "2.6.31.x-2.6.34.x" <stable@kernel.org>
Subject: [PATCH 1/2] perf: Resurrect flat callchains
Date: Thu,  8 Jul 2010 06:36:50 +0200
Message-Id: <1278563811-21818-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1278563811-21818-1-git-send-regression-fweisbec@gmail.com>
References: <1278563811-21818-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: 2.6.31.x-2.6.34.x <stable@kernel.org>
---
 tools/perf/util/callchain.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 1ca73e4..22dbaec 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -49,6 +49,9 @@ static inline void callchain_init(struct callchain_node *node)
 	INIT_LIST_HEAD(&node->brothers);
 	INIT_LIST_HEAD(&node->children);
 	INIT_LIST_HEAD(&node->val);
+
+	node->parent = NULL;
+	node->hit = 0;
 }
 
 static inline u64 cumul_hits(struct callchain_node *node)
-- 
1.6.2.3

