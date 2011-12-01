Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab1LAK2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 05:28:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50229 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab1LAK2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 05:28:07 -0500
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH] fs: Make write(2) interruptible by a fatal signal
Date: Thu,  1 Dec 2011 11:27:58 +0100
Message-Id: <1322735278-17420-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently write(2) to a file is not interruptible by any signal. Sometimes this
is desirable (e.g. when you want to quickly kill a process hogging your disk or
when some process gets blocked in balance_dirty_pages() indefinitely due to a
filesystem being in an error condition). This patch makes write interruptible
by SIGKILL. We do not allow write to be interruptible by any other signal
because that has larger potential of screwing some badly written applications.

Reported-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Tested-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/filemap.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

  Resending this patch to allow people outside linux-fsdevel to take part
in the discussion...

diff --git a/mm/filemap.c b/mm/filemap.c
index c0018f2..c106d3b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2407,7 +2407,6 @@ static ssize_t generic_perform_write(struct file *file,
 						iov_iter_count(i));
 
 again:
-
 		/*
 		 * Bring in the user page that we will copy from _first_.
 		 * Otherwise there's a nasty deadlock on copying from the
@@ -2463,7 +2462,10 @@ again:
 		written += copied;
 
 		balance_dirty_pages_ratelimited(mapping);
-
+		if (fatal_signal_pending(current)) {
+			status = -EINTR;
+			break;
+		}
 	} while (iov_iter_count(i));
 
 	return written ? written : status;
-- 
1.7.1

