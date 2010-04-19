Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab0DSN54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 09:57:56 -0400
Received: from borg.medozas.de ([188.40.89.202]:41928 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771Ab0DSN5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 09:57:54 -0400
Date: Mon, 19 Apr 2010 15:57:52 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] vt: deactive Shift In/Out in unicode mode
Message-ID: <alpine.LSU.2.01.1004191555290.17067@obet.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,



I am proposing the patch below for inclusion.
Also pullable via
	git://dev.medozas.de/linux siso

##
parent d93af0ec5842904b701927b0b4da41e59f284e45 (v2.6.34-rc1-1127-gd93af0e)
commit 063c73c9d7c4e7a86e99c9e7eefc2b47a9262065
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sat Apr 10 12:40:31 2010 +0200

vt: deactive Shift In/Out in unicode mode

WP describes these control codes as: "The original meaning of those
characters was to switch to a different character set and back.  This
was used, for instance, in the Russian character set known as KOI7,
where SO starts printing Russian letters, and SI starts printing Latin
letters again."

It is easy to switch one's terminal into gibberish mode by merely
cat-ing a file which has these characters (may happen with corrupted
text files, or if accidentally displaying the contents of a binary
file). This patch deactivates the processing of the control chars in
Unicode mode, where this switch is not needed.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 drivers/char/vt.c            |   16 ++++++----
 net/netfilter/xt_condition.c |   53 +++++++++++++--------------------
 2 files changed, 31 insertions(+), 38 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index bd1d116..a3e66bc 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -1698,14 +1698,18 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 		cr(vc);
 		return;
 	case 14:
-		vc->vc_charset = 1;
-		vc->vc_translate = set_translate(vc->vc_G1_charset, vc);
-		vc->vc_disp_ctrl = 1;
+		if (!vc->vc_utf) {
+			vc->vc_charset = 1;
+			vc->vc_translate = set_translate(vc->vc_G1_charset, vc);
+			vc->vc_disp_ctrl = 1;
+		}
 		return;
 	case 15:
-		vc->vc_charset = 0;
-		vc->vc_translate = set_translate(vc->vc_G0_charset, vc);
-		vc->vc_disp_ctrl = 0;
+		if (!vc->vc_utf) {
+			vc->vc_charset = 0;
+			vc->vc_translate = set_translate(vc->vc_G0_charset, vc);
+			vc->vc_disp_ctrl = 0;
+		}
 		return;
 	case 24: case 26:
 		vc->vc_state = ESnormal;
diff --git a/net/netfilter/xt_condition.c b/net/netfilter/xt_condition.c
index d3dcaa4..6594338 100644
--- a/net/netfilter/xt_condition.c
+++ b/net/netfilter/xt_condition.c
@@ -52,7 +52,7 @@ struct condition_variable {
 
 /* proc_lock is a user context only semaphore used for write access */
 /*           to the conditions' list.                               */
-static struct mutex proc_lock;
+static DEFINE_MUTEX(proc_lock);
 
 static LIST_HEAD(conditions_list);
 static struct proc_dir_entry *proc_net_condition;
@@ -96,13 +96,8 @@ condition_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	const struct xt_condition_mtinfo *info = par->matchinfo;
 	const struct condition_variable *var   = info->condvar;
-	bool x;
 
-	rcu_read_lock();
-	x = rcu_dereference(var->enabled);
-	rcu_read_unlock();
-
-	return x ^ info->invert;
+	return var->enabled ^ info->invert;
 }
 
 static int condition_mt_check(const struct xt_mtchk_param *par)
@@ -122,9 +117,7 @@ static int condition_mt_check(const struct xt_mtchk_param *par)
 	 * Let's acquire the lock, check for the condition and add it
 	 * or increase the reference counter.
 	 */
-	if (mutex_lock_interruptible(&proc_lock) != 0)
-		return -EINTR;
-
+	mutex_lock(&proc_lock);
 	list_for_each_entry(var, &conditions_list, list) {
 		if (strcmp(info->name, var->status_proc->name) == 0) {
 			++var->refcount;
@@ -156,7 +149,7 @@ static int condition_mt_check(const struct xt_mtchk_param *par)
 	wmb();
 	var->status_proc->read_proc  = condition_proc_read;
 	var->status_proc->write_proc = condition_proc_write;
-	list_add_rcu(&var->list, &conditions_list);
+	list_add(&var->list, &conditions_list);
 	var->status_proc->uid = condition_uid_perms;
 	var->status_proc->gid = condition_gid_perms;
 	mutex_unlock(&proc_lock);
@@ -171,16 +164,9 @@ static void condition_mt_destroy(const struct xt_mtdtor_param *par)
 
 	mutex_lock(&proc_lock);
 	if (--var->refcount == 0) {
-		list_del_rcu(&var->list);
+		list_del(&var->list);
 		remove_proc_entry(var->status_proc->name, proc_net_condition);
 		mutex_unlock(&proc_lock);
-		/*
-		 * synchronize_rcu() would be good enough, but
-		 * synchronize_net() guarantees that no packet
-		 * will go out with the old rule after
-		 * succesful removal.
-		 */
-		synchronize_net();
 		kfree(var);
 		return;
 	}
@@ -202,24 +188,13 @@ static const char *const dir_name = "nf_condition";
 
 static int __net_init condnet_mt_init(struct net *net)
 {
-	int ret;
-
 	proc_net_condition = proc_mkdir(dir_name, net->proc_net);
-	if (proc_net_condition == NULL)
-		return -EACCES;
-
-	ret = xt_register_match(&condition_mt_reg);
-	if (ret < 0) {
-		remove_proc_entry(dir_name, net->proc_net);
-		return ret;
-	}
 
-	return 0;
+	return (proc_net_condition == NULL) ? -EACCES : 0;
 }
 
 static void __net_exit condnet_mt_exit(struct net *net)
 {
-	xt_unregister_match(&condition_mt_reg);
 	remove_proc_entry(dir_name, net->proc_net);
 }
 
@@ -230,12 +205,26 @@ static struct pernet_operations condition_mt_netops = {
 
 static int __init condition_mt_init(void)
 {
+	int ret;
+
 	mutex_init(&proc_lock);
-	return register_pernet_subsys(&condition_mt_netops);
+
+	ret = xt_register_match(&condition_mt_reg);
+	if (ret < 0)
+		return ret;
+
+	ret = register_pernet_subsys(&condition_mt_netops);
+	if (ret < 0) {
+		xt_unregister_match(&condition_mt_reg);
+		return ret;
+	}
+
+	return 0;
 }
 
 static void __exit condition_mt_exit(void)
 {
+	xt_unregister_match(&condition_mt_reg);
 	unregister_pernet_subsys(&condition_mt_netops);
 }
 
-- 
# Created with git-export-patch
