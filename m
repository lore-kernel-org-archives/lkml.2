Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab0G0IGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 04:06:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:38573 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204Ab0G0IGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 04:06:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,266,1278313200"; 
   d="scan'208";a="641960104"
Subject: [RFC]ftrace: fix a unallocated memory access in function_graph
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, srostedt@redhat.com,
        "Huang, Ying" <ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 16:06:34 +0800
Message-ID: <1280217994.32400.76.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_DEBUG_PAGEALLOC, I observed a unallocated memory access in
function_graph trace. It appears we find a small size entry in ring buffer, but
we access it as a big size entry. The access overflows a page size and touch
a unallocated page.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 79f4bac..33b379d 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -507,7 +507,10 @@ get_return_for_leaf(struct trace_iterator *iter,
 			 * if the output fails.
 			 */
 			data->ent = *curr;
-			data->ret = *next;
+			if (next->ent.type == TRACE_GRAPH_RET)
+				data->ret = *next;
+			else
+				data->ret.ent.type = next->ent.type;
 		}
 	}
 


