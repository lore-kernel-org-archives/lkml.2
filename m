Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab2JCMTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:19:10 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:40739 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab2JCMTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:19:07 -0400
X-AuditID: b753bd60-963e4ba000004744-82-506c2d3797be
X-AuditID: b753bd60-963e4ba000004744-82-506c2d3797be
Subject: [PATCH -tip ] [BUGFIX] perf probe: Add a workaround for GCC -mfentry
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Michal Marek <mmarek@suse.cz>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        systemtap@sourceware.org, yrl.pp-manager.tt@hitachi.com
Date: Wed, 03 Oct 2012 21:17:07 +0900
Message-ID: <20121003121707.4186.28696.stgit@ltc138.sdl.hitachi.co.jp>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a workaround for GCC -mfentry option. This enables perf
probe to find function parameters(arguments) at given function
entry point again.

With -mfentry, GCC (I've found this with Red Hat 4.7.0-5 and
Red Hat 4.7.2-2 on Fedora 17) generates odd debuginfo about
variable locations.

Here are examples:
-----
 <1><9a58>: Abbrev Number: 86 (DW_TAG_subprogram)
    <9a59>   DW_AT_external    : 1
    <9a59>   DW_AT_name        : (indirect string, offset: 0xd82): unregister_di
e_notifier
    <9a5d>   DW_AT_decl_file   : 1
    <9a5e>   DW_AT_decl_line   : 551
    <9a60>   DW_AT_prototyped  : 1
    <9a60>   DW_AT_type        : <0x7c>
    <9a64>   DW_AT_low_pc      : 0x740
    <9a6c>   DW_AT_high_pc     : 0x75a
    <9a74>   DW_AT_frame_base  : 1 byte block: 9c       (DW_OP_call_frame_cfa)
    <9a76>   DW_AT_GNU_all_call_sites: 1
    <9a76>   DW_AT_sibling     : <0x9aac>
 <2><9a7a>: Abbrev Number: 87 (DW_TAG_formal_parameter)
    <9a7b>   DW_AT_name        : nb
    <9a7e>   DW_AT_decl_file   : 1
    <9a7f>   DW_AT_decl_line   : 551
    <9a81>   DW_AT_type        : <0x2a96>
    <9a85>   DW_AT_location    : 0x172f (location list)
...
    0000172f 0000000000000745 0000000000000750 (DW_OP_reg5 (rdi))
    0000172f 0000000000000750 0000000000000757 (DW_OP_reg4 (rsi))
    0000172f 0000000000000757 000000000000075a (DW_OP_GNU_entry_value: (DW_OP_reg5 (rdi)); DW_OP_stack_value)
    0000172f <End of list>
-----

As you can see, the location of the parameter "nb", starts from 0x745
but unregister_die_notifier() function itself starts from 0x740.

-----
 <1><9aac>: Abbrev Number: 86 (DW_TAG_subprogram)
    <9aad>   DW_AT_external    : 1
    <9aad>   DW_AT_name        : (indirect string, offset: 0x321f): notify_die
    <9ab1>   DW_AT_decl_file   : 1
    <9ab2>   DW_AT_decl_line   : 530
    <9ab4>   DW_AT_prototyped  : 1
    <9ab4>   DW_AT_type        : <0x7c>
    <9ab8>   DW_AT_low_pc      : 0xb0
    <9ac0>   DW_AT_high_pc     : 0xe0
    <9ac8>   DW_AT_frame_base  : 1 byte block: 9c       (DW_OP_call_frame_cfa)
    <9aca>   DW_AT_GNU_all_call_sites: 1
    <9aca>   DW_AT_sibling     : <0x9b6c>
 <2><9ace>: Abbrev Number: 87 (DW_TAG_formal_parameter)
    <9acf>   DW_AT_name        : val
    <9ad3>   DW_AT_decl_file   : 1
    <9ad4>   DW_AT_decl_line   : 530
    <9ad6>   DW_AT_type        : <0x2b36>
    <9ada>   DW_AT_location    : 0x177b (location list)
...
    0000177b 00000000000000b0 00000000000000cd (DW_OP_reg5 (rdi))
    0000177b 00000000000000cd 00000000000000dd (DW_OP_reg4 (rsi))
    0000177b 00000000000000dd 00000000000000e0 (DW_OP_GNU_entry_value: (DW_OP_reg5 (rdi)); DW_OP_stack_value)
    0000177b <End of list>
