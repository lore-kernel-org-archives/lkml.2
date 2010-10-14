Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab0JNPck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 11:32:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33098 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755245Ab0JNPcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 11:32:39 -0400
From: Anand Gadiyar <gadiyar@ti.com>
To: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org
Cc: Anand Gadiyar <gadiyar@ti.com>, Will Deacon <will.deacon@arm.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/2] oprofile: fix linker errors
Date: Thu, 14 Oct 2010 21:01:42 +0530
Message-Id: <1287070303-32404-1-git-send-email-gadiyar@ti.com>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e9677b3ce (oprofile, ARM: Use oprofile_arch_exit() to
cleanup on failure) caused oprofile_perf_exit to be called
in the cleanup path of oprofile_perf_init. The __exit tag
for oprofile_perf_exit should therefore be dropped.

The same has to be done for exit_driverfs as well, as this
function is called from oprofile_perf_exit. Else, we get
the following two linker errors.

  LD      .tmp_vmlinux1
`oprofile_perf_exit' referenced in section `.init.text' of arch/arm/oprofile/built-in.o: defined in discarded section `.exit.text' of arch/arm/oprofile/built-in.o
make: *** [.tmp_vmlinux1] Error 1

  LD      .tmp_vmlinux1
`exit_driverfs' referenced in section `.text' of arch/arm/oprofile/built-in.o: defined in discarded section `.exit.text' of arch/arm/oprofile/built-in.o
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Robert Richter <robert.richter@amd.com>
---

 drivers/oprofile/oprofile_perf.c |    2 +-
 include/linux/oprofile.h         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: mainline/drivers/oprofile/oprofile_perf.c
===================================================================
--- mainline.orig/drivers/oprofile/oprofile_perf.c
+++ mainline/drivers/oprofile/oprofile_perf.c
@@ -236,7 +236,7 @@ static int __init init_driverfs(void)
 	return ret;
 }
 
-static void __exit exit_driverfs(void)
+static void exit_driverfs(void)
 {
 	platform_device_unregister(oprofile_pdev);
 	platform_driver_unregister(&oprofile_driver);
Index: mainline/include/linux/oprofile.h
===================================================================
--- mainline.orig/include/linux/oprofile.h
+++ mainline/include/linux/oprofile.h
@@ -188,7 +188,7 @@ int oprofile_write_commit(struct op_entr
 
 #ifdef CONFIG_PERF_EVENTS
 int __init oprofile_perf_init(struct oprofile_operations *ops);
-void __exit oprofile_perf_exit(void);
+void oprofile_perf_exit(void);
 char *op_name_from_perf_id(void);
 #endif /* CONFIG_PERF_EVENTS */
 
