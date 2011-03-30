Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933342Ab1C3V7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:59:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:15947 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933300Ab1C3VGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903734374"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: tj@kernel.org, roland@redhat.com, oleg@redhat.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [61/275] ptrace: use safer wake up on ptrace_detach()
Message-Id: <20110330210457.E0D393E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/kernel/ptrace.c
===================================================================
--- linux-2.6.35.y.orig/kernel/ptrace.c	2011-03-29 22:51:45.449560230 -0700
+++ linux-2.6.35.y/kernel/ptrace.c	2011-03-29 23:02:59.433314670 -0700
@@ -313,7 +313,7 @@
 		child->exit_code = data;
 		dead = __ptrace_detach(current, child);
 		if (!child->exit_state)
-			wake_up_process(child);
+			wake_up_state(child, TASK_TRACED | TASK_STOPPED);
 	}
 	write_unlock_irq(&tasklist_lock);
 
