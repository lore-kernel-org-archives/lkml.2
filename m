Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751175Ab2ITFMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 01:12:52 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58901 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab2ITFMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 01:12:51 -0400
X-AuditID: 9c930179-b7bfcae0000020b4-de-505aa5d0ba7e
From: Hyeoncheol Lee <hyc.lee@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [PATCH] perf probe: Allow of casting an array of char to string
Date: Thu, 20 Sep 2012 14:12:12 +0900
Message-Id: <1348117932-786-1-git-send-email-hyc.lee@gmail.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before casting a type of a variable to string,
convert_variable_type() confirms that the type is a pointer or
an array. if it is a pointer to char, it is casted to string.
but in case of an array of char, it isn't

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Hyeoncheol Lee <hyc.lee@gmail.com>
---
 tools/perf/util/probe-finder.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 1daf5c1..be03293 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -413,12 +413,12 @@ static int convert_variable_type(Dwarf_Die *vr_die,
 				   dwarf_diename(vr_die), dwarf_diename(&type));
 			return -EINVAL;
 		}
+		if (die_get_real_type(&type, &type) == NULL) {
+			pr_warning("Failed to get a type"
+				   " information.\n");
+			return -ENOENT;
+		}
 		if (ret == DW_TAG_pointer_type) {
-			if (die_get_real_type(&type, &type) == NULL) {
-				pr_warning("Failed to get a type"
-					   " information.\n");
-				return -ENOENT;
-			}
 			while (*ref_ptr)
 				ref_ptr = &(*ref_ptr)->next;
 			/* Add new reference with offset +0 */
-- 
1.7.10.4

