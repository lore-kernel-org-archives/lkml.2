Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964874Ab2KEWtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:49:21 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:35541 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964809Ab2KEWtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:49:18 -0500
Date: Mon, 5 Nov 2012 23:49:16 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net
Subject: [PATCH] [perf] convert_variable_type does not correctly check type of arrays
Message-ID: <20121105224916.GA15530@order.stressinduktion.org>
Mail-Followup-To: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
	paulus@samba.org, mingo@redhat.com, acme@ghostprotocols.net
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While casting an array of (unsigned) chars to a string, perf does not
check the containing type but only the opaque type and is bailing out:

  $ perf probe -v -a 'neigh_destroy:22 dev->name:string'
  probe-definition(0): neigh_destroy:22 dev->name:string
  symbol:neigh_destroy file:(null) line:22 offset:0 return:0 lazy:(null)
  parsing arg: dev->name:string into type:string dev, name(1)
  1 arguments
  Use vmlinux: /home/hannes/linux/vmlinux
  Using /home/hannes/linux/vmlinux for symbols
  Probe point found: neigh_destroy+115
  Searching 'dev' variable in context.
  Converting variable dev into trace event.
  converting name in dev
  name type is (null).
  Failed to cast into string: name is not (unsigned) char *.
  Failed to find 'dev' in this function.
  An error occurred in debuginfo analysis (-22).
    Error: Failed to add events. (-22)

After the code flow ensures that type could only be a pointer or
array type, call die_get_real_type unconditionally again to fetch the
containing type and have further validation been done on that Die.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
---
 tools/perf/util/probe-finder.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 1daf5c1..2a61ea5 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -413,12 +413,13 @@ static int convert_variable_type(Dwarf_Die *vr_die,
 				   dwarf_diename(vr_die), dwarf_diename(&type));
 			return -EINVAL;
 		}
+		if (die_get_real_type(&type, &type) == NULL) {
+			pr_warning("Failed to get a type  information.\n");
+			return -ENOENT;
+		}
+		pr_debug("containing type of %s is %s.\n",
+			dwarf_diename(vr_die), dwarf_diename(&type));
 		if (ret == DW_TAG_pointer_type) {
-			if (die_get_real_type(&type, &type) == NULL) {
-				pr_warning("Failed to get a type"
-					   " information.\n");
-				return -ENOENT;
-			}
 			while (*ref_ptr)
 				ref_ptr = &(*ref_ptr)->next;
 			/* Add new reference with offset +0 */

