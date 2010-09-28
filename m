Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab0I1OZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 10:25:25 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:50201 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab0I1OZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 10:25:24 -0400
Message-Id: <20100928142519.237053845@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 28 Sep 2010 16:20:59 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] taskstats: Separate taskstats commands
References: <20100928142058.796669370@linux.vnet.ibm.com>
Content-Disposition: inline; filename=02-taskstats-top-prepare-1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

This patch moves each taskstats command into a single function. This
makes the code more readable and makes it easier to add new commands.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---
 kernel/taskstats.c |  118 +++++++++++++++++++++++++++++++++++------------------
 1 file changed, 78 insertions(+), 40 deletions(-)

--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -424,39 +424,76 @@ err:
 	return rc;
 }
 
-static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
+static int cmd_attr_register_cpumask(struct genl_info *info)
 {
-	int rc;
-	struct sk_buff *rep_skb;
-	struct taskstats *stats;
-	size_t size;
 	cpumask_var_t mask;
+	int rc;
 
 	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
 		return -ENOMEM;
-
 	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK], mask);
 	if (rc < 0)
-		goto free_return_rc;
-	if (rc == 0) {
-		rc = add_del_listener(info->snd_pid, mask, REGISTER);
-		goto free_return_rc;
-	}
+		goto out;
+	rc = add_del_listener(info->snd_pid, mask, REGISTER);
+out:
+	free_cpumask_var(mask);
+	return rc;
+}
+
+static int cmd_attr_deregister_cpumask(struct genl_info *info)
+{
+	cpumask_var_t mask;
+	int rc;
 
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+		return -ENOMEM;
 	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK], mask);
 	if (rc < 0)
-		goto free_return_rc;
-	if (rc == 0) {
-		rc = add_del_listener(info->snd_pid, mask, DEREGISTER);
-free_return_rc:
-		free_cpumask_var(mask);
-		return rc;
-	}
+		goto out;
+	rc = add_del_listener(info->snd_pid, mask, DEREGISTER);
+out:
 	free_cpumask_var(mask);
+	return rc;
+}
+
+static int cmd_attr_pid(struct genl_info *info)
+{
+	struct taskstats *stats;
+	struct sk_buff *rep_skb;
+	size_t size;
+	u32 pid;
+	int rc;
+
+	size = nla_total_size(sizeof(u32)) +
+		nla_total_size(sizeof(struct taskstats)) + nla_total_size(0);
+
+	rc = prepare_reply(info, TASKSTATS_CMD_NEW, &rep_skb, size);
+	if (rc < 0)
+		return rc;
+
+	rc = -EINVAL;
+	pid = nla_get_u32(info->attrs[TASKSTATS_CMD_ATTR_PID]);
+	stats = mk_reply(rep_skb, TASKSTATS_TYPE_PID, pid);
+	if (!stats)
+		goto err;
+
+	rc = fill_pid(pid, NULL, stats);
+	if (rc < 0)
+		goto err;
+	return send_reply(rep_skb, info);
+err:
+	nlmsg_free(rep_skb);
+	return rc;
+}
+
+static int cmd_attr_tgid(struct genl_info *info)
+{
+	struct taskstats *stats;
+	struct sk_buff *rep_skb;
+	size_t size;
+	u32 tgid;
+	int rc;
 
-	/*
-	 * Size includes space for nested attributes
-	 */
 	size = nla_total_size(sizeof(u32)) +
 		nla_total_size(sizeof(struct taskstats)) + nla_total_size(0);
 
@@ -465,33 +502,34 @@ free_return_rc:
 		return rc;
 
 	rc = -EINVAL;
-	if (info->attrs[TASKSTATS_CMD_ATTR_PID]) {
-		u32 pid = nla_get_u32(info->attrs[TASKSTATS_CMD_ATTR_PID]);
-		stats = mk_reply(rep_skb, TASKSTATS_TYPE_PID, pid);
-		if (!stats)
-			goto err;
-
-		rc = fill_pid(pid, NULL, stats);
-		if (rc < 0)
-			goto err;
-	} else if (info->attrs[TASKSTATS_CMD_ATTR_TGID]) {
-		u32 tgid = nla_get_u32(info->attrs[TASKSTATS_CMD_ATTR_TGID]);
-		stats = mk_reply(rep_skb, TASKSTATS_TYPE_TGID, tgid);
-		if (!stats)
-			goto err;
-
-		rc = fill_tgid(tgid, NULL, stats);
-		if (rc < 0)
-			goto err;
-	} else
+	tgid = nla_get_u32(info->attrs[TASKSTATS_CMD_ATTR_TGID]);
+	stats = mk_reply(rep_skb, TASKSTATS_TYPE_TGID, tgid);
+	if (!stats)
 		goto err;
 
+	rc = fill_tgid(tgid, NULL, stats);
+	if (rc < 0)
+		goto err;
 	return send_reply(rep_skb, info);
 err:
 	nlmsg_free(rep_skb);
 	return rc;
 }
 
+static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
+{
+	if (info->attrs[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK])
+		return cmd_attr_register_cpumask(info);
+	else if (info->attrs[TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK])
+		return cmd_attr_deregister_cpumask(info);
+	else if (info->attrs[TASKSTATS_CMD_ATTR_PID])
+		return cmd_attr_pid(info);
+	else if (info->attrs[TASKSTATS_CMD_ATTR_TGID])
+		return cmd_attr_tgid(info);
+	else
+		return -EINVAL;
+}
+
 static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
 {
 	struct signal_struct *sig = tsk->signal;

