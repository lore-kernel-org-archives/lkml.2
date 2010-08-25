Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab0HYCen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 22:34:43 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43768 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab0HYCek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 22:34:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 25 Aug 2010 11:29:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: linux-mm@kvack.org,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyuki@gmail.com,
        "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/5] cgroup: ID notification call back
Message-Id: <20100825112940.a477a04c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTinFdzzHxQhyGO9cPk+7kLw9WnRDnM+AekWFOn1q@mail.gmail.com>
References: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100820185816.1dbcd53a.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTi=imK6Px+JrdVupg2V3jtN9pgmEdWv=+aB1XKLY@mail.gmail.com>
	<20100825092010.cfe91b1a.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikD3CFRPo7WvWwCnLQ+jzEs6rUk1sivYM3aRbGJ@mail.gmail.com>
	<20100825093747.24085b28.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTi=KW_gxbmB14j5opSKL+-JFDFKO1YP6a7yvT8U5@mail.gmail.com>
	<20100825100310.ba3fd27e.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikuJ9x1u+GC_ox448Fp9wdJ2_GJyu6kNwjOJ9Y=@mail.gmail.com>
	<20100825104240.7dbaba6a.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTinFdzzHxQhyGO9cPk+7kLw9WnRDnM+AekWFOn1q@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 18:52:20 -0700
Paul Menage <menage@google.com> wrote:

> On Tue, Aug 24, 2010 at 6:42 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > Hmm, but placing css and subsystem's its own structure in different cache line
> > can increase cacheline/TLB miss, I think.
> 
> My patch shouldn't affect the memory placement of any structures.
> struct cgroup_subsys_state is still embedded in the per-subsystem
> state.
> 
> >
> > Do we have to call alloc_css_id() in kernel/cgroup.c ?
> 
> I guess not, if no-one's using it except for memcg. The general
> approach of allocating the CSS in cgroup.c rather than in every
> subsystem is something that I'd like to do separately, though.
> 

I'll use this for v6.
When you move css's allcation up to kernel/cgroup.c, this can be moved, too.
My regret is that I should argue CSS_ID is very tightly coupled with css itself
and should use this design from the 1st version.

-Kame

==

---
 block/blk-cgroup.c     |    6 ++++++
 include/linux/cgroup.h |   16 +++++++++-------
 kernel/cgroup.c        |   35 +++++++++--------------------------
 mm/memcontrol.c        |    4 ++++
 4 files changed, 28 insertions(+), 33 deletions(-)

Index: mmotm-0811/kernel/cgroup.c
===================================================================
--- mmotm-0811.orig/kernel/cgroup.c
+++ mmotm-0811/kernel/cgroup.c
@@ -770,9 +770,6 @@ static struct backing_dev_info cgroup_ba
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
 
