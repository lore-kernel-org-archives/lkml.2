Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab1HBJyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 05:54:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37374 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1HBJyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 05:54:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=Dulir3krlheclF3tqy8HQe28BEk3heowPyfxi0oD8xHCf7IAsccDrueF7VdDu0zl6
	R8FtRcG9f8D8qb7bFvdlA==
Date: Tue, 2 Aug 2011 02:54:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] oom: change warning for deprecated oom_adj to avoid
 WARN_ONCE()
In-Reply-To: <m2pqko1h38.fsf@firstfloor.org>
Message-ID: <alpine.DEB.2.00.1108020236140.18935@chino.kir.corp.google.com>
References: <20110802005206.GA3832@tassilo.jf.intel.com> <alpine.DEB.2.00.1108011928530.15596@chino.kir.corp.google.com> <m2pqko1h38.fsf@firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Aug 2011, Andi Kleen wrote:

> Simply backtraces are not supposed to happen unless something 
> is really broken. That's not the case here. The old distribution
> works perfectly fine and will continue to do so.
> 

It won't work perfectly fine in a year when the tunable is removed 
completely and the code that was writing OOM_DISABLE to /proc/pid/oom_adj 
just fails and the task that was supposed to be prevented from being 
killed at all costs may now be killed.  The printk_once() over the past 
year didn't get that fixed up like the other applications I mentioned did, 
so we need to attract more attention.

> I still think reverting this patch is the right thing to do.
> 

Reverting the patch is ludicrous, otherwise there is little possibility 
that the remaining users of the deprecated interface will change if they 
haven't done so already.  I'm perfectly happy with changing it to a 
different style of warning other than using WARN_ONCE() like I've already 
said.  That doesn't require a revert.

I'm fine with this patch if Linus would like to apply it.


oom: change warning for deprecated oom_adj to avoid WARN_ONCE()

WARN_ONCE() emits a stack trace to the kernel log which leads userspace 
parsers to interpret it as being a serious error or malfunction within the 
kernel.  Change the warning to appear more like a lockdep warning while 
still trying to preserve the intention of be8f684d73d8 (oom: make 
deprecated use of oom_adj more verbose) to attract more attention to the 
use of a deprecated interface.

Reported-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/proc/base.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1066,6 +1066,7 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
 	char buffer[PROC_NUMBUF];
 	int oom_adjust;
 	unsigned long flags;
+	static bool warning_printed;
 	int err;
 
 	memset(buffer, 0, sizeof(buffer));
@@ -1118,9 +1119,15 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
 	 * Warn that /proc/pid/oom_adj is deprecated, see
 	 * Documentation/feature-removal-schedule.txt.
 	 */
-	WARN_ONCE(1, "%s (%d): /proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead.\n",
-		  current->comm, task_pid_nr(current), task_pid_nr(task),
-		  task_pid_nr(task));
+	if (!warning_printed) {
+		warning_printed = true;
+		printk("\n===============================================================================\n");
+		printk("%s (%d): /proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead.\n",
+			current->comm, task_pid_nr(current), task_pid_nr(task),
+			task_pid_nr(task));
+		printk("===============================================================================\n\n");
+	}
+
 	task->signal->oom_adj = oom_adjust;
 	/*
 	 * Scale /proc/pid/oom_score_adj appropriately ensuring that a maximum
