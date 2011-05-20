Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935633Ab1ETKlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 06:41:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44405 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935608Ab1ETKlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 06:41:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DD6454E.6060305@jp.fujitsu.com>
Date: Fri, 20 May 2011 19:41:18 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: john.stultz@linaro.org, linux-kernel@vger.kernel.org, joe@perches.com,
        mingo@elte.hu, mina86@mina86.com, apw@canonical.com,
        jirislaby@gmail.com, rientjes@google.com, dave@linux.vnet.ibm.com,
        akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/4] v6 Improve task->comm locking situation
References: <1305682865-27111-1-git-send-email-john.stultz@linaro.org> <BANLkTikV5EUfpXF1PG3wXLXhou2crm_u2Q@mail.gmail.com>
In-Reply-To: <BANLkTikV5EUfpXF1PG3wXLXhou2crm_u2Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/19 4:58), Linus Torvalds wrote:
> On Tue, May 17, 2011 at 6:41 PM, John Stultz<john.stultz@linaro.org>  wrote:
>>
>> While this was brought up at the time, it was not considered
>> problematic, as the comm writing was done in such a way that
>> only null or incomplete comms could be read. However, recently
>> folks have made it clear they want to see this issue resolved.
>
> What folks?
>
> I don't think a new lock (or any lock) is at all appropriate.
>
> There's just no point. Just guarantee that the last byte is always
> zero, and you're done.
>
> If you just guarantee that, THERE IS NO RACE. The last byte never
> changes. You may get odd half-way strings, but you've trivially
> guaranteed that they are C NUL-terminated, with no locking, no memory
> ordering, no nothing.
>
> Anybody who asks for any locking is just being a silly git. Tell them
> to man the f*ck up.
>
> So I'm not going to apply anything like this for 2.6.39, but I'm also
> not going to apply it for 40 or 41 or anything else.
>
> I refuse to accept just stupid unnecessary crap.

Do every body agree this conclusion? If so, I'd like to propose
documentation update patch. Because I recently observed Dave Hansen
and David Rientjes discussed task->comm locking rule. So, I guess
current code comments is misleading. It doesn't describe why almost
all task->comm user don't take task_lock() at all.

What do you think?


 From e96571a8d470156d6ab7f3656d938aab126f17e8 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 20 May 2011 19:26:12 +0900
Subject: [PATCH] add comments for task->comm locking rule

Now, sched.h says, we should use [gs]et_task_comm for task->comm
access. but almost all actual code don't take task_lock(). It
brought repeated almost same locking rule discussion. Probably
we have to write exact current locking rule explicitly.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
---
  fs/exec.c             |   19 ++++++++++++++++++-
  include/linux/sched.h |    5 ++---
  2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 3d48ac6..bce64bb 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -995,9 +995,26 @@ static void flush_old_files(struct files_struct * files)
  	spin_unlock(&files->file_lock);
  }

+/**
+ * get_task_comm - get task name
+ * @buf: buffer to store result. must be at least sizeof(tsk->comm) in size
+ * @tsk: the task in question
+ *
+ * Note: task->comm has slightly complex locking rule.
+ *
+ * 1) write own or another task's name
+ *     -> must use set_task_comm()
+ * 2) read another task's name
+ *     -> must use get_task_comm() or take task_lock() manually.
+ * 3) read own task's name
+ *     -> recommend to use get_task_comm() or take task_lock() manually.
+ *        If you don't take task_lock(), you may see incomplete or empty string.
+ *        But it's guaranteed to keep valid C NUL-terminated string.
+ *        (ie never be crash)
+ *        So, debugging printk may be ok to read it without lock.
+ */
  char *get_task_comm(char *buf, struct task_struct *tsk)
  {
-	/* buf must be at least sizeof(tsk->comm) in size */
  	task_lock(tsk);
  	strncpy(buf, tsk->comm, sizeof(tsk->comm));
  	task_unlock(tsk);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 275c1a1..3e86500 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1334,9 +1334,8 @@ struct task_struct {
  	struct cred *replacement_session_keyring; /* for KEYCTL_SESSION_TO_PARENT */

  	char comm[TASK_COMM_LEN]; /* executable name excluding path
-				     - access with [gs]et_task_comm (which lock
-				       it with task_lock())
-				     - initialized normally by setup_new_exec */
+				     detailed locking rule is described at
+				     get_task_comm() */
  /* file system info */
  	int link_count, total_link_count;
  #ifdef CONFIG_SYSVIPC
-- 
1.7.3.1



