Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab1AORB2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 12:01:28 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60784 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab1AORBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 12:01:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HBqmFhXea0UxD568dW7ryEaUl8gkxyENvzYTYJg34LJvrzxJ0sthnHI6p+dkbFO74Z
         gWrnS3NaN9jkEuQAVVCWV+YCxm1zPglx+HwIP5boo4+hzaDV21lkpf09M5BMiGWVorId
         /ur7zlKV5dw+kEja+ay6D7EzTMdfwtQIeAihE=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jack Stone <jwjstone@fastmail.fm>, Viresh Kumar <viresh.kumar@st.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Davide Libenzi <davidel@xmailserver.org>,
        Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 2/3] epoll: short circuit the timeout==0 case
Date: Sat, 15 Jan 2011 11:00:36 -0600
Message-Id: <1295110837-3061-2-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20110115162027.GA2552@lintop>
References: <20110115162027.GA2552@lintop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a timeout == 0 is specified we will return immediately even if there
are no events so there is no need to enter the polling loop.

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 fs/eventpoll.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index c24a032..57a77f5 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1121,6 +1121,10 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 	struct timespec end_time;
 	ktime_t expires, *to = NULL;
 
+	/*
+	 * A negative timeout means wait indefinitely and leaves 'to' NULL for
+	 * an infinite timeout.
+	 */
 	if (timeout > 0) {
 		ktime_get_ts(&end_time);
 		timespec_add_ns(&end_time, (u64)timeout * NSEC_PER_MSEC);
@@ -1128,7 +1132,12 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		to = &expires;
 		*to = timespec_to_ktime(end_time);
 	} else if (timeout == 0) {
+		/*
+		 * Return immediately even if no events are available.
+		 */
 		timed_out = 1;
+		spin_lock_irqsave(&ep->lock, flags);
+		goto skip;
 	}
 
 retry:
@@ -1146,9 +1155,10 @@ retry:
 
 		for (;;) {
 			/*
-			 * We don't want to sleep if the ep_poll_callback() sends us
-			 * a wakeup in between. That's why we set the task state
-			 * to TASK_INTERRUPTIBLE before doing the checks.
+			 * We don't want to sleep if the ep_poll_callback()
+			 * sends us a wakeup in between. That's why we set the
+			 * task state to TASK_INTERRUPTIBLE before doing the
+			 * checks.
 			 */
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (!list_empty(&ep->rdllist) || timed_out)
@@ -1168,6 +1178,7 @@ retry:
 
 		set_current_state(TASK_RUNNING);
 	}
+skip:
 	/* Is it worth to try to dig for events ? */
 	eavail = !list_empty(&ep->rdllist) || ep->ovflist != EP_UNACTIVE_PTR;
 
-- 
1.7.3.4

