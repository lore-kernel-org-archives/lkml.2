Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab1DVLEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 07:04:37 -0400
Received: from smtp.nokia.com ([147.243.1.47]:51975 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474Ab1DVLEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 07:04:36 -0400
From: Roman Borisov <ext-roman.borisov@nokia.com>
To: akpm@linux-foundation.org
Cc: viro@zeniv.linux.org.uk, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org,
        Roman Borisov <ext-roman.borisov@nokia.com>
Subject: [PATCH v4] fs: namespacec bound mount propagation fix
Date: Fri, 22 Apr 2011 15:05:58 +0400
Message-Id: <c2799b0befd5248ff99e7f57400ea860c1f1417c.1303469255.git.ext-roman.borisov@nokia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20110421130412.ea953cbc.akpm@linux-foundation.org>
References: <20110421130412.ea953cbc.akpm@linux-foundation.org>
X-OriginalArrivalTime: 22 Apr 2011 11:03:59.0267 (UTC) FILETIME=[FB1CB730:01CC00DC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue was discovered by users of busybox.  And the bug is actual for 
busybox users, I don't know how it affects others. Apparently, mount is
called with and without MS_SILENT, and this affects mount() behaviour.
But MS_SILENT is only supposed to affect kernel logging verbosity.

There is the script to reproduce the issue in busybox environment:
mkdir -p mount.dir mount.shared1 mount.shared2
touch mount.dir/a mount.dir/b
mount -vv --bind mount.shared1 mount.shared1
mount -vv --make-rshared mount.shared1
mount -vv --bind mount.shared2 mount.shared2
mount -vv --make-rshared mount.shared2
mount -vv --bind mount.shared2 mount.shared1
mount -vv --bind mount.dir     mount.shared2
ls -R mount.dir mount.shared1 mount.shared2 

actual resul after the fourth command is error:
mount: mount.shared1: Invalid argument

but expected result is:
mount.dir:
a  b
mount.shared1:
a  b
mount.shared2:
a  b

The analysis shows that MS_SILENT flag which is ON by default in any busybox->
mount operations cames to flags_to_propagation_type function and causes the
error return while is_power_of_2 checking because the function expects only one 
bit set. This doesn't allow to do busybox->mount with 
any --make-[r]shared, --make-[r]private etc options.

Signed-off-by: Roman Borisov <ext-roman.borisov@nokia.com>
---
 fs/namespace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 7dba2ed..e7c479e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1711,7 +1711,7 @@ static int graft_tree(struct vfsmount *mnt, struct path *path)
 
 static int flags_to_propagation_type(int flags)
 {
-	int type = flags & ~MS_REC;
+	int type = flags & ~(MS_REC | MS_SILENT);
 
 	/* Fail if any non-propagation flags are set */
 	if (type & ~(MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
-- 
1.7.0.4

