Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab2GUHJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 03:09:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:14752 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab2GUHJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 03:09:18 -0400
X-IronPort-AV: E=Sophos;i="4.77,628,1336320000"; 
   d="scan'208";a="5450275"
Message-ID: <500A56C2.9080204@cn.fujitsu.com>
Date: Sat, 21 Jul 2012 15:14:10 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH 1/6 v7] start vm after reseting it
References: <500A565A.8080403@cn.fujitsu.com>
In-Reply-To: <500A565A.8080403@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/21 15:09:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/21 15:09:56,
	Serialize complete at 2012/07/21 15:09:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The guest should run after reseting it, but it does not run if its
old state is RUN_STATE_INTERNAL_ERROR or RUN_STATE_PAUSED.

We don't set runstate to RUN_STATE_PAUSED when reseting the guest,
so the runstate will be changed from RUN_STATE_INTERNAL_ERROR or
RUN_STATE_PAUSED to RUN_STATE_RUNNING(not RUN_STATE_PAUSED).

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 block.h |    2 ++
 qmp.c   |    2 +-
 vl.c    |    7 ++++---
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/block.h b/block.h
index c89590d..4ed042d 100644
--- a/block.h
+++ b/block.h
@@ -337,6 +337,8 @@ void bdrv_disable_copy_on_read(BlockDriverState *bs);
 void bdrv_set_in_use(BlockDriverState *bs, int in_use);
 int bdrv_in_use(BlockDriverState *bs);
 
+void iostatus_bdrv_it(void *opaque, BlockDriverState *bs);
+
 enum BlockAcctType {
     BDRV_ACCT_READ,
     BDRV_ACCT_WRITE,
diff --git a/qmp.c b/qmp.c
index fee9fb2..a111dff 100644
--- a/qmp.c
+++ b/qmp.c
@@ -125,7 +125,7 @@ SpiceInfo *qmp_query_spice(Error **errp)
 };
 #endif
 
-static void iostatus_bdrv_it(void *opaque, BlockDriverState *bs)
+void iostatus_bdrv_it(void *opaque, BlockDriverState *bs)
 {
     bdrv_iostatus_reset(bs);
 }
diff --git a/vl.c b/vl.c
index 8904db1..c7cee31 100644
--- a/vl.c
+++ b/vl.c
@@ -331,7 +331,7 @@ static const RunStateTransition runstate_transitions_def[] = {
     { RUN_STATE_INMIGRATE, RUN_STATE_RUNNING },
     { RUN_STATE_INMIGRATE, RUN_STATE_PRELAUNCH },
 
-    { RUN_STATE_INTERNAL_ERROR, RUN_STATE_PAUSED },
+    { RUN_STATE_INTERNAL_ERROR, RUN_STATE_RUNNING },
     { RUN_STATE_INTERNAL_ERROR, RUN_STATE_FINISH_MIGRATE },
 
     { RUN_STATE_IO_ERROR, RUN_STATE_RUNNING },
@@ -364,7 +364,7 @@ static const RunStateTransition runstate_transitions_def[] = {
 
     { RUN_STATE_SAVE_VM, RUN_STATE_RUNNING },
 
-    { RUN_STATE_SHUTDOWN, RUN_STATE_PAUSED },
+    { RUN_STATE_SHUTDOWN, RUN_STATE_RUNNING },
     { RUN_STATE_SHUTDOWN, RUN_STATE_FINISH_MIGRATE },
 
     { RUN_STATE_DEBUG, RUN_STATE_SUSPENDED },
@@ -1532,7 +1532,8 @@ static bool main_loop_should_exit(void)
         resume_all_vcpus();
         if (runstate_check(RUN_STATE_INTERNAL_ERROR) ||
             runstate_check(RUN_STATE_SHUTDOWN)) {
-            runstate_set(RUN_STATE_PAUSED);
+            bdrv_iterate(iostatus_bdrv_it, NULL);
+            vm_start();
         }
     }
     if (qemu_powerdown_requested()) {
-- 
1.7.1

