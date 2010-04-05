Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab0DEJLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 05:11:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58791 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab0DEJLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 05:11:31 -0400
Message-ID: <4BB9A929.2000303@cn.fujitsu.com>
Date: Mon, 05 Apr 2010 17:11:05 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: kill wrong message when cat tracing/trace
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of a local variable is not initialized, I got these
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
---
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

