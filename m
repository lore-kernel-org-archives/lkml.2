Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab1BPAXC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:23:02 -0500
Received: from kroah.org ([198.145.64.141]:49255 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757467Ab1BPAWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:22:49 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:41 2011
Message-Id: <20110216001441.716989903@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [166/272] ptrace: use safer wake up on ptrace_detach()
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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
@@ -313,7 +313,7 @@ int ptrace_detach(struct task_struct *ch
 		child->exit_code = data;
 		dead = __ptrace_detach(current, child);
 		if (!child->exit_state)
-			wake_up_process(child);
+			wake_up_state(child, TASK_TRACED | TASK_STOPPED);
 	}
 	write_unlock_irq(&tasklist_lock);
 


