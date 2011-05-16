Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab1EPVT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:19:29 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:40950 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab1EPVT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:19:28 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, "Ted Ts'o" <tytso@mit.edu>,
        Michal Nazarewicz <mina86@mina86.com>,
        Jiri Slaby <jirislaby@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: [PATCH 0/3] v4 Improve task->comm locking situation
Date: Mon, 16 May 2011 14:19:14 -0700
Message-Id: <1305580757-13175-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

New in this version: Improved checkpatch regex from Jiri Slaby and
Michal Nazarewicz. Also replaced the seqlock with a spinlock to
address the possible starvation case brought up by KOSAKI Motohiro.

Hopefully this will allow for a smooth transition, where we can
slowly fix up the unlocked current->comm access bit by bit,
reducing the race window with each patch, while not making the
situation any worse then it was yesterday.

Thanks for the comments and feedback so far. 
Any additional comments/feedback would still be appreciated.

thanks
-john


CC: Ted Ts'o <tytso@mit.edu>
CC: Michal Nazarewicz <mina86@mina86.com>
CC: Jiri Slaby <jirislaby@gmail.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: David Rientjes <rientjes@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org

John Stultz (3):
  comm: Introduce comm_lock seqlock to protect task->comm access
  printk: Add %ptc to safely print a task's comm
  checkpatch.pl: Add check for task comm references

 fs/exec.c                 |   19 ++++++++++++++++---
 include/linux/init_task.h |    1 +
 include/linux/sched.h     |    5 ++---
 lib/vsprintf.c            |   24 ++++++++++++++++++++++++
 scripts/checkpatch.pl     |    4 ++++
 5 files changed, 47 insertions(+), 6 deletions(-)

-- 
1.7.3.2.146.gca209

