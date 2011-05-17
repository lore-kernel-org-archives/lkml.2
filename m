Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab1EQUrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 16:47:53 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57879 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756566Ab1EQUrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 16:47:52 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Joe Perches <joe@perches.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andy Whitcroft <apw@canonical.com>, Jiri Slaby <jirislaby@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: [PATCH 0/3] v5 Improve task->comm locking situation
Date: Tue, 17 May 2011 13:47:40 -0700
Message-Id: <1305665263-20933-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. Here's v5. Hopefully this is getting close to something
that can be queued for 2.6.40.

Since my commit 4614a696bd1c3a9af3a08f0e5874830a85b889d4, the
current->comm value could be changed by other threads.

This changed the comm locking rules, which previously allowed for
unlocked current->comm access, since only the thread itself could
change its comm.

While this was brought up at the time, it was not considered
problematic, as the comm writing was done in such a way that
only null or incomplete comms could be read. However, recently
folks have made it clear they want to see this issue resolved.

So fair enough, as I opened this can of worms, I should work
to resolve it and this patchset is my initial attempt.

The proposed solution here is to introduce a new spinlock that
exclusively protects the comm value. We use it to serialize
access via get_task_comm() and set_task_comm(). Since some 
comm access is open-coded using the task lock, we preserve
the task locking in set_task_comm for now. Once all comm 
access is converted to using get_task_comm, we can clean that
up as well.

I've also introduced a printk %ptc accessor, which makes the
conversion to locked access simpler (as most uses are for printks)
as well as a checkpatch rule to try to catch any new current->comm
users from being introduced.

New in this version: Added a spin_lock_init in copy_process as
caught by Jiri. Also tweaked the regex as suggested by Joe.

Hopefully this will allow for a smooth transition, where we can
slowly fix up the unlocked current->comm access bit by bit,
reducing the race window with each patch, while not making the
situation any worse then it was yesterday.

Thanks for the comments and feedback so far. 
Any additional comments/feedback would still be appreciated.

thanks
-john


CC: Joe Perches <joe@perches.com>
CC: Michal Nazarewicz <mina86@mina86.com>
CC: Andy Whitcroft <apw@canonical.com>
CC: Jiri Slaby <jirislaby@gmail.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: David Rientjes <rientjes@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org

John Stultz (3):
  comm: Introduce comm_lock spinlock to protect task->comm access
  printk: Add %ptc to safely print a task's comm
  checkpatch.pl: Add check for task comm references

 fs/exec.c                 |   19 ++++++++++++++++---
 include/linux/init_task.h |    1 +
 include/linux/sched.h     |    5 ++---
 kernel/fork.c             |    1 +
 lib/vsprintf.c            |   24 ++++++++++++++++++++++++
 scripts/checkpatch.pl     |    7 +++++++
 6 files changed, 51 insertions(+), 6 deletions(-)

-- 
1.7.3.2.146.gca209

