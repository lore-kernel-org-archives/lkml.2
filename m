Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937Ab1CZAWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:22:40 -0400
Received: from kroah.org ([198.145.64.141]:41589 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325Ab1CYXwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:38 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:45:10 2011
Message-Id: <20110325234510.644660638@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:44:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Richard Weinberger <richard@nod.at>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, Eric Paris <eparis@redhat.com>,
        Kees Cook <kees.cook@canonical.com>, James Morris <jmorris@namei.org>,
        Eugene Teo <eugeneteo@kernel.org>
Subject: [27/63] sysctl: restrict write access to dmesg_restrict
In-Reply-To: <20110325234526.GA18017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Richard Weinberger <richard@nod.at>

commit bfdc0b497faa82a0ba2f9dddcf109231dd519fcc upstream.

When dmesg_restrict is set to 1 CAP_SYS_ADMIN is needed to read the kernel
ring buffer.  But a root user without CAP_SYS_ADMIN is able to reset
dmesg_restrict to 0.

This is an issue when e.g.  LXC (Linux Containers) are used and complete
user space is running without CAP_SYS_ADMIN.  A unprivileged and jailed
root user can bypass the dmesg_restrict protection.

With this patch writing to dmesg_restrict is only allowed when root has
CAP_SYS_ADMIN.

Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Dan Rosenberg <drosenberg@vsecurity.com>
Acked-by: Serge E. Hallyn <serge@hallyn.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Kees Cook <kees.cook@canonical.com>
Cc: James Morris <jmorris@namei.org>
Cc: Eugene Teo <eugeneteo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sysctl.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -169,6 +169,11 @@ static int proc_taint(struct ctl_table *
 			       void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
+#ifdef CONFIG_PRINTK
+static int proc_dmesg_restrict(struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp, loff_t *ppos);
+#endif
+
 #ifdef CONFIG_MAGIC_SYSRQ
 /* Note: sysrq code uses it's own private copy */
 static int __sysrq_enabled = SYSRQ_DEFAULT_ENABLE;
@@ -713,7 +718,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &kptr_restrict,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dmesg_restrict,
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
@@ -2397,6 +2402,17 @@ static int proc_taint(struct ctl_table *
 	return err;
 }
 
+#ifdef CONFIG_PRINTK
+static int proc_dmesg_restrict(struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+}
+#endif
+
 struct do_proc_dointvec_minmax_conv_param {
 	int *min;
 	int *max;


