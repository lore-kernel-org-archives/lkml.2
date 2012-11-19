Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab2KSRad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 12:30:33 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:50621 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab2KSRab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 12:30:31 -0500
Date: Mon, 19 Nov 2012 09:30:26 -0800
From: Tejun Heo <tj@kernel.org>
To: daniel.wagner@bmw-carit.de, serge.hallyn@canonical.com,
        ebiederm@xmission.com, nhorman@tuxdriver.com, tgraf@suug.ch
Cc: davem@davemloft.net, lizefan@huawei.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] netcls_cgroup: introduce cgroup_cls_state->is_local
Message-ID: <20121119173026.GJ15971@htj.dyndns.org>
References: <1353123062-23193-1-git-send-email-tj@kernel.org>
 <1353123062-23193-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353123062-23193-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cs->is_local will be used to indicate whether the cgroup has its own
configuration or inherited from the parent.  It's set when classid is
configured by writing a positive value to cgroup file
"net_cls.classid" and cleared when a negative value is written.

is_local is visible to userland via cgroup file "net_cls.is_local" so
that userland can know whether a cgroup has its config or not.

This patch doesn't yet change hierarchy behavior.  The next patch will
use is_local to implement proper hierarchy.

v2: Daniel pointed out that cftype->write_u64() accepts base prefix
    (e.g. 0x10 for 16).  Updated "%lld" to "%lli".

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Daniel Wagner <wagi@monom.org>
---
 include/net/cls_cgroup.h |    1 +
 net/sched/cls_cgroup.c   |   23 ++++++++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

--- a/include/net/cls_cgroup.h
+++ b/include/net/cls_cgroup.h
@@ -22,6 +22,7 @@ struct cgroup_cls_state
 {
 	struct cgroup_subsys_state css;
 	u32 classid;
+	bool is_local;	/* class id is explicitly configured for this cgroup */
 };
 
 extern void sock_update_classid(struct sock *sk);
--- a/net/sched/cls_cgroup.c
+++ b/net/sched/cls_cgroup.c
@@ -70,19 +70,36 @@ static u64 read_classid(struct cgroup *c
 	return cgrp_cls_state(cgrp)->classid;
 }
 
-static int write_classid(struct cgroup *cgrp, struct cftype *cft, u64 value)
+static int write_classid(struct cgroup *cgrp, struct cftype *cft,
+			 const char *buf)
 {
+	struct cgroup_cls_state *cs = cgrp_cls_state(cgrp);
+	s64 v;
+
+	if (sscanf(buf, "%lli", &v) != 1)
+		return -EINVAL;
+
 	mutex_lock(&netcls_mutex);
-	cgrp_cls_state(cgrp)->classid = (u32) value;
+	cs->classid = clamp_val(v, 0, UINT_MAX);
+	cs->is_local = v >= 0;
 	mutex_unlock(&netcls_mutex);
 	return 0;
 }
 
+static u64 read_is_local(struct cgroup *cgrp, struct cftype *cft)
+{
+	return cgrp_cls_state(cgrp)->is_local;
+}
+
 static struct cftype ss_files[] = {
 	{
 		.name = "classid",
 		.read_u64 = read_classid,
-		.write_u64 = write_classid,
+		.write_string = write_classid,
+	},
+	{
+		.name = "is_local",
+		.read_u64 = read_is_local,
 	},
 	{ }	/* terminate */
 };
