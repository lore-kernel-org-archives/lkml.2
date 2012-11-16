Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab2KPNe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 08:34:59 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:46739 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab2KPNe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 08:34:58 -0500
From: <Vineet.Gupta1@synopsys.com>
To: <viro@zeniv.linux.org.uk>
CC: <rusty@rustcorp.com.au>, <mingo@kernel.org>, <jim.cromie@gmail.com>,
        <hpa@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH] Ensure that kernel_init_freebale() is not inlined into non __init code
Date: Fri, 16 Nov 2012 19:04:34 +0530
Message-ID: <1353072874-18710-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

Commit d6b2123802d "make sure that we always have a return path from
kernel_execve()" reshuffled kernel_init()/init_post() to ensure that
kernel_execve() has a caller to return to.
Just for documentation, here's what that commit did.

Orig
----

THREAD __init kernel_init()
	smp_init()
	...
	open("/dev/console")

	init_post() --> forced to be noinline
	return 0;

init_post()
	free_initmem() --> reaps caller kernel_init()
	run_init_process("/init")
		kernel_execve

New
---

THREAD kernel_init()
	kernel_init_freeable()	--> __init tagged
		smp_init()
		...
		open("/dev/console")
	free_initmem() --> reaps kernel_init_freeable()
	run_init_process "init"
		kernel_execve

However kernel_init_freebale() was NOT marked as noinline making ARC gcc
4.4 inline it in non __init freeable kernel_init(), wasting a bit of
memory.

bloat-o-meter vmlinux_orig vmlinux
add/remove: 1/0 grow/shrink: 0/1 up/down: 374/-330 (44)
function                                     old     new   delta
kernel_init_freeable                           -     374    +374
kernel_init                                  636     306    -330

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 init/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index e33e09d..cd147a9 100644
--- a/init/main.c
+++ b/init/main.c
@@ -800,7 +800,7 @@ static int run_init_process(const char *init_filename)
 	return kernel_execve(init_filename, argv_init, envp_init);
 }
 
-static void __init kernel_init_freeable(void);
+static noinline void __init kernel_init_freeable(void);
 
 static int __ref kernel_init(void *unused)
 {
@@ -844,7 +844,7 @@ static int __ref kernel_init(void *unused)
 	      "See Linux Documentation/init.txt for guidance.");
 }
 
-static void __init kernel_init_freeable(void)
+static noinline void __init kernel_init_freeable(void)
 {
 	/*
 	 * Wait until kthreadd is all set-up.
-- 
1.7.4.1

