Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933511Ab2GKXc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 19:32:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933422Ab2GKXcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 19:32:24 -0400
Date: Wed, 11 Jul 2012 16:32:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Patch] kernel/sys.c: fix an incorrect error branch in
 orderly_poweroff()
Message-Id: <20120711163223.faa40af5.akpm@linux-foundation.org>
In-Reply-To: <20120711162323.9f22fa56.akpm@linux-foundation.org>
References: <20120703152739.ea7df9e6.akpm@linux-foundation.org>
	<1341372710-14648-1-git-send-email-amwang@redhat.com>
	<20120711162323.9f22fa56.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Also, the call_usermodehelper_fns() interface is rather nasty.  Let's
try to prevent mistakes:

--- a/kernel/kmod.c~a
+++ a/kernel/kmod.c
@@ -577,6 +577,12 @@ unlock:
 	return retval;
 }
 
+/*
+ * call_usermodehelper_fns() will not run the caller-provided cleanup function
+ * if a memory allocation failure is experienced.  So the caller might need to
+ * check the call_usermodehelper_fns() return value: if it is -ENOMEM, perform
+ * the necessaary cleanup within the caller.
+ */
 int call_usermodehelper_fns(
 	char *path, char **argv, char **envp, int wait,
 	int (*init)(struct subprocess_info *info, struct cred *new),
_

