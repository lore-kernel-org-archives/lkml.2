Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815Ab0CaAgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:36:04 -0400
Received: from kroah.org ([198.145.64.141]:48727 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151Ab0C3XLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:11:44 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:09 2010
Message-Id: <20100330225809.169197817@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [02/89] futex: Handle futex value corruption gracefully
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 59647b6ac3050dd964bc556fe6ef22f4db5b935c upstream.

The WARN_ON in lookup_pi_state which complains about a mismatch
between pi_state->owner->pid and the pid which we retrieved from the
user space futex is completely bogus.

The code just emits the warning and then continues despite the fact
that it detected an inconsistent state of the futex. A conveniant way
for user space to spam the syslog.

Replace the WARN_ON by a consistency check. If the values do not match
return -EINVAL and let user space deal with the mess it created.

This also fixes the missing task_pid_vnr() when we compare the
pi_state->owner pid with the futex value.

Reported-by: Jermome Marchand <jmarchan@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Darren Hart <dvhltc@us.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/futex.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -531,8 +531,25 @@ lookup_pi_state(u32 uval, struct futex_h
 				return -EINVAL;
 
 			WARN_ON(!atomic_read(&pi_state->refcount));
-			WARN_ON(pid && pi_state->owner &&
-				pi_state->owner->pid != pid);
+
+			/*
+			 * When pi_state->owner is NULL then the owner died
+			 * and another waiter is on the fly. pi_state->owner
+			 * is fixed up by the task which acquires
+			 * pi_state->rt_mutex.
+			 *
+			 * We do not check for pid == 0 which can happen when
+			 * the owner died and robust_list_exit() cleared the
+			 * TID.
+			 */
+			if (pid && pi_state->owner) {
+				/*
+				 * Bail out if user space manipulated the
+				 * futex value.
+				 */
+				if (pid != task_pid_vnr(pi_state->owner))
+					return -EINVAL;
+			}
 
 			atomic_inc(&pi_state->refcount);
 			*ps = pi_state;


