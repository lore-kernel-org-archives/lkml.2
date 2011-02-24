Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab1BXGzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 01:55:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51221 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753235Ab1BXGzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 01:55:12 -0500
Message-ID: <4D660130.8020009@cn.fujitsu.com>
Date: Thu, 24 Feb 2011 14:56:48 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, David Rientjes <rientjes@google.com>,
        =?UTF-8?B?57yqIOWLsA==?= <miaox@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [PATCH v2 1/4] cpuset: Remove unneeded NODEMASK_ALLOC() in cpuset_sprintf_memlist()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-24 14:54:07,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-24 14:54:08,
	Serialize complete at 2011-02-24 14:54:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not necessary to copy cpuset->mems_allowed to a buffer
allocated by NODEMASK_ALLOC(). Just pass it to nodelist_scnprintf().

As spotted by Paul, a side effect is we fix a bug that the function
can return -ENOMEM but the caller doesn't expect negative return
value. Therefore change the return value of cpuset_sprintf_cpulist()
and cpuset_sprintf_memlist() from int to size_t.

Acked-by: Paul Menage <menage@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cpuset.c |   24 ++++++++----------------
 1 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 10f1835..e79650b 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1607,34 +1607,26 @@ static int cpuset_write_resmask(struct cgroup *cgrp, struct cftype *cft,
  * across a page fault.
  */
 
-static int cpuset_sprintf_cpulist(char *page, struct cpuset *cs)
+static size_t cpuset_sprintf_cpulist(char *page, struct cpuset *cs)
 {
-	int ret;
+	size_t count;
 
 	mutex_lock(&callback_mutex);
-	ret = cpulist_scnprintf(page, PAGE_SIZE, cs->cpus_allowed);
+	count = cpulist_scnprintf(page, PAGE_SIZE, cs->cpus_allowed);
 	mutex_unlock(&callback_mutex);
 
-	return ret;
+	return count;
 }
 
-static int cpuset_sprintf_memlist(char *page, struct cpuset *cs)
+static size_t cpuset_sprintf_memlist(char *page, struct cpuset *cs)
 {
-	NODEMASK_ALLOC(nodemask_t, mask, GFP_KERNEL);
-	int retval;
-
-	if (mask == NULL)
-		return -ENOMEM;
+	size_t count;
 
 	mutex_lock(&callback_mutex);
-	*mask = cs->mems_allowed;
+	count = nodelist_scnprintf(page, PAGE_SIZE, cs->mems_allowed);
 	mutex_unlock(&callback_mutex);
 
-	retval = nodelist_scnprintf(page, PAGE_SIZE, *mask);
-
-	NODEMASK_FREE(mask);
-
-	return retval;
+	return count;
 }
 
 static ssize_t cpuset_common_file_read(struct cgroup *cont,
-- 
1.7.3.1
