Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab0HTKDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 06:03:16 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33536 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab0HTKDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 06:03:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 20 Aug 2010 18:58:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyuki@gmail.com, "menage@google.com" <menage@google.com>,
        "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: [PATCH 1/5] cgroup: ID notification call back
Message-Id: <20100820185816.1dbcd53a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC'ed to Paul Menage and Li Zefan.
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

When cgroup subsystem use ID (ss->use_id==1), each css's ID is assigned
after successful call of ->create(). css_ID is tightly coupled with
css struct itself but it is allocated by ->create() call, IOW,
per-subsystem special allocations.

To know css_id before creation, this patch adds id_attached() callback.
after css_ID allocation. This will be used by memory cgroup's quick lookup
routine.

Maybe you can think of other implementations as
	- pass ID to ->create()
	or
	- add post_create()
	etc...
But when considering dirtiness of codes, this straightforward patch seems
good to me. If someone wants post_create(), this patch can be replaced.

Changelog: 20100820
 - new approarch.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 Documentation/cgroups/cgroups.txt |   10 ++++++++++
 include/linux/cgroup.h            |    1 +
 kernel/cgroup.c                   |    5 ++++-
 3 files changed, 15 insertions(+), 1 deletion(-)

Index: mmotm-0811/Documentation/cgroups/cgroups.txt
===================================================================
--- mmotm-0811.orig/Documentation/cgroups/cgroups.txt
+++ mmotm-0811/Documentation/cgroups/cgroups.txt
@@ -621,6 +621,16 @@ and root cgroup. Currently this will onl
 the default hierarchy (which never has sub-cgroups) and a hierarchy
 that is being created/destroyed (and hence has no sub-cgroups).
 
+void id_attached(struct cgroup_subsys *ss, struct cgroup *root)
+(cgroup_mutex and ss->hierarchy_mutex held by caller)
+(called only when ss->use_id=1)
+
+Called when css_id is attached to css. Because css_id is assigned
+against "css", css_id is not available until ->create() is called.
+If subsystem wants to make use of ID at createtion time, use
+this handler. This handler will be called after css_id is assigned
+to css. Not necessary to be implemented in usual(see memcontrol.c)
+
 4. Questions
 ============
 
Index: mmotm-0811/include/linux/cgroup.h
===================================================================
--- mmotm-0811.orig/include/linux/cgroup.h
+++ mmotm-0811/include/linux/cgroup.h
@@ -475,6 +475,7 @@ struct cgroup_subsys {
 			struct cgroup *cgrp);
 	void (*post_clone)(struct cgroup_subsys *ss, struct cgroup *cgrp);
 	void (*bind)(struct cgroup_subsys *ss, struct cgroup *root);
+	void (*id_attached)(struct cgroup_subsys *ss, struct cgroup *cgrp);
 
 	int subsys_id;
 	int active;
Index: mmotm-0811/kernel/cgroup.c
===================================================================
--- mmotm-0811.orig/kernel/cgroup.c
+++ mmotm-0811/kernel/cgroup.c
@@ -4618,6 +4618,8 @@ static int __init_or_module cgroup_init_
 	newid->stack[0] = newid->id;
 	newid->css = rootcss;
 	rootcss->id = newid;
+	if (ss->id_attached)
+		ss->id_attached(ss, dummytop);
 	return 0;
 }
 
@@ -4646,7 +4648,8 @@ static int alloc_css_id(struct cgroup_su
 	 * see cgroup_populate_dir()
 	 */
 	rcu_assign_pointer(child_css->id, child_id);
-
+	if (ss->id_attached)
+		ss->id_attached(ss, child);
 	return 0;
 }
 

