Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab1KUJPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 04:15:15 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:30347 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab1KUJPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 04:15:10 -0500
Message-ID: <4ECA1696.5060500@parallels.com>
Date: Mon, 21 Nov 2011 13:15:02 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with given
 pids
References: <4EC4F2FB.408@parallels.com> <20111117154936.GB12325@redhat.com> <4EC52FBF.1010407@parallels.com> <20111118233055.GA29378@google.com>
In-Reply-To: <20111118233055.GA29378@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2011 03:30 AM, Tejun Heo wrote:
> Hello,
> 
> On Thu, Nov 17, 2011 at 08:01:03PM +0400, Pavel Emelyanov wrote:
>>> Yes, personally I'd prefer /proc/set_last_pid (or something similar) which
>>> simply writes to pid_ns->last_pid. Perhaps it is less convenient from the
>>> user-space pov (serialization, security) but it is much simpler.
>>
>> Yes, this is also possible. I have a working prototype of /proc/sys/kernel/ns_last_pid
>> with the security issue solved, but setting sysctl then cloning seems more obfuscating
>> to me than just passing an array of pids to clone.
> 
> Do you mind sharing the patch?

Sure! First of all, we need to change the ctl_table_root->permission callback to pass
the required operations (MAY_XXX) into it, rather than just getting the mode allowed.
The API change it like in the patch below (plus we need to patch the net/ sysctl's, since
they use this API):

--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -1052,10 +1052,12 @@ struct ctl_table_root {
 	struct ctl_table_set default_set;
 	struct ctl_table_set *(*lookup)(struct ctl_table_root *root,
 					   struct nsproxy *namespaces);
-	int (*permissions)(struct ctl_table_root *root,
-			struct nsproxy *namespaces, struct ctl_table *table);
+	int (*permissions)(struct nsproxy *namespaces,
+			struct ctl_table *table, int op);
 };
 
 /* struct ctl_table_header is used to maintain dynamic lists of
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1706,7 +1706,7 @@ void register_sysctl_root(struct ctl_table_root *root)
  * some sysctl variables are readonly even to root.
  */
 
-static int test_perm(int mode, int op)
+int sysctl_test_perm(int mode, int op)
 {
 	if (!current_euid())
 		mode >>= 6;
@@ -1722,11 +1722,9 @@ int sysctl_perm(struct ctl_table_root *root, struct ctl_table *table, int op)
 	int mode;
 
 	if (root->permissions)
-		mode = root->permissions(root, current->nsproxy, table);
+		return root->permissions(current->nsproxy, table, op);
 	else
-		mode = table->mode;
-
-	return test_perm(mode, op);
+		return sysctl_test_perm(table->mode, op);
 }
 
 static void sysctl_set_parent(struct ctl_table *parent, struct ctl_table *table)

---

Then I introduce the kernel.ns_last_pid sysctl that is allows for MAY_OPEN | MAP_WRITE for
the namespace's init only and allows for MAY_WRITE for anyone else. Thus, if we want to
write to this file from non-init task it must have the respective fd inherited from the init
on fork. It works OK for checkpoint/restore.

The patch is:


diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index e9c9adc..3686a07 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -15,6 +15,7 @@
 #include <linux/acct.h>
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
+#include <linux/sysctl.h>
 
 #define BITS_PER_PAGE		(PAGE_SIZE*8)
 
@@ -191,9 +192,54 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 	return;
 }
 
+static int pid_ns_ctl_permissions(struct nsproxy *namespaces,
+			struct ctl_table *table, int op)
+{
+	int mode = 0644;
+
+	if ((op & MAY_OPEN) &&
+			current != namespaces->pid_ns->child_reaper)
+		/*
+		 * Writing to this sysctl is allowed only for init
+		 * and to whoever it grands the open file
+		 */
+		mode &= ~0222;
+
+	return sysctl_test_perm(mode, op);
+}
+
+static struct ctl_table_root pid_ns_root = {
+	.permissions = pid_ns_ctl_permissions,
+};
+
+static int pid_ns_ctl_handler(struct ctl_table *table, int write,
+		     void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table tmp = *table;
+	tmp.data = &current->nsproxy->pid_ns->last_pid;
+	return proc_dointvec(&tmp, write, buffer, lenp, ppos);
+}
+
+static struct ctl_table pid_ns_ctl_table[] = {
+	.permissions = pid_ns_ctl_permissions,
+};
+
+static int pid_ns_ctl_handler(struct ctl_table *table, int write,
+		     void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table tmp = *table;
+	tmp.data = &current->nsproxy->pid_ns->last_pid;
+	return proc_dointvec(&tmp, write, buffer, lenp, ppos);
+}
+
+static struct ctl_table pid_ns_ctl_table[] = {
+	{
+		.procname = "ns_last_pid",
+		.maxlen = sizeof(int),
+		.proc_handler = pid_ns_ctl_handler,
+	},
+	{ }
+};
+
+static struct ctl_path kern_path[] = { { .procname = "kernel", }, { } };
+
 static __init int pid_namespaces_init(void)
 {
 	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC);
+
+	setup_sysctl_set(&pid_ns_root.default_set, NULL, NULL);
+	register_sysctl_root(&pid_ns_root);
+	__register_sysctl_paths(&pid_ns_root, current->nsproxy,
+			kern_path, pid_ns_ctl_table);
+
 	return 0;
 }
 

> It doesn't have to be perfect.  I'm just curious how it looks.
> IMHO the suggested pid array passing is good enough and not too intrusive
> but, if there's something simpler from kernel side, given that this is a
> very specialized interface, I think we definitely need to consider that.

Well, after a bit more thinking I found one more pros for this sysctl - when restoring
a container we'll have the possibility to set the last_pid to what we want to prevent the
pids reuse after the restore.

> Thank you.
> 

