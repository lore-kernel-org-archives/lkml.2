Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab0KXVlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 16:41:07 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34413 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab0KXVlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 16:41:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=FG9lwZwo4eLTt90CUupnCYAiFNqeIn1z/KaYrXryfWm6q4flsl+5Isq0Bxg9Nw+G7L
         Lz4yEKQ+ReDuPf02z0ive4jlTmn25ZPJ2Ql9VW7EV0DN49ElYQQh7e/J06Sx56Q2rTEb
         axtLftauwfXguFRNtyTfFWOer6zdaN7yOTJoo=
Date: Wed, 24 Nov 2010 23:40:58 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: use seq_puts()/seq_putc() where possible
Message-ID: <20101124214058.GA21245@core2.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For string without format specifiers, use seq_puts().
For seq_printf("\n"), use seq_putc('\n').

   text	   data	    bss	    dec	    hex	filename
  61866	    488	    112	  62466	   f402	fs/proc/proc.o
  61729	    488	    112	  62329	   f379	fs/proc/proc.o
  ----------------------------------------------------
  			   -139

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/array.c    |   22 +++++++++++-----------
 fs/proc/base.c     |    2 +-
 fs/proc/devices.c  |    4 ++--
 fs/proc/proc_tty.c |   26 +++++++++++++-------------
 fs/proc/softirqs.c |    6 +++---
 fs/proc/stat.c     |    2 +-
 6 files changed, 31 insertions(+), 31 deletions(-)

--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -95,7 +95,7 @@ static inline void task_name(struct seq_file *m, struct task_struct *p)
 
 	get_task_comm(tcomm, p);
 
-	seq_printf(m, "Name:\t");
+	seq_puts(m, "Name:\t");
 	end = m->buf + m->size;
 	buf = m->buf + m->count;
 	name = tcomm;
@@ -122,7 +122,7 @@ static inline void task_name(struct seq_file *m, struct task_struct *p)
 		buf++;
 	}
 	m->count = buf - m->buf;
-	seq_printf(m, "\n");
+	seq_putc(m, '\n');
 }
 
 /*
@@ -208,7 +208,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		seq_printf(m, "%d ", GROUP_AT(group_info, g));
 	put_cred(cred);
 
-	seq_printf(m, "\n");
+	seq_putc(m, '\n');
 }
 
 static void render_sigset_t(struct seq_file *m, const char *header,
@@ -216,7 +216,7 @@ static void render_sigset_t(struct seq_file *m, const char *header,
 {
 	int i;
 
-	seq_printf(m, "%s", header);
+	seq_puts(m, header);
 
 	i = _NSIG;
 	do {
@@ -230,7 +230,7 @@ static void render_sigset_t(struct seq_file *m, const char *header,
 		seq_printf(m, "%x", x);
 	} while (i >= 4);
 
-	seq_printf(m, "\n");
+	seq_putc(m, '\n');
 }
 
 static void collect_sigign_sigcatch(struct task_struct *p, sigset_t *ign,
@@ -291,12 +291,12 @@ static void render_cap_t(struct seq_file *m, const char *header,
 {
 	unsigned __capi;
 
-	seq_printf(m, "%s", header);
+	seq_puts(m, header);
 	CAP_FOR_EACH_U32(__capi) {
 		seq_printf(m, "%08x",
 			   a->cap[(_KERNEL_CAPABILITY_U32S-1) - __capi]);
 	}
-	seq_printf(m, "\n");
+	seq_putc(m, '\n');
 }
 
 static inline void task_cap(struct seq_file *m, struct task_struct *p)
@@ -329,12 +329,12 @@ static inline void task_context_switch_counts(struct seq_file *m,
 
 static void task_cpus_allowed(struct seq_file *m, struct task_struct *task)
 {
-	seq_printf(m, "Cpus_allowed:\t");
+	seq_puts(m, "Cpus_allowed:\t");
 	seq_cpumask(m, &task->cpus_allowed);
-	seq_printf(m, "\n");
-	seq_printf(m, "Cpus_allowed_list:\t");
+	seq_putc(m, '\n');
+	seq_puts(m, "Cpus_allowed_list:\t");
 	seq_cpumask_list(m, &task->cpus_allowed);
-	seq_printf(m, "\n");
+	seq_putc(m, '\n');
 }
 
 int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -392,7 +392,7 @@ static int lstats_show_proc(struct seq_file *m, void *v)
 					*c = 0;
 				seq_printf(m, "%s ", sym);
 			}
-			seq_printf(m, "\n");
+			seq_putc(m, '\n');
 		}
 
 	}
--- a/fs/proc/devices.c
+++ b/fs/proc/devices.c
@@ -9,14 +9,14 @@ static int devinfo_show(struct seq_file *f, void *v)
 
 	if (i < CHRDEV_MAJOR_HASH_SIZE) {
 		if (i == 0)
-			seq_printf(f, "Character devices:\n");
+			seq_puts(f, "Character devices:\n");
 		chrdev_show(f, i);
 	}
 #ifdef CONFIG_BLOCK
 	else {
 		i -= CHRDEV_MAJOR_HASH_SIZE;
 		if (i == 0)
-			seq_printf(f, "\nBlock devices:\n");
+			seq_puts(f, "\nBlock devices:\n");
 		blkdev_show(f, i);
 	}
 #endif
--- a/fs/proc/proc_tty.c
+++ b/fs/proc/proc_tty.c
@@ -36,27 +36,27 @@ static void show_tty_range(struct seq_file *m, struct tty_driver *p,
 	}
 	switch (p->type) {
 	case TTY_DRIVER_TYPE_SYSTEM:
-		seq_printf(m, "system");
+		seq_puts(m, "system");
 		if (p->subtype == SYSTEM_TYPE_TTY)
-			seq_printf(m, ":/dev/tty");
+			seq_puts(m, ":/dev/tty");
 		else if (p->subtype == SYSTEM_TYPE_SYSCONS)
-			seq_printf(m, ":console");
+			seq_puts(m, ":console");
 		else if (p->subtype == SYSTEM_TYPE_CONSOLE)
-			seq_printf(m, ":vtmaster");
+			seq_puts(m, ":vtmaster");
 		break;
 	case TTY_DRIVER_TYPE_CONSOLE:
-		seq_printf(m, "console");
+		seq_puts(m, "console");
 		break;
 	case TTY_DRIVER_TYPE_SERIAL:
-		seq_printf(m, "serial");
+		seq_puts(m, "serial");
 		break;
 	case TTY_DRIVER_TYPE_PTY:
 		if (p->subtype == PTY_TYPE_MASTER)
-			seq_printf(m, "pty:master");
+			seq_puts(m, "pty:master");
 		else if (p->subtype == PTY_TYPE_SLAVE)
-			seq_printf(m, "pty:slave");
+			seq_puts(m, "pty:slave");
 		else
-			seq_printf(m, "pty");
+			seq_puts(m, "pty");
 		break;
 	default:
 		seq_printf(m, "type:%d.%d", p->type, p->subtype);
@@ -74,19 +74,19 @@ static int show_tty_driver(struct seq_file *m, void *v)
 		/* pseudo-drivers first */
 		seq_printf(m, "%-20s /dev/%-8s ", "/dev/tty", "tty");
 		seq_printf(m, "%3d %7d ", TTYAUX_MAJOR, 0);
