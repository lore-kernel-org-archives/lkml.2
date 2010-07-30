Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826Ab0G3RSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:18:43 -0400
Received: from kroah.org ([198.145.64.141]:51582 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757613Ab0G3RSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:18:37 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:04 2010
Message-Id: <20100730171504.873941483@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:14:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [057/165] ethtool: Fix potential kernel buffer overflow in ETHTOOL_GRXCLSRLALL
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit db048b69037e7fa6a7d9e95a1271a50dc08ae233 upstream.

On a 32-bit machine, info.rule_cnt >= 0x40000000 leads to integer
overflow and the buffer may be smaller than needed.  Since
ETHTOOL_GRXCLSRLALL is unprivileged, this can presumably be used for at
least denial of service.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/ethtool.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -244,8 +244,9 @@ static int ethtool_get_rxnfc(struct net_
 
 	if (info.cmd == ETHTOOL_GRXCLSRLALL) {
 		if (info.rule_cnt > 0) {
-			rule_buf = kmalloc(info.rule_cnt * sizeof(u32),
-					   GFP_USER);
+			if (info.rule_cnt <= KMALLOC_MAX_SIZE / sizeof(u32))
+				rule_buf = kmalloc(info.rule_cnt * sizeof(u32),
+						   GFP_USER);
 			if (!rule_buf)
 				return -ENOMEM;
 		}


