Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab1J1ULi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 16:11:38 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59960 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab1J1ULh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 16:11:37 -0400
From: Scott James Remnant <scott@netsplit.com>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Scott James Remnant <scott@netsplit.com>
Subject: [PATCH] coredump: wait on the core pattern umh at least once
Date: Fri, 28 Oct 2011 13:11:28 -0700
Message-Id: <1319832688-30336-1-git-send-email-scott@netsplit.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a thread crashes as a result of a signal on the thread group leader
that signal can still be pending, which means the loop in
wait_for_dump_helpers() falls straight though.

This can mean that the crashing process is reaped before any core
pattern user-mode helper is run, leaving it without entries in /proc
to look through.

While the helper obviously has to deal with that, tweaking this loop
so it runs at least one iteration even in that case helps a lot.

Signed-off-by: Scott James Remnant <scott@netsplit.com>
---
 fs/exec.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 25dcbe5..8959d304 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2030,11 +2030,11 @@ static void wait_for_dump_helpers(struct file *file)
 	pipe->readers++;
 	pipe->writers--;
 
-	while ((pipe->readers > 1) && (!signal_pending(current))) {
+	do {
 		wake_up_interruptible_sync(&pipe->wait);
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 		pipe_wait(pipe);
-	}
+	} while ((pipe->readers > 1) && (!signal_pending(current)));
 
 	pipe->readers--;
 	pipe->writers++;
-- 
1.7.3.1

