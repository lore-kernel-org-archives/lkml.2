Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab0HYBIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 21:08:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44975 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab0HYBIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 21:08:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 25 Aug 2010 10:03:10 +0900
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
Message-Id: <20100825100310.ba3fd27e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTi=KW_gxbmB14j5opSKL+-JFDFKO1YP6a7yvT8U5@mail.gmail.com>
References: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100820185816.1dbcd53a.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTi=imK6Px+JrdVupg2V3jtN9pgmEdWv=+aB1XKLY@mail.gmail.com>
	<20100825092010.cfe91b1a.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikD3CFRPo7WvWwCnLQ+jzEs6rUk1sivYM3aRbGJ@mail.gmail.com>
	<20100825093747.24085b28.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTi=KW_gxbmB14j5opSKL+-JFDFKO1YP6a7yvT8U5@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 17:46:03 -0700
Paul Menage <menage@google.com> wrote:

> On Tue, Aug 24, 2010 at 5:37 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > Ou...I'm sorry but I would like to use attach_id() for this time.
> > Forgive me, above seems a big change.
> > I'd like to write a series of patch to do above, later.
> > At least, to do a trial.
> >
> 
> Sure, for testing outside the tree. I don't think introducing new code
> into mainline that's intentionally ugly and cutting corners is a good
> idea.
> 

Hmm. How this pseudo code looks like ? This passes "new id" via
cgroup->subsys[array] at creation. (Using union will be better, maybe).

---
 include/linux/cgroup.h |    1 +
 kernel/cgroup.c        |   26 +++++++++++++++++++-------
 2 files changed, 20 insertions(+), 7 deletions(-)

Index: mmotm-0811/include/linux/cgroup.h
===================================================================
--- mmotm-0811.orig/include/linux/cgroup.h
+++ mmotm-0811/include/linux/cgroup.h
@@ -508,6 +508,7 @@ struct cgroup_subsys {
 	struct cgroupfs_root *root;
 	struct list_head sibling;
 	/* used when use_id == true */
+	int max_id;
 	struct idr idr;
 	spinlock_t id_lock;
 
Index: mmotm-0811/kernel/cgroup.c
===================================================================
--- mmotm-0811.orig/kernel/cgroup.c
+++ mmotm-0811/kernel/cgroup.c
@@ -3335,19 +3335,31 @@ static long cgroup_create(struct cgroup 
 		set_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
 
 	for_each_subsys(root, ss) {
-		struct cgroup_subsys_state *css = ss->create(ss, cgrp);
+		struct cgroup_subsys_state *css;
 
-		if (IS_ERR(css)) {
-			err = PTR_ERR(css);
-			goto err_destroy;
-		}
-		init_cgroup_css(css, ss, cgrp);
 		if (ss->use_id) {
 			err = alloc_css_id(ss, parent, cgrp);
 			if (err)
 				goto err_destroy;
+			/*
+ 			 * Here, created css_id is recorded into
+ 			 * cgrp->subsys[ss->subsys_id]
+			 * array and passed to subsystem.
+			 */
+		} else
+			cgrp->subsys[ss->subsys_id] = NULL;
+
+		css = ss->create(ss, cgrp);
+
+		if (IS_ERR(css)) {
+			/* forget preallocated id */
+			if (cgrp->subsys[ss->subsys_id])
+				free_css_id_direct((struct css_id *)
+					cgrp->subsys[ss->subsys_id]);
+			err = PTR_ERR(css);
+			goto err_destroy;
 		}
-		/* At error, ->destroy() callback has to free assigned ID. */
+		init_cgroup_css(css, ss, cgrp);
 	}
 
 	cgroup_lock_hierarchy(root);

	

