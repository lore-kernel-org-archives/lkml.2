Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab1KRXOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:14:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53007 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283Ab1KRXOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:14:50 -0500
Date: Fri, 18 Nov 2011 15:14:15 -0800
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-d4d34b981a5327eec956c6cb4cce397ce6f57279@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rabin@rab.in, rostedt@goodmis.org, srostedt@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rabin@rab.in, rostedt@goodmis.org, srostedt@redhat.com,
        tglx@linutronix.de
In-Reply-To: <20111101141420.GA4918@debian>
References: <20111101141420.GA4918@debian>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace: Fix hash record accounting bug
Git-Commit-ID: d4d34b981a5327eec956c6cb4cce397ce6f57279
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:14:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d4d34b981a5327eec956c6cb4cce397ce6f57279
Gitweb:     http://git.kernel.org/tip/d4d34b981a5327eec956c6cb4cce397ce6f57279
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Fri, 4 Nov 2011 20:32:39 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 7 Nov 2011 13:48:05 -0500

ftrace: Fix hash record accounting bug

If the set_ftrace_filter is cleared by writing just whitespace to
it, then the filter hash refcounts will be decremented but not
updated. This causes two bugs:

1) No functions will be enabled for tracing when they all should be

2) If the users clears the set_ftrace_filter twice, it will crash ftrace:

------------[ cut here ]------------
WARNING: at /home/rostedt/work/git/linux-trace.git/kernel/trace/ftrace.c:1384 __ftrace_hash_rec_update.part.27+0x157/0x1a7()
Modules linked in:
Pid: 2330, comm: bash Not tainted 3.1.0-test+ #32
Call Trace:
 [<ffffffff81051828>] warn_slowpath_common+0x83/0x9b
 [<ffffffff8105185a>] warn_slowpath_null+0x1a/0x1c
 [<ffffffff810ba362>] __ftrace_hash_rec_update.part.27+0x157/0x1a7
 [<ffffffff810ba6e8>] ? ftrace_regex_release+0xa7/0x10f
 [<ffffffff8111bdfe>] ? kfree+0xe5/0x115
 [<ffffffff810ba51e>] ftrace_hash_move+0x2e/0x151
 [<ffffffff810ba6fb>] ftrace_regex_release+0xba/0x10f
 [<ffffffff8112e49a>] fput+0xfd/0x1c2
 [<ffffffff8112b54c>] filp_close+0x6d/0x78
 [<ffffffff8113a92d>] sys_dup3+0x197/0x1c1
 [<ffffffff8113a9a6>] sys_dup2+0x4f/0x54
 [<ffffffff8150cac2>] system_call_fastpath+0x16/0x1b
---[ end trace 77a3a7ee73794a02 ]---

Link: http://lkml.kernel.org/r/20111101141420.GA4918@debian

Reported-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0fcc6ca..7caa450 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1210,7 +1210,9 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
 	if (!src->count) {
 		free_ftrace_hash_rcu(*dst);
 		rcu_assign_pointer(*dst, EMPTY_HASH);
-		return 0;
+		/* still need to update the function records */
+		ret = 0;
+		goto out;
 	}
 
 	/*
