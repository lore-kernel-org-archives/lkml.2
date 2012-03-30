Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247Ab2C3N5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 09:57:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46114 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760180Ab2C3N5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 09:57:48 -0400
Date: Fri, 30 Mar 2012 06:57:36 -0700
From: tip-bot for Sasikantha babu <sasikanth.v19@gmail.com>
Message-ID: <tip-aa2bf9bc6414b6972b9e51903c1ce7b1f057aee2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, sasikanth.v19@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, sasikanth.v19@gmail.com
In-Reply-To: <1332340854-26053-1-git-send-email-sasikanth.v19@gmail.com>
References: <1332340854-26053-1-git-send-email-sasikanth.v19@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] itimer:
  Schedule silent NULL pointer fixup in setitimer() for removal
Git-Commit-ID: aa2bf9bc6414b6972b9e51903c1ce7b1f057aee2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 30 Mar 2012 06:57:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aa2bf9bc6414b6972b9e51903c1ce7b1f057aee2
Gitweb:     http://git.kernel.org/tip/aa2bf9bc6414b6972b9e51903c1ce7b1f057aee2
Author:     Sasikantha babu <sasikanth.v19@gmail.com>
AuthorDate: Wed, 21 Mar 2012 20:10:54 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 30 Mar 2012 15:43:33 +0200

itimer: Schedule silent NULL pointer fixup in setitimer() for removal

setitimer() should return -EFAULT if called with an invalid pointer
for value. The current code excludes a NULL pointer from this rule and
silently uses it to stop the timer. This violates the spec.

Warn about user space apps which rely on that feature and schedule it
for removal.

[ tglx: Massaged changelog, warn message and Doc entry ]

Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
Link: http://lkml.kernel.org/r/1332340854-26053-1-git-send-email-sasikanth.v19@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/feature-removal-schedule.txt |    8 ++++++++
 kernel/itimer.c                            |    5 ++++-
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 0cad480..32fae81 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -529,3 +529,11 @@ When:	3.5
 Why:	The old kmap_atomic() with two arguments is deprecated, we only
 	keep it for backward compatibility for few cycles and then drop it.
 Who:	Cong Wang <amwang@redhat.com>
+
+----------------------------
+
+What:	setitimer accepts user NULL pointer (value)
+When:	3.6
+Why:	setitimer is not returning -EFAULT if user pointer is NULL. This
+	violates the spec.
+Who:	Sasikantha Babu <sasikanth.v19@gmail.com>
diff --git a/kernel/itimer.c b/kernel/itimer.c
index 22000c3..c70369a 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -284,8 +284,11 @@ SYSCALL_DEFINE3(setitimer, int, which, struct itimerval __user *, value,
 	if (value) {
 		if(copy_from_user(&set_buffer, value, sizeof(set_buffer)))
 			return -EFAULT;
-	} else
+	} else {
 		memset((char *) &set_buffer, 0, sizeof(set_buffer));
+		WARN_ONCE(1, "setitimer: new_value pointer is NULL."
+			  " Misfeature support will be removed\n");
+	}
 
 	error = do_setitimer(which, &set_buffer, ovalue ? &get_buffer : NULL);
 	if (error || !ovalue)
