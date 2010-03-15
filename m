Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936970Ab0COWUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 18:20:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39049
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936616Ab0COWUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 18:20:17 -0400
Date: Mon, 15 Mar 2010 15:20:37 -0700 (PDT)
Message-Id: <20100315.152037.32744329.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       roger.oksanen@cs.helsinki.fi
Subject: Re: [Stable-review] [19/39] e100: Use pci pool to work around
 GFP_ATOMIC order 5 memory allocation failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100315.143906.150716862.davem@davemloft.net>
References: <20100315.143225.212581877.davem@davemloft.net>
	<20100315143653.294c0650@nehalam>
	<20100315.143906.150716862.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 15 Mar 2010 14:39:06 -0700 (PDT)

> From: Stephen Hemminger <shemminger@vyatta.com>
> Date: Mon, 15 Mar 2010 14:36:53 -0700
> 
>> The kernel has both fixes in it. The customer reported that if both
>> were reverted, the kernel panic went away.
> 
> Please recheck that as your backtrace matches exactly the
> crash signature fixed by the memset().

As an update, after some auditing I found that ring parameter changes
aren't handled correctly by the PCI pool changes and that might
explain the crash.

I'll push the following fix around as soon as possible:

diff --git a/drivers/net/e100.c b/drivers/net/e100.c
index a26ccab..b997e57 100644
--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -2858,7 +2858,7 @@ static int __devinit e100_probe(struct pci_dev *pdev,
 	}
 	nic->cbs_pool = pci_pool_create(netdev->name,
 			   nic->pdev,
-			   nic->params.cbs.count * sizeof(struct cb),
+			   nic->params.cbs.max * sizeof(struct cb),
 			   sizeof(u32),
 			   0);
 	DPRINTK(PROBE, INFO, "addr 0x%llx, irq %d, MAC addr %pM\n",
