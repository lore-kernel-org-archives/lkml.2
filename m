Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab2BNQ4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 11:56:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab2BNQ4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 11:56:06 -0500
Date: Tue, 14 Feb 2012 17:49:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@canonical.com, arjan@linux.intel.com, fhrbata@redhat.com,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] kmod: make __request_module() killable
Message-ID: <20120214164914.GF21185@redhat.com>
References: <20120214164709.GA21178@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214164709.GA21178@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Tetsuo Handa pointed out, request_module() can stress the
system while the oom-killed caller sleeps in TASK_UNINTERRUPTIBLE.

Make __request_module() killable. The only necessary change is
that call_modprobe() should kmalloc argv and module_name, they
can't live in the stack if we use UMH_KILLABLE. This memory is
freed via call_usermodehelper_freeinfo()->cleanup.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/kmod.c |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 56a29e8..957a7aa 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -60,6 +60,12 @@ static DECLARE_RWSEM(umhelper_sem);
 */
 char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
 
+static void free_modprobe_argv(struct subprocess_info *info)
+{
+	kfree(info->argv[3]); /* check call_modprobe() */
+	kfree(info->argv);
+}
+
 static int call_modprobe(char *module_name, int wait)
 {
 	static char *envp[] = {
@@ -69,10 +75,26 @@ static int call_modprobe(char *module_name, int wait)
 		NULL
 	};
 
-	char *argv[] = { modprobe_path, "-q", "--", module_name, NULL };
+	char **argv = kmalloc(sizeof(char *[5]), GFP_KERNEL);
+	if (!argv)
+		goto out;
+
+	module_name = kstrdup(module_name, GFP_KERNEL);
+	if (!module_name)
+		goto free_argv;
+
+	argv[0] = modprobe_path;
+	argv[1] = "-q";
+	argv[2] = "--";
+	argv[3] = module_name;	/* check free_modprobe_argv() */
+	argv[4] = NULL;
 
 	return call_usermodehelper_fns(modprobe_path, argv, envp,
-					wait, NULL, NULL, NULL);
+		wait | UMH_KILLABLE, NULL, free_modprobe_argv, NULL);
+free_argv:
+	kfree(argv);
+out:
+	return -ENOMEM;
 }
 
 /**
-- 
1.5.5.1


