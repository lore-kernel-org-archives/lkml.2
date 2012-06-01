Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab2FAAtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 20:49:25 -0400
Received: from ozlabs.org ([203.10.76.45]:59208 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932870Ab2FAAtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 20:49:24 -0400
Date: Fri, 1 Jun 2012 10:49:25 +1000
From: Anton Blanchard <anton@samba.org>
To: akinobu.mita@gmail.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fault-inject: Avoid call to random32() if fault injection
 is disabled
Message-ID: <20120601104925.5135263c@kryten>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After enabling CONFIG_FAILSLAB I noticed random32 in profiles even
if slub fault injection wasn't enabled at runtime.

should_fail forces a comparison against random32() even if
probability is 0:

        if (attr->probability <= random32() % 100)
                return false;

Add a check up front for probability == 0 and avoid all of the more
complicated checks.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-build/lib/fault-inject.c
===================================================================
--- linux-build.orig/lib/fault-inject.c	2012-02-11 21:22:32.303459860 +1100
+++ linux-build/lib/fault-inject.c	2012-02-11 22:38:10.470977505 +1100
@@ -101,6 +101,10 @@ static inline bool fail_stacktrace(struc
 
 bool should_fail(struct fault_attr *attr, ssize_t size)
 {
+	/* No need to check any other properties if the probability is 0 */
+	if (attr->probability == 0)
+		return false;
+
 	if (attr->task_filter && !fail_task(attr, current))
 		return false;
 
