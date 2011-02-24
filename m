Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab1BXG4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 01:56:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62261 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932485Ab1BXG4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 01:56:05 -0500
Message-ID: <4D660167.7070400@cn.fujitsu.com>
Date: Thu, 24 Feb 2011 14:57:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, David Rientjes <rientjes@google.com>,
        =?UTF-8?B?57yqIOWLsA==?= <miaox@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [PATCH v2 4/4] cpuset: Hold callback_mutex in cpuset_clone()
References: <4D660130.8020009@cn.fujitsu.com>
In-Reply-To: <4D660130.8020009@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-24 14:55:00,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-24 14:55:01,
	Serialize complete at 2011-02-24 14:55:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chaning cpuset->mems/cpuset->cpus should be protected under
callback_mutex.

cpuset_post_clone() doesn't follow this rule. It's ok because it's
called when creating/initializing a cgroup, but we'd better
hold the lock to avoid subtil break in the future.

Acked-by: Paul Menage <menage@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cpuset.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3f93e5a..1ca786a 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1836,8 +1836,10 @@ static void cpuset_post_clone(struct cgroup_subsys *ss,
 	cs = cgroup_cs(cgroup);
 	parent_cs = cgroup_cs(parent);
 
+	mutex_lock(&callback_mutex);
 	cs->mems_allowed = parent_cs->mems_allowed;
 	cpumask_copy(cs->cpus_allowed, parent_cs->cpus_allowed);
+	mutex_unlock(&callback_mutex);
 	return;
 }
 
-- 
1.7.3.1
