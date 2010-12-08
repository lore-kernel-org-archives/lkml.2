Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab0LHCT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:19:27 -0500
Received: from kroah.org ([198.145.64.141]:45862 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755748Ab0LHAqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:46:36 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:25 2010
Message-Id: <20101208004425.374723072@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kees Cook <kees.cook@canonical.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [010/127] net: clear heap allocation for ETHTOOL_GRXCLSRLALL
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kees Cook <kees.cook@canonical.com>

commit ae6df5f96a51818d6376da5307d773baeece4014 upstream.

Calling ETHTOOL_GRXCLSRLALL with a large rule_cnt will allocate kernel
heap without clearing it. For the one driver (niu) that implements it,
it will leave the unused portion of heap unchanged and copy the full
contents back to userspace.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Acked-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/ethtool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -265,7 +265,7 @@ static int ethtool_get_rxnfc(struct net_
 	if (info.cmd == ETHTOOL_GRXCLSRLALL) {
 		if (info.rule_cnt > 0) {
 			if (info.rule_cnt <= KMALLOC_MAX_SIZE / sizeof(u32))
-				rule_buf = kmalloc(info.rule_cnt * sizeof(u32),
+				rule_buf = kzalloc(info.rule_cnt * sizeof(u32),
 						   GFP_USER);
 			if (!rule_buf)
 				return -ENOMEM;


