Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab2LVB6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 20:58:30 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:43405 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab2LVB6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:58:21 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH 12/25] bluetooth/l2cap: don't use [delayed_]work_pending()
Date: Fri, 21 Dec 2012 17:57:02 -0800
Message-Id: <1356141435-17340-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356141435-17340-1-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to test whether a (delayed) work item in pending
before queueing, flushing or cancelling it.  Most uses are unnecessary
and quite a few of them are buggy.

Reimplement l2cap_set_timer() such that it uses mod_delayed_work() or
schedule_delayed_work() depending on a new param @override and let the
users specify whether to override or not instead of using
delayed_work_pending().

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: linux-bluetooth@vger.kernel.org
---
Please let me know how this patch should be routed.  I can take it
through the workqueue tree if necessary.

Thanks.

 include/net/bluetooth/l2cap.h | 24 ++++++++++++++++--------
 net/bluetooth/l2cap_core.c    |  7 +++----
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index 7588ef4..f12cbeb 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -718,17 +718,25 @@ static inline void l2cap_chan_unlock(struct l2cap_chan *chan)
 }
 
 static inline void l2cap_set_timer(struct l2cap_chan *chan,
-				   struct delayed_work *work, long timeout)
+				   struct delayed_work *work, long timeout,
+				   bool override)
 {
+	bool was_pending;
+
 	BT_DBG("chan %p state %s timeout %ld", chan,
 	       state_to_string(chan->state), timeout);
 
-	/* If delayed work cancelled do not hold(chan)
-	   since it is already done with previous set_timer */
-	if (!cancel_delayed_work(work))
-		l2cap_chan_hold(chan);
+	/* @work should hold a reference to @chan */
+	l2cap_chan_hold(chan);
+
+	if (override)
+		was_pending = mod_delayed_work(system_wq, work, timeout);
+	else
+		was_pending = !schedule_delayed_work(work, timeout);
 
-	schedule_delayed_work(work, timeout);
+	/* if @work was already pending, lose the extra ref */
+	if (was_pending)
+		l2cap_chan_put(chan);
 }
 
 static inline bool l2cap_clear_timer(struct l2cap_chan *chan,
@@ -745,12 +753,12 @@ static inline bool l2cap_clear_timer(struct l2cap_chan *chan,
 	return ret;
 }
 
-#define __set_chan_timer(c, t) l2cap_set_timer(c, &c->chan_timer, (t))
+#define __set_chan_timer(c, t) l2cap_set_timer(c, &c->chan_timer, (t), true)
 #define __clear_chan_timer(c) l2cap_clear_timer(c, &c->chan_timer)
 #define __clear_retrans_timer(c) l2cap_clear_timer(c, &c->retrans_timer)
 #define __clear_monitor_timer(c) l2cap_clear_timer(c, &c->monitor_timer)
 #define __set_ack_timer(c) l2cap_set_timer(c, &chan->ack_timer, \
-		msecs_to_jiffies(L2CAP_DEFAULT_ACK_TO));
+		msecs_to_jiffies(L2CAP_DEFAULT_ACK_TO), true);
 #define __clear_ack_timer(c) l2cap_clear_timer(c, &c->ack_timer)
 
 static inline int __seq_offset(struct l2cap_chan *chan, __u16 seq1, __u16 seq2)
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 2c78208..91db91c 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -246,10 +246,9 @@ static inline void l2cap_chan_set_err(struct l2cap_chan *chan, int err)
 
 static void __set_retrans_timer(struct l2cap_chan *chan)
 {
-	if (!delayed_work_pending(&chan->monitor_timer) &&
-	    chan->retrans_timeout) {
+	if (chan->retrans_timeout) {
 		l2cap_set_timer(chan, &chan->retrans_timer,
-				msecs_to_jiffies(chan->retrans_timeout));
+				msecs_to_jiffies(chan->retrans_timeout), false);
 	}
 }
 
@@ -258,7 +257,7 @@ static void __set_monitor_timer(struct l2cap_chan *chan)
 	__clear_retrans_timer(chan);
 	if (chan->monitor_timeout) {
 		l2cap_set_timer(chan, &chan->monitor_timer,
-				msecs_to_jiffies(chan->monitor_timeout));
+				msecs_to_jiffies(chan->monitor_timeout), true);
 	}
 }
 
-- 
1.8.0.2

