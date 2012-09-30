Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab2I3TlN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 15:41:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab2I3Tkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 15:40:31 -0400
Date: Sun, 30 Sep 2012 21:42:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] uprobes: Don't return success if alloc_uprobe() fails
Message-ID: <20120930194201.GA11319@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120930194119.GA11278@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If alloc_uprobe() fails uprobe_register() should return ENOMEM, not 0.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index a741ba7..3ec114c 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -813,7 +813,9 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 	mutex_lock(uprobes_hash(inode));
 	uprobe = alloc_uprobe(inode, offset);
 
-	if (uprobe && !consumer_add(uprobe, uc)) {
+	if (!uprobe) {
+		ret = -ENOMEM;
+	} else if (!consumer_add(uprobe, uc)) {
 		ret = __uprobe_register(uprobe);
 		if (ret) {
 			uprobe->consumers = NULL;
-- 
1.5.5.1

