Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab1JZBIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:08:25 -0400
Received: from smtp-out.google.com ([74.125.121.67]:2109 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab1JZBIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:08:23 -0400
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Neil Horman <nhorman@tuxdriver.com>, Earl Chew <earl_chew@agilent.com>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] exec: log when wait_for_dump_helpers aborts due to a signal
Date: Tue, 25 Oct 2011 18:07:08 -0700
Message-Id: <1319591228-20397-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To allow coredump pipe readers to look at /proc/<pid> of the crashing
process, the kernel waits for the reader to exit. However, the wait
is silently aborted if the crashing process is signalled.

This patch, logs whenever wait_for_dump_helpers is aborted or in order
to assist in debugging cases where /proc/<pid> is gone.

Alternatively, we may want to consider not aborting on a signal. You
could always break the loop by killing the reader process.

Reference: http://crosbug.com/21559
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Earl Chew <earl_chew@agilent.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/exec.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 25dcbe5..5d4190d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2030,7 +2030,14 @@ static void wait_for_dump_helpers(struct file *file)
 	pipe->readers++;
 	pipe->writers--;
 
-	while ((pipe->readers > 1) && (!signal_pending(current))) {
+	while (pipe->readers > 1) {
+		if (signal_pending(current)) {
+			pr_info("wait_for_dump_helpers[%d]: "
+				"aborted due to signal\n",
+				task_pid_nr(current));
+			break;
+		}
+
 		wake_up_interruptible_sync(&pipe->wait);
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 		pipe_wait(pipe);
-- 
1.7.3.1

