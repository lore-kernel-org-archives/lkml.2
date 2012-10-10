Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab2JJKY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 06:24:27 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:18945 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175Ab2JJKYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 06:24:24 -0400
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: [PATCH] pidns: limit a size of pid to one page
Date: Wed, 10 Oct 2012 14:24:14 +0400
Message-Id: <1349864654-1333268-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A size of pid depends on a level of pidns and now a level of pidns
is not limited, so it can be more than one page.

Looks reasonable, that it should be limited to a page size.  On x86_64
it will allow to create 125 nested pid namespaces.  I don't know a
usecase for which, it will be not enough. When someone finds a
reasonable use case, we can add a config option or a sysctl parameter.

In addition it will reduce effect of another problem, when we have many
nested namespaces and the oldest one starts dying.  zap_pid_ns_processe
will be called for each namespace and find_vpid will be called for each
process in a namespace. find_vpid will be called minimum max_level^2 / 2
times. The reason of that is that when we found a bit in pidmap, we
can't determine this pidns is top for this process or it isn't.

vpid is a heavy operation, so a fork bomb, which create many nested
namespace, can do a system inaccessible for a long time.

For example my system becomes inaccessible for a few minutes with
4000 processes.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 kernel/pid_namespace.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index b051fa6..bc822e6 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -70,12 +70,18 @@ err_alloc:
 	return NULL;
 }
 
+/* Limit a size of pid to one page */
+#define MAX_PID_NS_LEVEL ((PAGE_SIZE - sizeof(struct pid)) / sizeof(struct upid))
+
 static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_pid_ns)
 {
 	struct pid_namespace *ns;
 	unsigned int level = parent_pid_ns->level + 1;
 	int i, err = -ENOMEM;
 
+	if (level > MAX_PID_NS_LEVEL)
+		goto out;
+
 	ns = kmem_cache_zalloc(pid_ns_cachep, GFP_KERNEL);
 	if (ns == NULL)
 		goto out;
-- 
1.7.1

