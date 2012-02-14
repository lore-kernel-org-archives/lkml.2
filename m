Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693Ab2BNQzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 11:55:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758562Ab2BNQzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 11:55:40 -0500
Date: Tue, 14 Feb 2012 17:48:57 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@canonical.com, arjan@linux.intel.com, fhrbata@redhat.com,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] kmod: introduce call_modprobe() helper
Message-ID: <20120214164857.GE21185@redhat.com>
References: <20120214164709.GA21178@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214164709.GA21178@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes. Move the call_usermodehelper code from
__request_module() into the new simple helper, call_modprobe().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/kmod.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 685b246..56a29e8 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -60,6 +60,21 @@ static DECLARE_RWSEM(umhelper_sem);
 */
 char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
 
+static int call_modprobe(char *module_name, int wait)
+{
+	static char *envp[] = {
+		"HOME=/",
+		"TERM=linux",
+		"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
+		NULL
+	};
+
+	char *argv[] = { modprobe_path, "-q", "--", module_name, NULL };
+
+	return call_usermodehelper_fns(modprobe_path, argv, envp,
+					wait, NULL, NULL, NULL);
+}
+
 /**
  * __request_module - try to load a kernel module
  * @wait: wait (or not) for the operation to complete
@@ -81,11 +96,6 @@ int __request_module(bool wait, const char *fmt, ...)
 	char module_name[MODULE_NAME_LEN];
 	unsigned int max_modprobes;
 	int ret;
-	char *argv[] = { modprobe_path, "-q", "--", module_name, NULL };
-	static char *envp[] = { "HOME=/",
-				"TERM=linux",
-				"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
-				NULL };
 	static atomic_t kmod_concurrent = ATOMIC_INIT(0);
 #define MAX_KMOD_CONCURRENT 50	/* Completely arbitrary value - KAO */
 	static int kmod_loop_msg;
@@ -128,9 +138,7 @@ int __request_module(bool wait, const char *fmt, ...)
 
 	trace_module_request(module_name, wait, _RET_IP_);
 
-	ret = call_usermodehelper_fns(modprobe_path, argv, envp,
-			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC,
-			NULL, NULL, NULL);
+	ret = call_modprobe(module_name, wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
 
 	atomic_dec(&kmod_concurrent);
 	return ret;
-- 
1.5.5.1


