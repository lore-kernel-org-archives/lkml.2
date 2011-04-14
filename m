Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957Ab1DNSeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:34:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:37478 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553Ab1DNRpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:45:41 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Kees Cook <kees.cook@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 024/209] net: clear heap allocation for ETHTOOL_GRXCLSRLALL
Date: Thu, 14 Apr 2011 13:40:54 -0400
Message-Id: <1302803039-9400-25-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <kees.cook@canonical.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit ae6df5f96a51818d6376da5307d773baeece4014 upstream.

Calling ETHTOOL_GRXCLSRLALL with a large rule_cnt will allocate kernel
heap without clearing it. For the one driver (niu) that implements it,
it will leave the unused portion of heap unchanged and copy the full
contents back to userspace.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Acked-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/core/ethtool.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 5328c62..49a2338 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -349,7 +349,7 @@ static noinline_for_stack int ethtool_get_rxnfc(struct net_device *dev,
 	if (info.cmd == ETHTOOL_GRXCLSRLALL) {
 		if (info.rule_cnt > 0) {
 			if (info.rule_cnt <= KMALLOC_MAX_SIZE / sizeof(u32))
-				rule_buf = kmalloc(info.rule_cnt * sizeof(u32),
+				rule_buf = kzalloc(info.rule_cnt * sizeof(u32),
 						   GFP_USER);
 			if (!rule_buf)
 				return -ENOMEM;
-- 
1.7.4.4

