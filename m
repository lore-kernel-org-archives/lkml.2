Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161310Ab2JXVuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:50:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:40905 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161252Ab2JXVui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:50:38 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        "David S. Ahern" <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/12] Account the nr_entries in rblist properly
Date: Wed, 24 Oct 2012 19:50:15 -0200
Message-Id: <1351115423-9025-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351115423-9025-1-git-send-email-acme@infradead.org>
References: <1351115423-9025-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Suzuki K. Poulose" <suzuki@in.ibm.com>

The nr_entries in rblist is never decremented when an element
is deleted. Also, use rblist__remove_node to delete a node in
rblist__delete(). This would keep the nr_entries sane.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Acked-by: David S. Ahern <dsahern@gmail.com>
Cc: David S. Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/20120831070834.14806.87398.stgit@suzukikp.in.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/rblist.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/rblist.c b/tools/perf/util/rblist.c
index 0171fb6..a16cdd2 100644
--- a/tools/perf/util/rblist.c
+++ b/tools/perf/util/rblist.c
@@ -44,6 +44,7 @@ int rblist__add_node(struct rblist *rblist, const void *new_entry)
 void rblist__remove_node(struct rblist *rblist, struct rb_node *rb_node)
 {
 	rb_erase(rb_node, &rblist->entries);
+	--rblist->nr_entries;
 	rblist->node_delete(rblist, rb_node);
 }
 
@@ -87,8 +88,7 @@ void rblist__delete(struct rblist *rblist)
 		while (next) {
 			pos = next;
 			next = rb_next(pos);
-			rb_erase(pos, &rblist->entries);
-			rblist->node_delete(rblist, pos);
+			rblist__remove_node(rblist, pos);
 		}
 		free(rblist);
 	}
-- 
1.7.9.2.358.g22243

