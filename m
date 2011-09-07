Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab1IGS1D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:27:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756435Ab1IGS1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:27:01 -0400
Date: Wed, 7 Sep 2011 20:22:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: matthltc@us.ibm.com, paul@paulmenage.org,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] freezer: fix wait_event_freezable/__thaw_task races
Message-ID: <20110907182217.GB13909@redhat.com>
References: <1314988070-12244-1-git-send-email-tj@kernel.org> <1314988070-12244-7-git-send-email-tj@kernel.org> <20110904184626.GA30101@redhat.com> <20110905023315.GB9807@htj.dyndns.org> <20110905162012.GA4445@redhat.com> <20110906032846.GA18425@mtj.dyndns.org> <20110906151836.GA15568@redhat.com> <20110906152539.GA16899@redhat.com> <20110906155332.GF18425@mtj.dyndns.org> <20110907182156.GA13909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907182156.GA13909@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_event_freezable() and wait_event_freezable_timeout() stop
the waiting if try_to_freeze() fails. This is not right, we can
race with __thaw_task() and in this case

	- wait_event_freezable() returns the wrong ERESTARTSYS

	- wait_event_freezable_timeout() can return the positive
	  value while condition == F

Change the code to always check __retval/condition before return.

Note: with or without this patch the timeout logic looks strange,
probably we should recalc timeout if try_to_freeze() returns T.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/freezer.h |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- 3.1/include/linux/freezer.h~w_e_f	2011-09-04 20:23:30.000000000 +0200
+++ 3.1/include/linux/freezer.h	2011-09-07 20:00:27.000000000 +0200
@@ -107,32 +107,33 @@ static inline int freezer_should_skip(st
  * Freezer-friendly wrappers around wait_event_interruptible() and
  * wait_event_interruptible_timeout(), originally defined in <linux/wait.h>
  */
-
 #define wait_event_freezable(wq, condition)				\
 ({									\
 	int __retval;							\
-	do {								\
+	for (;;) {							\
 		__retval = wait_event_interruptible(wq, 		\
 				(condition) || freezing(current));	\
-		if (__retval && !freezing(current))			\
+		if (__retval || (condition))				\
 			break;						\
-		else if (!(condition))					\
-			__retval = -ERESTARTSYS;			\
-	} while (try_to_freeze());					\
+		try_to_freeze();					\
+	}								\
 	__retval;							\
 })
 
-
 #define wait_event_freezable_timeout(wq, condition, timeout)		\
 ({									\
 	long __retval = timeout;					\
-	do {								\
+	for (;;) {							\
 		__retval = wait_event_interruptible_timeout(wq,		\
 				(condition) || freezing(current),	\
 				__retval); 				\
-	} while (try_to_freeze());					\
+		if (__retval <= 0 || (condition))			\
+			break;						\
+		try_to_freeze();					\
+	}								\
 	__retval;							\
 })
+
 #else /* !CONFIG_FREEZER */
 static inline bool frozen(struct task_struct *p) { return false; }
 static inline bool freezing(struct task_struct *p) { return false; }

