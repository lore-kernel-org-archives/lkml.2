Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106Ab2IGGD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:03:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55037 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759017Ab2IGGD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:03:57 -0400
Date: Thu, 6 Sep 2012 23:03:37 -0700
From: "tip-bot for Suzuki K. Poulose" <suzuki@in.ibm.com>
Message-ID: <tip-60ebf328762914b80d3e4e5f07bda599043c8eda@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, suzuki@in.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, suzuki@in.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <20120831065840.5167.90318.stgit@suzukikp.in.ibm.com>
References: <20120831065840.5167.90318.stgit@suzukikp.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix intlist node removal
Git-Commit-ID: 60ebf328762914b80d3e4e5f07bda599043c8eda
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 06 Sep 2012 23:03:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60ebf328762914b80d3e4e5f07bda599043c8eda
Gitweb:     http://git.kernel.org/tip/60ebf328762914b80d3e4e5f07bda599043c8eda
Author:     Suzuki K. Poulose <suzuki@in.ibm.com>
AuthorDate: Fri, 31 Aug 2012 12:28:47 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Sep 2012 17:35:24 -0300

perf tools: Fix intlist node removal

Similar to the one in :
	https://lkml.org/lkml/2012/8/29/27

Make sure we remove the node from the rblist before we delete the node.
The rblist__remove_node() will invoke rblist->node_delete, which  will
take care of deleting the node with the suitable function provided by
the user.

Signed-off-by: Suzuki K Poulose <suzuki@in.ibm.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Suzuki K Poulose <suzuki@in.ibm.com>
Link: http://lkml.kernel.org/r/20120831065840.5167.90318.stgit@suzukikp.in.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/intlist.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/intlist.c b/tools/perf/util/intlist.c
index fd530dc..77c504f 100644
--- a/tools/perf/util/intlist.c
+++ b/tools/perf/util/intlist.c
@@ -52,9 +52,9 @@ int intlist__add(struct intlist *ilist, int i)
 	return rblist__add_node(&ilist->rblist, (void *)((long)i));
 }
 
-void intlist__remove(struct intlist *ilist __used, struct int_node *node)
+void intlist__remove(struct intlist *ilist, struct int_node *node)
 {
-	int_node__delete(node);
+	rblist__remove_node(&ilist->rblist, &node->rb_node);
 }
 
 struct int_node *intlist__find(struct intlist *ilist, int i)
