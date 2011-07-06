Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1GFL3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 07:29:09 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54434 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab1GFL3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 07:29:07 -0400
X-Nat-Received: from [202.181.97.72]:58981 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1309951701.30024
To: richard@nod.at
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][Resend v2] Fix infinite loop in search_binary_handler()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1309779003-8668-1-git-send-email-richard@nod.at>
	<201107051155.18465.richard@nod.at>
	<201107052102.BHE69234.OLQOVMJFOFFHSt@I-love.SAKURA.ne.jp>
	<201107051421.02658.richard@nod.at>
In-Reply-To: <201107051421.02658.richard@nod.at>
Message-Id: <201107062028.JFH82378.OLQHFFMVJtFOSO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 6 Jul 2011 20:28:18 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 06072011 #5552308, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger wrote:
> But IMHO adding a new attribute to task_struct is a bit overkill.
Indeed. I came up with a simpler solution. ;-)
----------------------------------------
[PATCH] exec: Do not call request_module() twice from search_binary_handler().

Currently, search_binary_handler() tries to load binary loader module using
request_module() if a loader for the requested program is not yet loaded. But
second attempt of request_module() does not affect the result of
search_binary_handler().

If request_module() triggered recursion, calling request_module() twice causes
2 to the power of MAX_KMOD_CONCURRENT (= 50) repetitions. It is not an infinite
loop but is sufficient for users to consider as a hang up.

Therefore, this patch changes not to call request_module() twice, making
1 to the power of MAX_KMOD_CONCURRENT repetitions in case of recursion.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
diff --git a/fs/exec.c b/fs/exec.c
index 6075a1e..044c13f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1411,6 +1411,8 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 			    printable(bprm->buf[2]) &&
 			    printable(bprm->buf[3]))
 				break; /* -ENOEXEC */
+			if (try)
+				break; /* -ENOEXEC */
 			request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
 #endif
 		}
