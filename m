Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab1D2Mey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 08:34:54 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:35459 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751729Ab1D2Mex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 08:34:53 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19SiZpj0bpS2U/GjC7S4OD+ULHpq3njMTak0D5eXH
	u54p7O/JawUi1i
Subject: Re: query: [PATCH 2/2] cgroup: Remove call to synchronize_rcu in
 cgroup_attach_task
From: Mike Galbraith <efault@gmx.de>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1303983516.7460.5.camel@marge.simson.net>
References: <1302170153.12304.31.camel@marge.simson.net>
	 <4DA50430.8020701@cn.fujitsu.com>
	 <1302664313.7407.29.camel@marge.simson.net>
	 <BANLkTikqvP90Etu=L24DPWbckrawM-6n=Q@mail.gmail.com>
	 <1303136494.7542.20.camel@marge.simson.net>
	 <1303983516.7460.5.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 14:34:47 +0200
Message-ID: <1304080487.21536.16.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(ok crickets, keep the noise down please)

On Thu, 2011-04-28 at 11:38 +0200, Mike Galbraith wrote:

> The explosions are because the logic to snag rmdir() should anyone grab
> a reference will let us zip right through and free a cgroup while
> there's a destruction in flight.  Adding a cgrp->count check before
> trying to cgroup_clear_css_refs() prevents the explosions, but that
> leaves RCU grace periods still embedded in userspace.
> 
> So...
> 
> I bent up put_css_set() a bit to try to destroy synchronously on final
> put if possible, so rmdir() will only be snagged if that fails.  The
> thing seems to be working, so I'll show it.  Readers (beware) may notice
> some gratuitous looking chicken scratches.  Just ignore those, and move
> along smartly to the suggesting a much better way part, for surely one
> must exist. 

Hi Self, (*howdy*)

You might try the below.  No weird gyrations to accomplish the same
thing, and I see no slub debug gripes, no list debug gripes, nada.

Makes one wonder what these things do for a living.

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 25c7eb5..b8c64bf 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -826,13 +826,6 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		struct cgroup *cgrp = dentry->d_fsdata;
 		struct cgroup_subsys *ss;
 		BUG_ON(!(cgroup_is_removed(cgrp)));
-		/* It's possible for external users to be holding css
-		 * reference counts on a cgroup; css_put() needs to
-		 * be able to access the cgroup after decrementing
-		 * the reference count in order to know if it needs to
-		 * queue the cgroup to be handled by the release
-		 * agent */
-		synchronize_rcu();
 
 		mutex_lock(&cgroup_mutex);
 		/*
@@ -1822,7 +1815,6 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 			ss->attach(ss, cgrp, oldcgrp, tsk, false);
 	}
 	set_bit(CGRP_RELEASABLE, &oldcgrp->flags);
-	synchronize_rcu();
 	put_css_set(cg);
 
 	/*


