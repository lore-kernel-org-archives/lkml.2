Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab0HVKWm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 06:22:42 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34593 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab0HVKWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 06:22:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=b4wUJvhUUCah42R/u7JFZyaJNo5awaVsNCt4M5SUrqXhR7bAV56XVGuVZMkbH8GiJF
         eIPwKVtzLPIqyddLILYulO/VsCdTgaz/WMIIi0bZxu8Bt73ZJp1HsoToPD40FQj6CUCV
         nrE/0fi0gtIGB+Bs+Buy4dmPMwXutJuMzaz9c=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ptrace: annotate siglock acquirement
Date: Sun, 22 Aug 2010 19:22:16 +0900
Message-Id: <1282472536-7430-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lock_task_sighand() conditionally acquires sighand->siglock in case of
returning non-NULL but unlock_task_sighand() releases it unconditionally.
This leads sparse to complain about the lock context imbalance. Annotate it
to make sparse happier.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/ptrace.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 1abbb4d..4553275 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -438,6 +438,7 @@ static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
 	int error = -ESRCH;
 
 	if (lock_task_sighand(child, &flags)) {
+		__acquire(&child->sighand->siglock);
 		error = -EINVAL;
 		if (likely(child->last_siginfo != NULL)) {
 			*info = *child->last_siginfo;
@@ -454,6 +455,7 @@ static int ptrace_setsiginfo(struct task_struct *child, const siginfo_t *info)
 	int error = -ESRCH;
 
 	if (lock_task_sighand(child, &flags)) {
+		__acquire(&child->sighand->siglock);
 		error = -EINVAL;
 		if (likely(child->last_siginfo != NULL)) {
 			*child->last_siginfo = *info;
-- 
1.7.0.4

