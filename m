Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab0GWRsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 13:48:05 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54784 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab0GWRsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 13:48:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=Qq+qQExEB2fPTOrYSnssm5rRHG/R/Q8DBaJ7vYkai2JWmRCqRM/vo/QqO1te19Wkds
         GrMEPwL/ie9rJiodfrtjVFOMYSirglnBPOUOxAQ4F6Kva6jKgKUKs9YwDZzYLus6jZkp
         h5/HAGFkUDiFkQ5jvEayajQIYPp2LyiqUXABg=
Subject: [RFC] [PATCH procfs] Add process age
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave.bueso@gmail.com
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Jul 2010 13:47:51 -0400
Message-ID: <1279907271.4335.3.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch exports a process's age, in seconds, adding a /proc/#/age file.

Thanks,
Davidlohr

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 fs/proc/base.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index acb7ef8..a5a4832 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -38,13 +38,16 @@
  *  ChangeLog:
  *  10-Mar-2005
  *  10LE Instituto Nokia de Tecnologia - INdT:
- *  A better way to walks through the page table as suggested by Hugh Dickins.
+ *  A better way to walk through the page table as suggested by Hugh Dickins.
  *
  *  Simo Piiroinen <simo.piiroinen@nokia.com>:
  *  Smaps information related to shared, private, clean and dirty pages.
  *
  *  Paul Mundt <paul.mundt@nokia.com>:
  *  Overall revision about smaps.
+ *
+ *  2010 - Davidlohr Bueso <dave@gnu.org>:
+ *  Added process age (/proc/#/age), in seconds.
  */
 
 #include <asm/uaccess.h>
@@ -2558,6 +2561,18 @@ static int proc_pid_personality(struct seq_file *m, struct pid_namespace *ns,
 	return 0;
 }
 
+static int proc_pid_age(struct seq_file *m, struct pid_namespace *ns,
+			struct pid *pid, struct task_struct *task)
+{
+	struct timespec uptime;
+
+	do_posix_clock_monotonic_gettime(&uptime);
+	monotonic_to_bootbased(&uptime);
+	seq_printf(m, "%lu\n", uptime.tv_sec - task->real_start_time.tv_sec);
+
+	return 0;
+}
+
 /*
  * Thread groups
  */
@@ -2575,6 +2590,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	INF("auxv",       S_IRUSR, proc_pid_auxv),
 	ONE("status",     S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
+	ONE("age",        S_IRUSR, proc_pid_age),
 	INF("limits",	  S_IRUSR, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
@@ -2910,6 +2926,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	INF("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
+	ONE("age",        S_IRUSR, proc_pid_age),
 	INF("limits",	 S_IRUSR, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
-- 
1.7.0.4

