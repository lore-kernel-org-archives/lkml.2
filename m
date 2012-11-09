Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2KINaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 08:30:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:53950 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab2KINaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 08:30:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,745,1344236400"; 
   d="scan'208";a="217269665"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] proc: pid/status: show all supplementary groups
Date: Fri,  9 Nov 2012 15:31:03 +0200
Message-Id: <1352467863-1371-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

We display a list of supplementary group for each process in the
/proc/<pid>/status. However, we show only the first 32 groups, not all of them.

Although this is rare, but sometimes processes do have more than 32
supplementary groups, and this kernel limitation breaks user-space apps
that rely on the group list in /proc/<pid>/status.

Number 32 comes from the internal NGROUPS_SMALL macro which defines the
length for the internal kernel "small" groups buffer. There is no apparent
reason to limit to this value.

This patch removes the 32 groups printing limit.

The Linux kernel limits the amount of supplementary groups by NGROUPS_MAX,
which is currently set to 65536. And this is the maximum count of groups we
may possibly print.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: stable@vger.kernel.org
---
 fs/proc/array.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

NOTE: I consider this to be a bug which breaks user-space, so I add -stable.

diff --git a/fs/proc/array.c b/fs/proc/array.c
index c1c207c..bd31e02 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -212,7 +212,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 	group_info = cred->group_info;
 	task_unlock(p);
 
-	for (g = 0; g < min(group_info->ngroups, NGROUPS_SMALL); g++)
+	for (g = 0; g < group_info->ngroups; g++)
 		seq_printf(m, "%d ",
 			   from_kgid_munged(user_ns, GROUP_AT(group_info, g)));
 	put_cred(cred);
-- 
1.7.7.6

