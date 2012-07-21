Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab2GUHKt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 03:10:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:37942 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab2GUHKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 03:10:47 -0400
X-IronPort-AV: E=Sophos;i="4.77,628,1336320000"; 
   d="scan'208";a="5450283"
Message-ID: <500A571B.8010109@cn.fujitsu.com>
Date: Sat, 21 Jul 2012 15:15:39 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH 3/6 v7] add a new runstate: RUN_STATE_GUEST_PANICKED
References: <500A565A.8080403@cn.fujitsu.com>
In-Reply-To: <500A565A.8080403@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/21 15:11:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/21 15:11:25,
	Serialize complete at 2012/07/21 15:11:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The guest will be in this state when it is panicked.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 qapi-schema.json |    6 +++++-
 qmp.c            |    3 ++-
 vl.c             |    7 ++++++-
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/qapi-schema.json b/qapi-schema.json
index a92adb1..5889af7 100644
--- a/qapi-schema.json
+++ b/qapi-schema.json
@@ -119,11 +119,15 @@
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
 # @StatusInfo:
diff --git a/qmp.c b/qmp.c
index a111dff..3b0c9bc 100644
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
index c7cee31..5e33c97 100644
--- a/vl.c
+++ b/vl.c
@@ -361,6 +361,7 @@ static const RunStateTransition runstate_transitions_def[] = {
     { RUN_STATE_RUNNING, RUN_STATE_SAVE_VM },
     { RUN_STATE_RUNNING, RUN_STATE_SHUTDOWN },
     { RUN_STATE_RUNNING, RUN_STATE_WATCHDOG },
+    { RUN_STATE_RUNNING, RUN_STATE_GUEST_PANICKED },
 
     { RUN_STATE_SAVE_VM, RUN_STATE_RUNNING },
 
@@ -375,6 +376,9 @@ static const RunStateTransition runstate_transitions_def[] = {
     { RUN_STATE_WATCHDOG, RUN_STATE_RUNNING },
     { RUN_STATE_WATCHDOG, RUN_STATE_FINISH_MIGRATE },
 
+    { RUN_STATE_GUEST_PANICKED, RUN_STATE_RUNNING },
+    { RUN_STATE_GUEST_PANICKED, RUN_STATE_FINISH_MIGRATE },
+
     { RUN_STATE_MAX, RUN_STATE_MAX },
 };
 
@@ -1531,7 +1535,8 @@ static bool main_loop_should_exit(void)
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
1.7.1

