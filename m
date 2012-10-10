Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab2JJXkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:40:33 -0400
Received: from mail-gg0-f202.google.com ([209.85.161.202]:47162 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470Ab2JJXkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:40:31 -0400
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH] ring-buffer: Check for uninitialized cpu buffer before resizing
Date: Wed, 10 Oct 2012 16:40:27 -0700
Message-Id: <1349912427-6486-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a system where, num_present_cpus < num_possible_cpus, even if all
CPUs are online, non-present CPUs don't have per_cpu buffers allocated.
If per_cpu/<cpu>/buffer_size_kb is modified for such a CPU, it can cause
a panic due to NULL dereference in ring_buffer_resize().

To fix this, resize operation is allowed only if the per-cpu buffer has
been initialized.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 kernel/trace/ring_buffer.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index b32ed0e..b979426 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1567,6 +1567,10 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 
 		put_online_cpus();
 	} else {
+		/* Make sure this CPU has been intitialized */
+		if (!cpumask_test_cpu(cpu_id, buffer->cpumask))
+			goto out;
+
 		cpu_buffer = buffer->buffers[cpu_id];
 
 		if (nr_pages == cpu_buffer->nr_pages)
-- 
1.7.7.3

