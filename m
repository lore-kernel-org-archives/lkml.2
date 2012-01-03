Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab2ACWf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:35:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126Ab2ACWfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:35:23 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:33 2012
Message-Id: <20120103223033.360752073@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:29:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mandeep Singh Baines <msb@chromium.org>,
        Tejun Heo <tj@kernel.org>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Paul Menage <paul@paulmenage.org>,
        Olof Johansson <olofj@chromium.org>
Subject: [24/67] cgroups: fix a css_set not found bug in cgroup_attach_proc
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mandeep Singh Baines <msb@chromium.org>

commit e0197aae59e55c06db172bfbe1a1cdb8c0e1cab3 upstream.

There is a BUG when migrating a PF_EXITING proc. Since css_set_prefetch()
is not called for the PF_EXITING case, find_existing_css_set() will return
NULL inside cgroup_task_migrate() causing a BUG.

This bug is easy to reproduce. Create a zombie and echo its pid to
cgroup.procs.

$ cat zombie.c
\#include <unistd.h>

int main()
{
  if (fork())
      pause();
  return 0;
}
$

We are hitting this bug pretty regularly on ChromeOS.

This bug is already fixed by Tejun Heo's cgroup patchset which is
targetted for the next merge window:

https://lkml.org/lkml/2011/11/1/356

I've create a smaller patch here which just fixes this bug so that a
fix can be merged into the current release and stable.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Downstream-Bug-Report: http://crosbug.com/23953
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: containers@lists.linux-foundation.org
Cc: cgroups@vger.kernel.org
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Olof Johansson <olofj@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/cgroup.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2095,11 +2095,6 @@ int cgroup_attach_proc(struct cgroup *cg
 			continue;
 		/* get old css_set pointer */
 		task_lock(tsk);
-		if (tsk->flags & PF_EXITING) {
-			/* ignore this task if it's going away */
-			task_unlock(tsk);
-			continue;
-		}
 		oldcg = tsk->cgroups;
 		get_css_set(oldcg);
 		task_unlock(tsk);


