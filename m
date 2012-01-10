Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082Ab2AJW5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 17:57:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932668Ab2AJW5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:57:36 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:46:19 2012
Message-Id: <20120110214619.861516594@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:45:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Li Zefan <lizf@cn.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Subject: [19/40] cgroup: fix to allow mounting a hierarchy by name
In-Reply-To: <20120110214630.GA14384@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizf@cn.fujitsu.com>

commit 0d19ea866562e46989412a0676412fa0983c9ce7 upstream.

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
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/cgroup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1173,10 +1173,10 @@ static int parse_cgroupfs_options(char *
 
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


