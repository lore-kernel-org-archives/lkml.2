Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab1KCXH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 19:07:57 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63650 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab1KCXHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 19:07:55 -0400
Date: Thu, 3 Nov 2011 16:07:49 -0700
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@redhat.com>
Subject: [PATCH pm-for-3.2 1/2] freezer: reimplement
 wait_event_freezekillable using freezer_do_not_count/freezer_count()
Message-ID: <20111103230749.GS4417@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

Commit 27920651fe "PM / Freezer: Make fake_signal_wake_up() wake
TASK_KILLABLE tasks too" updated fake_signal_wake_up() used by freezer
to wake up KILLABLE tasks.  Sending unsolicited wakeups to tasks in
killable sleep is dangerous as there are code paths which depend on
tasks not waking up spuriously from KILLABLE sleep.

For example. sys_read() or page can sleep in TASK_KILLABLE assuming
that wait/down/whatever _killable can only fail if we can not return
to the usermode.  TASK_TRACED is another obvious example.

The offending commit was to resolve freezer hang during system PM
operations caused by KILLABLE sleeps in network filesystems.
wait_event_freezekillable(), which depends on the spurious KILLABLE
wakeup, was added by f06ac72e92 "cifs, freezer: add
wait_event_freezekillable and have cifs use it" to be used to
implement killable & freezable sleeps in network filesystems.

To prepare for reverting of 27920651fe, this patch reimplements
wait_event_freezekillable() using freezer_do_not_count/freezer_count()
so that it doesn't depend on the spurious KILLABLE wakeup.  This isn't
very nice but should do for now.

tj: Refreshed patch to apply to linus/master and updated commit
    description on Rafael's request.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jeff Layton <jlayton@redhat.com>
LKML-Reference: <20111102175327.GA4446@redhat.com>
---
 include/linux/freezer.h |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

Index: work/include/linux/freezer.h
===================================================================
--- work.orig/include/linux/freezer.h
+++ work/include/linux/freezer.h
@@ -143,14 +143,9 @@ static inline void set_freezable_with_si
 #define wait_event_freezekillable(wq, condition)			\
 ({									\
 	int __retval;							\
-	do {								\
-		__retval = wait_event_killable(wq,			\
-				(condition) || freezing(current));	\
-		if (__retval && !freezing(current))			\
-			break;						\
-		else if (!(condition))					\
-			__retval = -ERESTARTSYS;			\
-	} while (try_to_freeze());					\
+	freezer_do_not_count();						\
+	__retval = wait_event_killable(wq, (condition));		\
+	freezer_count();						\
 	__retval;							\
 })
 
