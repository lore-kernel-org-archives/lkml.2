Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab2GFJ4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:56:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:19942 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756172Ab2GFJ4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:56:09 -0400
X-IronPort-AV: E=Sophos;i="4.77,537,1336320000"; 
   d="scan'208";a="5344265"
Message-ID: <4FF6B2C9.10302@cn.fujitsu.com>
Date: Fri, 06 Jul 2012 17:41:29 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH 6/7 v6] deal with guest panicked event accoring to -onpanic
 parameter
References: <4FF6B188.2060607@cn.fujitsu.com>
In-Reply-To: <4FF6B188.2060607@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/06 17:37:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/06 17:37:04,
	Serialize complete at 2012/07/06 17:37:04
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The onpanic parameter can have the following value:
1. none
2. pause
3. poweroff
4. reset

The action for each value when the guest is panicked:
1. none: emit QEVENT_GUEST_PANICKED only
2. pause: emit QEVENT_GUEST_PANICKED and pause the guest
3. poweroff: emit QEVENT_GUEST_PANICKED and poweroff the guest
4. reset: emit QEVENT_GUEST_PANICKED and reset the guest

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 hw/kvm/pv_event.c |   17 +++++++++++++++++
 qemu-options.hx   |   15 +++++++++++++++
 vl.c              |    6 ++++++
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/hw/kvm/pv_event.c b/hw/kvm/pv_event.c
index d7ded37..890abcd 100644
--- a/hw/kvm/pv_event.c
+++ b/hw/kvm/pv_event.c
@@ -59,6 +59,23 @@ static void panicked_perform_action(uint32_t panicked_action)
     }
 }
 
+int select_panicked_action(const char *p)
+{
+    if (strcasecmp(p, "none") == 0) {
+        panicked_action = PANICKED_REPORT;
+    } else if (strcasecmp(p, "pause") == 0) {
+        panicked_action = PANICKED_PAUSE;
+    } else if (strcasecmp(p, "poweroff") == 0) {
+        panicked_action = PANICKED_POWEROFF;
+    } else if (strcasecmp(p, "reset") == 0) {
+        panicked_action = PANICKED_RESET;
+    } else {
+        return -1;
+    }
+
+    return 0;
+}
+
 #if defined(KVM_PV_PORT)
 #include "pv_ioport.c"
 
diff --git a/qemu-options.hx b/qemu-options.hx
index 8b66264..4a061bf 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -2743,6 +2743,21 @@ DEF("qtest-log", HAS_ARG, QEMU_OPTION_qtest_log,
     "-qtest-log LOG  specify tracing options\n",
     QEMU_ARCH_ALL)
 
+DEF("onpanic", HAS_ARG, QEMU_OPTION_onpanic, \
+    "-onpanic none|pause|poweroff|reset\n" \
+    "                action when the guest is panicked [default=none]",
+    QEMU_ARCH_ALL)
+STEXI
+@item -onpanic @var{action}
+
+The @var{action} controls what QEmu will do when the guest is panicked.
+The default is @code{none} (emit QEVENT_GUEST_PANICKED only).
+Other possible actions are:
+@code{pause} (emit QEVENT_GUEST_PANICKED and pause the guest),
+@code{poweroff} (emit QEVENT_GUEST_PANICKED and forcefully poweroff the guest),
+@code{reset} (emit QEVENT_GUEST_PANICKED and forcefully reset the guest).
+ETEXI
+
 HXCOMM This is the last statement. Insert new options before this line!
 STEXI
 @end table
diff --git a/vl.c b/vl.c
index f5cd28d..1a68257 100644
--- a/vl.c
+++ b/vl.c
@@ -3205,6 +3205,12 @@ int main(int argc, char **argv, char **envp)
             case QEMU_OPTION_qtest_log:
                 qtest_log = optarg;
                 break;
+            case QEMU_OPTION_onpanic:
+                if (select_panicked_action(optarg) == -1) {
+                    fprintf(stderr, "Unknown -onpanic parameter\n");
+                    exit(1);
+                }
+                break;
             default:
                 os_parse_cmd_args(popt->index, optarg);
             }
-- 
1.7.1

