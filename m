Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab2CHKNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 05:13:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49718 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756485Ab2CHKNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 05:13:50 -0500
X-IronPort-AV: E=Sophos;i="4.73,551,1325433600"; 
   d="scan'208";a="4490108"
Message-ID: <4F5886C4.7040100@cn.fujitsu.com>
Date: Thu, 08 Mar 2012 18:15:32 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: [RESEND][PATCH 2/2 v3] deal with guest panicked event
References: <4F58664D.1070800@cn.fujitsu.com> <4F5868C4.2090509@cn.fujitsu.com>
In-Reply-To: <4F5868C4.2090509@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-08 18:11:50,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-08 18:11:52,
	Serialize complete at 2012-03-08 18:11:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the host knows the guest is panicked, it will set
exit_reason to KVM_EXIT_GUEST_PANICKED. So if qemu receive
this exit_reason, we can send a event to tell management
application that the guest is panicked and set the guest
status to RUN_STATE_PANICKED.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 kvm-all.c        |    5 +++++
 monitor.c        |    3 +++
 monitor.h        |    1 +
 qapi-schema.json |    2 +-
 qmp.c            |    3 ++-
 vl.c             |    1 +
 6 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/kvm-all.c b/kvm-all.c
index 77eadf6..b3c9a83 100644
--- a/kvm-all.c
+++ b/kvm-all.c
@@ -1290,6 +1290,11 @@ int kvm_cpu_exec(CPUState *env)
                     (uint64_t)run->hw.hardware_exit_reason);
             ret = -1;
             break;
+        case KVM_EXIT_GUEST_PANICKED:
+            monitor_protocol_event(QEVENT_GUEST_PANICKED, NULL);
+            vm_stop(RUN_STATE_PANICKED);
+            ret = -1;
+            break;
         case KVM_EXIT_INTERNAL_ERROR:
             ret = kvm_handle_internal_error(env, run);
             break;
diff --git a/monitor.c b/monitor.c
index cbdfbad..a0ad0a9 100644
--- a/monitor.c
+++ b/monitor.c
@@ -494,6 +494,9 @@ void monitor_protocol_event(MonitorEvent event, QObject *data)
         case QEVENT_WAKEUP:
             event_name = "WAKEUP";
             break;
+        case QEVENT_GUEST_PANICKED:
+            event_name = "GUEST_PANICKED";
+            break;
         default:
             abort();
             break;
diff --git a/monitor.h b/monitor.h
index 0d49800..94e8a3c 100644
--- a/monitor.h
+++ b/monitor.h
@@ -41,6 +41,7 @@ typedef enum MonitorEvent {
     QEVENT_DEVICE_TRAY_MOVED,
     QEVENT_SUSPEND,
     QEVENT_WAKEUP,
+    QEVENT_GUEST_PANICKED,
     QEVENT_MAX,
 } MonitorEvent;
 
diff --git a/qapi-schema.json b/qapi-schema.json
index 5f293c4..4f1ae20 100644
--- a/qapi-schema.json
+++ b/qapi-schema.json
@@ -121,7 +121,7 @@
 { 'enum': 'RunState',
   'data': [ 'debug', 'inmigrate', 'internal-error', 'io-error', 'paused',
             'postmigrate', 'prelaunch', 'finish-migrate', 'restore-vm',
-            'running', 'save-vm', 'shutdown', 'watchdog' ] }
+            'running', 'save-vm', 'shutdown', 'watchdog', 'panicked' ] }
 
 ##
 # @StatusInfo:
diff --git a/qmp.c b/qmp.c
index a182b51..e535969 100644
--- a/qmp.c
+++ b/qmp.c
@@ -148,7 +148,8 @@ void qmp_cont(Error **errp)
         error_set(errp, QERR_MIGRATION_EXPECTED);
         return;
     } else if (runstate_check(RUN_STATE_INTERNAL_ERROR) ||
-               runstate_check(RUN_STATE_SHUTDOWN)) {
+               runstate_check(RUN_STATE_SHUTDOWN) ||
+               runstate_check(RUN_STATE_PANICKED)) {
         error_set(errp, QERR_RESET_REQUIRED);
         return;
     }
diff --git a/vl.c b/vl.c
index 97ab2b9..65390fa 100644
--- a/vl.c
+++ b/vl.c
@@ -359,6 +359,7 @@ static const RunStateTransition runstate_transitions_def[] = {
     { RUN_STATE_RUNNING, RUN_STATE_SAVE_VM },
     { RUN_STATE_RUNNING, RUN_STATE_SHUTDOWN },
     { RUN_STATE_RUNNING, RUN_STATE_WATCHDOG },
+    { RUN_STATE_RUNNING, RUN_STATE_PANICKED },
 
     { RUN_STATE_SAVE_VM, RUN_STATE_RUNNING },
 
-- 
1.7.1

