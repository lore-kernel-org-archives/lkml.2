Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab0IRTmT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:42:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39389 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582Ab0IRTmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:42:16 -0400
Date: Sat, 18 Sep 2010 20:42:15 +0100
To: linux-arch@vger.kernel.org
Subject: [PATCH 5/5] frv: double syscall restarts, syscall restart in
 sigreturn()
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Ox3Id-0006Ri-Bk@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we need to make sure that only the first do_signal() to be handled
on the way out syscall will bother with syscall restarts; additionally,
the check on the "signal has user handler" path had been wrong -
compare with restart prevention in sigreturn()...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/frv/kernel/signal.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index ad74e2e..c2d331e 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -446,7 +446,7 @@ static int handle_signal(unsigned long sig, siginfo_t *info,
 	int ret;
 
 	/* Are we from a system call? */
-	if (in_syscall(__frame)) {
+	if (__frame->syscallno != -1) {
 		/* If so, check system call restarting.. */
 		switch (__frame->gr8) {
 		case -ERESTART_RESTARTBLOCK:
@@ -465,6 +465,7 @@ static int handle_signal(unsigned long sig, siginfo_t *info,
 			__frame->gr8 = __frame->orig_gr8;
 			__frame->pc -= 4;
 		}
+		__frame->syscallno = -1;
 	}
 
 	/* Set up the stack frame */
@@ -551,6 +552,7 @@ no_signal:
 			__frame->pc -= 4;
 			break;
 		}
+		__frame->syscallno = -1;
 	}
 
 	/* if there's no signal to deliver, we just put the saved sigmask
-- 
1.5.6.5

