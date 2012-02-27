Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab2B0DFA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 22:05:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58712 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753178Ab2B0DE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 22:04:59 -0500
Message-ID: <4F4AF316.50400@cn.fujitsu.com>
Date: Mon, 27 Feb 2012 11:05:58 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        linux-kernel@vger.kernel.org, qemu-devel <qemu-devel@nongnu.org>
Subject: [PATCH]qemu: deal with guest paniced event
References: <4F4AF1FB.6000903@cn.fujitsu.com>
In-Reply-To: <4F4AF1FB.6000903@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-27 11:03:12,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-27 11:03:12,
	Serialize complete at 2012-02-27 11:03:12
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the host knows the guest is paniced, it will set
exit_reason to KVM_EXIT_GUEST_PANIC. So if qemu receive
this exit_reason, we can send a event to tell management
application that the guest is paniced.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 kvm-all.c                 |    3 +++
 linux-headers/linux/kvm.h |    1 +
 monitor.c                 |    3 +++
 monitor.h                 |    1 +
 4 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kvm-all.c b/kvm-all.c
index c4babda..ae428ab 100644
--- a/kvm-all.c
+++ b/kvm-all.c
@@ -1190,6 +1190,9 @@ int kvm_cpu_exec(CPUState *env)
                     (uint64_t)run->hw.hardware_exit_reason);
             ret = -1;
             break;
+        case KVM_EXIT_GUEST_PANIC:
+            monitor_protocol_event(QEVENT_GUEST_PANICED, NULL);
+            break;
         case KVM_EXIT_INTERNAL_ERROR:
             ret = kvm_handle_internal_error(env, run);
             break;
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index f6b5343..45dd031 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -163,6 +163,7 @@ struct kvm_pit_config {
 #define KVM_EXIT_OSI              18
 #define KVM_EXIT_PAPR_HCALL	  19
 #define KVM_EXIT_S390_UCONTROL	  20
+#define KVM_EXIT_GUEST_PANIC	  21
 
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
 
-- 
1.7.1

