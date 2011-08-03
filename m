Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab1HCX2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:28:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33728 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932118Ab1HCX2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:28:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:47 2011
Message-Id: <20110803221246.917881526@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:00:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [029/102] ethtool: Allow zero-length register dumps again
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit 67ae7cf1eeda777f79259c4c6cb17a0bd28dee71 upstream.

Some drivers (ab)use the ethtool_ops::get_regs operation to expose
only a hardware revision ID.  Commit
a77f5db361ed9953b5b749353ea2c7fed2bf8d93 ('ethtool: Allocate register
dump buffer with vmalloc()') had the side-effect of breaking these, as
vmalloc() returns a null pointer for size=0 whereas kmalloc() did not.

For backward-compatibility, allow zero-length dumps again.

Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/ethtool.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1227,7 +1227,7 @@ static int ethtool_get_regs(struct net_d
 		regs.len = reglen;
 
 	regbuf = vzalloc(reglen);
-	if (!regbuf)
+	if (reglen && !regbuf)
 		return -ENOMEM;
 
 	ops->get_regs(dev, &regs, regbuf);
@@ -1236,7 +1236,7 @@ static int ethtool_get_regs(struct net_d
 	if (copy_to_user(useraddr, &regs, sizeof(regs)))
 		goto out;
 	useraddr += offsetof(struct ethtool_regs, data);
-	if (copy_to_user(useraddr, regbuf, regs.len))
+	if (regbuf && copy_to_user(useraddr, regbuf, regs.len))
 		goto out;
 	ret = 0;
 


