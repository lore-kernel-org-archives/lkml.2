Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab0C3XIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:08:54 -0400
Received: from kroah.org ([198.145.64.141]:48379 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937Ab0C3XIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:08:51 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:43 2010
Message-Id: <20100330224943.052193459@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Slaby <jslaby@suse.cz>, James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [06/45] resource: add helpers for fetching rlimits
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 3e10e716abf3c71bdb5d86b8f507f9e72236c9cd upstream.

We want to be sure that compiler fetches the limit variable only
once, so add helpers for fetching current and maximal resource
limits which do that.

Add them to sched.h (instead of resource.h) due to circular dependency
 sched.h->resource.h->task_struct
Alternative would be to create a separate res_access.h or similar.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: James Morris <jmorris@namei.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/sched.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2232,6 +2232,28 @@ static inline void mm_init_owner(struct
 
 #define TASK_STATE_TO_CHAR_STR "RSDTtZX"
 
+static inline unsigned long task_rlimit(const struct task_struct *tsk,
+		unsigned int limit)
+{
+	return ACCESS_ONCE(tsk->signal->rlim[limit].rlim_cur);
+}
+
+static inline unsigned long task_rlimit_max(const struct task_struct *tsk,
+		unsigned int limit)
+{
+	return ACCESS_ONCE(tsk->signal->rlim[limit].rlim_max);
+}
+
+static inline unsigned long rlimit(unsigned int limit)
+{
+	return task_rlimit(current, limit);
+}
+
+static inline unsigned long rlimit_max(unsigned int limit)
+{
+	return task_rlimit_max(current, limit);
+}
+
 #endif /* __KERNEL__ */
 
 #endif


