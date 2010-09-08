Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502Ab0IHIew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 04:34:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:55620 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758481Ab0IHIeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 04:34:50 -0400
Date: Wed, 8 Sep 2010 08:34:18 GMT
From: tip-bot for Neil Horman <nhorman@tuxdriver.com>
Cc: mingo@redhat.com, mathieu.desnoyers@efficios.com,
        sanagi.koki@jp.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
        nhorman@tuxdriver.com, scott.a.mcmillan@intel.com, tglx@linutronix.de,
        laijs@cn.fujitsu.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        davem@davemloft.net, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com
Reply-To: mingo@redhat.com, mathieu.desnoyers@efficios.com,
        sanagi.koki@jp.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
        nhorman@tuxdriver.com, scott.a.mcmillan@intel.com, tglx@linutronix.de,
        laijs@cn.fujitsu.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        davem@davemloft.net, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <4C7242D7.4050009@jp.fujitsu.com>
References: <4C7242D7.4050009@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] napi: Convert trace_napi_poll to TRACE_EVENT
Message-ID: <tip-3e4b10d7a4d2a78af64f8096dc7cdb3bebd65adb@git.kernel.org>
Git-Commit-ID: 3e4b10d7a4d2a78af64f8096dc7cdb3bebd65adb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Sep 2010 08:34:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e4b10d7a4d2a78af64f8096dc7cdb3bebd65adb
Gitweb:     http://git.kernel.org/tip/3e4b10d7a4d2a78af64f8096dc7cdb3bebd65adb
Author:     Neil Horman <nhorman@tuxdriver.com>
AuthorDate: Mon, 23 Aug 2010 18:43:51 +0900
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 7 Sep 2010 17:51:01 +0200

napi: Convert trace_napi_poll to TRACE_EVENT

This patch converts trace_napi_poll from DECLARE_EVENT to TRACE_EVENT
to improve the usability of napi_poll tracepoint.

          <idle>-0     [001] 241302.750777: napi_poll: napi poll on napi struct f6acc480 for device eth3
          <idle>-0     [000] 241302.852389: napi_poll: napi poll on napi struct f5d0d70c for device eth1

The original patch is below:
http://marc.info/?l=linux-kernel&m=126021713809450&w=2

[ sanagi.koki@jp.fujitsu.com: And add a fix by Steven Rostedt:
http://marc.info/?l=linux-kernel&m=126150506519173&w=2 ]

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Kaneshige Kenji <kaneshige.kenji@jp.fujitsu.com>
Cc: Izumo Taku <izumi.taku@jp.fujitsu.com>
Cc: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Scott Mcmillan <scott.a.mcmillan@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
LKML-Reference: <4C7242D7.4050009@jp.fujitsu.com>
Signed-off-by: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/trace/events/napi.h |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/napi.h b/include/trace/events/napi.h
index 188deca..8fe1e93 100644
--- a/include/trace/events/napi.h
+++ b/include/trace/events/napi.h
@@ -6,10 +6,31 @@
 
 #include <linux/netdevice.h>
 #include <linux/tracepoint.h>
+#include <linux/ftrace.h>
+
+#define NO_DEV "(no_device)"
+
+TRACE_EVENT(napi_poll,
 
-DECLARE_TRACE(napi_poll,
 	TP_PROTO(struct napi_struct *napi),
-	TP_ARGS(napi));
+
+	TP_ARGS(napi),
+
+	TP_STRUCT__entry(
+		__field(	struct napi_struct *,	napi)
+		__string(	dev_name, napi->dev ? napi->dev->name : NO_DEV)
+	),
+
+	TP_fast_assign(
+		__entry->napi = napi;
+		__assign_str(dev_name, napi->dev ? napi->dev->name : NO_DEV);
+	),
+
+	TP_printk("napi poll on napi struct %p for device %s",
+		__entry->napi, __get_str(dev_name))
+);
+
+#undef NO_DEV
 
 #endif /* _TRACE_NAPI_H_ */
 