-		seq_printf(m, "system:/dev/tty\n");
+		seq_puts(m, "system:/dev/tty\n");
 		seq_printf(m, "%-20s /dev/%-8s ", "/dev/console", "console");
 		seq_printf(m, "%3d %7d ", TTYAUX_MAJOR, 1);
-		seq_printf(m, "system:console\n");
+		seq_puts(m, "system:console\n");
 #ifdef CONFIG_UNIX98_PTYS
 		seq_printf(m, "%-20s /dev/%-8s ", "/dev/ptmx", "ptmx");
 		seq_printf(m, "%3d %7d ", TTYAUX_MAJOR, 2);
-		seq_printf(m, "system\n");
+		seq_puts(m, "system\n");
 #endif
 #ifdef CONFIG_VT
 		seq_printf(m, "%-20s /dev/%-8s ", "/dev/vc/0", "vc/0");
 		seq_printf(m, "%3d %7d ", TTY_MAJOR, 0);
-		seq_printf(m, "system:vtmaster\n");
+		seq_puts(m, "system:vtmaster\n");
 #endif
 	}
 
--- a/fs/proc/softirqs.c
+++ b/fs/proc/softirqs.c
@@ -10,16 +10,16 @@ static int show_softirqs(struct seq_file *p, void *v)
 {
 	int i, j;
 
-	seq_printf(p, "                    ");
+	seq_puts(p, "                    ");
 	for_each_possible_cpu(i)
 		seq_printf(p, "CPU%-8d", i);
-	seq_printf(p, "\n");
+	seq_putc(p, '\n');
 
 	for (i = 0; i < NR_SOFTIRQS; i++) {
 		seq_printf(p, "%12s:", softirq_to_name[i]);
 		for_each_possible_cpu(j)
 			seq_printf(p, " %10u", kstat_softirqs_cpu(i, j));
-		seq_printf(p, "\n");
+		seq_putc(p, '\n');
 	}
 	return 0;
 }
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -126,7 +126,7 @@ static int show_stat(struct seq_file *p, void *v)
 
 	for (i = 0; i < NR_SOFTIRQS; i++)
 		seq_printf(p, " %u", per_softirq_sums[i]);
-	seq_printf(p, "\n");
+	seq_putc(p, '\n');
 
 	return 0;
 }
