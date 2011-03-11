Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab1CKUnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:43:01 -0500
Received: from kroah.org ([198.145.64.141]:46517 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163Ab1CKUnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:43:00 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 11 12:41:09 2011
Message-Id: <20110311204109.443501113@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 11 Mar 2011 12:40:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
        David Rientjes <rientjes@google.com>, Miao Xie <miaox@cn.fujitsu.com>
Subject: [01/17] cpuset: add a missing unlock in cpuset_write_resmask()
In-Reply-To: <20110311204126.GA7223@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -1514,8 +1514,10 @@ static int cpuset_write_resmask(struct c
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
@@ -1530,6 +1532,7 @@ static int cpuset_write_resmask(struct c
 	}
 
 	free_trial_cpuset(trialcs);
+out:
 	cgroup_unlock();
 	return retval;
 }


