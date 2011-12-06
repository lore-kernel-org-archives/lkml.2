Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab1LFG3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 01:29:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33941 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932822Ab1LFG3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 01:29:16 -0500
Date: Mon, 5 Dec 2011 22:29:04 -0800
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-ddf6e0e50723b62ac76ed18eb53e9417c6eefba7@git.kernel.org>
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
Git-Commit-ID: ddf6e0e50723b62ac76ed18eb53e9417c6eefba7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 22:29:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ddf6e0e50723b62ac76ed18eb53e9417c6eefba7
Gitweb:     http://git.kernel.org/tip/ddf6e0e50723b62ac76ed18eb53e9417c6eefba7
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Fri, 4 Nov 2011 20:32:39 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 5 Dec 2011 13:28:47 -0500

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
index 1276b3c..b1e8943 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1211,7 +1211,9 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
 	if (!src->count) {
 		free_ftrace_hash_rcu(*dst);
 		rcu_assign_pointer(*dst, EMPTY_HASH);
-		return 0;
+		/* still need to update the function records */
+		ret = 0;
+		goto out;
 	}
 
 	/*
