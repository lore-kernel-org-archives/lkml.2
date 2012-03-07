Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031219Ab2CGB5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 20:57:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:14765 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965269Ab2CGB5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 20:57:21 -0500
X-IronPort-AV: E=Sophos;i="4.73,542,1325433600"; 
   d="scan'208";a="4474640"
Message-ID: <4F56C0E1.1090703@cn.fujitsu.com>
Date: Wed, 07 Mar 2012 09:58:57 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH v2] deal with guest paniced event
References: <4F56BEF2.4020405@cn.fujitsu.com>
In-Reply-To: <4F56BEF2.4020405@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 09:55:19,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 09:55:24,
	Serialize complete at 2012-03-07 09:55:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the host knows the guest is paniced, it will set
exit_reason to KVM_EXIT_GUEST_PANICED. So if qemu receive
this exit_reason, we can send a event to tell management
application that the guest is paniced and set the guest
status to RUN_STATE_PANICED.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 kvm-all.c                 |    4 ++++
 linux-headers/linux/kvm.h |    1 +
 monitor.c                 |    3 +++
 monitor.h                 |    1 +
 qapi-schema.json          |    2 +-
 qmp.c                     |    3 ++-
 vl.c                      |    1 +
 7 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/kvm-all.c b/kvm-all.c
index c4babda..d356948 100644
--- a/kvm-all.c
+++ b/kvm-all.c
@@ -1190,6 +1190,10 @@ int kvm_cpu_exec(CPUState *env)
                     (uint64_t)run->hw.hardware_exit_reason);
             ret = -1;
             break;
+        case KVM_EXIT_GUEST_PANICED:
+            monitor_protocol_event(QEVENT_GUEST_PANICED, NULL);
+            vm_stop(RUN_STATE_PANICED);
+            break;
         case KVM_EXIT_INTERNAL_ERROR:
             ret = kvm_handle_internal_error(env, run);
             break;
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index f6b5343..ddc9716 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -163,6 +163,7 @@ struct kvm_pit_config {
 #define KVM_EXIT_OSI              18
 #define KVM_EXIT_PAPR_HCALL	  19
 #define KVM_EXIT_S390_UCONTROL	  20
+#define KVM_EXIT_GUEST_PANICED	  21
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 #define KVM_INTERNAL_ERROR_EMULATION 1
diff --git a/monitor.c b/monitor.c
index 953e748..9802792 100644
--- a/monitor.c
+++ b/monitor.c
@@ -494,6 +494,9 @@ void monitor_protocol_event(MonitorEvent event, QObject *data)
         case QEVENT_WAKEUP:
             event_name = "WAKEUP";
             break;
+        case QEVENT_GUEST_PANICED:
+            event_name = "GUEST_PANICED";
+            break;
         default:
             abort();
             break;
diff --git a/monitor.h b/monitor.h
index 0d49800..a62da93 100644
--- a/monitor.h
+++ b/monitor.h
@@ -41,6 +41,7 @@ typedef enum MonitorEvent {
     QEVENT_DEVICE_TRAY_MOVED,
     QEVENT_SUSPEND,
     QEVENT_WAKEUP,
+    QEVENT_GUEST_PANICED,
     QEVENT_MAX,
 } MonitorEvent;
 
diff --git a/qapi-schema.json b/qapi-schema.json
index d0b6792..dd4b7a0 100644
--- a/qapi-schema.json
+++ b/qapi-schema.json
@@ -121,7 +121,7 @@
 { 'enum': 'RunState',
   'data': [ 'debug', 'inmigrate', 'internal-error', 'io-error', 'paused',
             'postmigrate', 'prelaunch', 'finish-migrate', 'restore-vm',
-            'running', 'save-vm', 'shutdown', 'watchdog' ] }
+            'running', 'save-vm', 'shutdown', 'watchdog', 'paniced' ] }
 
 ##
 # @StatusInfo:
diff --git a/qmp.c b/qmp.c
index a182b51..eeb6d3b 100644
--- a/qmp.c
+++ b/qmp.c
@@ -148,7 +148,8 @@ void qmp_cont(Error **errp)
         error_set(errp, QERR_MIGRATION_EXPECTED);
         return;
     } else if (runstate_check(RUN_STATE_INTERNAL_ERROR) ||
-               runstate_check(RUN_STATE_SHUTDOWN)) {
+               runstate_check(RUN_STATE_SHUTDOWN) ||
+               runstate_check(RUN_STATE_PANICED)) {
         error_set(errp, QERR_RESET_REQUIRED);
         return;
     }
diff --git a/vl.c b/vl.c
index 1d4c350..d9c13cf 100644
--- a/vl.c
+++ b/vl.c
@@ -359,6 +359,7 @@ static const RunStateTransition runstate_transitions_def[] = {
     { RUN_STATE_RUNNING, RUN_STATE_SAVE_VM },
     { RUN_STATE_RUNNING, RUN_STATE_SHUTDOWN },
     { RUN_STATE_RUNNING, RUN_STATE_WATCHDOG },
+    { RUN_STATE_RUNNING, RUN_STATE_PANICED },
 
     { RUN_STATE_SAVE_VM, RUN_STATE_RUNNING },
 
-- 
1.7.1



