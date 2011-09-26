Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab1IZIf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 04:35:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54132 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab1IZIf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 04:35:57 -0400
Date: Mon, 26 Sep 2011 10:35:55 +0200
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 2/2] oom: give bonus to frozen processes
Message-ID: <20110926083555.GD10156@tiehlicka.suse.cz>
References: <alpine.DEB.2.00.1108241226550.31357@chino.kir.corp.google.com>
 <20110825091920.GA22564@tiehlicka.suse.cz>
 <20110825151818.GA4003@redhat.com>
 <20110825164758.GB22564@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1108251404130.18747@chino.kir.corp.google.com>
 <20110826070946.GA7280@tiehlicka.suse.cz>
 <20110826085610.GA9083@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1108260218050.14732@chino.kir.corp.google.com>
 <20110826095356.GB9083@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1108261110020.13943@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1108261110020.13943@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 26-08-11 11:13:40, David Rientjes wrote:
> On Fri, 26 Aug 2011, Michal Hocko wrote:
[...]
> > I am not saying the bonus is necessary, though. It depends on what
> > the freezer is used for (e.g. freeze a process which went wild and
> > debug what went wrong wouldn't welcome that somebody killed it or other
> > (mis)use which relies on D state).
[...]
> If it actually does come down to a heuristic change, then it need not 
> happen in the oom killer: the freezing code would need to use 
> test_set_oom_score_adj() to temporarily reduce the oom_score_adj for that 
> task until it comes out of the refrigerator.  We already use that in ksm 
> and swapoff to actually prefer threads, but we can use it to bias against 
> threads as well.

Let's try it with a heuristic change first. If you really do not like
it, we can move to oom_scode_adj. I like the heuristic change little bit
more because it is at the same place as the root bonus.
---
>From 2f8fbab922f353eebaa9fa1c5fcb59a59cf2f441 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 16 Sep 2011 15:51:25 +0200
Subject: [PATCH 2/2] oom: give bonus to frozen processes

We do not want to kill frozen processes if there are some processes that
could be killed instead. Frozen tasks are in uninterruptible sleep and
somebody might rely on that.
Let's give those tasks a bonus so that they would be selected only when
really necessary. The size of the bonus is questionable but let's start
with the same bonus we give to root processes.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/oom.h |    6 ++++++
 mm/oom_kill.c       |   10 +++++++++-
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/include/linux/oom.h b/include/linux/oom.h
index 13b7b02e..960e2de 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -13,6 +13,12 @@
 #define OOM_ADJUST_MAX 15
 
 /*
+ * Bonus (3%) for a task that shouldn't be killed unless necessary.
+ * We give this bonus to root and frozen tasks currently.
+ */
+#define OOM_BONUS 30
+
+/*
  * /proc/<pid>/oom_score_adj set to OOM_SCORE_ADJ_MIN disables oom killing for
  * pid.
  */
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index b9774f3..4aea1b3 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -205,7 +205,15 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
 	 * implementation used by LSMs.
 	 */
 	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
-		points -= 30;
+		points -= OOM_BONUS;
+
+	/*
+	 * Do not try to kill frozen tasks unless there is nothing else to kill.
+	 * We do not want to give it 1 point because we still want to select a good
+	 * candidate among all frozen tasks. Let's give it a reasonable bonus.
+	 */
+	if (frozen(p))
+		points -= OOM_BONUS;
 
 	/*
 	 * /proc/pid/oom_score_adj ranges from -1000 to +1000 such that it may
-- 
1.7.5.4


-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
