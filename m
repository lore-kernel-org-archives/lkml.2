Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab1FBQaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 12:30:20 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46034 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab1FBQaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 12:30:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6364"; a="95153924"
From: Laura Abbott <lauraa@codeaurora.org>
To: linux-kernel@vger.kernel.org, gregkh@suse.de
Cc: Laura Abbott <lauraa@codeaurora.org>
Subject: [PATCH] kobject: mark object as not initialized after release
Date: Thu,  2 Jun 2011 09:29:47 -0700
Message-Id: <1307032187-15823-1-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During kobject initalization, state_initialized is set to 1. This state
is never set back to 0, even after release. This results in re-initialized
object warnings if the kobject needs to be reinitialized after release. On
a statically allocated platform device and driver:

platform_device_register(&my_device)
platform_driver_register(&my_matching_driver)
platform_device_unregister(&my_device)
platform_device_register(&my_device)

gives

kobject (bf000128): tried to init an initialized object, something is seriously wrong.
[<c0053964>] (unwind_backtrace+0x0/0x128) from [<c02bd444>] (kobject_init+0x38/0x8c)
[<c02bd444>] (kobject_init+0x38/0x8c) from [<c03445cc>] (device_initialize+0x20/0x68)
[<c03445cc>] (device_initialize+0x20/0x68) from [<c0348924>] (platform_device_register+0x10/0x1c)
[<c0348924>] (platform_device_register+0x10/0x1c) from [<bf00305c>] (platform_driver_test_init+0x5c/0x7c [platform_driver_test])
[<bf00305c>] (platform_driver_test_init+0x5c/0x7c [platform_driver_test]) from [<c00466e8>] (do_one_initcall+0xd0/0x1a4)
[<c00466e8>] (do_one_initcall+0xd0/0x1a4) from [<c0109ea4>] (sys_init_module+0x90/0x1ac)

since the kobject that is part of the platform device (mydevice.dev.kobj) never
had the state_initialized reset despite eventually calling kobject_release.

Fix this by setting state_initialized on a released kobject back to 0 as any
state referenced after releasing is undefined.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 lib/kobject.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 82dc34c..00390e3 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -577,7 +577,10 @@ static void kobject_cleanup(struct kobject *kobj)
 
 static void kobject_release(struct kref *kref)
 {
-	kobject_cleanup(container_of(kref, struct kobject, kref));
+	struct kobject *kobj = container_of(kref, struct kobject, kref);
+
+	kobject_cleanup(kobj);
+	kobj->state_initialized = 0;
 }
 
 /**
-- 
1.7.3.3

