Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350Ab2CMAWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:22:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:47824 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758693Ab2CMAWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:44 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 080/196] next_pidmap: fix overflow condition
Date: Mon, 12 Mar 2012 20:19:53 -0400
Message-Id: <1331598109-31424-35-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c78193e9c7bcbf25b8237ad0dec82f805c4ea69b upstream.

next_pidmap() just quietly accepted whatever 'last' pid that was passed
in, which is not all that safe when one of the users is /proc.

Admittedly the proc code should do some sanity checking on the range
(and that will be the next commit), but that doesn't mean that the
helper functions should just do that pidmap pointer arithmetic without
checking the range of its arguments.

So clamp 'last' to PID_MAX_LIMIT.  The fact that we then do "last+1"
doesn't really matter, the for-loop does check against the end of the
pidmap array properly (it's only the actual pointer arithmetic overflow
case we need to worry about, and going one bit beyond isn't going to
overflow).

[ Use PID_MAX_LIMIT rather than pid_max as per Eric Biederman ]

Reported-by: Tavis Ormandy <taviso@cmpxchg8b.com>
Analyzed-by: Robert Święcki <robert@swiecki.net>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/pid.h |    2 +-
 kernel/pid.c        |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index 49f1c2f..ec9f2df 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -117,7 +117,7 @@ extern struct pid *find_vpid(int nr);
  */
 extern struct pid *find_get_pid(int nr);
 extern struct pid *find_ge_pid(int nr, struct pid_namespace *);
-int next_pidmap(struct pid_namespace *pid_ns, int last);
+int next_pidmap(struct pid_namespace *pid_ns, unsigned int last);
 
 extern struct pid *alloc_pid(struct pid_namespace *ns);
 extern void free_pid(struct pid *pid);
diff --git a/kernel/pid.c b/kernel/pid.c
index aebb30d..af8dbf7 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -183,11 +183,14 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 	return -1;
 }
 
-int next_pidmap(struct pid_namespace *pid_ns, int last)
+int next_pidmap(struct pid_namespace *pid_ns, unsigned int last)
 {
 	int offset;
 	struct pidmap *map, *end;
 
+	if (last >= PID_MAX_LIMIT)
+		return -1;
+
 	offset = (last + 1) & BITS_PER_PAGE_MASK;
 	map = &pid_ns->pidmap[(last + 1)/BITS_PER_PAGE];
 	end = &pid_ns->pidmap[PIDMAP_ENTRIES];
-- 
1.7.9.3

