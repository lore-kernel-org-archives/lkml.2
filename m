Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab1BQBsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 20:48:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61962 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab1BQBsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 20:48:16 -0500
Message-ID: <4D5C7EA7.1030409@cn.fujitsu.com>
Date: Thu, 17 Feb 2011 09:49:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        David Rientjes <rientjes@google.com>,
        =?UTF-8?B?57yqIOWLsA==?= <miaox@cn.fujitsu.com>, linux-mm@kvack.org
Subject: [PATCH 1/4] cpuset: Remove unneeded NODEMASK_ALLOC() in cpuset_sprintf_memlist()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-17 09:47:11,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-17 09:47:17,
	Serialize complete at 2011-02-17 09:47:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not necessary to copy cpuset->mems_allowed to a buffer
allocated by NODEMASK_ALLOC(). Just pass it to nodelist_scnprintf().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cpuset.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 10f1835..f13ff2e 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1620,20 +1620,12 @@ static int cpuset_sprintf_cpulist(char *page, struct cpuset *cs)
 
 static int cpuset_sprintf_memlist(char *page, struct cpuset *cs)
 {
-	NODEMASK_ALLOC(nodemask_t, mask, GFP_KERNEL);
 	int retval;
 
-	if (mask == NULL)
-		return -ENOMEM;
-
 	mutex_lock(&callback_mutex);
-	*mask = cs->mems_allowed;
+	retval = nodelist_scnprintf(page, PAGE_SIZE, cs->mems_allowed);
 	mutex_unlock(&callback_mutex);
 
-	retval = nodelist_scnprintf(page, PAGE_SIZE, *mask);
-
-	NODEMASK_FREE(mask);
-
 	return retval;
 }
 
-- 
1.7.3.1
