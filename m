Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab2GFLB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:01:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51559 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609Ab2GFLB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:01:57 -0400
Date: Fri, 6 Jul 2012 04:01:43 -0700
From: tip-bot for Vaibhav Nagarnaik <vnagarnaik@google.com>
Message-ID: <tip-44b99462d9d776522e174d6c531ce5ccef309e26@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vnagarnaik@google.com, hpa@zytor.com,
        mingo@kernel.org, rostedt@goodmis.org, dhsharp@google.com,
        tglx@linutronix.de, teravest@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, vnagarnaik@google.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, dhsharp@google.com,
        tglx@linutronix.de, teravest@google.com
In-Reply-To: <1340391005-10880-1-git-send-email-vnagarnaik@google.com>
References: <1340391005-10880-1-git-send-email-vnagarnaik@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] ring-buffer:
  Fix crash due to uninitialized new_pages list head
Git-Commit-ID: 44b99462d9d776522e174d6c531ce5ccef309e26
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 04:01:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  44b99462d9d776522e174d6c531ce5ccef309e26
Gitweb:     http://git.kernel.org/tip/44b99462d9d776522e174d6c531ce5ccef309e26
Author:     Vaibhav Nagarnaik <vnagarnaik@google.com>
AuthorDate: Fri, 22 Jun 2012 11:50:05 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 29 Jun 2012 16:16:35 -0400

ring-buffer: Fix crash due to uninitialized new_pages list head

The new_pages list head in the cpu_buffer is not initialized. When
adding pages to the ring buffer, if the memory allocation fails in
ring_buffer_resize, the clean up handler tries to free up the allocated
pages from all the cpu buffers. The panic is caused by referencing the
uninitialized new_pages list head.

Initializing the new_pages list head in rb_allocate_cpu_buffer fixes
this.

Link: http://lkml.kernel.org/r/1340391005-10880-1-git-send-email-vnagarnaik@google.com

Cc: Justin Teravest <teravest@google.com>
Cc: David Sharp <dhsharp@google.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 1d0f6a8..ba39cba 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1075,6 +1075,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int nr_pages, int cpu)
 	rb_init_page(bpage->page);
 
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
+	INIT_LIST_HEAD(&cpu_buffer->new_pages);
 
 	ret = rb_allocate_pages(cpu_buffer, nr_pages);
 	if (ret < 0)
