Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934342Ab0HXXi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:38:56 -0400
Received: from kroah.org ([198.145.64.141]:40316 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932800Ab0HXW6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:58:23 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:13 2010
Message-Id: <20100824224213.695908245@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:41:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shaohua Li <shaohua.li@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [19/91] tracing: Fix an unallocated memory access in function_graph
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shaohua Li <shaohua.li@intel.com>

commit 575570f02761bd680ba5731c1dfd4701062e7fb2 upstream.

With CONFIG_DEBUG_PAGEALLOC, I observed an unallocated memory access in
function_graph trace. It appears we find a small size entry in ring buffer,
but we access it as a big size entry. The access overflows the page size
and touches an unallocated page.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
LKML-Reference: <1280217994.32400.76.camel@sli10-desk.sh.intel.com>
[ Added a comment to explain the problem - SDR ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/trace_functions_graph.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -506,7 +506,15 @@ get_return_for_leaf(struct trace_iterato
 			 * if the output fails.
 			 */
 			data->ent = *curr;
-			data->ret = *next;
+			/*
+			 * If the next event is not a return type, then
+			 * we only care about what type it is. Otherwise we can
+			 * safely copy the entire event.
+			 */
+			if (next->ent.type == TRACE_GRAPH_RET)
+				data->ret = *next;
+			else
+				data->ret.ent.type = next->ent.type;
 		}
 	}
 


