Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3ACWjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 17:39:14 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:48798 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754389Ab3ACWid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 17:38:33 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH] dtc: Fix util_is_printable_string
Date: Fri,  4 Jan 2013 00:32:01 +0200
Message-Id: <1357252321-6097-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The method used did not account for multi-part strings.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 scripts/dtc/util.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/scripts/dtc/util.c b/scripts/dtc/util.c
index 2422c34..45f186b 100644
--- a/scripts/dtc/util.c
+++ b/scripts/dtc/util.c
@@ -72,7 +72,7 @@ char *join_path(const char *path, const char *name)
 int util_is_printable_string(const void *data, int len)
 {
 	const char *s = data;
-	const char *ss;
+	const char *ss, *se;
 
 	/* zero length is not */
 	if (len == 0)
@@ -82,13 +82,19 @@ int util_is_printable_string(const void *data, int len)
 	if (s[len - 1] != '\0')
 		return 0;
 
-	ss = s;
-	while (*s && isprint(*s))
-		s++;
+	se = s + len;
 
-	/* not zero, or not done yet */
-	if (*s != '\0' || (s + 1 - ss) < len)
-		return 0;
+	while (s < se) {
+		ss = s;
+		while (s < se && *s && isprint(*s))
+			s++;
+
+		/* not zero, or not done yet */
+		if (*s != '\0' || s == ss)
+			return 0;
+
+		s++;
+	}
 
 	return 1;
 }
-- 
1.7.12

