Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab2HHCjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 22:39:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:47249 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755225Ab2HHCjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 22:39:53 -0400
X-IronPort-AV: E=Sophos;i="4.77,730,1336320000"; 
   d="scan'208";a="5577033"
Message-ID: <5021D2AB.4070005@cn.fujitsu.com>
Date: Wed, 08 Aug 2012 10:44:59 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH v8 1/6] start vm after reseting it
References: <5021D235.4050800@cn.fujitsu.com>
In-Reply-To: <5021D235.4050800@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/08 10:40:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/08 10:40:14,
	Serialize complete at 2012/08/08 10:40:14
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
index 650d872..29449bd 100644
--- a/block.h
+++ b/block.h
@@ -338,6 +338,8 @@ void bdrv_disable_copy_on_read(BlockDriverState *bs);
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
index e71cb30..856e089 100644
--- a/vl.c
+++ b/vl.c
@@ -333,7 +333,7 @@ static const RunStateTransition runstate_transitions_def[] = {
     { RUN_STATE_INMIGRATE, RUN_STATE_RUNNING },
     { RUN_STATE_INMIGRATE, RUN_STATE_PRELAUNCH },
 
-    { RUN_STATE_INTERNAL_ERROR, RUN_STATE_PAUSED },
+    { RUN_STATE_INTERNAL_ERROR, RUN_STATE_RUNNING },
     { RUN_STATE_INTERNAL_ERROR, RUN_STATE_FINISH_MIGRATE },
 
     { RUN_STATE_IO_ERROR, RUN_STATE_RUNNING },
@@ -366,7 +366,7 @@ static const RunStateTransition runstate_transitions_def[] = {
 
     { RUN_STATE_SAVE_VM, RUN_STATE_RUNNING },
 
-    { RUN_STATE_SHUTDOWN, RUN_STATE_PAUSED },
+    { RUN_STATE_SHUTDOWN, RUN_STATE_RUNNING },
     { RUN_STATE_SHUTDOWN, RUN_STATE_FINISH_MIGRATE },
 
     { RUN_STATE_DEBUG, RUN_STATE_SUSPENDED },
@@ -1531,7 +1531,8 @@ static bool main_loop_should_exit(void)
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

