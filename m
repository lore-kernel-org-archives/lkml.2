Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab1C3JdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:33:13 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51579 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394Ab1C3JdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:33:07 -0400
X-AuditID: b753bd60-a50bbba000004916-a4-4d92f8d165e7
X-AuditID: b753bd60-a50bbba000004916-a4-4d92f8d165e7
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 08/12] [CLEANUP]perf probe: Remove redundant dwarf
	functions
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Wed, 30 Mar 2011 18:26:23 +0900
Message-ID: <20110330092623.2132.47016.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110330092533.2132.35412.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110330092533.2132.35412.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there are dwarf_bitsize, dwarf_bitoffset and dwarf_bytesize
defined in libdw, we don't need die_get_bit_size, die_get_bit_offset
and die_get_byte_size anymore.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 tools/perf/util/probe-finder.c |   50 ++++++++++------------------------------
 1 files changed, 13 insertions(+), 37 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index e258eb3..c84043a 100644
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

