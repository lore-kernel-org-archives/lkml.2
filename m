Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab1CWKGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:06:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50823 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097Ab1CWKGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:06:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=aBWdd/BK2dNzI9gZPiQiImnz/SkkF7siuHZAGNu+HV45xdCuFQTFXNxAwYI9vkDFrP
         9bCe8ibQUIfH8FvugYTPRbswq3EgEP7GXWRPpr1cThTBDjNPfUjhdbn8mlR9uP+fiChD
         InLrUj1GAr1M5jaO6EedMy65MqNLXHDB6asfI=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/20] signal: Fix SIGCONT notification code
Date: Wed, 23 Mar 2011 11:05:47 +0100
Message-Id: <1300874766-12941-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300874766-12941-1-git-send-email-tj@kernel.org>
References: <1300874766-12941-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a task receives SIGCONT, its parent is notified via SIGCHLD with
its siginfo describing what the notified event is.  If SIGCONT is
received while the child process is stopped, the code should be
CLD_CONTINUED.  If SIGCONT is recieved while the child process is in
the process of being stopped, it should be CLD_STOPPED.  Which code to
use is determined in prepare_signal() and recorded in signal->flags
using SIGNAL_CLD_CONTINUED|STOP flags.

get_signal_deliver() should test these flags and then notify
accoringly; however, it incorrectly tested SIGNAL_STOP_CONTINUED
instead of SIGNAL_CLD_CONTINUED, thus incorrectly notifying
CLD_CONTINUED if the signal is delivered before the task is wait(2)ed
and CLD_STOPPED if the state was fetched already.

Fix it by testing SIGNAL_CLD_CONTINUED.  While at it, uncompress the
?: test into if/else clause for better readability.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
---
 kernel/signal.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 3175186..e26274a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1853,8 +1853,13 @@ relock:
 	 * the CLD_ si_code into SIGNAL_CLD_MASK bits.
 	 */
 	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
-		int why = (signal->flags & SIGNAL_STOP_CONTINUED)
-				? CLD_CONTINUED : CLD_STOPPED;
+		int why;
+
+		if (signal->flags & SIGNAL_CLD_CONTINUED)
+			why = CLD_CONTINUED;
+		else
+			why = CLD_STOPPED;
+
 		signal->flags &= ~SIGNAL_CLD_MASK;
 
 		why = tracehook_notify_jctl(why, CLD_CONTINUED);
-- 
1.7.1

