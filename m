Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab0KKEgC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 23:36:02 -0500
Received: from smtp-out.google.com ([216.239.44.51]:30658 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab0KKEgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 23:36:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:x-operating-system:user-agent;
        b=GbEmC3YdGrnoYIeG6JeAN36JeLEo2cV5Tyqvxo6x7u7uIm8VN2sXmv7la5ENFVNc0H
         g7I3ULHoP3rFOH3OmPOw==
Date: Wed, 10 Nov 2010 20:35:41 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>
Cc: linux-kernel@vger.kernel.org, gspencer@chromium.org, piman@chromium.org,
        wad@chromium.org, olofj@chromium.org
Subject: [PATCH] oom: create a resource limit for oom_adj
Message-ID: <20101111043541.GA4588@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux/2.6.32-gg252-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For ChromiumOS, we'd like to be able to oom_adj a process up/down
as its leaves/enters the foreground. Currently, it is not possible
to oom_adj down without CAP_SYS_RESOURCE. This patch creates a new
resource limit, RLIMIT_OOMADJ, which is works in a similar fashion
to RLIMIT_NICE. This allows a process's oom_adj to be lowered
without CAP_SYS_RESOURCE as long as the new value is greater
than the resource limit.

Alternative considered:

* a setuid binary
* a daemon with CAP_SYS_RESOURCE

Since you don't wan't all processes to be able to reduce their
oom_adj, a setuid or daemon implementation would be complex. The
alternatives also have much higher overhead.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
---
 fs/proc/base.c                 |   12 ++++++++++--
 include/asm-generic/resource.h |    5 ++++-
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index f3d02ca..4384013 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -462,6 +462,7 @@ static const struct limit_names lnames[RLIM_NLIMITS] = {
 	[RLIMIT_NICE] = {"Max nice priority", NULL},
 	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
 	[RLIMIT_RTTIME] = {"Max realtime timeout", "us"},
+	[RLIMIT_OOMADJ] = {"Max OOM adjust", NULL},
 };
 
 /* Display limits for a process */
@@ -1057,8 +1058,15 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
 	}
 
 	if (oom_adjust < task->signal->oom_adj && !capable(CAP_SYS_RESOURCE)) {
-		err = -EACCES;
-		goto err_sighand;
+		/* convert oom_adj [15,-17] to rlimit style value [1,33] */
+		long oom_rlim = OOM_ADJUST_MAX + 1 - oom_adjust;
+
+		if (oom_rlim > task->signal->rlim[RLIMIT_OOMADJ].rlim_cur) {
+			unlock_task_sighand(task, &flags);
+			put_task_struct(task);
+			err = -EACCES;
+			goto err_sighand;
+		}
 	}
 
 	if (oom_adjust != task->signal->oom_adj) {
diff --git a/include/asm-generic/resource.h b/include/asm-generic/resource.h
index 587566f..a8640a4 100644
--- a/include/asm-generic/resource.h
+++ b/include/asm-generic/resource.h
@@ -45,7 +45,9 @@
 					   0-39 for nice level 19 .. -20 */
 #define RLIMIT_RTPRIO		14	/* maximum realtime priority */
 #define RLIMIT_RTTIME		15	/* timeout for RT tasks in us */
-#define RLIM_NLIMITS		16
+#define RLIMIT_OOMADJ		16	/* max oom_adj allowed to lower to
+					   0-32 for oom level 15 .. -17 */
+#define RLIM_NLIMITS		17
 
 /*
  * SuS says limits have to be unsigned.
@@ -86,6 +88,7 @@
 	[RLIMIT_MSGQUEUE]	= {   MQ_BYTES_MAX,   MQ_BYTES_MAX },	\
 	[RLIMIT_NICE]		= { 0, 0 },				\
 	[RLIMIT_RTPRIO]		= { 0, 0 },				\
+	[RLIMIT_OOMADJ]		= { 0, 0 },				\
 	[RLIMIT_RTTIME]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
 }
 
-- 
1.7.3.1

