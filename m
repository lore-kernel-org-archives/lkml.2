Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933988Ab2JLM5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 08:57:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933817Ab2JLM5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 08:57:11 -0400
Date: Fri, 12 Oct 2012 14:57:08 +0200
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] add some drop_caches documentation and info messsge
Message-ID: <20121012125708.GJ10110@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I would like to resurrect the following Dave's patch. The last time it
has been posted was here https://lkml.org/lkml/2010/9/16/250 and there
didn't seem to be any strong opposition. 
Kosaki was worried about possible excessive logging when somebody drops
caches too often (but then he claimed he didn't have a strong opinion
on that) but I would say opposite. If somebody does that then I would
really like to know that from the log when supporting a system because
it almost for sure means that there is something fishy going on. It is
also worth mentioning that only root can write drop caches so this is
not an flooding attack vector.
I am bringing that up again because this can be really helpful when
chasing strange performance issues which (surprise surprise) turn out to
be related to artificially dropped caches done because the admin thinks
this would help...

I have just refreshed the original patch on top of the current mm tree
but I could live with KERN_INFO as well if people think that KERN_NOTICE
is too hysterical.
---
>From 1f4058be9b089bc9d43d71bc63989335d7637d8d Mon Sep 17 00:00:00 2001
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 12 Oct 2012 14:30:54 +0200
Subject: [PATCH] add some drop_caches documentation and info messsge

There is plenty of anecdotal evidence and a load of blog posts
suggesting that using "drop_caches" periodically keeps your system
running in "tip top shape".  Perhaps adding some kernel
documentation will increase the amount of accurate data on its use.

If we are not shrinking caches effectively, then we have real bugs.
Using drop_caches will simply mask the bugs and make them harder
to find, but certainly does not fix them, nor is it an appropriate
"workaround" to limit the size of the caches.

It's a great debugging tool, and is really handy for doing things
like repeatable benchmark runs.  So, add a bit more documentation
about it, and add a little KERN_NOTICE.  It should help developers
who are chasing down reclaim-related bugs.

[mhocko@suse.cz: refreshed to current -mm tree]
Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 Documentation/sysctl/vm.txt |   33 +++++++++++++++++++++++++++------
 fs/drop_caches.c            |    2 ++
 2 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 078701f..21ad181 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -138,18 +138,39 @@ Setting this to zero disables periodic writeback altogether.
 
 drop_caches
 
-Writing to this will cause the kernel to drop clean caches, dentries and
-inodes from memory, causing that memory to become free.
+Writing to this will cause the kernel to drop clean caches, as well as
+reclaimable slab objects like dentries and inodes.  Once dropped, their
+memory becomes free.
 
 To free pagecache:
 	echo 1 > /proc/sys/vm/drop_caches
-To free dentries and inodes:
+To free reclaimable slab objects (includes dentries and inodes):
 	echo 2 > /proc/sys/vm/drop_caches
-To free pagecache, dentries and inodes:
+To free slab objects and pagecache:
 	echo 3 > /proc/sys/vm/drop_caches
 
-As this is a non-destructive operation and dirty objects are not freeable, the
-user should run `sync' first.
+This is a non-destructive operation and will not free any dirty objects.
+To increase the number of objects freed by this operation, the user may run
+`sync' prior to writing to /proc/sys/vm/drop_caches.  This will minimize the
+number of dirty objects on the system and create more candidates to be
+dropped.
+
+This file is not a means to control the growth of the various kernel caches
+(inodes, dentries, pagecache, etc...)  These objects are automatically
+reclaimed by the kernel when memory is needed elsewhere on the system.
+
+Use of this file can cause performance problems.  Since it discards cached
+objects, it may cost a significant amount of I/O and CPU to recreate the
+dropped objects, especially if they were under heavy use.  Because of this,
+use outside of a testing or debugging environment is not recommended.
+
+You may see informational messages in your kernel log when this file is
+used:
+
+	cat (1234): dropped kernel caches: 3
+
+These are informational only.  They do not mean that anything is wrong
+with your system.
 
 ==============================================================
 
diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index c00e055..f72395e 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -58,6 +58,8 @@ int drop_caches_sysctl_handler(ctl_table *table, int write,
 	if (ret)
 		return ret;
 	if (write) {
+		printk(KERN_NOTICE "%s (%d): dropped kernel caches: %d\n",
+			current->comm, task_pid_nr(current), sysctl_drop_caches);
 		if (sysctl_drop_caches & 1)
 			iterate_supers(drop_pagecache_sb, NULL);
 		if (sysctl_drop_caches & 2)
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
