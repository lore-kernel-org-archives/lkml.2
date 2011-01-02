Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab1ABHa1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:30:27 -0500
Received: from mail.windriver.com ([147.11.1.11]:37168 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab1ABHZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:50 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Roland McGrath <roland@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 217/260] execve: make responsive to SIGKILL with large arguments
Date: Sun,  2 Jan 2011 02:18:33 -0500
Message-Id: <1293952756-15010-218-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:06.0917 (UTC) FILETIME=[0A6B5B50:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland McGrath <roland@redhat.com>

commit 9aea5a65aa7a1af9a4236dfaeb0088f1624f9919 upstream.

An execve with a very large total of argument/environment strings
can take a really long time in the execve system call.  It runs
uninterruptibly to count and copy all the strings.  This change
makes it abort the exec quickly if sent a SIGKILL.

Note that this is the conservative change, to interrupt only for
SIGKILL, by using fatal_signal_pending().  It would be perfectly
correct semantics to let any signal interrupt the string-copying in
execve, i.e. use signal_pending() instead of fatal_signal_pending().
We'll save that change for later, since it could have user-visible
consequences, such as having a timer set too quickly make it so that
an execve can never complete, though it always happened to work before.

Signed-off-by: Roland McGrath <roland@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/exec.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index b187ab0..afd9977 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -376,6 +376,9 @@ static int count(char __user * __user * argv, int max)
 			argv++;
 			if (i++ >= max)
 				return -E2BIG;
+
+			if (fatal_signal_pending(current))
+				return -ERESTARTNOHAND;
 			cond_resched();
 		}
 	}
@@ -419,6 +422,10 @@ static int copy_strings(int argc, char __user * __user * argv,
 		while (len > 0) {
 			int offset, bytes_to_copy;
 
+			if (fatal_signal_pending(current)) {
+				ret = -ERESTARTNOHAND;
+				goto out;
+			}
 			cond_resched();
 
 			offset = pos % PAGE_SIZE;
-- 
1.7.3.3

