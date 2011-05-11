Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab1EKAXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 20:23:13 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:37412 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1EKAXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 20:23:11 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: [RFC][PATCH 0/3] v2 Improve task->comm locking situation
Date: Tue, 10 May 2011 17:23:03 -0700
Message-Id: <1305073386-4810-1-git-send-email-john.stultz@linaro.org>
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

The proposed solution here is to introduce a new seqlock that
exclusively protects the comm value. We use it to serialize
access via get_task_comm() and set_task_comm(). Since some 
comm access is open-coded using the task lock, we preserve
the task locking in set_task_comm for now. Once all comm 
access is converted to using get_task_comm, we can clean that
up as well.

In addition, with this new patch set I've introduced a printk
%ptc accessor, which makes the conversion to locked access
simpler (as most uses are for printks).

Hopefully this will allow for a smooth transition, where we can
slowly fix up the unlocked current->comm access bit by bit,
reducing the race window with each patch, while not making the
situation any worse then it was yesterday.

Also in this patch set I have a an example how I've converted 
comm access in ext4 to use %ptc method. I've got quite a number
of similar patches queued, but wanted to get some feedback on
the approach before I start patchbombing everyone.

Comments/feedback would be appreciated.

thanks
-john


CC: Ted Ts'o <tytso@mit.edu>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: David Rientjes <rientjes@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org

John Stultz (3):
  comm: Introduce comm_lock seqlock to protect task->comm access
  printk: Add %ptc to safely print a task's comm
  comm: ext4: Protect task->comm access by using get_task_comm()

 fs/exec.c                 |   25 ++++++++++++++++++++-----
 fs/ext4/file.c            |    4 ++--
 fs/ext4/super.c           |    8 ++++----
 include/linux/init_task.h |    1 +
 include/linux/sched.h     |    5 ++---
 lib/vsprintf.c            |   27 +++++++++++++++++++++++++++
 6 files changed, 56 insertions(+), 14 deletions(-)

-- 
1.7.3.2.146.gca209

