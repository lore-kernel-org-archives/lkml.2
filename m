Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751025Ab1L0GXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 01:23:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49999 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab1L0GXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 01:23:42 -0500
Message-ID: <4EF964F3.8090705@cn.fujitsu.com>
Date: Tue, 27 Dec 2011 14:25:55 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH v2] cgroup: fix to allow mounting a hierarchy by name
References: <4EF9291D.7030208@cn.fujitsu.com>
In-Reply-To: <4EF9291D.7030208@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-27 14:22:52,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-27 14:22:52,
	Serialize complete at 2011-12-27 14:22:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we mount a hierarchy with a specified name, the name is unique,
and we can use it to mount the hierarchy without specifying its
set of subsystem names. This feature is documented is
Documentation/cgroups/cgroups.txt section 2.3

Here's an example:

	# mount -t cgroup -o cpuset,name=myhier xxx /cgroup1
	# mount -t cgroup -o name=myhier xxx /cgroup2

But it was broken by commit 32a8cf235e2f192eb002755076994525cdbaa35a
(cgroup: make the mount options parsing more accurate)

This fixes the regression.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

v2: fix code comment s/or/and

---

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1042b3c..8e412fd 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1193,10 +1193,10 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 
 	/*
 	 * If the 'all' option was specified select all the subsystems,
-	 * otherwise 'all, 'none' and a subsystem name options were not
-	 * specified, let's default to 'all'
+	 * otherwise if 'none', 'name=' and a subsystem name options
+	 * were not specified, let's default to 'all'
 	 */
-	if (all_ss || (!all_ss && !one_ss && !opts->none)) {
+	if (all_ss || (!one_ss && !opts->none && !opts->name)) {
 		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 			struct cgroup_subsys *ss = subsys[i];
 			if (ss == NULL)
-- 
1.7.3.1
