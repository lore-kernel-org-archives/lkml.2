Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab1L0IOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 03:14:21 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:51880 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab1L0ION (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 03:14:13 -0500
X-Nat-Received: from [202.181.97.72]:52151 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1324973646.4346
Message-Id: <201112270814.pBR8E5SS026269@www262.sakura.ne.jp>
Subject: Re: [3.1.6] Deadlock upon recursive call_usermodehelper_exec().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: gregkh@suse.de, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Dec 2011 17:14:05 +0900
References: <201112270701.pBR713wO005588@www262.sakura.ne.jp>
In-Reply-To: <201112270701.pBR713wO005588@www262.sakura.ne.jp>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 27122011 #6247643, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Additional info. I added debug printk()

--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -305,8 +305,13 @@ int kobject_uevent_env(struct kobject *k
 		if (retval)
 			goto exit;
 
+		printk(KERN_INFO "*** Calling call_usermodehelper(\"%s\")\n",
+		       argv[0]);
 		retval = call_usermodehelper(argv[0], argv,
 					     env->envp, UMH_WAIT_EXEC);
+		printk(KERN_INFO
+		       "*** Returned from call_usermodehelper(\"%s\")\n",
+		       argv[0]);
 	}
 
 exit:
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1435,7 +1435,14 @@ int search_binary_handler(struct linux_b
 				break; /* -ENOEXEC */
 			if (try)
 				break; /* -ENOEXEC */
+			printk(KERN_INFO
+			       "*** Calling request_module(\"binfmt-%04x\")\n",
+			       *(unsigned short *)(&bprm->buf[2]));
 			request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
+			printk(KERN_INFO
+			       "*** Returned from "
+			       "request_module(\"binfmt-%04x\")\n",
+			       *(unsigned short *)(&bprm->buf[2]));
 		}
 #else
 		break;

and got below output just before deadlock.

*** Calling call_usermodehelper("/sbin/hotplug")
*** Calling request_module("binfmt-0000")

So, this deadlock occurs when call_usermodehelper(UMH_WAIT_EXEC) is called and
request_module() is also called from search_binary_handler() when processing
call_usermodehelper(UMH_WAIT_EXEC).

This would not hanppen for normal condition, but 100% happens when the
userspace helper program is damaged.
