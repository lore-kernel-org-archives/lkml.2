Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab1GGEGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 00:06:30 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:59762 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1GGEG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 00:06:27 -0400
X-Nat-Received: from [202.181.97.72]:56777 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1310011474.28609
Message-Id: <201107070404.p6744Ygd029169@www262.sakura.ne.jp>
Subject: Re: [PATCH][Resend v2] Fix infinite loop in search_binary_handler()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: akpm@linux-foundation.org
Cc: richard@nod.at, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 07 Jul 2011 13:04:34 +0900
References: <1309779003-8668-1-git-send-email-richard@nod.at> <201107051155.18465.richard@nod.at> <201107052102.BHE69234.OLQOVMJFOFFHSt@I-love.SAKURA.ne.jp> <201107051421.02658.richard@nod.at> <201107062028.JFH82378.OLQHFFMVJtFOSO@I-love.SAKURA.ne.jp> <20110706132138.7e65a912.akpm@linux-foundation.org>
In-Reply-To: <20110706132138.7e65a912.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 07072011 #5531376, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> What is that "for (try=0; try<2" loop actually there for?  To retry
> after the request_module(), it appears.  Which is pointless if
> !CONFIG_MODULES.

Indeed. This loop was introduced in Linux 1.3.57 (where CONFIG_KERNELD was
introduced). Comparing between 1.3.56 and 1.3.57, there is no reason to retry
if !CONFIG_KERNELD, for get_fs_type() in fs/super.c and dev_get() in
net/core/dev.c do not retry if !CONFIG_KERNELD.

struct file_system_type *get_fs_type(const char *name)
{
	struct file_system_type * fs = file_systems;
	
	if (!name)
		return fs;
	for (fs = file_systems; fs && strcmp(fs->name, name); fs = fs->next)
		;
#ifdef CONFIG_KERNELD
	if (!fs && (request_module(name) == 0)) {
		for (fs = file_systems; fs && strcmp(fs->name, name); fs = fs->next)
			;
	}
#endif

	return fs;
}

struct device *dev_get(const char *name)
{
	struct device *dev;

	for (dev = dev_base; dev != NULL; dev = dev->next) 
	{
		if (strcmp(dev->name, name) == 0)
			return(dev);
	}
#ifdef CONFIG_KERNELD
	if (request_module(name) == 0)
		for (dev = dev_base; dev != NULL; dev = dev->next) {
			if (strcmp(dev->name, name) == 0)
				return(dev);
		}
#endif
	return(NULL);
}

It is likely that we have been doing needless retry if !CONFIG_MODULES.
----------------------------------------
[PATCH] exec: Do not retry load_binary method if CONFIG_MODULES=n.

If CONFIG_MODULES=n, it makes no sense to retry the list of binary formats
handler because the list will not be modified by request_module().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
diff --git a/fs/exec.c b/fs/exec.c
index 6075a1e..46c399f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1401,9 +1401,9 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 			}
 		}
 		read_unlock(&binfmt_lock);
+#ifdef CONFIG_MODULES
 		if (retval != -ENOEXEC || bprm->mm == NULL) {
 			break;
-#ifdef CONFIG_MODULES
 		} else {
 #define printable(c) (((c)=='\t') || ((c)=='\n') || (0x20<=(c) && (c)<=0x7e))
 			if (printable(bprm->buf[0]) &&
@@ -1412,8 +1412,10 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 			    printable(bprm->buf[3]))
 				break; /* -ENOEXEC */
 			request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
-#endif
 		}
+#else
+		break;
+#endif
 	}
 	return retval;
 }
