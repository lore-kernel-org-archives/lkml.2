Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab2AXCsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:48:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932677Ab2AXCsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:48:11 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:33 2012
Message-Id: <20120124023933.912905971@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ben Hutchings <ben@decadent.org.uk>, Dave Jones <davej@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [112/129] tracepoints/module: Fix disabling tracepoints with taint CRAP or OOT
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1643
Lines: 43

From: Steven Rostedt <srostedt@redhat.com>

commit c10076c4304083af15a41f6bc5e657e781c1f9a6 upstream.

Tracepoints are disabled for tainted modules, which is usually because the
module is either proprietary or was forced, and we don't want either of them
using kernel tracepoints.

But, a module can also be tainted by being in the staging directory or
compiled out of tree. Either is fine for use with tracepoints, no need
to punish them.  I found this out when I noticed that my sample trace event
module, when done out of tree, stopped working.

Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Dave Jones <davej@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/tracepoint.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -634,10 +634,11 @@ static int tracepoint_module_coming(stru
 	int ret = 0;
 
 	/*
-	 * We skip modules that tain the kernel, especially those with different
-	 * module header (for forced load), to make sure we don't cause a crash.
+	 * We skip modules that taint the kernel, especially those with different
+	 * module headers (for forced load), to make sure we don't cause a crash.
+	 * Staging and out-of-tree GPL modules are fine.
 	 */
-	if (mod->taints)
+	if (mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP)))
 		return 0;
 	mutex_lock(&tracepoints_mutex);
 	tp_mod = kmalloc(sizeof(struct tp_module), GFP_KERNEL);


