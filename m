Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab0JEInQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 04:43:16 -0400
Received: from smtp.nokia.com ([192.100.105.134]:65374 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757921Ab0JEInP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 04:43:15 -0400
From: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
To: menage@google.com, lizf@cn.fujitsu.com
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
        bblum@andrew.cmu.edu, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, ext-eugeny.kuznetsov@nokia.com
Subject: [PATCH 1/1] cgroups: strcpy destination string overflow
Date: Tue,  5 Oct 2010 12:38:05 +0400
Message-Id: <2acb25707f916de866aa520b1a9f04f0f48c949c.1286193571.git.EXT-Eugeny.Kuznetsov@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <cover.1286193571.git.EXT-Eugeny.Kuznetsov@nokia.com>
References: <cover.1286193571.git.EXT-Eugeny.Kuznetsov@nokia.com>
In-Reply-To: <cover.1286193571.git.EXT-Eugeny.Kuznetsov@nokia.com>
References: <cover.1286193571.git.EXT-Eugeny.Kuznetsov@nokia.com>
X-OriginalArrivalTime: 05 Oct 2010 08:41:40.0016 (UTC) FILETIME=[211E2B00:01CB6469]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeny Kuznetsov <ext-eugeny.kuznetsov@nokia.com>

Function "strcpy" is used without check for maximum allowed source
string length and could cause destination string overflow.
Check for string length is added before using "strcpy".
Function now is return error if source string length is more than
a maximum.

Signed-off-by: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
---
 kernel/cgroup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c9483d8..82bbede 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1883,6 +1883,8 @@ static int cgroup_release_agent_write(struct cgroup *cgrp, struct cftype *cft,
 				      const char *buffer)
 {
 	BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
+	if (strlen(buffer) >= PATH_MAX)
+		return -EINVAL;
 	if (!cgroup_lock_live_group(cgrp))
 		return -ENODEV;
 	strcpy(cgrp->root->release_agent_path, buffer);
-- 
1.6.3.3

