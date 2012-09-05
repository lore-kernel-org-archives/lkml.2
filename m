Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551Ab2IEVa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:30:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44829 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab2IEVa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:30:26 -0400
Date: Wed, 05 Sep 2012 17:30:23 -0400 (EDT)
Message-Id: <20120905.173023.2235590074897156746.davem@davemloft.net>
To: nicolas.ferre@atmel.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        havard@skinnemoen.net, plagnioj@jcrosoft.com, jamie@jamieiles.com,
        linux-kernel@vger.kernel.org, patrice.vilchez@atmel.com
Subject: Re: [PATCH 04/10] net/macb: Fix a race in macb_start_xmit()
From: David Miller <davem@davemloft.net>
In-Reply-To: <40f02ee50a29aaec6c949432a1bcf09f4b027181.1346775479.git.nicolas.ferre@atmel.com>
References: <cover.1346775479.git.nicolas.ferre@atmel.com>
	<40f02ee50a29aaec6c949432a1bcf09f4b027181.1346775479.git.nicolas.ferre@atmel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Wed, 5 Sep 2012 10:19:11 +0200

> From: Havard Skinnemoen <havard@skinnemoen.net>
> 
> Fix a race in macb_start_xmit() where we unconditionally set the TSTART bit.
> If an underrun just happened (we do this with interrupts disabled, so it might
> not have been handled yet), the controller starts transmitting from the first
> entry in the ring, which is usually wrong.
> Restart the controller after error handling.
> 
> Signed-off-by: Havard Skinnemoen <havard@skinnemoen.net>
> [nicolas.ferre@atmel.com: split patch in topics]
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Accumulating special case code and checks into the hot path of TX packet
processing is extremely unwise.

Instead, when you handle the TX error conditions and reset the chip you
should first ensure that there are no flows of control in the transmit
function of your driver by using the appropriate locking et al. facilities.

For example, you can quiesce the transmit path by handling the chip error
interrupt as follows:

1) Disable chip interrupt generation.

2) Schedule a workqueue so you can process the reset outside of hard
   interrupt context.

3) In the workqueue function, disable NAPI and perform a
   netif_tx_disable() to guarentee there are no threads of
   execution trying to queue up packets for TX into the driver.

4) Perform your chip reset and whatever else is necessary.

5) Re-enable NAPI and TX.

Then you don't need any special checks in your xmit method at all.


