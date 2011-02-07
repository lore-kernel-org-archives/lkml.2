Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab1BGPBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:01:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58941 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab1BGPA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:00:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 7/9] perf probe: Add bitfield member support
Date: Mon,  7 Feb 2011 13:00:10 -0200
Message-Id: <1297090812-10782-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297090812-10782-1-git-send-email-acme@infradead.org>
References: <1297090812-10782-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Add bitfield member accessing support to probe arguments.

Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20110204125211.9507.60265.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |   95 ++++++++++++++++++++++++++++-----------
 1 files changed, 68 insertions(+), 27 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 46addfb..fd78123 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -33,6 +33,7 @@
 #include <ctype.h>
 #include <dwarf-regs.h>
 
+#include <linux/bitops.h>
 #include "event.h"
 #include "debug.h"
 #include "util.h"
@@ -333,13 +334,23 @@ static Dwarf_Die *die_get_real_type(Dwarf_Die *vr_die, Dwarf_Die *die_mem)
 	return vr_die;
 }
 
-static bool die_is_signed_type(Dwarf_Die *tp_die)
+static int die_get_attr_udata(Dwarf_Die *tp_die, unsigned int attr_name,
+			      Dwarf_Word *result)
 {
 	Dwarf_Attribute attr;
+
+	if (dwarf_attr(tp_die, attr_name, &attr) == NULL ||
+	    dwarf_formudata(&attr, result) != 0)
+		return -ENOENT;
+
+	return 0;
+}
+
+static bool die_is_signed_type(Dwarf_Die *tp_die)
+{
 	Dwarf_Word ret;
 
-	if (dwarf_attr(tp_die, DW_AT_encoding, &attr) == NULL ||
-	    dwarf_formudata(&attr, &ret) != 0)
+	if (die_get_attr_udata(tp_die, DW_AT_encoding, &ret))
 		return false;
 
 	return (ret == DW_ATE_signed_char || ret == DW_ATE_signed ||
@@ -348,11 +359,29 @@ static bool die_is_signed_type(Dwarf_Die *tp_die)
 
 static int die_get_byte_size(Dwarf_Die *tp_die)
 {
-	Dwarf_Attribute attr;
 	Dwarf_Word ret;
 
-	if (dwarf_attr(tp_die, DW_AT_byte_size, &attr) == NULL ||
-	    dwarf_formudata(&attr, &ret) != 0)
+	if (die_get_attr_udata(tp_die, DW_AT_byte_size, &ret))
+		return 0;
+
+	return (int)ret;
+}
+
+static int die_get_bit_size(Dwarf_Die *tp_die)
+{
+	Dwarf_Word ret;
+
+	if (die_get_attr_udata(tp_die, DW_AT_bit_size, &ret))
+		return 0;
+
+	return (int)ret;
+}
+
+static int die_get_bit_offset(Dwarf_Die *tp_die)
+{
+	Dwarf_Word ret;
+
+	if (die_get_attr_udata(tp_die, DW_AT_bit_offset, &ret))
 		return 0;
 
 	return (int)ret;
@@ -827,6 +856,8 @@ static_var:
 	return 0;
 }
 
+#define BYTES_TO_BITS(nb)	((nb) * BITS_PER_LONG / sizeof(long))
+
 static int convert_variable_type(Dwarf_Die *vr_die,
 				 struct probe_trace_arg *tvar,
 				 const char *cast)
@@ -843,6 +874,14 @@ static int convert_variable_type(Dwarf_Die *vr_die,
 		return (tvar->type == NULL) ? -ENOMEM : 0;
 	}
 
+	if (die_get_bit_size(vr_die) != 0) {
+		/* This is a bitfield */
+		ret = snprintf(buf, 16, "b%d@%d/%lu", die_get_bit_size(vr_die),
+				die_get_bit_offset(vr_die),
+				BYTES_TO_BITS(die_get_byte_size(vr_die)));
+		goto formatted;
+	}
+
 	if (die_get_real_type(vr_die, &type) == NULL) {
 		pr_warning("Failed to get a type information of %s.\n",
 			   dwarf_diename(vr_die));
@@ -887,29 +926,31 @@ static int convert_variable_type(Dwarf_Die *vr_die,
 		return (tvar->type == NULL) ? -ENOMEM : 0;
 	}
 
-	ret = die_get_byte_size(&type) * 8;
-	if (ret) {
-		/* Check the bitwidth */
-		if (ret > MAX_BASIC_TYPE_BITS) {
-			pr_info("%s exceeds max-bitwidth."
-				" Cut down to %d bits.\n",
-				dwarf_diename(&type), MAX_BASIC_TYPE_BITS);
-			ret = MAX_BASIC_TYPE_BITS;
-		}
+	ret = BYTES_TO_BITS(die_get_byte_size(&type));
+	if (!ret)
+		/* No size ... try to use default type */
+		return 0;
 
-		ret = snprintf(buf, 16, "%c%d",
-			       die_is_signed_type(&type) ? 's' : 'u', ret);
-		if (ret < 0 || ret >= 16) {
-			if (ret >= 16)
-				ret = -E2BIG;
-			pr_warning("Failed to convert variable type: %s\n",
-				   strerror(-ret));
-			return ret;
-		}
-		tvar->type = strdup(buf);
-		if (tvar->type == NULL)
-			return -ENOMEM;
+	/* Check the bitwidth */
+	if (ret > MAX_BASIC_TYPE_BITS) {
+		pr_info("%s exceeds max-bitwidth. Cut down to %d bits.\n",
+			dwarf_diename(&type), MAX_BASIC_TYPE_BITS);
+		ret = MAX_BASIC_TYPE_BITS;
+	}
+	ret = snprintf(buf, 16, "%c%d",
+		       die_is_signed_type(&type) ? 's' : 'u', ret);
+
+formatted:
+	if (ret < 0 || ret >= 16) {
+		if (ret >= 16)
+			ret = -E2BIG;
+		pr_warning("Failed to convert variable type: %s\n",
+			   strerror(-ret));
+		return ret;
 	}
+	tvar->type = strdup(buf);
+	if (tvar->type == NULL)
+		return -ENOMEM;
 	return 0;
 }
 
-- 
1.6.2.5