-static int alloc_css_id(struct cgroup_subsys *ss,
-			struct cgroup *parent, struct cgroup *child);
-
 static struct inode *cgroup_new_inode(mode_t mode, struct super_block *sb)
 {
 	struct inode *inode = new_inode(sb);
@@ -3257,7 +3254,8 @@ static void init_cgroup_css(struct cgrou
 	css->cgroup = cgrp;
 	atomic_set(&css->refcnt, 1);
 	css->flags = 0;
-	css->id = NULL;
+	if (!ss->use_id)
+		css->id = NULL;
 	if (cgrp == dummytop)
 		set_bit(CSS_ROOT, &css->flags);
 	BUG_ON(cgrp->subsys[ss->subsys_id]);
@@ -3342,11 +3340,6 @@ static long cgroup_create(struct cgroup 
 			goto err_destroy;
 		}
 		init_cgroup_css(css, ss, cgrp);
-		if (ss->use_id) {
-			err = alloc_css_id(ss, parent, cgrp);
-			if (err)
-				goto err_destroy;
-		}
 		/* At error, ->destroy() callback has to free assigned ID. */
 	}
 
@@ -3709,17 +3702,6 @@ int __init_or_module cgroup_load_subsys(
 
 	/* our new subsystem will be attached to the dummy hierarchy. */
 	init_cgroup_css(css, ss, dummytop);
-	/* init_idr must be after init_cgroup_css because it sets css->id. */
-	if (ss->use_id) {
-		int ret = cgroup_init_idr(ss, css);
-		if (ret) {
-			dummytop->subsys[ss->subsys_id] = NULL;
-			ss->destroy(ss, dummytop);
-			subsys[i] = NULL;
-			mutex_unlock(&cgroup_mutex);
-			return ret;
-		}
-	}
 
 	/*
 	 * Now we need to entangle the css into the existing css_sets. unlike
@@ -3888,8 +3870,6 @@ int __init cgroup_init(void)
 		struct cgroup_subsys *ss = subsys[i];
 		if (!ss->early_init)
 			cgroup_init_subsys(ss);
-		if (ss->use_id)
-			cgroup_init_idr(ss, init_css_set.subsys[ss->subsys_id]);
 	}
 
 	/* Add init_css_set to the hash table */
@@ -4603,8 +4583,8 @@ err_out:
 
 }
 
-static int __init_or_module cgroup_init_idr(struct cgroup_subsys *ss,
-					    struct cgroup_subsys_state *rootcss)
+static int cgroup_init_idr(struct cgroup_subsys *ss,
+			    struct cgroup_subsys_state *rootcss)
 {
 	struct css_id *newid;
 
@@ -4621,13 +4601,16 @@ static int __init_or_module cgroup_init_
 	return 0;
 }
 
-static int alloc_css_id(struct cgroup_subsys *ss, struct cgroup *parent,
-			struct cgroup *child)
+int alloc_css_id(struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
 	int subsys_id, i, depth = 0;
+	struct cgroup *parent = cgrp->parent;
 	struct cgroup_subsys_state *parent_css, *child_css;
 	struct css_id *child_id, *parent_id;
 
+	if (cgrp->parent == NULL)
+		return cgroup_init_idr(ss, cgrp->subsys[ss->subsys_id]);
+
 	subsys_id = ss->subsys_id;
 	parent_css = parent->subsys[subsys_id];
 	child_css = child->subsys[subsys_id];
Index: mmotm-0811/include/linux/cgroup.h
===================================================================
--- mmotm-0811.orig/include/linux/cgroup.h
+++ mmotm-0811/include/linux/cgroup.h
@@ -583,9 +583,11 @@ int cgroup_attach_task_current_cg(struct
 /*
  * CSS ID is ID for cgroup_subsys_state structs under subsys. This only works
  * if cgroup_subsys.use_id == true. It can be used for looking up and scanning.
- * CSS ID is assigned at cgroup allocation (create) automatically
- * and removed when subsys calls free_css_id() function. This is because
- * the lifetime of cgroup_subsys_state is subsys's matter.
+ * CSS ID must be assigned by subsys itself at cgroup creation and deleted
+ * when subsys calls free_css_id() function. This is because the life time of
+ * of cgroup_subsys_state is subsys's matter.
+ *
+ * ID->css look up is available after cgroup's directory is populated.
  *
  * Looking up and scanning function should be called under rcu_read_lock().
  * Taking cgroup_mutex()/hierarchy_mutex() is not necessary for following calls.
@@ -593,10 +595,10 @@ int cgroup_attach_task_current_cg(struct
  * destroyed". The caller should check css and cgroup's status.
  */
 
-/*
- * Typically Called at ->destroy(), or somewhere the subsys frees
- * cgroup_subsys_state.
- */
+/* Should be called in ->create() by subsys itself */
+int alloc_css_id(struct cgroup_subsys *ss, struct cgroup *child);
+
+/* Typically Called at ->destroy(), or somewhere the subsys frees css */
 void free_css_id(struct cgroup_subsys *ss, struct cgroup_subsys_state *css);
 
 /* Find a cgroup_subsys_state which has given ID */
Index: mmotm-0811/mm/memcontrol.c
===================================================================
--- mmotm-0811.orig/mm/memcontrol.c
+++ mmotm-0811/mm/memcontrol.c
@@ -4141,6 +4141,10 @@ mem_cgroup_create(struct cgroup_subsys *
 		if (alloc_mem_cgroup_per_zone_info(mem, node))
 			goto free_out;
 
+	if (alloc_css_id(ss, cont))
+		goto free_out;
+	/* Here, css_id(&mem->css) works. but css_lookup(id)->mem doesn't */
+
 	/* root ? */
 	if (cont->parent == NULL) {
 		int cpu;
Index: mmotm-0811/block/blk-cgroup.c
===================================================================
--- mmotm-0811.orig/block/blk-cgroup.c
+++ mmotm-0811/block/blk-cgroup.c
@@ -958,6 +958,7 @@ blkiocg_create(struct cgroup_subsys *sub
 {
 	struct blkio_cgroup *blkcg;
 	struct cgroup *parent = cgroup->parent;
+	int ret;
 
 	if (!parent) {
 		blkcg = &blkio_root_cgroup;
@@ -971,6 +972,11 @@ blkiocg_create(struct cgroup_subsys *sub
 	blkcg = kzalloc(sizeof(*blkcg), GFP_KERNEL);
 	if (!blkcg)
 		return ERR_PTR(-ENOMEM);
+	ret = alloc_css_id(subsys, cgroup);
+	if (ret) {
+		kfree(blkcg);
+		return ret;
+	}
 
 	blkcg->weight = BLKIO_WEIGHT_DEFAULT;
 done:

