Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1GPLXd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 07:23:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39349 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab1GPLXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 07:23:03 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=_Zo8MIn8NCsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3nbZYyFuAAAA:8 a=pGLkceISAAAA:8 a=hGzw-44bAAAA:8 a=h3sCQ_blAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=IHacXYrSmxaTGrwequwA:9 a=EvKJbDF4Ut8A:10 a=MSl-tDqOz04A:10 a=dowx1zmaLagA:10 a=fNChW5oJl9MA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110716112255.547587326@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 16 Jul 2011 07:22:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 16/20] perf probe: Remove redundant dwarf functions
References: <20110716112200.096203519@goodmis.org>
Content-Disposition: inline; filename=0016-perf-probe-Remove-redundant-dwarf-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Since there are dwarf_bitsize, dwarf_bitoffset and dwarf_bytesize
defined in libdw, we don't need die_get_bit_size, die_get_bit_offset
and die_get_byte_size anymore.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/20110627072721.6528.2747.stgit@fedora15
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/util/probe-finder.c |   50 ++++++++++-----------------------------
 1 files changed, 13 insertions(+), 37 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 459ebe8..d443b64 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -361,36 +361,6 @@ static bool die_is_signed_type(Dwarf_Die *tp_die)
 		ret == DW_ATE_signed_fixed);
 }
 
-static int die_get_byte_size(Dwarf_Die *tp_die)
-{
-	Dwarf_Word ret;
-
-	if (die_get_attr_udata(tp_die, DW_AT_byte_size, &ret))
-		return 0;
-
-	return (int)ret;
-}
-
-static int die_get_bit_size(Dwarf_Die *tp_die)
-{
-	Dwarf_Word ret;
-
-	if (die_get_attr_udata(tp_die, DW_AT_bit_size, &ret))
-		return 0;
-
-	return (int)ret;
-}
-
-static int die_get_bit_offset(Dwarf_Die *tp_die)
-{
-	Dwarf_Word ret;
-
-	if (die_get_attr_udata(tp_die, DW_AT_bit_offset, &ret))
-		return 0;
-
-	return (int)ret;
-}
-
 /* Get data_member_location offset */
 static int die_get_data_member_location(Dwarf_Die *mb_die, Dwarf_Word *offs)
 {
@@ -882,6 +852,7 @@ static int convert_variable_type(Dwarf_Die *vr_die,
 	struct probe_trace_arg_ref **ref_ptr = &tvar->ref;
 	Dwarf_Die type;
 	char buf[16];
+	int bsize, boffs, total;
 	int ret;
 
 	/* TODO: check all types */
@@ -891,11 +862,15 @@ static int convert_variable_type(Dwarf_Die *vr_die,
 		return (tvar->type == NULL) ? -ENOMEM : 0;
 	}
 
-	if (die_get_bit_size(vr_die) != 0) {
+	bsize = dwarf_bitsize(vr_die);
+	if (bsize > 0) {
 		/* This is a bitfield */
-		ret = snprintf(buf, 16, "b%d@%d/%zd", die_get_bit_size(vr_die),
-				die_get_bit_offset(vr_die),
-				BYTES_TO_BITS(die_get_byte_size(vr_die)));
+		boffs = dwarf_bitoffset(vr_die);
+		total = dwarf_bytesize(vr_die);
+		if (boffs < 0 || total < 0)
+			return -ENOENT;
+		ret = snprintf(buf, 16, "b%d@%d/%zd", bsize, boffs,
+				BYTES_TO_BITS(total));
 		goto formatted;
 	}
 
@@ -943,10 +918,11 @@ static int convert_variable_type(Dwarf_Die *vr_die,
 		return (tvar->type == NULL) ? -ENOMEM : 0;
 	}
 
-	ret = BYTES_TO_BITS(die_get_byte_size(&type));
-	if (!ret)
+	ret = dwarf_bytesize(&type);
+	if (ret <= 0)
 		/* No size ... try to use default type */
 		return 0;
+	ret = BYTES_TO_BITS(ret);
 
 	/* Check the bitwidth */
 	if (ret > MAX_BASIC_TYPE_BITS) {
@@ -1010,7 +986,7 @@ static int convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 			else
 				*ref_ptr = ref;
 		}
-		ref->offset += die_get_byte_size(&type) * field->index;
+		ref->offset += dwarf_bytesize(&type) * field->index;
 		if (!field->next)
 			/* Save vr_die for converting types */
 			memcpy(die_mem, vr_die, sizeof(*die_mem));
-- 
1.7.5.4


