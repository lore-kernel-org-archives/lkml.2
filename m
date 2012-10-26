Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab2JZA22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:28:28 -0400
Received: from mail.kernel.org ([198.145.19.201]:53413 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062Ab2JZAH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:07:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 13/85] ring-buffer: Check for uninitialized cpu buffer before resizing
Date: Thu, 25 Oct 2012 17:05:31 -0700
Message-Id: <20121026000032.459789873@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ring_buffer.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1567,6 +1567,10 @@ int ring_buffer_resize(struct ring_buffe
 
 		put_online_cpus();
 	} else {
+		/* Make sure this CPU has been intitialized */
+		if (!cpumask_test_cpu(cpu_id, buffer->cpumask))
+			goto out;
+
 		cpu_buffer = buffer->buffers[cpu_id];
 
 		if (nr_pages == cpu_buffer->nr_pages)


