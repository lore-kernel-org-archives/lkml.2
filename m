Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750934Ab1HVEBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 00:01:52 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:23283
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806Ab1HVEBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 00:01:50 -0400
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Aug 2011 00:01:50 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EADDSUU7LO5kB/2dsb2JhbABBhEujSHeBQAEpBFIoCAUCGA4CSRYTrRSQOYEshAyBEASHXpBgi1k
X-IronPort-AV: E=Sophos;i="4.68,261,1312128000"; 
   d="scan'208";a="765105065"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH] autofs4 - fix lockdep splat in autofs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 22 Aug 2011 11:52:28 +0800
Message-ID: <20110822035228.13189.62994.stgit@perseus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

When recursing down the locks when traversing a tree/list in
get_next_positive_dentry() or get_next_positive_subdir() a lock can
change from being nested to being a parent which breaks lockdep. This
patch tells lockdep about what we did.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/expire.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 450f529..1feb68e 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -124,6 +124,7 @@ start:
 	/* Negative dentry - try next */
 	if (!simple_positive(q)) {
 		spin_unlock(&p->d_lock);
+		lock_set_subclass(&q->d_lock.dep_map, 0, _RET_IP_);
 		p = q;
 		goto again;
 	}
@@ -186,6 +187,7 @@ again:
 	/* Negative dentry - try next */
 	if (!simple_positive(ret)) {
 		spin_unlock(&p->d_lock);
+		lock_set_subclass(&ret->d_lock.dep_map, 0, _RET_IP_);
 		p = ret;
 		goto again;
 	}

