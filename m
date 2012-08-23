Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab2HWC0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:26:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45799 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab2HWC0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:26:02 -0400
X-IronPort-AV: E=Sophos;i="4.77,812,1336320000"; 
   d="scan'208";a="5700330"
Message-ID: <503595F7.5060102@cn.fujitsu.com>
Date: Thu, 23 Aug 2012 10:31:19 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v9 3/6] add a new runstate: RUN_STATE_GUEST_PANICKED
References: <50359561.9070001@cn.fujitsu.com>
In-Reply-To: <50359561.9070001@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/23 10:25:58,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/23 10:26:00,
	Serialize complete at 2012/08/23 10:26:00
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
index bd8ad74..edb090a 100644
--- a/qapi-schema.json
+++ b/qapi-schema.json
@@ -149,11 +149,15 @@
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
index c5a20f1..f863f56 100644
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
index 316a977..947b23a 100644
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
 
@@ -1607,7 +1611,8 @@ static bool main_loop_should_exit(void)
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

