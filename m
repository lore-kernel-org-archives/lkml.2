Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab0LVLZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:25:46 -0500
Received: from mail-bw0-f67.google.com ([209.85.214.67]:59798 "EHLO
	mail-bw0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab0LVLZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:25:45 -0500
X-Greylist: delayed 739 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Dec 2010 06:25:44 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=HYfl6fLWqDUuo7i5W+3AX9WlygNIH7LXHN1BOnDTolSAc3ZpphKMoNTR7YaseWI5B+
         TAjRneHgeuY66axpguzUTDO2W1cau2p6NC9l2K2M94zMV0XSnbm3PKgj3ujzEmFW01vd
         m3S86HF+pzG2rabQJgP+nwI7iCNs88Y6Dwgc4=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
        rjw@sisk.pl, jan.kratochvil@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] signal: fix SIGCONT notification code
Date: Wed, 22 Dec 2010 12:13:15 +0100
Message-Id: <1293016398-18001-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293016398-18001-1-git-send-email-tj@kernel.org>
References: <1293016398-18001-1-git-send-email-tj@kernel.org>
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
index 4e3cff1..fe004b5 100644
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

