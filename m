Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab2BICCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 21:02:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49706 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025Ab2BICCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 21:02:02 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=50Qc3saDhTEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=Y6fbuv1wHoTy9iPxX6AA:9 a=Zh68SRI7RUMA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120209020159.978564482@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 08 Feb 2012 20:59:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sankara Muthukrishnan <sankara.m@gmail.com>, stable-rt@vger.kernel.org
Subject: [PATCH RT 5/8] timer-fd: Prevent live lock
References: <20120209015926.851312665@goodmis.org>
Content-Disposition: inline; filename=0005-timer-fd-Prevent-live-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

If hrtimer_try_to_cancel() requires a retry, then depending on the
priority setting te retry loop might prevent timer callback completion
on RT. Prevent that by waiting for completion on RT, no change for a
non RT kernel.

Reported-by: Sankara Muthukrishnan <sankara.m@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/timerfd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index dffeb37..57f0e4e 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -313,7 +313,7 @@ SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
 		if (hrtimer_try_to_cancel(&ctx->tmr) >= 0)
 			break;
 		spin_unlock_irq(&ctx->wqh.lock);
-		cpu_relax();
+		hrtimer_wait_for_timer(&ctx->tmr);
 	}
 
 	/*
-- 
1.7.8.3


