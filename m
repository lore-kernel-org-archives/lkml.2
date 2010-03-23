Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab0CWC6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 22:58:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44500
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753359Ab0CWC6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 22:58:10 -0400
Date: Mon, 22 Mar 2010 19:58:31 -0700 (PDT)
Message-Id: <20100322.195831.233398454.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: [PATCH] via-velocity: FLOW_CNTL_RX does not disable Asymmetric
 pause in set_mii_flow_control()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BA7D22A.6080300@gmail.com>
References: <4BA7D22A.6080300@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Mon, 22 Mar 2010 21:25:14 +0100

> Asymmetric pause was not disabled in the RX case.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> I spotted this because In the FLOW_CNTL_RX and FLOW_CNTL_TX_RX
> cases the same code is executed, is the amendment below required?

The bit settings in the MII_ADVERTISE register should be:

1) RX and TX pause both requested

   set only ADVERTISE_PAUSE_CAP

2) Only TX pause requested

   set only ADVERTISE_PAUSE_ASYM

3) Only RX pause requested

   set both ADVERTISE_PAUSE_CAP and ADVERTISE_PAUSE_ASYM

4) Neither TX nor RX pause requested

   set nothing

(drivers/net/tg3.c:tg3_advert_flowctrl_1000t() is a good
 reference point)

It would be easier to compare the VIA driver with the rest of
the world if it used the standard mii.h defines instead of
it's own private ones.  That would be a good change to make at
some point.

Anyways, the correct fix is therefore something like:

diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c
index 3a486f3..bc278d4 100644
--- a/drivers/net/via-velocity.c
+++ b/drivers/net/via-velocity.c
@@ -812,7 +812,7 @@ static void set_mii_flow_control(struct velocity_info *vptr)
 
 	case FLOW_CNTL_TX_RX:
 		MII_REG_BITS_ON(ANAR_PAUSE, MII_REG_ANAR, vptr->mac_regs);
-		MII_REG_BITS_ON(ANAR_ASMDIR, MII_REG_ANAR, vptr->mac_regs);
+		MII_REG_BITS_OFF(ANAR_ASMDIR, MII_REG_ANAR, vptr->mac_regs);
 		break;
 
 	case FLOW_CNTL_DISABLE:
