Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab0IGQsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:48:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47445 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172Ab0IGQsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:48:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=IXhBoUVMZhPXgdhGSipffiV5Sk9VNCaH8PerVpc911WFfKzwUFNOxZRCKQsMUmnEUU
         SNtRIMlaUU6eU419ZYAEPFnnpxnwckpx35Vd2nRtJFPev7Q/j69EFiPh3MDN+RK72Agq
         4fVkKh30L1lfeDnzrCi2YvRM4vXuZxtUU3Zjc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Kaneshige Kenji <kaneshige.kenji@jp.fujitsu.com>,
        Izumo Taku <izumi.taku@jp.fujitsu.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Scott Mcmillan <scott.a.mcmillan@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/5] napi: Convert trace_napi_poll to TRACE_EVENT
Date: Tue,  7 Sep 2010 18:48:08 +0200
Message-Id: <1283878091-5751-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1283878091-5751-1-git-send-regression-fweisbec@gmail.com>
References: <1283878091-5751-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>

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
 
-- 
1.6.2.3

