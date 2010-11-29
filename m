Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab0K2CLJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 21:11:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46519
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754096Ab0K2CLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 21:11:08 -0500
Date: Sun, 28 Nov 2010 18:11:34 -0800 (PST)
Message-Id: <20101128.181134.104049260.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, peppe.cavallaro@st.com
Subject: Re: linux-next: build failure after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101129110824.639b2659.sfr@canb.auug.org.au>
References: <20101129110824.639b2659.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 29 Nov 2010 11:08:24 +1100

> Hi all,
> 
> After merging the net tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/net/stmmac/stmmac_main.c: In function 'stmmac_resume':
> drivers/net/stmmac/stmmac_main.c:1849: error: 'struct stmmac_priv' has no member named 'shutdown'
> 
> Caused by commit 874bd42d24c2a74f5dbd65e81e175982240fecd8 ("stmmac:
> convert to dev_pm_ops").
> 
> I have used the net tree from next-20101126 for today.

I have pushed the following fix which should cure this:

--------------------
stmmac: fix stmmac_resume removing not yet used shutdown flag

The commit to convert to use the dev_pm_ops struct
introduces a bug. The shutdown flag is not yet used
because the hibernation on memory is done by using
the freeze callback.
Thanks to Vlad for having reported it.

Reported-by: Vlad Lungu <vlad.lungu@windriver.com>
Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/stmmac/stmmac_main.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/net/stmmac/stmmac_main.c b/drivers/net/stmmac/stmmac_main.c
index f1dbc18..730a6fd 100644
--- a/drivers/net/stmmac/stmmac_main.c
+++ b/drivers/net/stmmac/stmmac_main.c
@@ -1846,13 +1846,6 @@ static int stmmac_resume(struct device *dev)
 	if (!netif_running(ndev))
 		return 0;
 
-	if (priv->shutdown) {
-		/* Re-open the interface and re-init the MAC/DMA
-		   and the rings (i.e. on hibernation stage) */
-		stmmac_open(dev);
-		return 0;
-	}
-
 	spin_lock(&priv->lock);
 
 	/* Power Down bit, into the PM register, is cleared
-- 
1.7.3.2

