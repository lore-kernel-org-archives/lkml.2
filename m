Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab0INXrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 19:47:17 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56716 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab0INXrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 19:47:16 -0400
Subject: [RFC][PATCH] update /proc/sys/vm/drop_caches documentation
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, lnxninja@linux.vnet.ibm.com,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Tue, 14 Sep 2010 16:47:14 -0700
Message-Id: <20100914234714.8AF506EA@kernel.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There seems to be an epidemic spreading around.  People get the idea
in their heads that the kernel caches are evil.  They eat too much
memory, and there's no way to set a size limit on them!  Stupid
kernel!

There is plenty of anecdotal evidence and a load of blog posts
suggesting that using "drop_caches" periodically keeps your system
running in "tip top shape".  I do not think that is true.

If we are not shrinking caches effectively, then we have real bugs.
Using drop_caches will simply mask the bugs and make them harder
to find, but certainly does not fix them, nor is it an appropriate
"workaround" to limit the size of the caches.

It's a great debugging tool, and is really handy for doing things
like repeatable benchmark runs.  So, add a bit more documentation
about it, and add a WARN_ONCE().  Maybe the warning will scare
some sense into people.


Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/Documentation/sysctl/vm.txt |   14 ++++++++++++--
 linux-2.6.git-dave/fs/drop_caches.c            |    2 ++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff -puN Documentation/sysctl/vm.txt~update-drop_caches-documentation Documentation/sysctl/vm.txt
--- linux-2.6.git/Documentation/sysctl/vm.txt~update-drop_caches-documentation	2010-09-14 15:30:19.000000000 -0700
+++ linux-2.6.git-dave/Documentation/sysctl/vm.txt	2010-09-14 16:40:58.000000000 -0700
@@ -145,8 +145,18 @@ To free dentries and inodes:
 To free pagecache, dentries and inodes:
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
+Outside of a testing or debugging environment, use of
+/proc/sys/vm/drop_caches is not recommended.
 
 ==============================================================
 
diff -puN fs/drop_caches.c~update-drop_caches-documentation fs/drop_caches.c
--- linux-2.6.git/fs/drop_caches.c~update-drop_caches-documentation	2010-09-14 15:44:29.000000000 -0700
+++ linux-2.6.git-dave/fs/drop_caches.c	2010-09-14 15:58:31.000000000 -0700
@@ -47,6 +47,8 @@ int drop_caches_sysctl_handler(ctl_table
 {
 	proc_dointvec_minmax(table, write, buffer, length, ppos);
 	if (write) {
+		WARN_ONCE(1, "kernel caches forcefully dropped, "
+			     "see Documentation/sysctl/vm.txt\n");
 		if (sysctl_drop_caches & 1)
 			iterate_supers(drop_pagecache_sb, NULL);
 		if (sysctl_drop_caches & 2)
diff -puN include/linux/kernel.h~update-drop_caches-documentation include/linux/kernel.h
diff -puN drivers/pci/intel-iommu.c~update-drop_caches-documentation drivers/pci/intel-iommu.c
diff -puN drivers/pci/dmar.c~update-drop_caches-documentation drivers/pci/dmar.c
_
