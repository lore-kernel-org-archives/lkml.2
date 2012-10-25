Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934303Ab2JYDmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 23:42:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64734 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933520Ab2JYDmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 23:42:43 -0400
X-IronPort-AV: E=Sophos;i="4.80,645,1344182400"; 
   d="scan'208";a="6064360"
From: Hu Tao <hutao@cn.fujitsu.com>
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH v11 3/6] add a new runstate: RUN_STATE_GUEST_PANICKED
Date: Thu, 25 Oct 2012 11:42:35 +0800
Message-Id: <1351136563-15073-3-git-send-email-hutao@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <0a2274eccf1b1dd420f16359f7e1de74fa2f9fbe.1351131144.git.hutao@cn.fujitsu.com>
References: <0a2274eccf1b1dd420f16359f7e1de74fa2f9fbe.1351131144.git.hutao@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/25 11:41:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/25 11:42:02,
	Serialize complete at 2012/10/25 11:42:02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wen Congyang <wency@cn.fujitsu.com>

The guest will be in this state when it is panicked.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 qapi-schema.json |    6 +++++-
 qmp.c            |    3 ++-
 vl.c             |    7 ++++++-
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/qapi-schema.json b/qapi-schema.json
index c615ee2..25a21eb 100644
--- a/qapi-schema.json
+++ b/qapi-schema.json
@@ -174,11 +174,15 @@
 # @suspended: guest is suspended (ACPI S3)
 #
 # @watchdog: the watchdog action is configured to pause and has been triggered
+#
+# @guest-panicked: the panicked action is configured to pause and has been
+# triggered.
 ##
 { 'enum': 'RunState',
   'data': [ 'debug', 'inmigrate', 'internal-error', 'io-error', 'paused',
             'postmigrate', 'prelaunch', 'finish-migrate', 'restore-vm',
-            'running', 'save-vm', 'shutdown', 'suspended', 'watchdog' ] }
+            'running', 'save-vm', 'shutdown', 'suspended', 'watchdog',
+            'guest-panicked' ] }
 
 ##
 # @SnapshotInfo
diff --git a/qmp.c b/qmp.c
index f4a757b..52cc623 100644
--- a/qmp.c
+++ b/qmp.c
@@ -148,7 +148,8 @@ void qmp_cont(Error **errp)
         error_set(errp, QERR_MIGRATION_EXPECTED);
         return;
     } else if (runstate_check(RUN_STATE_INTERNAL_ERROR) ||
-               runstate_check(RUN_STATE_SHUTDOWN)) {
+               runstate_check(RUN_STATE_SHUTDOWN) ||
+               runstate_check(RUN_STATE_GUEST_PANICKED)) {
         error_set(errp, QERR_RESET_REQUIRED);
         return;
     } else if (runstate_check(RUN_STATE_SUSPENDED)) {
diff --git a/vl.c b/vl.c
index ca2e1e2..33b4578 100644
--- a/vl.c
+++ b/vl.c
@@ -373,6 +373,7 @@ static const RunStateTransition runstate_transitions_def[] = {
     { RUN_STATE_RUNNING, RUN_STATE_SAVE_VM },
     { RUN_STATE_RUNNING, RUN_STATE_SHUTDOWN },
     { RUN_STATE_RUNNING, RUN_STATE_WATCHDOG },
+    { RUN_STATE_RUNNING, RUN_STATE_GUEST_PANICKED },
 
     { RUN_STATE_SAVE_VM, RUN_STATE_RUNNING },
 
@@ -387,6 +388,9 @@ static const RunStateTransition runstate_transitions_def[] = {
     { RUN_STATE_WATCHDOG, RUN_STATE_RUNNING },
     { RUN_STATE_WATCHDOG, RUN_STATE_FINISH_MIGRATE },
 
+    { RUN_STATE_GUEST_PANICKED, RUN_STATE_RUNNING },
+    { RUN_STATE_GUEST_PANICKED, RUN_STATE_FINISH_MIGRATE },
+
     { RUN_STATE_MAX, RUN_STATE_MAX },
 };
 
@@ -1617,7 +1621,8 @@ static bool main_loop_should_exit(void)
         qemu_system_reset(VMRESET_REPORT);
         resume_all_vcpus();
         if (runstate_check(RUN_STATE_INTERNAL_ERROR) ||
-            runstate_check(RUN_STATE_SHUTDOWN)) {
+            runstate_check(RUN_STATE_SHUTDOWN) ||
+            runstate_check(RUN_STATE_GUEST_PANICKED)) {
             bdrv_iterate(iostatus_bdrv_it, NULL);
             vm_start();
         }
-- 
1.7.10.2

