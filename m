Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab2DFUZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 16:25:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:38451 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757903Ab2DFUZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 16:25:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="129554168"
Subject: [PATCH v2 1/2] sysfs: handle 'parent deleted before child added'
To: gregkh@linuxfoundation.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: James Bottomley <JBottomley@parallels.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Date: Fri, 06 Apr 2012 13:41:06 -0700
Message-ID: <20120406203619.22624.69445.stgit@dwillia2-linux.jf.intel.com>
User-Agent: StGit/0.16-1-g7004
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In scsi at least two cases of the parent device being deleted before the
child is added have been observed.

1/ scsi is performing async scans and the device is removed prior to the
   async can thread running (can happen with an in-opportune / unlikely
   unplug during initial scan).

2/ libsas discovery event running after the parent port has been torn
   down (this is a bug in libsas).

Result in crash signatures like:
 BUG: unable to handle kernel NULL pointer dereference at 0000000000000098
 IP: [<ffffffff8115e100>] sysfs_create_dir+0x32/0xb6
 ...
 Process scsi_scan_8 (pid: 5417, threadinfo ffff88080bd16000, task ffff880801b8a0b0)
 Stack:
  00000000fffffffe ffff880813470628 ffff88080bd17cd0 ffff88080614b7e8
  ffff88080b45c108 00000000fffffffe ffff88080bd17d20 ffffffff8125e4a8
  ffff88080bd17cf0 ffffffff81075149 ffff88080bd17d30 ffff88080614b7e8
 Call Trace:
  [<ffffffff8125e4a8>] kobject_add_internal+0x120/0x1e3
  [<ffffffff81075149>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff8125e641>] kobject_add_varg+0x41/0x50
  [<ffffffff8125e70b>] kobject_add+0x64/0x66
  [<ffffffff8131122b>] device_add+0x12d/0x63a

In this scenario the parent is still valid (because we have a
reference), but it has been device_del()'d which means its kobj->sd
pointer is NULL'd via:

 device_del()->kobject_del()->sysfs_remove_dir()

...and then sysfs_create_dir() (without this fix) goes ahead and
de-references parent_sd via sysfs_ns_type():

 return (sd->s_flags & SYSFS_NS_TYPE_MASK) >> SYSFS_NS_TYPE_SHIFT;

This scenario is being fixed in scsi/libsas, but if other subsystems
present the same ordering the system need not immediately crash.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: James Bottomley <JBottomley@parallels.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

Changes since v1: http://marc.info/?l=linux-scsi&m=133239707303441&w=2

1/ split out the kobject_add_internal() warning message changes into
   its own patch

2/ clarified the changelog a bit due to the discussion from v1.

I think this patch can wait until 3.5, since it is just closing a hole I
found along the way to fixing the real bug.  Now, the system won't crash
at device_add() time, but the system may still be de-stabilized if the
caller does not handle device_add() errors properly.

 fs/sysfs/dir.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 7fdf6a7..86521ee 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -714,6 +714,9 @@ int sysfs_create_dir(struct kobject * kobj)
 	else
 		parent_sd = &sysfs_root;
 
+	if (!parent_sd)
+		return -ENOENT;
+
 	if (sysfs_ns_type(parent_sd))
 		ns = kobj->ktype->namespace(kobj);
 	type = sysfs_read_ns_type(kobj);

