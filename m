Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab2KXSDG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 13:03:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab2KXSCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 13:02:35 -0500
Date: Sat, 24 Nov 2012 19:02:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] uprobes: Change filter_chain() to iterate ->consumers
	list
Message-ID: <20121124180231.GA30983@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121124180213.GA30963@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that it safe to use ->consumer_rwsem under ->mmap_sem we can
almost finish the implementation of filter_chain(). It still lacks
the actual uc->filter(...) call but othewrwise it is ready, just
it pretends that ->filter() always returns true.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 03ffbb5..873c993 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -614,14 +614,19 @@ static int prepare_uprobe(struct uprobe *uprobe, struct file *file,
 
 static bool filter_chain(struct uprobe *uprobe)
 {
-	/*
-	 * TODO:
-	 *	for_each_consumer(uc)
-	 *		if (uc->filter(...))
-	 *			return true;
-	 *	return false;
-	 */
-	return uprobe->consumers != NULL;
+	struct uprobe_consumer *uc;
+	bool ret = false;
+
+	down_read(&uprobe->consumer_rwsem);
+	for (uc = uprobe->consumers; uc; uc = uc->next) {
+		/* TODO: ret = uc->filter(...) */
+		ret = true;
+		if (ret)
+			break;
+	}
+	up_read(&uprobe->consumer_rwsem);
+
+	return ret;
 }
 
 static int
-- 
1.5.5.1

