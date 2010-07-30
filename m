Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631Ab0G3Rqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:46:35 -0400
Received: from kroah.org ([198.145.64.141]:36071 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932344Ab0G3Rfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:35:46 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:12 2010
Message-Id: <20100730173112.395986296@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:31:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [107/140] ethtool: Fix potential user buffer overflow for ETHTOOL_{G, S}RXFH
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

commit bf988435bd5b53529f4408a8efb1f433f6ddfda9 upstream.

struct ethtool_rxnfc was originally defined in 2.6.27 for the
ETHTOOL_{G,S}RXFH command with only the cmd, flow_type and data
fields.  It was then extended in 2.6.30 to support various additional
commands.  These commands should have been defined to use a new
structure, but it is too late to change that now.

Since user-space may still be using the old structure definition
for the ETHTOOL_{G,S}RXFH commands, and since they do not need the
additional fields, only copy the originally defined fields to and
from user-space.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/ethtool.h |    2 ++
 net/core/ethtool.c      |   38 +++++++++++++++++++++++++++++---------
 2 files changed, 31 insertions(+), 9 deletions(-)

--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -358,6 +358,8 @@ struct ethtool_rxnfc {
 	__u32				flow_type;
 	/* The rx flow hash value or the rule DB size */
 	__u64				data;
+	/* The following fields are not valid and must not be used for
+	 * the ETHTOOL_{G,X}RXFH commands. */
 	struct ethtool_rx_flow_spec	fs;
 	__u32				rule_cnt;
 	__u32				rule_locs[0];
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -209,22 +209,34 @@ static int ethtool_get_drvinfo(struct ne
 	return 0;
 }
 
-static int ethtool_set_rxnfc(struct net_device *dev, void __user *useraddr)
+static int ethtool_set_rxnfc(struct net_device *dev,
+			     u32 cmd, void __user *useraddr)
 {
-	struct ethtool_rxnfc cmd;
+	struct ethtool_rxnfc info;
+	size_t info_size = sizeof(info);
 
 	if (!dev->ethtool_ops->set_rxnfc)
 		return -EOPNOTSUPP;
 
-	if (copy_from_user(&cmd, useraddr, sizeof(cmd)))
+	/* struct ethtool_rxnfc was originally defined for
+	 * ETHTOOL_{G,S}RXFH with only the cmd, flow_type and data
+	 * members.  User-space might still be using that
+	 * definition. */
+	if (cmd == ETHTOOL_SRXFH)
+		info_size = (offsetof(struct ethtool_rxnfc, data) +
+			     sizeof(info.data));
+
+	if (copy_from_user(&info, useraddr, info_size))
 		return -EFAULT;
 
-	return dev->ethtool_ops->set_rxnfc(dev, &cmd);
+	return dev->ethtool_ops->set_rxnfc(dev, &info);
 }
 
-static int ethtool_get_rxnfc(struct net_device *dev, void __user *useraddr)
+static int ethtool_get_rxnfc(struct net_device *dev,
+			     u32 cmd, void __user *useraddr)
 {
 	struct ethtool_rxnfc info;
+	size_t info_size = sizeof(info);
 	const struct ethtool_ops *ops = dev->ethtool_ops;
 	int ret;
 	void *rule_buf = NULL;
@@ -232,7 +244,15 @@ static int ethtool_get_rxnfc(struct net_
 	if (!ops->get_rxnfc)
 		return -EOPNOTSUPP;
 
-	if (copy_from_user(&info, useraddr, sizeof(info)))
+	/* struct ethtool_rxnfc was originally defined for
+	 * ETHTOOL_{G,S}RXFH with only the cmd, flow_type and data
+	 * members.  User-space might still be using that
+	 * definition. */
+	if (cmd == ETHTOOL_GRXFH)
+		info_size = (offsetof(struct ethtool_rxnfc, data) +
+			     sizeof(info.data));
+
+	if (copy_from_user(&info, useraddr, info_size))
 		return -EFAULT;
 
 	if (info.cmd == ETHTOOL_GRXCLSRLALL) {
@@ -250,7 +270,7 @@ static int ethtool_get_rxnfc(struct net_
 		goto err_out;
 
 	ret = -EFAULT;
-	if (copy_to_user(useraddr, &info, sizeof(info)))
+	if (copy_to_user(useraddr, &info, info_size))
 		goto err_out;
 
 	if (rule_buf) {
@@ -1095,12 +1115,12 @@ int dev_ethtool(struct net *net, struct
 	case ETHTOOL_GRXCLSRLCNT:
 	case ETHTOOL_GRXCLSRULE:
 	case ETHTOOL_GRXCLSRLALL:
-		rc = ethtool_get_rxnfc(dev, useraddr);
+		rc = ethtool_get_rxnfc(dev, ethcmd, useraddr);
 		break;
 	case ETHTOOL_SRXFH:
 	case ETHTOOL_SRXCLSRLDEL:
 	case ETHTOOL_SRXCLSRLINS:
-		rc = ethtool_set_rxnfc(dev, useraddr);
+		rc = ethtool_set_rxnfc(dev, ethcmd, useraddr);
 		break;
 	case ETHTOOL_GGRO:
 		rc = ethtool_get_gro(dev, useraddr);


