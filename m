Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab0G0H7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 03:59:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35481 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab0G0H7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 03:59:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 27 Jul 2010 16:54:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 2/7][memcg] cgroup arbitarary ID allocation
Message-Id: <20100727165417.dacbe199.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100727165155.8b458b7f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100727165155.8b458b7f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

When a subsystem want to make use of "id" more, it's necessary to
manage the id at cgroup subsystem creation time. But, now,
because of the order of cgroup creation callback, subsystem can't
declare the id it wants. This patch allows subsystem to use customized
ID for themselves.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 Documentation/cgroups/cgroups.txt |    9 +++++++++
 include/linux/cgroup.h            |    3 ++-
 kernel/cgroup.c                   |   17 ++++++++++++-----
 3 files changed, 23 insertions(+), 6 deletions(-)

Index: mmotm-2.6.35-0719/include/linux/cgroup.h
===================================================================
--- mmotm-2.6.35-0719.orig/include/linux/cgroup.h
+++ mmotm-2.6.35-0719/include/linux/cgroup.h
@@ -475,7 +475,7 @@ struct cgroup_subsys {
 			struct cgroup *cgrp);
 	void (*post_clone)(struct cgroup_subsys *ss, struct cgroup *cgrp);
 	void (*bind)(struct cgroup_subsys *ss, struct cgroup *root);
-
+	int (*custom_id)(struct cgroup_subsys *ss, struct cgroup *cgrp);
 	int subsys_id;
 	int active;
 	int disabled;
@@ -483,6 +483,7 @@ struct cgroup_subsys {
 	/*
 	 * True if this subsys uses ID. ID is not available before cgroup_init()
 	 * (not available in early_init time.)
+	 * You can detemine ID if you have custom_id() callback.
 	 */
 	bool use_id;
 #define MAX_CGROUP_TYPE_NAMELEN 32
Index: mmotm-2.6.35-0719/kernel/cgroup.c
===================================================================
--- mmotm-2.6.35-0719.orig/kernel/cgroup.c
+++ mmotm-2.6.35-0719/kernel/cgroup.c
@@ -4526,10 +4526,11 @@ EXPORT_SYMBOL_GPL(free_css_id);
  * always serialized (By cgroup_mutex() at create()).
  */
 
-static struct css_id *get_new_cssid(struct cgroup_subsys *ss, int depth)
+static struct css_id *get_new_cssid(struct cgroup_subsys *ss,
+		int depth, struct cgroup *child)
 {
 	struct css_id *newid;
-	int myid, error, size;
+	int from_id, myid, error, size;
 
 	BUG_ON(!ss->use_id);
 
@@ -4542,9 +4543,13 @@ static struct css_id *get_new_cssid(stru
 		error = -ENOMEM;
 		goto err_out;
 	}
+	if (child && ss->custom_id)
+		from_id = ss->custom_id(ss, child);
+	else
+		from_id = 1;
 	spin_lock(&ss->id_lock);
 	/* Don't use 0. allocates an ID of 1-65535 */
-	error = idr_get_new_above(&ss->idr, newid, 1, &myid);
+	error = idr_get_new_above(&ss->idr, newid, from_id, &myid);
 	spin_unlock(&ss->id_lock);
 
 	/* Returns error when there are no free spaces for new ID.*/
@@ -4552,6 +4557,8 @@ static struct css_id *get_new_cssid(stru
 		error = -ENOSPC;
 		goto err_out;
 	}
+	BUG_ON(ss->custom_id && from_id != myid);
+
 	if (myid > CSS_ID_MAX)
 		goto remove_idr;
 
@@ -4577,7 +4584,7 @@ static int __init_or_module cgroup_init_
 	spin_lock_init(&ss->id_lock);
 	idr_init(&ss->idr);
 
-	newid = get_new_cssid(ss, 0);
+	newid = get_new_cssid(ss, 0 ,NULL);
 	if (IS_ERR(newid))
 		return PTR_ERR(newid);
 
@@ -4600,7 +4607,7 @@ static int alloc_css_id(struct cgroup_su
 	parent_id = parent_css->id;
 	depth = parent_id->depth + 1;
 
-	child_id = get_new_cssid(ss, depth);
+	child_id = get_new_cssid(ss, depth, child);
 	if (IS_ERR(child_id))
 		return PTR_ERR(child_id);
 
Index: mmotm-2.6.35-0719/Documentation/cgroups/cgroups.txt
===================================================================
--- mmotm-2.6.35-0719.orig/Documentation/cgroups/cgroups.txt
+++ mmotm-2.6.35-0719/Documentation/cgroups/cgroups.txt
@@ -621,6 +621,15 @@ and root cgroup. Currently this will onl
 the default hierarchy (which never has sub-cgroups) and a hierarchy
 that is being created/destroyed (and hence has no sub-cgroups).
 
+void custom_id(struct cgroup_subsys *ss, struct cgroup *cgrp)
+
+Called at assigning a new ID to cgroup subsystem state struct. This
+is called when ss->use_id == true. If this function is not provided,
+a new ID is automatically assigned. If you enable ss->use_id,
+you can use css_lookup()  and css_get_next() to access "css" objects
+via IDs.
+
+
 4. Questions
 ============
 

