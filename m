Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921Ab1BPCFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:05:00 -0500
Received: from kroah.org ([198.145.64.141]:49022 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758325Ab1BPBuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:50:25 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:00 2011
Message-Id: <20110216014700.083208697@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [058/115] ptrace: use safer wake up on ptrace_detach()
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 01e05e9a90b8f4c3997ae0537e87720eb475e532 upstream.

The wake_up_process() call in ptrace_detach() is spurious and not
interlocked with the tracee state.  IOW, the tracee could be running or
sleeping in any place in the kernel by the time wake_up_process() is
called.  This can lead to the tracee waking up unexpectedly which can be
dangerous.

The wake_up is spurious and should be removed but for now reduce its
toxicity by only waking up if the tracee is in TRACED or STOPPED state.

This bug can possibly be used as an attack vector.  I don't think it
will take too much effort to come up with an attack which triggers oops
somewhere.  Most sleeps are wrapped in condition test loops and should
be safe but we have quite a number of places where sleep and wakeup
conditions are expected to be interlocked.  Although the window of
opportunity is tiny, ptrace can be used by non-privileged users and with
some loading the window can definitely be extended and exploited.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Roland McGrath <roland@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -314,7 +314,7 @@ int ptrace_detach(struct task_struct *ch
 		child->exit_code = data;
 		dead = __ptrace_detach(current, child);
 		if (!child->exit_state)
-			wake_up_process(child);
+			wake_up_state(child, TASK_TRACED | TASK_STOPPED);
 	}
 	write_unlock_irq(&tasklist_lock);
 


