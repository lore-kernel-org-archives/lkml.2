Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab0IIFEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 01:04:51 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56141 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab0IIFEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 01:04:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 2/2] execve: check the VM has enough memory at first
Cc: kosaki.motohiro@jp.fujitsu.com, Roland McGrath <roland@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-fsdevel@vger.kernel.org, pageexec@freemail.hu,
        "Brad Spengler <spender@grsecurity.net>, Eugene Teo" 
	<eugene@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100909134842.C93F.A69D9226@jp.fujitsu.com>
References: <20100908023417.8B055401AF@magilla.sf.frob.com> <20100909134842.C93F.A69D9226@jp.fujitsu.com>
Message-Id: <20100909140439.C945.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  9 Sep 2010 14:04:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, Argv size of execve are limited by STACK_LIMIT/4. In other
words, If we are setting 'ulimit -s unlimited', we've lost any
guard of argv size.

More unfortunately, current argv setup logic is bypassing the VM
overcommitment check unintentionally. because current overcommitment
check don't care gradually increased stack.
therefore, wrong argument of execve() easily makes OOM instead
execve() failure. that's bad.

After this patch, execve() expand stack at first and receive to
check vm_enough_memory() properly. then, too long argument of
execve() than the machine memory return EFAULT properly.

Note, almost all user are using OVERCOMMIT_GUESS overcommit mode
(because it's default). It provide only guess. It doesn't works
perfectly on some case. However usually execve() failure is better
than OOM-killer and swap-storm compbination.

Cc: pageexec@freemail.hu
Cc: Roland McGrath <roland@redhat.com>
Cc: Solar Designer <solar@openwall.com>
Cc: Brad Spengler <spender@grsecurity.net>
Cc: Eugene Teo <eteo@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/compat.c |   38 +++++++++++++++++++++++++++++++-------
 fs/exec.c   |   38 +++++++++++++++++++++++++++++++-------
 2 files changed, 62 insertions(+), 14 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index b631120..ff32573 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1394,10 +1394,39 @@ static int compat_copy_strings(int argc, compat_uptr_t __user *argv,
 	char *kaddr = NULL;
 	unsigned long kpos = 0;
 	int ret;
+	compat_uptr_t str;
+	int len;
+	int i;
+	unsigned long total_len = 0;
+
+	for (i = 0; i < argc; i++) {
+		ret = -EFAULT;
+		if (get_user(str, argv+i))
+			goto out;
+		len = strnlen_user(compat_ptr(str), MAX_ARG_STRLEN);
+		if (!len)
+			goto out;
+
+		ret = -E2BIG;
+		if (len > MAX_ARG_STRLEN)
+			goto out;
+
+		total_len += len;
+		if (total_len > bprm->p)
+			goto out;
+	}
+
+	/*
+	 * Firstly, we try to expand stack. It also invoke
+	 * security_vm_enough_memory() and get failure when we don't
+	 * have enough space. It help to avoid stack smashing by plenty argv.
+	 */
+	ret = get_user_pages(current, bprm->mm, bprm->p - total_len,
+			     1, 1, 1, NULL, NULL);
+	if (ret < 0)
+		goto out;
 
 	while (argc-- > 0) {
-		compat_uptr_t str;
-		int len;
 		unsigned long pos;
 
 		if (get_user(str, argv+argc) ||
@@ -1406,11 +1435,6 @@ static int compat_copy_strings(int argc, compat_uptr_t __user *argv,
 			goto out;
 		}
 
-		if (len > MAX_ARG_STRLEN) {
-			ret = -E2BIG;
-			goto out;
-		}
-
 		/* We're going to work our way backwords. */
 		pos = bprm->p;
 		str += len;
diff --git a/fs/exec.c b/fs/exec.c
index b41834c..ef8b9dc 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -396,10 +396,39 @@ static int copy_strings(int argc, const char __user *const __user *argv,
 	char *kaddr = NULL;
 	unsigned long kpos = 0;
 	int ret;
+	int i;
+	unsigned long total_len = 0;
+	const char __user *str;
+	int len;
+
+	for (i = 0; i < argc; i++) {
+		ret = -EFAULT;
+		if (get_user(str, argv+i))
+			goto out;
+		len = strnlen_user(str, MAX_ARG_STRLEN);
+		if (!len)
+			goto out;
+
+		ret = -E2BIG;
+		if (!valid_arg_len(bprm, len))
+			goto out;
+
+		total_len += len;
+		if (total_len > bprm->p)
+			goto out;
+	}
+
+	/*
+	 * Firstly, we try to expand stack. It also invoke
+	 * security_vm_enough_memory() and get failure when we don't
+	 * have enough space. It help to avoid stack smashing by plenty argv.
+	 */
+	ret = get_user_pages(current, bprm->mm, bprm->p - total_len,
+			     1, 1, 1, NULL, NULL);
+	if (ret < 0)
+		goto out;
 
 	while (argc-- > 0) {
-		const char __user *str;
-		int len;
 		unsigned long pos;
 
 		if (get_user(str, argv+argc) ||
@@ -408,11 +437,6 @@ static int copy_strings(int argc, const char __user *const __user *argv,
 			goto out;
 		}
 
-		if (!valid_arg_len(bprm, len)) {
-			ret = -E2BIG;
-			goto out;
-		}
-
 		/* We're going to work our way backwords. */
 		pos = bprm->p;
 		str += len;
-- 
1.6.5.2



