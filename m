Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab2KBAiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 20:38:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:18913 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab2KBAiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 20:38:50 -0400
X-IronPort-AV: E=Sophos;i="4.80,696,1344182400"; 
   d="scan'208";a="6119579"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Cc: serge.hallyn@canonical.com, ebiederm@xmission.com, glommer@parallels.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH] namespace:unmount pid_namespace's proc_mnt when copy_net_ns failed
Date: Fri, 2 Nov 2012 08:38:23 +0800
Message-Id: <1351816703-8805-1-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/02 08:38:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/02 08:38:02,
	Serialize complete at 2012/11/02 08:38:02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we should call pid_ns_release_proc to unmount pid_namespace's
proc_mnt when copy_net_ns failed in function create_new_namespaces.

otherwise,the proc_mnt will not be freed and because the super_block
of proc_mnt also add the reference of the pid_namespace,so this
pid_namespace will never be released too.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/nsproxy.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index b576f7f..d536480 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -99,8 +99,11 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
 	return new_nsp;
 
 out_net:
-	if (new_nsp->pid_ns)
+	if (new_nsp->pid_ns) {
+		if (flags & CLONE_NEWPID)
+			pid_ns_release_proc(new_nsp->pid_ns);
 		put_pid_ns(new_nsp->pid_ns);
+	}
 out_pid:
 	if (new_nsp->ipc_ns)
 		put_ipc_ns(new_nsp->ipc_ns);
-- 
1.7.7.6

