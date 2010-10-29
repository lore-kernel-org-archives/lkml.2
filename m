Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934194Ab0J2Qqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 12:46:48 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:10630 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757841Ab0J2Qqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 12:46:45 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXJ75kzGobGRqxN3
X-RZG-CLASS-ID: mo00
Message-ID: <4CCAFA68.2030903@hartkopp.net>
Date: Fri, 29 Oct 2010 18:46:32 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100913 Icedove/3.0.7
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        Tomoya <tomoya-linux@dsn.okisemi.com>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        Barry Song <21cnbao@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew.chih.howe.khor@intel.com,
        qi.wang@intel.com, margie.foster@intel.com, yong.y.wang@intel.com,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Fix build
 warnings
References: <4CCAA3D4.8070408@dsn.okisemi.com> <4CCAC4CD.7000503@pengutronix.de>
In-Reply-To: <4CCAC4CD.7000503@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.10.2010 14:57, Marc Kleine-Budde wrote:
> Hello,
> 
> On 10/29/2010 12:37 PM, Tomoya wrote:

>>>> If you figured out how to use the endianess conversion functions from
>>>> the cpu_to_{le,be}-{le,to}_to_cpup family use them here, too.
> 
>> Sorry, I misunderstood the spec of Topcliff CAN endianess.
>> I have understood endianess conversion is not necessary.
>> (CAN data is set as Big-Endian in Topcliff CAN register)
> 
>>> You have to change the definition of the regs struct a bit:
>>>> 	u32 if1_mcont;
>>>> 	u32 if1_data[4];
>>>> 	u32 reserve2;
>> Uh, I can't find this. Where is this ?
> 
> Here's a patch to illustrate what I meant:
> 
> diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
> index 55ec324..5ee7589 100644
> --- a/drivers/net/can/pch_can.c
> +++ b/drivers/net/can/pch_can.c
> @@ -150,10 +150,7 @@ struct pch_can_regs {
>         u32 if1_id1;
>         u32 if1_id2;
>         u32 if1_mcont;
> -       u32 if1_dataa1;
> -       u32 if1_dataa2;
> -       u32 if1_datab1;
> -       u32 if1_datab2;
> +       u32 if1_data[4];
>         u32 reserve2;
>         u32 reserve3[12];
>         u32 if2_creq;
> 

Indeed the access to the data registers does not seem to be endian aware.

See in pch_can_rx_normal():

+			cf->can_dlc = get_can_dlc((ioread32(&priv->regs->
+						   if1_mcont)) & 0xF);
+			*(u16 *)(cf->data + 0) = ioread16(&priv->regs->
+							  if1_dataa1);
+			*(u16 *)(cf->data + 2) = ioread16(&priv->regs->
+							  if1_dataa2);
+			*(u16 *)(cf->data + 4) = ioread16(&priv->regs->
+							  if1_datab1);
+			*(u16 *)(cf->data + 6) = ioread16(&priv->regs->
+							  if1_datab2);

See in pch_xmit():

+	/* Copy data to register */
+	if (cf->can_dlc > 0) {
+		u32 data1 = *((u16 *)&cf->data[0]);
+		iowrite32(data1, &priv->regs->if2_dataa1);
+	}
+	if (cf->can_dlc > 2) {
+		u32 data1 = *((u16 *)&cf->data[2]);
+		iowrite32(data1, &priv->regs->if2_dataa2);
+	}
+	if (cf->can_dlc > 4) {
+		u32 data1 = *((u16 *)&cf->data[4]);
+		iowrite32(data1, &priv->regs->if2_datab1);
+	}
+	if (cf->can_dlc > 6) {
+		u32 data1 = *((u16 *)&cf->data[6]);
+		iowrite32(data1, &priv->regs->if2_datab2);
+	}
+

It's just a question if the driver for an Intel Chipset should/could ignore
the endian problematic.

If this is intended the driver should only appear in Kconfig depending on X86
or little endian systems.

Besides this remark, the struct pch_can_regs could also be defined in a way
that every single CAN payload data byte could be accessed directly to allow
e.g. this code in pch_can_rx_normal():

cf->data[0] = ioread8(&priv->regs->if1_data0);
cf->data[1] = ioread8(&priv->regs->if1_data1);
cf->data[2] = ioread8(&priv->regs->if1_data2);
(..)
cf->data[6] = ioread8(&priv->regs->if1_data6);
cf->data[7] = ioread8(&priv->regs->if1_data7);

This is easy to understand and additionally endian aware.

In opposite to this:

+	if (cf->can_dlc > 2) {
+		u32 data1 = *((u16 *)&cf->data[2]);
+		iowrite32(data1, &priv->regs->if2_dataa2);
+	}

Which puts a little? endian u16 into the big endian register layout.
Sorry i'm just getting curious on this register access implementation.

Regards,
Oliver
