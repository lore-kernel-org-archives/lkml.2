Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab2EYNd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:33:58 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:37332
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754516Ab2EYNd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:33:56 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bhf0ah)
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>, <devicetree-discuss@lists.ozlabs.org>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <b29396@freescale.com>
Subject: [PATCH v4 5/6] of: add of_parse_phandle_with_args_ext function
Date: Fri, 25 May 2012 21:36:19 +0800
Message-ID: <1337952980-14621-5-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337952980-14621-1-git-send-email-b29396@freescale.com>
References: <1337952980-14621-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

The api is used when user wants to get some more extended args except ones
indicated by the cells_name.
For example, gpio cells is 2.
list = <&gpio 1 2 3 4>;
If users want to get extended args including 3, 4, he can call:
of_parse_phandle_with_args_ext(np, "gpios", "#gpio-cells", index, 2, &outargs);

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 drivers/of/base.c  |   25 ++++++++++++++++++++++++-
 include/linux/of.h |    5 ++++-
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 91c1fb4..e51ee5f 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -893,6 +893,28 @@ int of_parse_phandle_with_args(struct device_node *np, const char *list_name,
 				const char *cells_name, int index,
 				struct of_phandle_args *out_args)
 {
+	return of_parse_phandle_with_args_ext(np, list_name, cells_name,
+					index, 0, out_args);
+}
+EXPORT_SYMBOL(of_parse_phandle_with_args);
+
+/*
+ * of_parse_phandle_with_args_ext() - Find a node pointed by phandle in a list
+ * with extended args.
+ * @np:		pointer to a device tree node containing a list
+ * @list_name:	property name that contains a list
+ * @cells_name:	property name that specifies phandles' arguments count
+ * @index:	index of a phandle to parse out
+ * @cells_ext:	property name that specifies the extended args count except
+ *		phandles' arguments count
+ * @out_args:	optional pointer to output arguments structure (will be filled)
+ */
+int of_parse_phandle_with_args_ext(struct device_node *np,
+				const char *list_name,
+				const char *cells_name, int index,
+				unsigned int cells_ext,
+				struct of_phandle_args *out_args)
+{
 	const __be32 *list, *list_end;
 	int size, cur_index = 0;
 	uint32_t count = 0;
@@ -936,6 +958,7 @@ int of_parse_phandle_with_args(struct device_node *np, const char *list_name,
 			 * Make sure that the arguments actually fit in the
 			 * remaining property data length
 			 */
+			count += cells_ext;
 			if (list + count > list_end) {
 				pr_err("%s: arguments longer than property\n",
 					 np->full_name);
@@ -978,7 +1001,7 @@ int of_parse_phandle_with_args(struct device_node *np, const char *list_name,
 		of_node_put(node);
 	return -EINVAL;
 }
-EXPORT_SYMBOL(of_parse_phandle_with_args);
+EXPORT_SYMBOL(of_parse_phandle_with_args_ext);
 
 /**
  * prom_add_property - Add a property to a node
diff --git a/include/linux/of.h b/include/linux/of.h
index 2ec1083..27b4d67 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -251,7 +251,10 @@ extern struct device_node *of_parse_phandle(struct device_node *np,
 extern int of_parse_phandle_with_args(struct device_node *np,
 	const char *list_name, const char *cells_name, int index,
 	struct of_phandle_args *out_args);
-
+extern int of_parse_phandle_with_args_ext(struct device_node *np,
+	const char *list_name, const char *cells_name, int index,
+	unsigned int cells_ext,
+	struct of_phandle_args *out_args);
 extern void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align));
 extern int of_alias_get_id(struct device_node *np, const char *stem);
 
-- 
1.7.0.4


