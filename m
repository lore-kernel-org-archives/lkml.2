Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab0KIW7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:59:12 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:15935 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab0KIW7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:59:10 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] exec_domain: Establish a Linux32 domain on CONFIG_COMPAT systems.
Date: Tue,  9 Nov 2010 14:59:00 -0800
Message-Id: <1289343540-8319-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 09 Nov 2010 22:59:51.0233 (UTC) FILETIME=[D0BB9B10:01CB8061]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If PER_LINUX32 is set calling sys_personality, we will try to
find the corresponding exec_domain.  This causes us to try to load a
module for personality-8.  After running the userspace module loader
and failing to find the module, we fall back to the default.

We can avoid the failed module loading overhead by building-in the
linux32_exec_domain for systems that have CONFIG_COMPAT.

I noticed this on MIPS64 systems, but it is a general problem and
applies to x86 among others.  Admittedly sys_personality() is probably
not in the hot path of many programs, but the overhead of the extra
exec_domain is fairly small.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exec_domain.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/kernel/exec_domain.c b/kernel/exec_domain.c
index 0dbeae3..9335495 100644
--- a/kernel/exec_domain.c
+++ b/kernel/exec_domain.c
@@ -34,6 +34,17 @@ static unsigned long ident_map[32] = {
 	24,	25,	26,	27,	28,	29,	30,	31
 };
 
+#ifdef CONFIG_COMPAT
+static struct exec_domain linux32_exec_domain = {
+	.name		= "Linux32",		/* name */
+	.handler	= default_handler,	/* lcall7 causes a seg fault. */
+	.pers_low	= PER_LINUX32,
+	.pers_high	= PER_LINUX32,
+	.signal_map	= ident_map,		/* Identity map signals. */
+	.signal_invmap	= ident_map,		/*  - both ways. */
+};
+#endif
+
 struct exec_domain default_exec_domain = {
 	.name		= "Linux",		/* name */
 	.handler	= default_handler,	/* lcall7 causes a seg fault. */
@@ -41,6 +52,9 @@ struct exec_domain default_exec_domain = {
 	.pers_high	= 0,			/* PER_LINUX personality. */
 	.signal_map	= ident_map,		/* Identity map signals. */
 	.signal_invmap	= ident_map,		/*  - both ways. */
+#ifdef CONFIG_COMPAT
+	.next		= &linux32_exec_domain,
+#endif
 };
 
 
-- 
1.7.2.3

