Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab0HLADk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:03:40 -0400
Received: from kroah.org ([198.145.64.141]:43730 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759319Ab0HKX72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:59:28 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:05 2010
Message-Id: <20100811235505.020257245@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:55:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Teigland <teigland@redhat.com>
Subject: [102/111] dlm: send reply before bast
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Teigland <teigland@redhat.com>

commit cf6620acc0f6fac57968aafef79ab372bdcf6157 upstream.

When the lock master processes a successful operation (request,
convert, cancel, or unlock), it will process the effects of the
change before sending the reply for the operation.  The "effects"
of the operation are:

- blocking callbacks (basts) for any newly granted locks
- waiting or converting locks that can now be granted

The cast is queued on the local node when the reply from the lock
master is received.  This means that a lock holder can receive a
bast for a lock mode that is doesn't yet know has been granted.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/dlm/lock.c |  110 ++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 84 insertions(+), 26 deletions(-)

--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -2280,20 +2280,30 @@ static int do_request(struct dlm_rsb *r,
 	if (can_be_queued(lkb)) {
 		error = -EINPROGRESS;
 		add_lkb(r, lkb, DLM_LKSTS_WAITING);
-		send_blocking_asts(r, lkb);
 		add_timeout(lkb);
 		goto out;
 	}
 
 	error = -EAGAIN;
-	if (force_blocking_asts(lkb))
-		send_blocking_asts_all(r, lkb);
 	queue_cast(r, lkb, -EAGAIN);
-
  out:
 	return error;
 }
 
+static void do_request_effects(struct dlm_rsb *r, struct dlm_lkb *lkb,
+			       int error)
+{
+	switch (error) {
+	case -EAGAIN:
+		if (force_blocking_asts(lkb))
+			send_blocking_asts_all(r, lkb);
+		break;
+	case -EINPROGRESS:
+		send_blocking_asts(r, lkb);
+		break;
+	}
+}
+
 static int do_convert(struct dlm_rsb *r, struct dlm_lkb *lkb)
 {
 	int error = 0;
@@ -2304,7 +2314,6 @@ static int do_convert(struct dlm_rsb *r,
 	if (can_be_granted(r, lkb, 1, &deadlk)) {
 		grant_lock(r, lkb);
 		queue_cast(r, lkb, 0);
-		grant_pending_locks(r);
 		goto out;
 	}
 
@@ -2334,7 +2343,6 @@ static int do_convert(struct dlm_rsb *r,
 		if (_can_be_granted(r, lkb, 1)) {
 			grant_lock(r, lkb);
 			queue_cast(r, lkb, 0);
-			grant_pending_locks(r);
 			goto out;
 		}
 		/* else fall through and move to convert queue */
@@ -2344,28 +2352,47 @@ static int do_convert(struct dlm_rsb *r,
 		error = -EINPROGRESS;
 		del_lkb(r, lkb);
 		add_lkb(r, lkb, DLM_LKSTS_CONVERT);
-		send_blocking_asts(r, lkb);
 		add_timeout(lkb);
 		goto out;
 	}
 
 	error = -EAGAIN;
-	if (force_blocking_asts(lkb))
-		send_blocking_asts_all(r, lkb);
 	queue_cast(r, lkb, -EAGAIN);
-
  out:
 	return error;
 }
 
+static void do_convert_effects(struct dlm_rsb *r, struct dlm_lkb *lkb,
+			       int error)
+{
+	switch (error) {
+	case 0:
+		grant_pending_locks(r);
+		/* grant_pending_locks also sends basts */
+		break;
+	case -EAGAIN:
+		if (force_blocking_asts(lkb))
+			send_blocking_asts_all(r, lkb);
+		break;
+	case -EINPROGRESS:
+		send_blocking_asts(r, lkb);
+		break;
+	}
+}
+
 static int do_unlock(struct dlm_rsb *r, struct dlm_lkb *lkb)
 {
 	remove_lock(r, lkb);
 	queue_cast(r, lkb, -DLM_EUNLOCK);
-	grant_pending_locks(r);
 	return -DLM_EUNLOCK;
 }
 
+static void do_unlock_effects(struct dlm_rsb *r, struct dlm_lkb *lkb,
+			      int error)
+{
+	grant_pending_locks(r);
+}
+
 /* returns: 0 did nothing, -DLM_ECANCEL canceled lock */
  
 static int do_cancel(struct dlm_rsb *r, struct dlm_lkb *lkb)
@@ -2375,12 +2402,18 @@ static int do_cancel(struct dlm_rsb *r,
 	error = revert_lock(r, lkb);
 	if (error) {
 		queue_cast(r, lkb, -DLM_ECANCEL);
-		grant_pending_locks(r);
 		return -DLM_ECANCEL;
 	}
 	return 0;
 }
 
+static void do_cancel_effects(struct dlm_rsb *r, struct dlm_lkb *lkb,
+			      int error)
+{
+	if (error)
+		grant_pending_locks(r);
+}
+
 /*
  * Four stage 3 varieties:
  * _request_lock(), _convert_lock(), _unlock_lock(), _cancel_lock()
@@ -2402,11 +2435,15 @@ static int _request_lock(struct dlm_rsb
 		goto out;
 	}
 
-	if (is_remote(r))
+	if (is_remote(r)) {
 		/* receive_request() calls do_request() on remote node */
 		error = send_request(r, lkb);
-	else
+	} else {
 		error = do_request(r, lkb);
+		/* for remote locks the request_reply is sent
+		   between do_request and do_request_effects */
+		do_request_effects(r, lkb, error);
+	}
  out:
 	return error;
 }
@@ -2417,11 +2454,15 @@ static int _convert_lock(struct dlm_rsb
 {
 	int error;
 
-	if (is_remote(r))
+	if (is_remote(r)) {
 		/* receive_convert() calls do_convert() on remote node */
 		error = send_convert(r, lkb);
-	else
+	} else {
 		error = do_convert(r, lkb);
+		/* for remote locks the convert_reply is sent
+		   between do_convert and do_convert_effects */
+		do_convert_effects(r, lkb, error);
+	}
 
 	return error;
 }
@@ -2432,11 +2473,15 @@ static int _unlock_lock(struct dlm_rsb *
 {
 	int error;
 
-	if (is_remote(r))
+	if (is_remote(r)) {
 		/* receive_unlock() calls do_unlock() on remote node */
 		error = send_unlock(r, lkb);
-	else
+	} else {
 		error = do_unlock(r, lkb);
+		/* for remote locks the unlock_reply is sent
+		   between do_unlock and do_unlock_effects */
+		do_unlock_effects(r, lkb, error);
+	}
 
 	return error;
 }
@@ -2447,11 +2492,15 @@ static int _cancel_lock(struct dlm_rsb *
 {
 	int error;
 
-	if (is_remote(r))
+	if (is_remote(r)) {
 		/* receive_cancel() calls do_cancel() on remote node */
 		error = send_cancel(r, lkb);
-	else
+	} else {
 		error = do_cancel(r, lkb);
+		/* for remote locks the cancel_reply is sent
+		   between do_cancel and do_cancel_effects */
+		do_cancel_effects(r, lkb, error);
+	}
 
 	return error;
 }
@@ -3191,6 +3240,7 @@ static void receive_request(struct dlm_l
 	attach_lkb(r, lkb);
 	error = do_request(r, lkb);
 	send_request_reply(r, lkb, error);
+	do_request_effects(r, lkb, error);
 
 	unlock_rsb(r);
 	put_rsb(r);
@@ -3226,15 +3276,19 @@ static void receive_convert(struct dlm_l
 		goto out;
 
 	receive_flags(lkb, ms);
+
 	error = receive_convert_args(ls, lkb, ms);
-	if (error)
-		goto out_reply;
+	if (error) {
+		send_convert_reply(r, lkb, error);
+		goto out;
+	}
+
 	reply = !down_conversion(lkb);
 
 	error = do_convert(r, lkb);
- out_reply:
 	if (reply)
 		send_convert_reply(r, lkb, error);
+	do_convert_effects(r, lkb, error);
  out:
 	unlock_rsb(r);
 	put_rsb(r);
@@ -3266,13 +3320,16 @@ static void receive_unlock(struct dlm_ls
 		goto out;
 
 	receive_flags(lkb, ms);
+
 	error = receive_unlock_args(ls, lkb, ms);
-	if (error)
-		goto out_reply;
+	if (error) {
+		send_unlock_reply(r, lkb, error);
+		goto out;
+	}
 
 	error = do_unlock(r, lkb);
- out_reply:
 	send_unlock_reply(r, lkb, error);
+	do_unlock_effects(r, lkb, error);
  out:
 	unlock_rsb(r);
 	put_rsb(r);
@@ -3307,6 +3364,7 @@ static void receive_cancel(struct dlm_ls
 
 	error = do_cancel(r, lkb);
 	send_cancel_reply(r, lkb, error);
+	do_cancel_effects(r, lkb, error);
  out:
 	unlock_rsb(r);
 	put_rsb(r);


