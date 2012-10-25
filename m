Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965445Ab2JYIAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 04:00:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38327 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964815Ab2JYIAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 04:00:51 -0400
Date: Thu, 25 Oct 2012 01:00:28 -0700
From: "tip-bot for Suzuki K. Poulose" <suzuki@in.ibm.com>
Message-ID: <tip-03f2f93ae00762eb881424df1c688d034fd341ee@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, suzuki@in.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, suzuki@in.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <20120831070834.14806.87398.stgit@suzukikp.in.ibm.com>
References: <20120831070834.14806.87398.stgit@suzukikp.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] Account the nr_entries in rblist properly
Git-Commit-ID: 03f2f93ae00762eb881424df1c688d034fd341ee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 25 Oct 2012 01:00:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  03f2f93ae00762eb881424df1c688d034fd341ee
Gitweb:     http://git.kernel.org/tip/03f2f93ae00762eb881424df1c688d034fd341ee
Author:     Suzuki K. Poulose <suzuki@in.ibm.com>
AuthorDate: Fri, 31 Aug 2012 12:39:18 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 24 Oct 2012 14:20:11 -0200

Account the nr_entries in rblist properly

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
