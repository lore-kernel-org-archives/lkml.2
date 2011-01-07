Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab1AGAoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:44:06 -0500
Received: from smtp-out.google.com ([74.125.121.67]:11675 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab1AGAoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:44:04 -0500
From: Simon Glass <sjg@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Simon Glass <sjg@chromium.org>
Subject: [PATCH] Initialize sysctl to 1 to fix /proc/sys/kernel/sysrq value
Date: Thu,  6 Jan 2011 16:43:55 -0800
Message-Id: <1294361035-22843-1-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysreq has previously (before commit 97f5f0cd) been initialized to 1,
thus enabling it on startup and making this value visible to user
space via /proc/sys/kernel/sysrq.

Commit 97f5f0cd split the __sysrq_enabled into two variables, one in
kernel/sysctl.c and the other in drivers/char/sysrq.c. The second is
initialised to 1 but the first is not, and I can find no mechanism in
the code to do so.

The upshot of this problem is that sysrq will read as 0 and appear to
be disabled as far as user space thinks, even though in fact it will
be enabled on boot. This problem goes away as soon as anyone writes
the sysrq file, and in particular when sysctl.conf contains the sysrq
line, so it may not be obvious.

This simple fix just initialises the variable on the sysctl.c side.

Change-Id: Iaeda23abf236e7791d71a384dc453b6a0138eaf5

Signed-off-by: Simon Glass <sjg@chromium.org>
---
 kernel/sysctl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 3a45c22..4b2f758 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -171,7 +171,8 @@ static int proc_taint(struct ctl_table *table, int write,
 #endif
 
 #ifdef CONFIG_MAGIC_SYSRQ
-static int __sysrq_enabled; /* Note: sysrq code ises it's own private copy */
+/* Note: sysrq code in drivers/char/sysrq.c uses its own private copy */
+static int __sysrq_enabled = 1;
 
 static int sysrq_sysctl_handler(ctl_table *table, int write,
 				void __user *buffer, size_t *lenp,
-- 
1.7.3.1

