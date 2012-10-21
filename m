Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab2JUShr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 14:37:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50988 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405Ab2JUShp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 14:37:45 -0400
Date: Sun, 21 Oct 2012 11:37:24 -0700
From: tip-bot for Vaibhav Nagarnaik <vnagarnaik@google.com>
Message-ID: <tip-8e49f418c9632790bf456634742d34d97120a784@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vnagarnaik@google.com, hpa@zytor.com,
        mingo@kernel.org, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, vnagarnaik@google.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1349912427-6486-1-git-send-email-vnagarnaik@google.com>
References: <1349912427-6486-1-git-send-email-vnagarnaik@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] ring-buffer:
  Check for uninitialized cpu buffer before resizing
Git-Commit-ID: 8e49f418c9632790bf456634742d34d97120a784
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 21 Oct 2012 11:37:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e49f418c9632790bf456634742d34d97120a784
Gitweb:     http://git.kernel.org/tip/8e49f418c9632790bf456634742d34d97120a784
Author:     Vaibhav Nagarnaik <vnagarnaik@google.com>
AuthorDate: Wed, 10 Oct 2012 16:40:27 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 11 Oct 2012 12:21:48 -0400

ring-buffer: Check for uninitialized cpu buffer before resizing

With a system where, num_present_cpus < num_possible_cpus, even if all
CPUs are online, non-present CPUs don't have per_cpu buffers allocated.
If per_cpu/<cpu>/buffer_size_kb is modified for such a CPU, it can cause
a panic due to NULL dereference in ring_buffer_resize().

To fix this, resize operation is allowed only if the per-cpu buffer has
been initialized.

Link: http://lkml.kernel.org/r/1349912427-6486-1-git-send-email-vnagarnaik@google.com

Cc: stable@vger.kernel.org # 3.5+
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
