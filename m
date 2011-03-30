Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965051Ab1C3Vbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:31:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:48428 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965012Ab1C3VIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133583"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: lizf@cn.fujitsu.com, ak@linux.intel.com, menage@google.com,
        rientjes@google.com, miaox@cn.fujitsu.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [173/275] cpuset: add a missing unlock in cpuset_write_resmask()
Message-Id: <20110330210655.D946A3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Li Zefan <lizf@cn.fujitsu.com>

commit b75f38d659e6fc747eda64cb72f3920e29dd44a4 upstream.

Don't forget to release cgroup_mutex if alloc_trial_cpuset() fails.

[akpm@linux-foundation.org: avoid multiple return points]
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Paul Menage <menage@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/cpuset.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/kernel/cpuset.c
===================================================================
--- linux-2.6.35.y.orig/kernel/cpuset.c	2011-03-29 22:50:54.764857122 -0700
+++ linux-2.6.35.y/kernel/cpuset.c	2011-03-29 23:03:01.845252954 -0700
@@ -1576,8 +1576,10 @@
 		return -ENODEV;
 
 	trialcs = alloc_trial_cpuset(cs);
-	if (!trialcs)
-		return -ENOMEM;
+	if (!trialcs) {
+		retval = -ENOMEM;
+		goto out;
+	}
 
 	switch (cft->private) {
 	case FILE_CPULIST:
@@ -1592,6 +1594,7 @@
 	}
 
 	free_trial_cpuset(trialcs);
+out:
 	cgroup_unlock();
 	return retval;
 }
