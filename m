Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab1CJX5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:57:12 -0500
Received: from kroah.org ([198.145.64.141]:45159 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311Ab1CJX5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:10 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:36 2011
Message-Id: <20110310235536.118211033@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
        David Rientjes <rientjes@google.com>, Miao Xie <miaox@cn.fujitsu.com>
Subject: [patch 01/29] cpuset: add a missing unlock in cpuset_write_resmask()
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Li Zefan <lizf@cn.fujitsu.com>

commit b75f38d659e6fc747eda64cb72f3920e29dd44a4 upstream.

Don't forget to release cgroup_mutex if alloc_trial_cpuset() fails.

[akpm@linux-foundation.org: avoid multiple return points]
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/cpuset.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1575,8 +1575,10 @@ static int cpuset_write_resmask(struct c
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
@@ -1591,6 +1593,7 @@ static int cpuset_write_resmask(struct c
 	}
 
 	free_trial_cpuset(trialcs);
+out:
 	cgroup_unlock();
 	return retval;
 }


