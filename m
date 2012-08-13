Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2HMUqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:46:09 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:54788 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab2HMUUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:20:18 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        David Miller <davem@davemloft.net>, Serge Hallyn <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 13 Aug 2012 13:18:22 -0700
Message-Id: <1344889115-21610-8-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
References: <87ehnav9n5.fsf@xmission.com>
 <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/Z5F4FUIE8gTgUne+9aCCbP4SJRqBwjv8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4067]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 XMBrknScrpt_02 Possible Broken Spam Script
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<netdev@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 08/21] net ip6 flowlabel: Make owner a union of struct pid * and kuid_t
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Correct a long standing omission and use struct pid in the owner
field of struct ip6_flowlabel when the share type is IPV6_FL_S_PROCESS.
This guarantees we don't have issues when pid wraparound occurs.

Use a kuid_t in the owner field of struct ip6_flowlabel when the
share type is IPV6_FL_S_USER to add user namespace support.

In /proc/net/ip6_flowlabel capture the current pid namespace when
opening the file and release the pid namespace when the file is
closed ensuring we print the pid owner value that is meaning to
the reader of the file.  Similarly use from_kuid_munged to print
uid values that are meaningful to the reader of the file.

This requires exporting pid_nr_ns so that ipv6 can continue to built
as a module.  Yoiks what silliness

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/net/ipv6.h       |    5 +++-
 init/Kconfig             |    1 -
 kernel/pid.c             |    1 +
 net/ipv6/ip6_flowlabel.c |   50 +++++++++++++++++++++++++++++++++++++++------
 4 files changed, 48 insertions(+), 9 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 01c34b3..c8a2024 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -222,7 +222,10 @@ struct ip6_flowlabel {
 	struct ipv6_txoptions	*opt;
 	unsigned long		linger;
 	u8			share;
-	u32			owner;
+	union {
+		struct pid *pid;
+		kuid_t uid;
+	} owner;
 	unsigned long		lastuse;
 	unsigned long		expires;
 	struct net		*fl_net;
diff --git a/init/Kconfig b/init/Kconfig
index f857f97..64ff9ce 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -948,7 +948,6 @@ config UIDGID_CONVERTED
 	depends on NETFILTER_XT_MATCH_RECENT = n
 	depends on NETFILTER_XT_TARGET_LOG = n
 	depends on NETFILTER_NETLINK_LOG = n
-	depends on IPV6 = n
 	depends on AF_RXRPC = n
 	depends on NET_KEY = n
 	depends on INET_DIAG = n
diff --git a/kernel/pid.c b/kernel/pid.c
index e86b291a..aebd4f5 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -479,6 +479,7 @@ pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns)
 	}
 	return nr;
 }
+EXPORT_SYMBOL_GPL(pid_nr_ns);
 
 pid_t pid_vnr(struct pid *pid)
 {
diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index 9772fbd..c836a6a 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -22,6 +22,7 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/pid_namespace.h>
 
 #include <net/net_namespace.h>
 #include <net/sock.h>
@@ -90,6 +91,11 @@ static struct ip6_flowlabel *fl_lookup(struct net *net, __be32 label)
 
 static void fl_free(struct ip6_flowlabel *fl)
 {
+	switch (fl->share) {
+	case IPV6_FL_S_PROCESS:
+		put_pid(fl->owner.pid);
+		break;
+	}
 	if (fl) {
 		release_net(fl->fl_net);
 		kfree(fl->opt);
@@ -394,10 +400,10 @@ fl_create(struct net *net, struct sock *sk, struct in6_flowlabel_req *freq,
 	case IPV6_FL_S_ANY:
 		break;
 	case IPV6_FL_S_PROCESS:
-		fl->owner = current->pid;
+		fl->owner.pid = get_task_pid(current, PIDTYPE_PID);
 		break;
 	case IPV6_FL_S_USER:
-		fl->owner = current_euid();
+		fl->owner.uid = current_euid();
 		break;
 	default:
 		err = -EINVAL;
@@ -561,7 +567,10 @@ recheck:
 				err = -EPERM;
 				if (fl1->share == IPV6_FL_S_EXCL ||
 				    fl1->share != fl->share ||
-				    fl1->owner != fl->owner)
+				    ((fl1->share == IPV6_FL_S_PROCESS) &&
+				     (fl1->owner.pid == fl->owner.pid)) ||
+				    ((fl1->share == IPV6_FL_S_USER) &&
+				     uid_eq(fl1->owner.uid, fl->owner.uid)))
 					goto release;
 
 				err = -EINVAL;
@@ -621,6 +630,7 @@ done:
 
 struct ip6fl_iter_state {
 	struct seq_net_private p;
+	struct pid_namespace *pid_ns;
 	int bucket;
 };
 
@@ -699,6 +709,7 @@ static void ip6fl_seq_stop(struct seq_file *seq, void *v)
 
 static int ip6fl_seq_show(struct seq_file *seq, void *v)
 {
+	struct ip6fl_iter_state *state = ip6fl_seq_private(seq);
 	if (v == SEQ_START_TOKEN)
 		seq_printf(seq, "%-5s %-1s %-6s %-6s %-6s %-8s %-32s %s\n",
 			   "Label", "S", "Owner", "Users", "Linger", "Expires", "Dst", "Opt");
@@ -708,7 +719,11 @@ static int ip6fl_seq_show(struct seq_file *seq, void *v)
 			   "%05X %-1d %-6d %-6d %-6ld %-8ld %pi6 %-4d\n",
 			   (unsigned int)ntohl(fl->label),
 			   fl->share,
-			   (int)fl->owner,
+			   ((fl->share == IPV6_FL_S_PROCESS) ?
+			    pid_nr_ns(fl->owner.pid, state->pid_ns) :
+			    ((fl->share == IPV6_FL_S_USER) ?
+			     from_kuid_munged(seq_user_ns(seq), fl->owner.uid) :
+			     0)),
 			   atomic_read(&fl->users),
 			   fl->linger/HZ,
 			   (long)(fl->expires - jiffies)/HZ,
@@ -727,8 +742,29 @@ static const struct seq_operations ip6fl_seq_ops = {
 
 static int ip6fl_seq_open(struct inode *inode, struct file *file)
 {
-	return seq_open_net(inode, file, &ip6fl_seq_ops,
-			    sizeof(struct ip6fl_iter_state));
+	struct seq_file *seq;
+	struct ip6fl_iter_state *state;
+	int err;
+
+	err = seq_open_net(inode, file, &ip6fl_seq_ops,
+			   sizeof(struct ip6fl_iter_state));
+
+	if (!err) {
+		seq = file->private_data;
+		state = ip6fl_seq_private(seq);
+		rcu_read_lock();
+		state->pid_ns = get_pid_ns(task_active_pid_ns(current));
+		rcu_read_unlock();
+	}
+	return err;
+}
+
+static int ip6fl_seq_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq = file->private_data;
+	struct ip6fl_iter_state *state = ip6fl_seq_private(seq);
+	put_pid_ns(state->pid_ns);
+	return seq_release_net(inode, file);
 }
 
 static const struct file_operations ip6fl_seq_fops = {
@@ -736,7 +772,7 @@ static const struct file_operations ip6fl_seq_fops = {
 	.open		=	ip6fl_seq_open,
 	.read		=	seq_read,
 	.llseek		=	seq_lseek,
-	.release	=	seq_release_net,
+	.release	=	ip6fl_seq_release,
 };
 
 static int __net_init ip6_flowlabel_proc_init(struct net *net)
-- 
1.7.5.4

