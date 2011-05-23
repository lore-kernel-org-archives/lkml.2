Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab1EWRHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:07:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756324Ab1EWRHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:07:12 -0400
Date: Mon, 23 May 2011 19:05:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: [PATCH 2/2] signal: sys_pause() should check signal_pending()
Message-ID: <20110523170551.GC29328@redhat.com>
References: <201105152235.32073.vda.linux@googlemail.com> <20110516153122.GA15856@redhat.com> <BANLkTintE-QVUJhJY-_A5nvgj7viJatZ4Q@mail.gmail.com> <20110519194908.GA26584@redhat.com> <BANLkTi=bRb+NCqqS9+ptzxHVOjKKXhZgsg@mail.gmail.com> <20110523121011.GA5799@redhat.com> <20110523141034.GA11866@redhat.com> <20110523170508.GA29328@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523170508.GA29328@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERESTART* is always wrong without TIF_SIGPENDING. Teach sys_pause()
to handle the spurious wakeup correctly.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/signal.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- sigprocmask/kernel/signal.c~pause_ck_signal_pending	2011-05-23 18:09:49.000000000 +0200
+++ sigprocmask/kernel/signal.c	2011-05-23 18:52:24.000000000 +0200
@@ -3023,8 +3023,10 @@ SYSCALL_DEFINE2(signal, int, sig, __sigh
 
 SYSCALL_DEFINE0(pause)
 {
-	current->state = TASK_INTERRUPTIBLE;
-	schedule();
+	while (!signal_pending(current)) {
+		current->state = TASK_INTERRUPTIBLE;
+		schedule();
+	}
 	return -ERESTARTNOHAND;
 }
 

