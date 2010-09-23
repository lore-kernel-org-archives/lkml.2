Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab0IWIrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 04:47:05 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:52082 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab0IWIrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 04:47:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: <linux-kernel@vger.kernel.org>
Cc: Linux Containers <containers@lists.osdl.org>, <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, <linux-fsdevel@vger.kernel.org>,
        jamal <hadi@cyberus.ca>, Daniel Lezcano <daniel.lezcano@free.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Miller <davem@davemloft.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Ben Greear <greearb@candelatech.com>,
        Matt Helsley <matthltc@us.ibm.com>, Jonathan Corbet <corbet@lwn.net>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>
References: <m1ocborgq7.fsf@fess.ebiederm.org>
Date: Thu, 23 Sep 2010 01:46:56 -0700
In-Reply-To: <m1ocborgq7.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Thu, 23 Sep 2010 01:45:04 -0700")
Message-ID: <m1d3s4rgn3.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 2/8] ns: Introduce the setns syscall
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With the networking stack today there is demand to handle
multiple network stacks at a time.  Not in the context
of containers but in the context of people doing interesting
things with routing.

There is also demand in the context of containers to have
an efficient way to execute some code in the container itself.
If nothing else it is very useful ad a debugging technique.

Both problems can be solved by starting some form of login
daemon in the namespaces people want access to, or you
can play games by ptracing a process and getting the
traced process to do things you want it to do. However
it turns out that a login daemon or a ptrace puppet
controller are more code, they are more prone to
failure, and generally they are less efficient than
simply changing the namespace of a process to a
specified one.

Pieces of this puzzle can also be solved by instead of
coming up with a general purpose system call coming up
with targed system calls perhaps socketat that solve
a subset of the larger problem.  Overall that appears
to be more work for less reward.

int setns(unsigned int nstype, int fd);

In the setns system call the nstype is 0 or specifies
an the name of the namespace you think you are changing,
to prevent changing a namespace unintentionally.

The fd argument is a file descriptor referring to a proc
file of the namespace you want to switch the process to.

v2: Most of the architecture support added by Daniel Lezcano <dlezcano@fr.ibm.com>
v3: ported to v2.6.36-rc4 by: Eric W. Biederman <ebiederm@xmission.com>
v4: Moved wiring up of the system call to another patch

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/nsproxy.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index f74e6c0..0bf2dba 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -22,6 +22,9 @@
 #include <linux/pid_namespace.h>
 #include <net/net_namespace.h>
 #include <linux/ipc_namespace.h>
+#include <linux/proc_fs.h>
+#include <linux/file.h>
+#include <linux/syscalls.h>
 
 static struct kmem_cache *nsproxy_cachep;
 
@@ -233,6 +236,42 @@ void exit_task_namespaces(struct task_struct *p)
 	switch_task_namespaces(p, NULL);
 }
 
+SYSCALL_DEFINE2(setns, unsigned int, nstype, int, fd)
+{
+	const struct proc_ns_operations *ops;
+	struct task_struct *tsk = current;
+	struct nsproxy *new_nsproxy;
+	struct proc_inode *ei;
+	struct file *file;
+	int err;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	file = proc_ns_fget(fd);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	err = -EINVAL;
+	ei = PROC_I(file->f_dentry->d_inode);
+	ops = ei->ns_ops;
+	if (nstype &&
+	    ((ops->name.len >= sizeof(nstype)) ||
+	    memcmp(&nstype, ops->name.name, ops->name.len)))
+		goto out;
+
+	new_nsproxy = create_new_namespaces(0, tsk, tsk->fs);
+	err = ops->install(new_nsproxy, ei->ns);
+	if (err) {
+		free_nsproxy(new_nsproxy);
+		goto out;
+	}
+	switch_task_namespaces(tsk, new_nsproxy);
+out:
+	fput(file);
+	return err;
+}
+
 static int __init nsproxy_cache_init(void)
 {
 	nsproxy_cachep = KMEM_CACHE(nsproxy, SLAB_PANIC);
-- 
1.6.5.2.143.g8cc62

