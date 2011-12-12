Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab1LLRuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:50:39 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:38022 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab1LLRug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:50:36 -0500
Subject: [PATCH 1/2] SYSCTL: root unregister routine introduced
To: mingo@elte.hu
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: a.p.zijlstra@chello.nl, xemul@parallels.com, drosenberg@vsecurity.com,
        linux-kernel@vger.kernel.org, eparis@redhat.com, bfields@fieldses.org,
        jbottomley@parallels.com, akpm@linux-foundation.org, devel@openvz.org
Date: Mon, 12 Dec 2011 21:50:00 +0300
Message-ID: <20111212175000.7084.94219.stgit@localhost6.localdomain6>
In-Reply-To: <20111212174709.7084.54702.stgit@localhost6.localdomain6>
References: <20111212174709.7084.54702.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This routine is required for SUNRPC sysctl's, which are going to be allocated,
processed and destroyed per network namespace context.
IOW, new sysctl root will be registered on network namespace creation and
thus have to unregistered before network namespace destruction.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

---
 kernel/sysctl.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ae27196..21e68c1 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1701,6 +1701,13 @@ void register_sysctl_root(struct ctl_table_root *root)
 	spin_unlock(&sysctl_lock);
 }
 
+void unregister_sysctl_root(struct ctl_table_root *root)
+{
+	spin_lock(&sysctl_lock);
+	list_del(&root->root_list);
+	spin_unlock(&sysctl_lock);
+}
+
 /*
  * sysctl_perm does NOT grant the superuser all rights automatically, because
  * some sysctl variables are readonly even to root.