-----

However, without fentry call (notifiy_die is marked notrace),
the parameter "val" location start with 0xb0, which is same as
notify_die start address.

To avoid failing variable search at the function entry point,
this add a workaround which adjusts var-search address +5
only if all the below conditions are true;

- given variable is a formal_parameter
- the searching address is a function entry point
- the formal_parameter has no location at the function entry point

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/util/probe-finder.c |   40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 1daf5c1..84b3b5f 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -276,7 +276,7 @@ static struct probe_trace_arg_ref *alloc_trace_arg_ref(long offs)
  * If tvar == NULL, this just checks variable can be converted.
  */
 static int convert_variable_location(Dwarf_Die *vr_die, Dwarf_Addr addr,
-				     Dwarf_Op *fb_ops,
+				     Dwarf_Op *fb_ops, bool fentry,
 				     struct probe_trace_arg *tvar)
 {
 	Dwarf_Attribute attr;
@@ -291,13 +291,31 @@ static int convert_variable_location(Dwarf_Die *vr_die, Dwarf_Addr addr,
 	if (dwarf_attr(vr_die, DW_AT_external, &attr) != NULL)
 		goto static_var;
 
+	if (dwarf_attr(vr_die, DW_AT_location, &attr) == NULL)
+		return -ENOENT;
+
+	if (fentry && (dwarf_tag(vr_die) == DW_TAG_formal_parameter) &&
+	    (dwarf_getlocation_addr(&attr, addr, &op, &nops, 1) == 0))
+		/*
+		 * Workaround: GCC -mfentry option generates odd
+		 * variable location entries which start from a
+		 * function entry+5, even if it is a formal_parameter.
+		 * On the other hand, for functions without fentry call
+		 * (e.g. notrace function), the formal_parameter location
+		 * starts from the function entry address.
+		 * Here, if we find a formal_parameter which doesn't
+		 * start from the function entry, but from function
+		 * entry+5, it should be a buggy entry.
+		 * We forcibly get the variable(parameter) location
+		 * information from entry+5.
+		 */
+		addr += 5;
+
 	/* TODO: handle more than 1 exprs */
-	if (dwarf_attr(vr_die, DW_AT_location, &attr) == NULL ||
-	    dwarf_getlocation_addr(&attr, addr, &op, &nops, 1) <= 0 ||
-	    nops == 0) {
+	if (dwarf_getlocation_addr(&attr, addr, &op, &nops, 1) <= 0 ||
+	    nops == 0)
 		/* TODO: Support const_value */
 		return -ENOENT;
-	}
 
 	if (op->atom == DW_OP_addr) {
 static_var:
@@ -595,13 +613,19 @@ next:
 static int convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 {
 	Dwarf_Die die_mem;
+	Dwarf_Addr eaddr;
+	bool fentry;
 	int ret;
 
 	pr_debug("Converting variable %s into trace event.\n",
 		 dwarf_diename(vr_die));
 
+	/* GCC -mfentry workaround */
+	fentry = (dwarf_entrypc(&pf->sp_die, &eaddr) == 0) &&
+		 (eaddr == pf->addr);
+
 	ret = convert_variable_location(vr_die, pf->addr, pf->fb_ops,
-					pf->tvar);
+					fentry, pf->tvar);
 	if (ret == -ENOENT)
 		pr_err("Failed to find the location of %s at this address.\n"
 		       " Perhaps, it has been optimized out.\n", pf->pvar->var);
@@ -1220,7 +1244,9 @@ static int collect_variables_cb(Dwarf_Die *die_mem, void *data)
 	if (tag == DW_TAG_formal_parameter ||
 	    tag == DW_TAG_variable) {
 		ret = convert_variable_location(die_mem, af->pf.addr,
-						af->pf.fb_ops, NULL);
+						af->pf.fb_ops,
+						vl->point.offset == 0,
+						NULL);
 		if (ret == 0) {
 			ret = die_get_varname(die_mem, buf, MAX_VAR_LEN);
 			pr_debug2("Add new var: %s\n", buf);

