Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab1GUKEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:04:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:56000 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab1GUKEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:04:45 -0400
Date: Thu, 21 Jul 2011 10:04:15 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-bcfc082150c6b1e9443c1277bca8be80094150b5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110627072721.6528.2747.stgit@fedora15>
References: <20110627072721.6528.2747.stgit@fedora15>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Remove redundant dwarf functions
Git-Commit-ID: bcfc082150c6b1e9443c1277bca8be80094150b5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 10:04:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bcfc082150c6b1e9443c1277bca8be80094150b5
Gitweb:     http://git.kernel.org/tip/bcfc082150c6b1e9443c1277bca8be80094150b5
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Mon, 27 Jun 2011 16:27:21 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 15 Jul 2011 16:04:47 -0400

perf probe: Remove redundant dwarf functions

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
