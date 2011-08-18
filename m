Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab1HRL5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 07:57:52 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:52797 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab1HRL5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 07:57:50 -0400
X-IronPort-AV: E=Sophos;i="4.68,245,1312156800"; 
   d="scan'208";a="7334449"
Subject: Re: how to handle tracing .h loops
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1313668307.5010.300.camel@zakaz.uk.xensource.com>
References: <1313668307.5010.300.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 18 Aug 2011 12:57:42 +0100
Message-ID: <1313668662.5010.303.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 12:51 +0100, Ian Campbell wrote:
> Clearly other places are including interrupt.h and highmem.h without
> issue so what am I doing wrong here?

I guess I should have look at the .c file instead of concentrating on
the .h's because this works:

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 7b996ed..3f5ee74 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -29,6 +29,7 @@
 #include <linux/rcupdate.h>
 #include <linux/dmaengine.h>
 #include <linux/hrtimer.h>
+#include <linux/highmem.h>
 
 /* Don't change this without changing skb_csum_unnecessary! */
 #define CHECKSUM_NONE 0
diff --git a/kernel/signal.c b/kernel/signal.c
index 291c970..ff432ec 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -30,6 +30,7 @@
 #include <linux/nsproxy.h>
 #define CREATE_TRACE_POINTS
 #include <trace/events/signal.h>
+#undef CREATE_TRACE_POINTS
 
 #include <asm/param.h>
 #include <asm/uaccess.h>


But that seems odd (noone else does it). Perhaps I should instead move
that include to last in the file? i.e.:

diff --git a/kernel/signal.c b/kernel/signal.c
index 291c970..d3cd4e7 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -28,8 +28,6 @@
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
 #include <linux/nsproxy.h>
-#define CREATE_TRACE_POINTS
-#include <trace/events/signal.h>
 
 #include <asm/param.h>
 #include <asm/uaccess.h>
@@ -37,6 +35,9 @@
 #include <asm/siginfo.h>
 #include "audit.h"	/* audit_signal_info() */
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/signal.h>
+
 /*
  * SLAB caches for signal bits.
  */

Ian.

