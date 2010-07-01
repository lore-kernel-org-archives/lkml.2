Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab0GAVf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:35:56 -0400
Received: from kroah.org ([198.145.64.141]:33045 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758781Ab0GAVOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:49 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:58 2010
Message-Id: <20100701174258.852925976@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:43:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Greg Thelen <gthelen@google.com>, Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [147/200] cgroups: alloc_css_id() increments hierarchy depth
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Thelen <gthelen@google.com>

commit 94b3dd0f7bb393d93e84a173b1df9b8b64c83ac4 upstream.

Child groups should have a greater depth than their parents.  Prior to
this change, the parent would incorrectly report zero memory usage for
child cgroups when use_hierarchy is enabled.

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
Acked-by: Paul Menage <menage@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4599,7 +4599,7 @@ static int alloc_css_id(struct cgroup_su
 	parent_css = parent->subsys[subsys_id];
 	child_css = child->subsys[subsys_id];
 	parent_id = parent_css->id;
-	depth = parent_id->depth;
+	depth = parent_id->depth + 1;
 
 	child_id = get_new_cssid(ss, depth);
 	if (IS_ERR(child_id))


