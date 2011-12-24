Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab1LXCBD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 21:01:03 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34577 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab1LXCBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 21:01:00 -0500
From: Jeff Layton <jlayton@redhat.com>
To: rjw@sisk.pl
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] freezer: fix return value of freezable_schedule_timeout_killable
Date: Fri, 23 Dec 2011 21:00:54 -0500
Message-Id: <1324692054-5424-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...it should return the return code from schedule_timeout_killable(),
not the one from freezer_count().

All of the current callers ignore the return code so the bug is
harmless but it's worth fixing.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 include/linux/freezer.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 30f06c2..96b5b59 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -122,9 +122,11 @@ static inline int freezer_should_skip(struct task_struct *p)
 /* Like schedule_timeout_killable(), but should not block the freezer. */
 #define freezable_schedule_timeout_killable(timeout)			\
 ({									\
+	long __retval;							\
 	freezer_do_not_count();						\
-	schedule_timeout_killable(timeout);				\
+	__retval = schedule_timeout_killable(timeout);			\
 	freezer_count();						\
+	__retval;							\
 })
 
 /*
-- 
1.7.7.4

