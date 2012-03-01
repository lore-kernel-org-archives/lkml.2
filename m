Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab2CASYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 13:24:31 -0500
Received: from mail-gy0-f202.google.com ([209.85.160.202]:40532 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab2CASY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 13:24:29 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of benchan@google.com designates 10.236.145.135 as permitted sender) smtp.mail=benchan@google.com
MIME-Version: 1.0
From: Ben Chan <benchan@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Ben Chan <benchan@chromium.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-fsdevel@vger.kernel.org
Subject: [PATCH] exec: abort core dump piping only due to a fatal signal
Date: Thu,  1 Mar 2012 10:23:47 -0800
Message-Id: <1330626227-32257-1-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes wait_for_dump_helpers() not to abort piping the core
dump data when the crashing process has received any but a fatal signal
(SIGKILL). The rationale is that a crashing process may still receive
uninteresting signals such as SIGCHLD when its core dump data is being
redirected to a helper application. While it's necessary to allow
terminating the core dump piping via SIGKILL, it's practically more
useful for the purpose of debugging and crash reporting if the core dump
piping is not aborted due to other non-fatal signals.

Addresses http://code.google.com/p/chromium-os/issues/detail?id=21559

Signed-off-by: Ben Chan <benchan@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/exec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 92ce83a..a614203 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2031,7 +2031,7 @@ static void wait_for_dump_helpers(struct file *file)
 	pipe->readers++;
 	pipe->writers--;
 
-	while ((pipe->readers > 1) && (!signal_pending(current))) {
+	while ((pipe->readers > 1) && (!fatal_signal_pending(current))) {
 		wake_up_interruptible_sync(&pipe->wait);
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 		pipe_wait(pipe);
-- 
1.7.7.3

