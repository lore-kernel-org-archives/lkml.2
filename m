Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab1LGQ5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:57:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33227 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756973Ab1LGQSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:18:23 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:24 2011
Message-Id: <20111207160824.801299363@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:06:46 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Michal Hocko <mhocko@suse.cz>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Tomasz Buchert <tomasz.buchert@inria.fr>,
        Paul Menage <paul@paulmenage.org>, Tejun Heo <htejun@gmail.com>
Subject: [26/80] cgroup_freezer: fix freezing groups with stopped tasks
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Hocko <mhocko@suse.cz>

commit 884a45d964dd395eda945842afff5e16bcaedf56 upstream.

2d3cbf8b (cgroup_freezer: update_freezer_state() does incorrect state
transitions) removed is_task_frozen_enough and replaced it with a simple
frozen call. This, however, breaks freezing for a group with stopped tasks
because those cannot be frozen and so the group remains in CGROUP_FREEZING
state (update_if_frozen doesn't count stopped tasks) and never reaches
CGROUP_FROZEN.

Let's add is_task_frozen_enough back and use it at the original locations
(update_if_frozen and try_to_freeze_cgroup). Semantically we consider
stopped tasks as frozen enough so we should consider both cases when
testing frozen tasks.

Testcase:
mkdir /dev/freezer
mount -t cgroup -o freezer none /dev/freezer
mkdir /dev/freezer/foo
sleep 1h &
pid=$!
kill -STOP $pid
echo $pid > /dev/freezer/foo/tasks
echo FROZEN > /dev/freezer/foo/freezer.state
while true
do
	cat /dev/freezer/foo/freezer.state
	[ "`cat /dev/freezer/foo/freezer.state`" = "FROZEN" ] && break
	sleep 1
done
echo OK

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tomasz Buchert <tomasz.buchert@inria.fr>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/cgroup_freezer.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -153,6 +153,13 @@ static void freezer_destroy(struct cgrou
 	kfree(cgroup_freezer(cgroup));
 }
 
+/* task is frozen or will freeze immediately when next it gets woken */
+static bool is_task_frozen_enough(struct task_struct *task)
+{
+	return frozen(task) ||
+		(task_is_stopped_or_traced(task) && freezing(task));
+}
+
 /*
  * The call to cgroup_lock() in the freezer.state write method prevents
  * a write to that file racing against an attach, and hence the
@@ -231,7 +238,7 @@ static void update_if_frozen(struct cgro
 	cgroup_iter_start(cgroup, &it);
 	while ((task = cgroup_iter_next(cgroup, &it))) {
 		ntotal++;
-		if (frozen(task))
+		if (is_task_frozen_enough(task))
 			nfrozen++;
 	}
 
@@ -284,7 +291,7 @@ static int try_to_freeze_cgroup(struct c
 	while ((task = cgroup_iter_next(cgroup, &it))) {
 		if (!freeze_task(task, true))
 			continue;
-		if (frozen(task))
+		if (is_task_frozen_enough(task))
 			continue;
 		if (!freezing(task) && !freezer_should_skip(task))
 			num_cant_freeze_now++;


