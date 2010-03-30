Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab0CaAfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:35:16 -0400
Received: from kroah.org ([198.145.64.141]:48737 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755447Ab0C3XLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:11:45 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:10 2010
Message-Id: <20100330225809.818167021@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [03/89] futex: Handle user space corruption gracefully
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 51246bfd189064079c54421507236fd2723b18f3 upstream.

If the owner of a PI futex dies we fix up the pi_state and set
pi_state->owner to NULL. When a malicious or just sloppy programmed
user space application sets the futex value to 0 e.g. by calling
pthread_mutex_init(), then the futex can be acquired again. A new
waiter manages to enqueue itself on the pi_state w/o damage, but on
unlock the kernel dereferences pi_state->owner and oopses.

Prevent this by checking pi_state->owner in the unlock path. If
pi_state->owner is not current we know that user space manipulated the
futex value. Ignore the mess and return -EINVAL.

This catches the above case and also the case where a task hijacks the
futex by setting the tid value and then tries to unlock it.

Reported-by: Jermome Marchand <jmarchan@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Darren Hart <dvhltc@us.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/futex.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -776,6 +776,13 @@ static int wake_futex_pi(u32 __user *uad
 	if (!pi_state)
 		return -EINVAL;
 
+	/*
+	 * If current does not own the pi_state then the futex is
+	 * inconsistent and user space fiddled with the futex value.
+	 */
+	if (pi_state->owner != current)
+		return -EINVAL;
+
 	spin_lock(&pi_state->pi_mutex.wait_lock);
 	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
 


