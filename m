Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab1D1EE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 00:04:28 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59606 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab1D1EEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 00:04:23 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: [RFC][PATCH 0/3] Improve task->comm locking situation.
Date: Wed, 27 Apr 2011 21:03:28 -0700
Message-Id: <1303963411-2064-1-git-send-email-john.stultz@linaro.org>
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

Hopefully this will allow for a smooth transition, where we can
slowly fix up the unlocked current->comm access bit by bit,
reducing the race window with each patch, while not making the
situation any worse then it was yesterday.

Also in this patch set I have a few examples of how I've
converted comm access to use get_task_comm. I've got quite 
a number of similar patches queued, but wanted to get some
feedback on the approach before I start patchbombing everyone.

Comments/feedback would be appreciated.

thanks
-john

CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: David Rientjes <rientjes@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org

John Stultz (3):
  comm: Introduce comm_lock seqlock to protect task->comm access
  comm: timerstats: Protect task->comm access by using get_task_comm()
  comm: ext4: Protect task->comm access by using get_task_comm()

 fs/exec.c                 |   25 ++++++++++++++++++++-----
 fs/ext4/file.c            |    8 ++++++--
 fs/ext4/super.c           |   13 ++++++++++---
 include/linux/init_task.h |    1 +
 include/linux/sched.h     |    5 ++---
 kernel/timer.c            |    2 +-
 6 files changed, 40 insertions(+), 14 deletions(-)

-- 
1.7.3.2.146.gca209

