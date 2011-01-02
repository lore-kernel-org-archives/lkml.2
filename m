Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1ABHWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:22:44 -0500
Received: from mail.windriver.com ([147.11.1.11]:34914 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1ABHWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:38 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Chris Wright <chrisw@sous-sol.org>,
        Robert Swiecki <swiecki@google.com>, Eugene Teo <eugene@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 064/260] tracing: t_start: reset FTRACE_ITER_HASH in case of seek/pread
Date: Sun,  2 Jan 2011 02:16:00 -0500
Message-Id: <1293952756-15010-65-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:16.0085 (UTC) FILETIME=[A4987650:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

commit df09162550fbb53354f0c88e85b5d0e6129ee9cc upstream.

Be sure to avoid entering t_show() with FTRACE_ITER_HASH set without
having properly started the iterator to iterate the hash.  This case is
degenerate and, as discovered by Robert Swiecki, can cause t_hash_show()
to misuse a pointer.  This causes a NULL ptr deref with possible security
implications.  Tracked as CVE-2010-3079.

Cc: Robert Swiecki <swiecki@google.com>
Cc: Eugene Teo <eugene@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/trace/ftrace.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7d51cab..73dedb3 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1488,6 +1488,8 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 		if (*pos > 0)
 			return t_hash_start(m, pos);
 		iter->flags |= FTRACE_ITER_PRINTALL;
+		/* reset in case of seek/pread */
+		iter->flags &= ~FTRACE_ITER_HASH;
 		return iter;
 	}
 
-- 
1.7.3.3

