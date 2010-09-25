Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab0IYLxx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 07:53:53 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57053 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab0IYLxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 07:53:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DzcNu2Gg16ofMT9rOV2/CCkaohdkbFR5LdnPr+Z6Qs4J2PnVZX53xL+TM9ikuMCah3
         E+N/LMwylGlg/G8FH2BWf/RGtty8MvBOTr1mosyMftMPyOlo8Q0iMKQ4TBxB51Y02oJ7
         tEGdIkk4JXOcGqAiMZsHhRmSxD805z7X0PlMQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] ptrace: annotate siglock acquisition
Date: Sat, 25 Sep 2010 20:53:41 +0900
Message-Id: <1285415621-28548-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lock_task_sighand() conditionally acquires sighand->siglock in case of
returning non-NULL but unlock_task_sighand() releases it unconditionally.
This leads sparse to complain about the lock context imbalance. Annotate it
to make sparse happier.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---

Roland, I sent the same patch a month ago and got your Acked-by but this
time I update it using __cond_lock() suggested by Al Viro. Please take a
look again, Thanks.

 kernel/ptrace.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index f34d798..8d9b7b2 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -435,7 +435,8 @@ static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
 	unsigned long flags;
 	int error = -ESRCH;
 
-	if (lock_task_sighand(child, &flags)) {
+	if (__cond_lock(&child->sighand->siglock,
+			lock_task_sighand(child, &flags))) {
 		error = -EINVAL;
 		if (likely(child->last_siginfo != NULL)) {
 			*info = *child->last_siginfo;
@@ -451,7 +452,8 @@ static int ptrace_setsiginfo(struct task_struct *child, const siginfo_t *info)
 	unsigned long flags;
 	int error = -ESRCH;
 
-	if (lock_task_sighand(child, &flags)) {
+	if (__cond_lock(&child->sighand->siglock,
+			lock_task_sighand(child, &flags))) {
 		error = -EINVAL;
 		if (likely(child->last_siginfo != NULL)) {
 			*child->last_siginfo = *info;
-- 
1.7.2.2

