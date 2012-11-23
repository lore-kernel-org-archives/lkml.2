Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab2KWU2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 15:28:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172Ab2KWU2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 15:28:09 -0500
Date: Fri, 23 Nov 2012 21:28:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] uprobes: Kill the pointless inode/uc checks in
	register/unregister
Message-ID: <20121123202806.GA18887@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121123202741.GA18858@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

register/unregister verifies that inode/uc != NULL. For what?
This really looks like "hide the potential problem", the caller
should pass the valid data.

register() also checks uc->next == NULL, probably to prevent the
double-register but the caller can do other stupid/wrong things.
If we do this check, then we should document that uc->next should
be cleared before register() and add BUG_ON().

Also add the small comment about the i_size_read() check.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 13b247c..d8e930a 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -844,9 +844,7 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 	struct uprobe *uprobe;
 	int ret;
 
-	if (!inode || !uc || uc->next)
-		return -EINVAL;
-
+	/* Racy, just to catch the obvious mistakes */
 	if (offset > i_size_read(inode))
 		return -EINVAL;
 
@@ -883,9 +881,6 @@ void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consume
 {
 	struct uprobe *uprobe;
 
-	if (!inode || !uc)
-		return;
-
 	uprobe = find_uprobe(inode, offset);
 	if (!uprobe)
 		return;
-- 
1.5.5.1

