Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab0LFQ6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:58:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:59712 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab0LFQ61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:58:27 -0500
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/16] signal: fix CLD_CONTINUED notification target
Date: Mon,  6 Dec 2010 17:56:50 +0100
Message-Id: <1291654624-6230-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291654624-6230-1-git-send-email-tj@kernel.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 16:57:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CLD_CONTINUED notification code calls do_notify_parent_cldstop() with
its group_leader; however, do_notify_parent_cldstop() already uses the
group_leader for non-ptraced notifications.  The duplicate
->group_leader dereferencing is unnecessary and leads to incorrectly
notifying the group_leader's ptracer of CLD_CONTINUED from a different
task in the group.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 kernel/signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index fe004b5..0411131 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1867,7 +1867,7 @@ relock:
 
 		if (why) {
 			read_lock(&tasklist_lock);
-			do_notify_parent_cldstop(current->group_leader, why);
+			do_notify_parent_cldstop(current, why);
 			read_unlock(&tasklist_lock);
 		}
 		goto relock;
-- 
1.7.1

