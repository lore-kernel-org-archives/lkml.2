Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab1LFJk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:40:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34747 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974Ab1LFJkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:40:55 -0500
Date: Tue, 6 Dec 2011 01:40:28 -0800
From: tip-bot for Ming Lei <tom.leiming@gmail.com>
Message-ID: <tip-73839c5b2eacc15cb0aa79c69b285fc659fa8851@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, tglx@linutronix.de, yong.zhang0@gmail.com,
        tom.leiming@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tglx@linutronix.de, yong.zhang0@gmail.com,
        tom.leiming@gmail.com, mingo@elte.hu
In-Reply-To: <1321508072-23853-1-git-send-email-tom.leiming@gmail.com>
References: <1321508072-23853-1-git-send-email-tom.leiming@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] init/main.c: Execute lockdep_init() as early as possible
Git-Commit-ID: 73839c5b2eacc15cb0aa79c69b285fc659fa8851
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:40:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73839c5b2eacc15cb0aa79c69b285fc659fa8851
Gitweb:     http://git.kernel.org/tip/73839c5b2eacc15cb0aa79c69b285fc659fa8851
Author:     Ming Lei <tom.leiming@gmail.com>
AuthorDate: Thu, 17 Nov 2011 13:34:31 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 08:16:53 +0100

init/main.c: Execute lockdep_init() as early as possible

This patch fixes a lockdep warning on ARM platforms:

  [    0.000000] WARNING: lockdep init error! Arch code didn't call lockdep_init() early enough?
  [    0.000000] Call stack leading to lockdep invocation was:
  [    0.000000]  [<c00164bc>] save_stack_trace_tsk+0x0/0x90
  [    0.000000]  [<ffffffff>] 0xffffffff

The warning is caused by printk inside smp_setup_processor_id().

It is safe to do this because lockdep_init() doesn't depend on
smp_setup_processor_id(), so improve things that printk can be
called as early as possible without lockdep complaint.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1321508072-23853-1-git-send-email-tom.leiming@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
