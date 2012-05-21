Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab2EUTXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 15:23:40 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:56969 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190Ab2EUTXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 15:23:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] epoll: Fix user space breakage related to EPOLLWAKEUP (was: Re: [-next regression] TCP window full with EPOLLWAKEUP)
Date: Mon, 21 May 2012 21:28:37 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Jiri Slaby <jslaby@suse.cz>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        NeilBrown <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
References: <4FB81981.3050509@suse.cz> <4FBA4946.8080905@suse.cz> <201205212111.34800.rjw@sisk.pl>
In-Reply-To: <201205212111.34800.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205212128.38157.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Commit 4d7e30d (epoll: Add a flag, EPOLLWAKEUP, to prevent
suspend while epoll events are ready) caused some applications to
malfunction, because they set the bit corresponding to the new
EPOLLWAKEUP flag in their eventpoll flags and they don't have the
new CAP_EPOLLWAKEUP capability.

To prevent that from happening, change epoll_ctl() to clear
EPOLLWAKEUP in epds.events if the caller doesn't have the
CAP_EPOLLWAKEUP capability instead of failing and returning an
error code, which allows the affected applications to function
normally.

Reported-and-tested-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 fs/eventpoll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/fs/eventpoll.c
===================================================================
--- linux.orig/fs/eventpoll.c
+++ linux/fs/eventpoll.c
@@ -1711,7 +1711,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 
 	/* Check if EPOLLWAKEUP is allowed */
 	if ((epds.events & EPOLLWAKEUP) && !capable(CAP_EPOLLWAKEUP))
-		goto error_tgt_fput;
+		epds.events &= ~EPOLLWAKEUP;
 
 	/*
 	 * We have to check that the file structure underneath the file descriptor
