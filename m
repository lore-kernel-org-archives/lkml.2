Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab2DFUZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 16:25:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:41978 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757903Ab2DFUZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 16:25:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="126178226"
Subject: [PATCH v2 2/2] sysfs: provide more diagnostic info for
 kobject_add_internal() failures
To: gregkh@linuxfoundation.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: James Bottomley <JBottomley@parallels.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Date: Fri, 06 Apr 2012 13:41:15 -0700
Message-ID: <20120406204111.22624.34820.stgit@dwillia2-linux.jf.intel.com>
In-Reply-To: <20120406203619.22624.69445.stgit@dwillia2-linux.jf.intel.com>
References: <20120406203619.22624.69445.stgit@dwillia2-linux.jf.intel.com>
User-Agent: StGit/0.16-1-g7004
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1/ convert open-coded KERN_ERR+dump_stack() to WARN(), so that automated
   tools pick up this warning.

2/ include the 'child' and 'parent' kobject names.  This information was
   useful for tracking down the case where scsi invoked device_del() on a
   parent object and subsequently invoked device_add() on a child.  Now the
   warning looks like:

     kobject_add_internal failed for target8:0:16 (error: -2 parent: end_device-8:0:24)
     Pid: 2942, comm: scsi_scan_8 Not tainted 3.3.0-rc7-isci+ #2
     Call Trace:
      [<ffffffff8125e551>] kobject_add_internal+0x1c1/0x1f3
      [<ffffffff81075149>] ? trace_hardirqs_on+0xd/0xf
      [<ffffffff8125e659>] kobject_add_varg+0x41/0x50
      [<ffffffff8125e723>] kobject_add+0x64/0x66
      [<ffffffff8131124b>] device_add+0x12d/0x63a
      [<ffffffff8125e0ef>] ? kobject_put+0x4c/0x50
      [<ffffffff8132f370>] scsi_sysfs_add_sdev+0x4e/0x28a
      [<ffffffff8132dce3>] do_scan_async+0x9c/0x145

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: James Bottomley <JBottomley@parallels.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 lib/kobject.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index c33d7a1..1bd0893 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -192,14 +192,14 @@ static int kobject_add_internal(struct kobject *kobj)
 
 		/* be noisy on error issues */
 		if (error == -EEXIST)
-			printk(KERN_ERR "%s failed for %s with "
-			       "-EEXIST, don't try to register things with "
-			       "the same name in the same directory.\n",
-			       __func__, kobject_name(kobj));
+			WARN(1, "%s failed for %s with "
+			     "-EEXIST, don't try to register things with "
+			     "the same name in the same directory.\n",
+			     __func__, kobject_name(kobj));
 		else
-			printk(KERN_ERR "%s failed for %s (%d)\n",
-			       __func__, kobject_name(kobj), error);
-		dump_stack();
+			WARN(1, "%s failed for %s (error: %d parent: %s)\n",
+			     __func__, kobject_name(kobj), error,
+			     parent ? kobject_name(parent) : "'none'");
 	} else
 		kobj->state_in_sysfs = 1;
 

