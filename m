Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab1ABHdD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:33:03 -0500
Received: from mail.windriver.com ([147.11.1.11]:37125 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab1ABHZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:40 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Roland McGrath <roland@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 216/260] execve: improve interactivity with large arguments
Date: Sun,  2 Jan 2011 02:18:32 -0500
Message-Id: <1293952756-15010-217-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:05.0886 (UTC) FILETIME=[09CE09E0:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland McGrath <roland@redhat.com>

commit 7993bc1f4663c0db67bb8f0d98e6678145b387cd upstream.

This adds a preemption point during the copying of the argument and
environment strings for execve, in copy_strings().  There is already
a preemption point in the count() loop, so this doesn't add any new
points in the abstract sense.

When the total argument+environment strings are very large, the time
spent copying them can be much more than a normal user time slice.
So this change improves the interactivity of the rest of the system
when one process is doing an execve with very large arguments.

Signed-off-by: Roland McGrath <roland@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/exec.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index b884fde..b187ab0 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -419,6 +419,8 @@ static int copy_strings(int argc, char __user * __user * argv,
 		while (len > 0) {
 			int offset, bytes_to_copy;
 
+			cond_resched();
+
 			offset = pos % PAGE_SIZE;
 			if (offset == 0)
 				offset = PAGE_SIZE;
-- 
1.7.3.3

