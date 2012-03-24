Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab2CXAVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 20:21:32 -0400
Received: from out07.mta.xmission.com ([166.70.13.237]:44796 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964874Ab2CXAVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 20:21:30 -0400
X-Greylist: delayed 2176 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Mar 2012 20:21:29 EDT
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
References: <20120313005855.GA24639@redhat.com>
	<CA+55aFwb2WRRamWPVY-ETDG_LO0QR9C8epk8tSAJVZhPFSNzhA@mail.gmail.com>
	<20120318192755.GB6589@ZenIV.linux.org.uk>
	<CAMOw1v4qa_AxJgc+qAsY6M=K--2JDvO-+CNj8OwKuE7piRViGw@mail.gmail.com>
	<m1vclw1fx8.fsf@fess.ebiederm.org>
	<CAMOw1v4gszzV7F3z1m+RWEe9UDgR2Jrp9wX_w9z_1UkXT=FL5Q@mail.gmail.com>
Date: Fri, 23 Mar 2012 17:25:02 -0700
In-Reply-To: <CAMOw1v4gszzV7F3z1m+RWEe9UDgR2Jrp9wX_w9z_1UkXT=FL5Q@mail.gmail.com>
	(Lucas De Marchi's message of "Thu, 22 Mar 2012 19:12:26 -0300")
Message-ID: <m1iphuu9pd.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX189rlA59zsqbphs+tNh5tCnoq5aLFlscxg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 TR_Symld_Words too many words that have symbols inside
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0018]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lucas De Marchi <lucas.demarchi@profusion.mobi>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH] Making poll generally useful for sysctls
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Lucas can you take a look at the patch below. I don't have a test
harness to test this but this should make poll generally useful
for all sysctls as well as fix the module removal case.

In particular if you could test to see if the code still works as
expected for the hostname and domainname cases that would be great.

I don't anticipate any problems but real world testing is always good.

 fs/proc/proc_sysctl.c   |   34 +++++++++++++++++-----------------
 include/linux/sysctl.h  |   22 +++-------------------
 kernel/utsname_sysctl.c |   14 ++++----------
 3 files changed, 24 insertions(+), 46 deletions(-)
---
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 47b474b..98fd5c9 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -16,13 +16,15 @@ static const struct inode_operations proc_sys_inode_operations;
 static const struct file_operations proc_sys_dir_file_operations;
 static const struct inode_operations proc_sys_dir_operations;
 
-void proc_sys_poll_notify(struct ctl_table_poll *poll)
+static inline void *proc_sys_poll_event(struct ctl_table *table)
 {
-	if (!poll)
-		return;
+	return (void *)(unsigned long)atomic_read(&table->event);
+}
 
-	atomic_inc(&poll->event);
-	wake_up_interruptible(&poll->wait);
+void proc_sys_poll_notify(struct ctl_table_header *head, struct ctl_table *table)
+{
+	atomic_inc(&table->event);
+	wake_up_interruptible(&head->wait);
 }
 
 static struct ctl_table root_table[] = {
@@ -169,6 +171,7 @@ static void init_header(struct ctl_table_header *head,
 		for (entry = table; entry->procname; entry++, node++) {
 			rb_init_node(&node->node);
 			node->header = head;
+			atomic_set(&entry->event, 1);
 		}
 	}
 }
@@ -240,6 +243,8 @@ static void start_unregistering(struct ctl_table_header *p)
 		/* anything non-NULL; we'll never dereference it */
 		p->unregistering = ERR_PTR(-EINVAL);
 	}
+	/* Don't let poll sleep forever on deleted entries */
+	wake_up_interruptible(&p->wait);
 	/*
 	 * do not remove from the list until nobody holds it; walking the
 	 * list in do_sysctl() relies on that.
@@ -505,6 +510,9 @@ static ssize_t proc_sys_call_handler(struct file *filp, void __user *buf,
 	error = table->proc_handler(table, write, buf, &res, ppos);
 	if (!error)
 		error = res;
+
+	if (write)
+		proc_sys_poll_notify(head, table);
 out:
 	sysctl_head_finish(head);
 
@@ -532,8 +540,7 @@ static int proc_sys_open(struct inode *inode, struct file *filp)
 	if (IS_ERR(head))
 		return PTR_ERR(head);
 
-	if (table->poll)
-		filp->private_data = proc_sys_poll_event(table->poll);
+	filp->private_data = proc_sys_poll_event(table);
 
 	sysctl_head_finish(head);
 
@@ -552,21 +559,14 @@ static unsigned int proc_sys_poll(struct file *filp, poll_table *wait)
 	if (IS_ERR(head))
 		return POLLERR | POLLHUP;
 
-	if (!table->proc_handler)
-		goto out;
-
-	if (!table->poll)
-		goto out;
-
 	event = (unsigned long)filp->private_data;
-	poll_wait(filp, &table->poll->wait, wait);
+	poll_wait(filp, &head->wait, wait);
 
-	if (event != atomic_read(&table->poll->event)) {
-		filp->private_data = proc_sys_poll_event(table->poll);
+	if (event != atomic_read(&table->event)) {
+		filp->private_data = proc_sys_poll_event(table);
 		ret = POLLIN | POLLRDNORM | POLLERR | POLLPRI;
 	}
 
-out:
 	sysctl_head_finish(head);
 
 	return ret;
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index c34b4c8..8647ee0 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -992,34 +992,17 @@ extern int proc_do_large_bitmap(struct ctl_table *, int,
  * cover common cases.
  */
 
