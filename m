Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154Ab2LUG4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 01:56:24 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:44835 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2LUG4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 01:56:19 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Al Viro <viro@zeniv.linux.org.uk>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jim Cromie <jim.cromie@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND] Ensure that kernel_init_freeable() is not inlined into non __init code
Date: Fri, 21 Dec 2012 12:25:44 +0530
Message-ID: <1356072944-23800-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d6b2123802d "make sure that we always have a return path from
kernel_execve()" reshuffled kernel_init()/init_post() to ensure that
kernel_execve() has a caller to return to.

It removed __init annotation for kernel_init() and introduced/calls a
new routine kernel_init_freeable(). Latter however is inlined by any
reasonable compiler (ARC gcc 4.4 in this case), causing slight code
bloat.

This patch forces kernel_init_freeable() as noinline reducing the .text

bloat-o-meter vmlinux vmlinux_new
add/remove: 1/0 grow/shrink: 0/1 up/down: 374/-334 (40)
function                        old     new   delta
kernel_init_freeable              -     374    +374 (.init.text)
kernel_init                     628     294    -334 (.text)

Just for documentation, here's what Al's orig commit did.

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

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Jim Cromie <jim.cromie@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>
CC: linux-kernel@vger.kernel.org
---
 init/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index 85d69df..92d728a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -802,7 +802,7 @@ static int run_init_process(const char *init_filename)
 		(const char __user *const __user *)envp_init);
 }
 
-static void __init kernel_init_freeable(void);
+static noinline void __init kernel_init_freeable(void);
 
 static int __ref kernel_init(void *unused)
 {
@@ -845,7 +845,7 @@ static int __ref kernel_init(void *unused)
 	      "See Linux Documentation/init.txt for guidance.");
 }
 
-static void __init kernel_init_freeable(void)
+static noinline void __init kernel_init_freeable(void)
 {
 	/*
 	 * Wait until kthreadd is all set-up.
-- 
1.7.4.1

