Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673Ab1LNRZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:25:38 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57063 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab1LNRZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:25:37 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: ralf@linux-mips.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mips@linux-mips.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
        David Daney <david.daney@cavium.com>
Subject: [PATCH v2] jump-label: initialize jump-label subsystem somewhat later
Date: Wed, 14 Dec 2011 09:25:32 -0800
Message-Id: <1323883532-26374-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

commit 97ce2c88f9ad42e3c60a9beb9fca87abf3639faa breaks MIPS.

The jump-lable initialization does I-Cache flushing after modifying
code.  On MIPS this is done by calling through the function pointer
flush_icache_range().  This function pointer is initialized trap_init().

As things stand, we cannot be calling jump_label_init() until after
trap_init() completes, so we move the call down to satisfy this
constraint.

Signed-off-by: David Daney <david.daney@cavium.com>
---

Difference from v1: Move jump_label_init() up one so it is now before
                    mm_init() instead of after it.

 init/main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index 217ed23..68ab12b 100644
--- a/init/main.c
+++ b/init/main.c
@@ -513,8 +513,6 @@ asmlinkage void __init start_kernel(void)
 		   __stop___param - __start___param,
 		   &unknown_bootoption);
 
-	jump_label_init();
-
 	/*
 	 * These use large bootmem allocations and must precede
 	 * kmem_cache_init()
@@ -524,6 +522,7 @@ asmlinkage void __init start_kernel(void)
 	vfs_caches_init_early();
 	sort_main_extable();
 	trap_init();
+	jump_label_init();
 	mm_init();
 
 	/*
-- 
1.7.2.3

