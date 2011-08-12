Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750944Ab1HLQaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 12:30:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:33784 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab1HLQ3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 12:29:20 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/12] perf probe: Filter out redundant inline-instances
Date: Fri, 12 Aug 2011 13:29:04 -0300
Message-Id: <1313166544-6209-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1313166544-6209-1-git-send-email-acme@infradead.org>
References: <1313166544-6209-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

With gcc4.6, some instances of concrete inlined function looks redundant
and broken, because it appears inside of a concrete instance and its
call_file and call_line are same as the original abstruct's decl_file
and decl_line respectively.

e.g.
 [  d1aa]    subprogram
             external             (flag) Yes
             name                 (strp) "add_timer"
             decl_file            (data1) 2		;here is original
             decl_line            (data2) 847		;line and file
             prototyped           (flag) Yes
             inline               (data1) inlined (1)
             sibling              (ref4) [  d1c6]
...
 [ 11d84]    subprogram
             abstract_origin      (ref4) [  d1aa]	; concrete instance
             low_pc               (addr) .text+0x000000000000246f <add_timer>
             high_pc              (addr) .text+0x000000000000248b <mod_timer_pending>
             frame_base           (block1)               [   0] call_frame_cfa
             sibling              (ref4) [ 11dd9]
 [ 11d9f]      formal_parameter
               abstract_origin      (ref4) [  d1b9]
               location             (data4) location list [  701b]
 [ 11da8]      inlined_subroutine
               abstract_origin      (ref4) [  d1aa]	; redundant instance
               low_pc               (addr) .text+0x000000000000247e <add_timer+0xf>
               high_pc              (addr) .text+0x0000000000002480 <add_timer+0x11>
               call_file            (data1) 2		; call line and file
               call_line            (data2) 847		; are same as above

Those redundant instances leads unwilling results;

e.g. find probe points inside of functions even if we specify
a function entry as below;

$ perf probe -V add_timer
Available variables at add_timer
        @<add_timer+0>
                struct timer_list*      timer
        @<add_timer+15>
                (No matched variables)

So, this filters out those redundant instances based on call-site and
decl-site information.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20110811110317.19900.59525.stgit@fedora15
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dwarf-aux.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index d0f4048..ee51e9b 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -307,6 +307,17 @@ static int die_get_call_fileno(Dwarf_Die *in_die)
 		return -ENOENT;
 }
 
+/* Get the declared file index number in CU DIE */
+static int die_get_decl_fileno(Dwarf_Die *pdie)
+{
+	Dwarf_Sword idx;
+
+	if (die_get_attr_sdata(pdie, DW_AT_decl_file, &idx) == 0)
+		return (int)idx;
+	else
+		return -ENOENT;
+}
+
 /**
  * die_get_call_file - Get callsite file name of inlined function instance
  * @in_die: a DIE of an inlined function instance
@@ -467,6 +478,7 @@ static int __die_walk_instances_cb(Dwarf_Die *inst, void *data)
 	Dwarf_Die origin_mem;
 	Dwarf_Attribute *attr;
 	Dwarf_Die *origin;
+	int tmp;
 
 	attr = dwarf_attr(inst, DW_AT_abstract_origin, &attr_mem);
 	if (attr == NULL)
@@ -476,6 +488,16 @@ static int __die_walk_instances_cb(Dwarf_Die *inst, void *data)
 	if (origin == NULL || origin->addr != iwp->addr)
 		return DIE_FIND_CB_CONTINUE;
 
+	/* Ignore redundant instances */
+	if (dwarf_tag(inst) == DW_TAG_inlined_subroutine) {
+		dwarf_decl_line(origin, &tmp);
+		if (die_get_call_lineno(inst) == tmp) {
+			tmp = die_get_decl_fileno(origin);
+			if (die_get_call_fileno(inst) == tmp)
+				return DIE_FIND_CB_CONTINUE;
+		}
+	}
+
 	iwp->retval = iwp->callback(inst, iwp->data);
 
 	return (iwp->retval) ? DIE_FIND_CB_END : DIE_FIND_CB_CONTINUE;
-- 
1.6.2.5

