Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab2JKARR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:17:17 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56761 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932878Ab2JKARH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:17:07 -0400
X-Sasl-enc: EcA/CUJNm62/W46o/ke4cYtP+y045nuqn7DoXl2tHhf0 1349914626
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Huang Shijie <shijie8@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 122/133] mtd: mtdpart: break it as soon as we parse out the partitions
Date: Thu, 11 Oct 2012 07:52:28 +0900
Message-Id: <20121010224916.502816988@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huang Shijie <shijie8@gmail.com>

commit c51803ddba10d80d9f246066802c6e359cf1d44c upstream.

We may cause a memory leak when the @types has more then one parser.

Take the `default_mtd_part_types` for example. The default_mtd_part_types has
two parsers now: `cmdlinepart` and `ofpart`.

Assume the following case:
The kernel command line sets the partitions like:
	#gpmi-nand:20m(boot),20m(kernel),1g(rootfs),-(user)
But the devicetree file(such as arch/arm/boot/dts/imx28-evk.dts) also sets
the same partitions as the kernel command line does.

In the current code, the partitions parsed out by the `ofpart` will
overwrite the @pparts which has already set by the `cmdlinepart` parser,
and the the partitions parsed out by the `cmdlinepart` is missed.
A memory leak occurs.

So we should break the code as soon as we parse out the partitions,
In actually, this patch makes a priority order between the parsers.
If one parser has already parsed out the partitions successfully,
it's no need to use another parser anymore.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/mtdpart.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -711,6 +711,8 @@ static const char *default_mtd_part_type
  * partition parsers, specified in @types. However, if @types is %NULL, then
  * the default list of parsers is used. The default list contains only the
  * "cmdlinepart" and "ofpart" parsers ATM.
+ * Note: If there are more then one parser in @types, the kernel only takes the
+ * partitions parsed out by the first parser.
  *
  * This function may return:
  * o a negative error code in case of failure
@@ -735,11 +737,12 @@ int parse_mtd_partitions(struct mtd_info
 		if (!parser)
 			continue;
 		ret = (*parser->parse_fn)(master, pparts, data);
+		put_partition_parser(parser);
 		if (ret > 0) {
 			printk(KERN_NOTICE "%d %s partitions found on MTD device %s\n",
 			       ret, parser->name, master->name);
+			break;
 		}
-		put_partition_parser(parser);
 	}
 	return ret;
 }


