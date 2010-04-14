Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab0DNPBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:01:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:53727 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929Ab0DNPBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:01:03 -0400
Date: Wed, 14 Apr 2010 15:00:39 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com
In-Reply-To: <4BB9A929.2000303@cn.fujitsu.com>
References: <4BB9A929.2000303@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Fix uninitialized variable of tracing/trace output
Message-ID: <tip-aa27497c2fb4c7f57706099bd489e683e5cc3e3b@git.kernel.org>
Git-Commit-ID: aa27497c2fb4c7f57706099bd489e683e5cc3e3b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 14 Apr 2010 15:00:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aa27497c2fb4c7f57706099bd489e683e5cc3e3b
Gitweb:     http://git.kernel.org/tip/aa27497c2fb4c7f57706099bd489e683e5cc3e3b
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Mon, 5 Apr 2010 17:11:05 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 5 Apr 2010 11:01:22 -0400

tracing: Fix uninitialized variable of tracing/trace output

Because a local variable is not initialized, I got these
when I did 'cat tracing/trace'. (not trace_pipe):

CPU:0 [LOST 18446744071579453134 EVENTS]
              ps-3099  [000]   560.770221: lock_acquire: ffff880030865010 &(&dentry->d_lock)->rlock
CPU:0 [LOST 18446744071579453134 EVENTS]
              ps-3099  [000]   560.770221: lock_release: ffff880030865010 &(&dentry->d_lock)->rlock
CPU:0 [LOST 18446612133255294080 EVENTS]
              ps-3099  [000]   560.770221: lock_acquire: ffff880030865010 &(&dentry->d_lock)->rlock
CPU:0 [LOST 18446744071579453134 EVENTS]
              ps-3099  [000]   560.770222: lock_release: ffff880030865010 &(&dentry->d_lock)->rlock
CPU:0 [LOST 18446744071579453134 EVENTS]
              ps-3099  [000]   560.770222: lock_release: ffffffff816cfb98 dcache_lock

See peek_next_entry(), it does not set *lost_events when we 'cat tracing/trace'

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4BB9A929.2000303@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0498beb..b9be232 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1571,7 +1571,7 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu,
 {
 	struct ring_buffer *buffer = iter->tr->buffer;
 	struct trace_entry *ent, *next = NULL;
-	unsigned long lost_events, next_lost = 0;
+	unsigned long lost_events = 0, next_lost = 0;
 	int cpu_file = iter->cpu_file;
 	u64 next_ts = 0, ts;
 	int next_cpu = -1;