-/* Support for userspace poll() to watch for changes */
-struct ctl_table_poll {
-	atomic_t event;
-	wait_queue_head_t wait;
-};
-
-static inline void *proc_sys_poll_event(struct ctl_table_poll *poll)
-{
-	return (void *)(unsigned long)atomic_read(&poll->event);
-}
-
-#define __CTL_TABLE_POLL_INITIALIZER(name) {				\
-	.event = ATOMIC_INIT(0),					\
-	.wait = __WAIT_QUEUE_HEAD_INITIALIZER(name.wait) }
-
-#define DEFINE_CTL_TABLE_POLL(name)					\
-	struct ctl_table_poll name = __CTL_TABLE_POLL_INITIALIZER(name)
 
 /* A sysctl table is an array of struct ctl_table: */
 struct ctl_table 
 {
 	const char *procname;		/* Text ID for /proc/sys, or zero */
 	void *data;
+	atomic_t event;
 	int maxlen;
 	umode_t mode;
 	struct ctl_table *child;	/* Deprecated */
 	proc_handler *proc_handler;	/* Callback for text formatting */
-	struct ctl_table_poll *poll;
 	void *extra1;
 	void *extra2;
 };
@@ -1042,6 +1025,7 @@ struct ctl_table_header
 		};
 		struct rcu_head rcu;
 	};
+	wait_queue_head_t wait;
 	struct completion *unregistering;
 	struct ctl_table *ctl_table_arg;
 	struct ctl_table_root *root;
@@ -1076,7 +1060,7 @@ struct ctl_path {
 
 #ifdef CONFIG_SYSCTL
 
-void proc_sys_poll_notify(struct ctl_table_poll *poll);
+void proc_sys_poll_notify(struct ctl_table_header *head, struct ctl_table *table);
 
 extern void setup_sysctl_set(struct ctl_table_set *p,
 	struct ctl_table_root *root,
diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
index 63da38c..3e91a50 100644
--- a/kernel/utsname_sysctl.c
+++ b/kernel/utsname_sysctl.c
@@ -53,18 +53,12 @@ static int proc_do_uts_string(ctl_table *table, int write,
 	r = proc_dostring(&uts_table,write,buffer,lenp, ppos);
 	put_uts(table, write, uts_table.data);
 
-	if (write)
-		proc_sys_poll_notify(table->poll);
-
 	return r;
 }
 #else
 #define proc_do_uts_string NULL
 #endif
 
-static DEFINE_CTL_TABLE_POLL(hostname_poll);
-static DEFINE_CTL_TABLE_POLL(domainname_poll);
-
 static struct ctl_table uts_kern_table[] = {
 	{
 		.procname	= "ostype",
@@ -93,7 +87,6 @@ static struct ctl_table uts_kern_table[] = {
 		.maxlen		= sizeof(init_uts_ns.name.nodename),
 		.mode		= 0644,
 		.proc_handler	= proc_do_uts_string,
-		.poll		= &hostname_poll,
 	},
 	{
 		.procname	= "domainname",
@@ -101,7 +94,6 @@ static struct ctl_table uts_kern_table[] = {
 		.maxlen		= sizeof(init_uts_ns.name.domainname),
 		.mode		= 0644,
 		.proc_handler	= proc_do_uts_string,
-		.poll		= &domainname_poll,
 	},
 	{}
 };
@@ -115,6 +107,8 @@ static struct ctl_table uts_root_table[] = {
 	{}
 };
 
+static struct ctl_table_header *uts_header;
+
 #ifdef CONFIG_PROC_SYSCTL
 /*
  * Notify userspace about a change in a certain entry of uts_kern_table,
@@ -124,13 +118,13 @@ void uts_proc_notify(enum uts_proc proc)
 {
 	struct ctl_table *table = &uts_kern_table[proc];
 
-	proc_sys_poll_notify(table->poll);
+	proc_sys_poll_notify(uts_header, table);
 }
 #endif
 
 static int __init utsname_sysctl_init(void)
 {
-	register_sysctl_table(uts_root_table);
+	uts_header = register_sysctl_table(uts_root_table);
 	return 0;
 }
 
