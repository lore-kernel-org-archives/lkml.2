Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab2KZRjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:39:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47866 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933581Ab2KZRLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:11:09 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 180/270] ring-buffer: Check for uninitialized cpu buffer before resizing
Date: Mon, 26 Nov 2012 14:57:50 -0200
Message-Id: <1353949160-26803-181-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vaibhav Nagarnaik <vnagarnaik@google.com>

commit 8e49f418c9632790bf456634742d34d97120a784 upstream.

With a system where, num_present_cpus < num_possible_cpus, even if all
CPUs are online, non-present CPUs don't have per_cpu buffers allocated.
If per_cpu/<cpu>/buffer_size_kb is modified for such a CPU, it can cause
a panic due to NULL dereference in ring_buffer_resize().

To fix this, resize operation is allowed only if the per-cpu buffer has
been initialized.

Link: http://lkml.kernel.org/r/1349912427-6486-1-git-send-email-vnagarnaik@google.com

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/trace/ring_buffer.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index f765465..db6dff1 100644
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
1.7.9.5

