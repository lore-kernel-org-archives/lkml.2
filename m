Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab0FYA6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 20:58:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49054 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab0FYA6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 20:58:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C23FF28.4040404@jp.fujitsu.com>
Date: Fri, 25 Jun 2010 09:58:16 +0900
From: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: kaneshige.kenji@jp.fujitsu.com, izumi.taku@jp.fujitsu.com
Subject: [RFC PATCH v2 2/5] napi: convert trace_napi_poll to TRACE_EVENT
References: <4C2312A8.9060903@jp.fujitsu.com>
In-Reply-To: <4C2312A8.9060903@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts trace_napi_poll from DECLARE_EVENT to TRACE_EVENT.
This lets you know how long napi_poll takes.

          <idle>-0     [001] 241302.750777: napi_poll: napi poll on napi struct f6acc480 for device eth3
          <idle>-0     [000] 241302.852389: napi_poll: napi poll on napi struct f5d0d70c for device eth1
          <idle>-0     [000] 241302.852389: napi_poll: napi poll on napi struct f5d0d20c for device eth1

This is a same patch Neil Horman submitted.
http://marc.info/?l=linux-kernel&m=125978157926853&w=2

Signed-off-by: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
---
 include/trace/events/napi.h |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/napi.h b/include/trace/events/napi.h
index 188deca..512a057 100644
--- a/include/trace/events/napi.h
+++ b/include/trace/events/napi.h
@@ -6,10 +6,29 @@
 
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
 
 #endif /* _TRACE_NAPI_H_ */
 

