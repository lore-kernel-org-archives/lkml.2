Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855Ab2F0XCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 19:02:38 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51392 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756828Ab2F0XCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 19:02:36 -0400
Date: Wed, 27 Jun 2012 16:02:30 -0700
From: "tj@kernel.org" <tj@kernel.org>
To: shyju pv <shyju.pv@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Sanil kumar <sanil.kumar@huawei.com>,
        Masanari Iida <standby24x7@gmail.com>, Li Zefan <lizefan@huawei.com>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup
 cgroup]
Message-ID: <20120627230230.GT15811@google.com>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com>
 <20120627182903.GP15811@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627182903.GP15811@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Does the following patch make the problem go away?

Thank you.

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2097684..f9556cf 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3644,6 +3644,7 @@ static void cgroup_event_remove(struct work_struct *work)
 	eventfd_ctx_put(event->eventfd);
 	kfree(event);
 	dput(cgrp->dentry);
+	deactivate_super(cgrp->root->sb);
 }
 
 /*
@@ -3770,6 +3771,7 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 	 * destroying subsystem state objects. Let's take reference to cgroup
 	 * directory dentry to do that.
 	 */
+	atomic_inc(&cgrp->root->sb->s_active);
 	dget(cgrp->dentry);
 
 	spin_lock(&cgrp->event_list_lock);
