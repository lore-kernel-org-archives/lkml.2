Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab2HIMb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 08:31:29 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41901 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab2HIMbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 08:31:24 -0400
X-AuditID: b753bd60-932c5ba0000047ca-a3-5023ad991478
X-AuditID: b753bd60-932c5ba0000047ca-a3-5023ad991478
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [PATCH V2 4/6] ftrace: Allow stealing pages from pipe buffer
To: linux-kernel@vger.kernel.org
Cc: Amit Shah <amit.shah@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@amd64.org>,
        "Franch Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Thu, 09 Aug 2012 21:31:10 +0900
Message-ID: <20120809123110.8542.99098.stgit@ltc189.sdl.hitachi.co.jp>
In-Reply-To: <20120809123029.8542.38311.stgit@ltc189.sdl.hitachi.co.jp>
References: <20120809123029.8542.38311.stgit@ltc189.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Use generic steal operation on pipe buffer to allow stealing
ring buffer's read page from pipe buffer.

Note that this could reduce the performance of splice on the
splice_write side operation without affinity setting.
Since the ring buffer's read pages are allocated on the
tracing-node, but the splice user does not always execute
splice write side operation on the same node. In this case,
the page will be accessed from the another node.
Thus, it is strongly recommended to assign the splicing
thread to corresponding node.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
---

 kernel/trace/trace.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a120f98..ae01930 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4194,12 +4194,6 @@ static void buffer_pipe_buf_release(struct pipe_inode_info *pipe,
 	buf->private = 0;
 }
 
-static int buffer_pipe_buf_steal(struct pipe_inode_info *pipe,
-				 struct pipe_buffer *buf)
-{
-	return 1;
-}
-
 static void buffer_pipe_buf_get(struct pipe_inode_info *pipe,
 				struct pipe_buffer *buf)
 {
@@ -4215,7 +4209,7 @@ static const struct pipe_buf_operations buffer_pipe_buf_ops = {
 	.unmap			= generic_pipe_buf_unmap,
 	.confirm		= generic_pipe_buf_confirm,
 	.release		= buffer_pipe_buf_release,
-	.steal			= buffer_pipe_buf_steal,
+	.steal			= generic_pipe_buf_steal,
 	.get			= buffer_pipe_buf_get,
 };
 


