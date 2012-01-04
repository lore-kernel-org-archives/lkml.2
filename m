Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2ADHnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 02:43:13 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:58023 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab2ADHnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 02:43:11 -0500
X-Nat-Received: from [202.181.97.72]:62947 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1325662989.17381
Message-Id: <201201040743.q047h9OD055670@www262.sakura.ne.jp>
Subject: [PATCH] kmod: Avoid deadlock by recursive kmod call.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Jan 2012 16:43:09 +0900
References: <201112270701.pBR713wO005588@www262.sakura.ne.jp> 
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 04012012 #6388694, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that the system deadlocks if do_execve() request by kmod() triggered
recursive do_execve() request.

An example operation for triggering this deadlock:

  # : > /tmp/dummy
  # chmod 755 /tmp/dummy
  # echo /tmp/dummy > /proc/sys/kernel/hotplug
  # modprobe whatever

Although this patch works for me, I'm not sure that this is a correct fix.
Also, my analysis in the patch description may be wrong. Please check.
--------------------
[PATCH] kmod: Avoid deadlock by recursive kmod call.

call_usermodehelper(UMH_WAIT_EXEC) creates a CLONE_VFORK'ed thread.
The vforked thread may call call_usermodehelper(UMH_WAIT_PROC) from
search_binary_handler() which in turn calls wait_for_completion().

This sequence results in a deadlock because "khelper cannot start processing
call_usermodehelper(UMH_WAIT_PROC) until do_execve() of vforked thread by
call_usermodehelper(UMH_WAIT_EXEC) completes" but "vforked thread cannot
complete do_execve() until call_usermodehelper(UMH_WAIT_PROC) completes".

We need to make sure that do_execve() request by vforked thread does not
trigger call_usermodehelper(UMH_WAIT_PROC or UMH_WAIT_EXEC).

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 kernel/kmod.c |    9 +++++++++
 1 files changed, 9 insertions(+)

--- linux-3.1.7.orig/kernel/kmod.c
+++ linux-3.1.7/kernel/kmod.c
@@ -428,6 +428,15 @@ int call_usermodehelper_exec(struct subp
 		retval = -EBUSY;
 		goto out;
 	}
+	/*
+	 * We can't call wait_for_completion() if current thread was created
+	 * with CLONE_VFORK flag, or we will deadlock when current thread calls
+	 * request_module() from search_binary_handler().
+	 */
+	if (wait != UMH_NO_WAIT && current->vfork_done) {
+		retval = -EBUSY;
+		goto out;
+	}
 
 	sub_info->complete = &done;
 	sub_info->wait = wait;
