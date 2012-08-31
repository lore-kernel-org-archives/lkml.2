Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab2HaHKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 03:10:17 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:59509 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2HaHKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 03:10:15 -0400
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Subject: [PATCH] [perf] Account the nr_entries in rblist properly
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        "David S. Ahern" <dsahern@gmail.com>
Date: Fri, 31 Aug 2012 12:39:18 +0530
Message-ID: <20120831070834.14806.87398.stgit@suzukikp.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12083107-3568-0000-0000-00000264D840
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nr_entries in rblist is never decremented when an element
is deleted. Also, use rblist__remove_node to delete a node in
rblist__delete(). This would keep the nr_entries sane.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Cc: David S. Ahern <dsahern@gmail.com>
---

 tools/perf/util/rblist.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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

