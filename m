Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab0E1PUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 11:20:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:61762 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab0E1PUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 11:20:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=oU2CworMXTcgwhtnGjUhhAWSBnoNck8ovNlmJAKPIL7fjFZbqHLqOPnxffVFCBPrr
	+U8r7YnKYnvVGVJH4OEeg==
From: Greg Thelen <gthelen@google.com>
To: Paul Menage <menage@google.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Subject: [PATCH] cgroup: alloc_css_id() increments hierarchy depth
Date: Fri, 28 May 2010 08:16:21 -0700
Message-Id: <1275059781-9831-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Child groups should have a greater depth than their parents.
Prior to this change, the parent would incorrectly report zero
memory usage for child cgroups when use_hierarchy is enabled.

test script:
  mount -t cgroup none /cgroups -o memory
  cd /cgroups
  mkdir cg1

  echo 1 > cg1/memory.use_hierarchy
  mkdir cg1/cg11

  echo $$ > cg1/cg11/tasks
  dd if=/dev/zero of=/tmp/foo bs=1M count=1

  echo
  echo CHILD
  grep cache cg1/cg11/memory.stat

  echo
  echo PARENT
  grep cache cg1/memory.stat

  echo $$ > tasks
  rmdir cg1/cg11 cg1
  cd /
  umount /cgroups

Using fae9c79, a recent patch that changed alloc_css_id() depth computation,
the parent incorrectly reports zero usage:
  root@ubuntu:~# ./test
  1+0 records in
  1+0 records out
  1048576 bytes (1.0 MB) copied, 0.0151844 s, 69.1 MB/s

  CHILD
  cache 1048576
  total_cache 1048576

  PARENT
  cache 0
  total_cache 0

With this patch, the parent correctly includes child usage:
  root@ubuntu:~# ./test
  1+0 records in
  1+0 records out
  1048576 bytes (1.0 MB) copied, 0.0136827 s, 76.6 MB/s

  CHILD
  cache 1052672
  total_cache 1052672

  PARENT
  cache 0
  total_cache 1052672

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 kernel/cgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 422cb19..3ac6f5b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4598,7 +4598,7 @@ static int alloc_css_id(struct cgroup_subsys *ss, struct cgroup *parent,
 	parent_css = parent->subsys[subsys_id];
 	child_css = child->subsys[subsys_id];
 	parent_id = parent_css->id;
-	depth = parent_id->depth;
+	depth = parent_id->depth + 1;
 
 	child_id = get_new_cssid(ss, depth);
 	if (IS_ERR(child_id))
-- 
1.7.0.1

