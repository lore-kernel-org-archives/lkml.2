Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab1HNPue (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 11:50:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:49412 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab1HNPuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 11:50:32 -0400
Date: Sun, 14 Aug 2011 15:50:05 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-3f4460a28fb2f73df6c32c3a305797abc01c0f9c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        penberg@kernel.org, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, penberg@kernel.org,
        peterz@infradead.org, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110811110317.19900.59525.stgit@fedora15>
References: <20110811110317.19900.59525.stgit@fedora15>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Filter out redundant inline-instances
Git-Commit-ID: 3f4460a28fb2f73df6c32c3a305797abc01c0f9c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 15:50:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f4460a28fb2f73df6c32c3a305797abc01c0f9c
Gitweb:     http://git.kernel.org/tip/3f4460a28fb2f73df6c32c3a305797abc01c0f9c
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 11 Aug 2011 20:03:18 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Aug 2011 09:34:35 -0300

perf probe: Filter out redundant inline-instances

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
