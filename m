Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab1CJVMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:12:22 -0500
Received: from smtp-out.google.com ([74.125.121.67]:49980 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab1CJVMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:12:21 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=HYsmfHZ9YHvIwT3+6j5Iu6CFhGnrhjvWz2UTjieBC5o6hczo/XWTNnlvdAjUciLGz
	2OUNgSQs7PwjT2h+tGsvg==
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org, rostedt@goodmis.org
Cc: mrubin@google.com, David Sharp <dhsharp@google.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH trace-cmd v2] trace-cmd: allow setting CC and AR, or CROSS_COMPILE from command line
Date: Thu, 10 Mar 2011 13:11:31 -0800
Message-Id: <1299791491-1805-1-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1299780664.15854.399.camel@gandalf.stny.rr.com>
References: <1299780664.15854.399.camel@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makefiles suck: Use some makefile magic to get the best of all worlds for
CC and AR: Sane defaults and the ability to override CC, and AR, or use
CROSS_COMPILE to set a prefix.

Signed-off-by: David Sharp <dhsharp@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Darren Hart <dvhart@linux.intel.com>
---
 Makefile |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 169fcbc..c4cd926 100644
--- a/Makefile
+++ b/Makefile
@@ -13,8 +13,22 @@ FILE_VERSION = 6
 
 MAKEFLAGS += --no-print-directory
 
-CC ?= $(CROSS_COMPILE)gcc
-AR ?= $(CROSS_COMPILE)ar
+
+# Makefiles suck: This macro sets a default value of $(2) for the
+# variable named by $(1), unless the variable has been set by
+# environment or command line. This is necessary for CC and AR
+# because make sets default values, so the simpler ?= approach
+# won't work as expected.
+define allow-override
+  $(if $(or $(findstring environment,$(origin $(1))),\
+            $(findstring command line,$(origin $(1)))),,\
+    $(eval $(1) = $(2)))
+endef
+
+# Allow setting CC and AR, or setting CROSS_COMPILE as a prefix.
+$(call allow-override,CC,$(CROSS_COMPILE)gcc)
+$(call allow-override,AR,$(CROSS_COMPILE)ar)
+
 EXT = -std=gnu99
 INSTALL = install
 
-- 
1.7.3.1

