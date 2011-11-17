Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab1KQFev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 00:34:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41674 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab1KQFeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 00:34:50 -0500
From: tom.leiming@gmail.com
To: mingo@elte.hu, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 1/2] init/main.c: execute lockdep_init as early as possible
Date: Thu, 17 Nov 2011 13:34:31 +0800
Message-Id: <1321508072-23853-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch removes the lockdep warning[1] on ARM platform.
The warning is caused by printk inside smp_setup_processor_id.

It is safe to do this because lockdep_init doesn't depend on
smp_setup_processor_id, so make printk can be called as early
as possible without lockdep complainment.

[1], lockdep warning
[    0.000000] WARNING: lockdep init error! Arch code didn't call
lockdep_init() early enough?
[    0.000000] Call stack leading to lockdep invocation was:
[    0.000000]  [<c00164bc>] save_stack_trace_tsk+0x0/0x90
[    0.000000]  [<ffffffff>] 0xffffffff

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 init/main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index 217ed23..2c76efb 100644
--- a/init/main.c
+++ b/init/main.c
@@ -469,13 +469,12 @@ asmlinkage void __init start_kernel(void)
 	char * command_line;
 	extern const struct kernel_param __start___param[], __stop___param[];
 
-	smp_setup_processor_id();
-
 	/*
 	 * Need to run as early as possible, to initialize the
 	 * lockdep hash:
 	 */
 	lockdep_init();
+	smp_setup_processor_id();
 	debug_objects_early_init();
 
 	/*
-- 
1.7.5.4

