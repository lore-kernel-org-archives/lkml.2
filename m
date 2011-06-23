Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826Ab1FWRrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:47:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:35508 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933779Ab1FWRi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:28 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 219/247] proc: protect mm start_code/end_code in /proc/pid/stat
Date: Thu, 23 Jun 2011 13:34:47 -0400
Message-Id: <1308850515-15242-160-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <kees.cook@canonical.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 5883f57ca0008ffc93e09cbb9847a1928e50c6f3 upstream.

While mm->start_stack was protected from cross-uid viewing (commit
f83ce3e6b02d5 ("proc: avoid information leaks to non-privileged
processes")), the start_code and end_code values were not.  This would
allow the text location of a PIE binary to leak, defeating ASLR.

Note that the value "1" is used instead of "0" for a protected value since
"ps", "killall", and likely other readers of /proc/pid/stat, take
start_code of "0" to mean a kernel thread and will misbehave.  Thanks to
Brad Spengler for pointing this out.

Addresses CVE-2011-0726

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/proc/array.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index ed2afa6..412e163 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -489,8 +489,8 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		vsize,
 		mm ? get_mm_rss(mm) : 0,
 		rsslim,
-		mm ? mm->start_code : 0,
-		mm ? mm->end_code : 0,
+		mm ? (permitted ? mm->start_code : 1) : 0,
+		mm ? (permitted ? mm->end_code : 1) : 0,
 		(permitted && mm) ? mm->start_stack : 0,
 		esp,
 		eip,
-- 
1.7.4.4

