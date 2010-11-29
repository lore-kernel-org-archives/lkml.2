Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab0K2XQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 18:16:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab0K2XQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 18:16:09 -0500
From: Dave Airlie <airlied@gmail.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: Dave Airlie <airlied@redhat.com>, David S Miller <davem@davemloft.net>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Revert "debug_locks: set oops_in_progress if we will log messages."
Date: Tue, 30 Nov 2010 09:15:46 +1000
Message-Id: <1291072546-28838-1-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

This reverts commit e0fdace10e75dac67d906213b780ff1b1a4cc360.

On-list discussion seems to suggest that the robustness fixes for printk
make this unnecessary and DaveM has also agreed in person at Kernel Summit
and on list.

The main problem with this code is once we hit a lockdep splat we always
keep oops_in_progress set, the console layer uses oops_in_progress with KMS
to decide when it should be showing the oops and not showing X, so it causes
problems around suspend/resume time when a userspace resume can cause a console
switch away from X, only if oops_in_progress is set (which is what we want
if an oops actually is in progress, but not because we had a lockdep splat
2 days prior).

Cc: David S Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 lib/debug_locks.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/lib/debug_locks.c b/lib/debug_locks.c
index 5bf0020..b1c1773 100644
--- a/lib/debug_locks.c
+++ b/lib/debug_locks.c
@@ -8,7 +8,6 @@
  *
  *  Copyright (C) 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
  */
-#include <linux/kernel.h>
 #include <linux/rwsem.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
@@ -39,7 +38,6 @@ int debug_locks_off(void)
 {
 	if (__debug_locks_off()) {
 		if (!debug_locks_silent) {
-			oops_in_progress = 1;
 			console_verbose();
 			return 1;
 		}
-- 
1.7.1

