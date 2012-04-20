Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab2DTIzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 04:55:00 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56538 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2DTIy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 04:54:56 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6686"; a="181108316"
X-IronPort-AV: E=Sophos;i="4.75,449,1330934400"; 
   d="scan'208";a="222559025"
From: "Huang, Xiong" <xiong@qca.qualcomm.com>
To: Florian Fainelli <florian@openwrt.org>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>
Subject: RE: [PATCH 2/9] atl1c: refine phy-register read/write function
Thread-Topic: [PATCH 2/9] atl1c: refine phy-register read/write function
Thread-Index: AQHNHr0u2PdNtLhrSUGSTYd0whhOZpajyZqA//+MLUA=
Date: Fri, 20 Apr 2012 08:54:54 +0000
Message-ID: <157393863283F442885425D2C454285623D5A948@nasanexd02a.na.qualcomm.com>
References: <1334902584-15584-1-git-send-email-xiong@qca.qualcomm.com>
 <1334902584-15584-3-git-send-email-xiong@qca.qualcomm.com>
 <4F9112F1.1030403@openwrt.org>
In-Reply-To: <4F9112F1.1030403@openwrt.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.39.5]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3K8tDJ3002431



> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
> On Behalf Of Florian Fainelli
> Sent: Friday, April 20, 2012 15:41
> To: Huang, Xiong
> Cc: davem@davemloft.net; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; qca-linux-team; nic-devel
> Subject: Re: [PATCH 2/9] atl1c: refine phy-register read/write function
> 
> Hi Xiong,
> 
> Le 04/20/12 08:16, xiong a Ã©crit :
> > phy register is read/write via MDIO control module --- that module
> > will be affected by the hibernate status, to access phy regs in hib
> > stutus, slow frequency clk must be selected.
> > To access phy extension register, the MDIO related registers are
> > refined/updated, a _core function is re-wroted for both regular PHY
> > regs and extension regs.
> > existing PHY r/w function is revised based on the _core.
> > PHY extension registers will be used for the comming patches.
> >
> > Signed-off-by: xiong<xiong@qca.qualcomm.com>
> > Tested-by: Liu David<dwliu@qca.qualcomm.com>
> > ---
> >   drivers/net/ethernet/atheros/atl1c/atl1c_hw.c   |  178
> +++++++++++++++++++----
> >   drivers/net/ethernet/atheros/atl1c/atl1c_hw.h   |   64 +++++---
> >   drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    4 +-
> >   3 files changed, 189 insertions(+), 57 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
> > b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
> > index bd1667c..6cbe78a 100644
> > --- a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
> > +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
> > @@ -277,65 +277,181 @@ void atl1c_hash_set(struct atl1c_hw *hw, u32
> hash_value)
> >   	AT_WRITE_REG_ARRAY(hw, REG_RX_HASH_TABLE, hash_reg, mta);
> >   }
> >
> > +
> > +void atl1c_stop_phy_polling(struct atl1c_hw *hw) {
> > +	u32 val;
> > +	int i;
> > +
> > +	if (hw->ctrl_flags&  ATL1C_FPGA_VERSION) {
> > +		AT_WRITE_REG(hw, REG_MDIO_CTRL, 0);
> > +		for (i = 0; i<  MDIO_MAX_AC_TO; i++) {
> > +			AT_READ_REG(hw, REG_MDIO_CTRL,&val);
> > +			if (0 == (val&  MDIO_CTRL_BUSY))
> > +				break;
> > +			udelay(10);
> > +		}
> > +	}
> > +}
> 
> Please reduce the identation by doing this:
> 
> if (!(hw->ctrl_flags & ALT1C_FPAG_VERSION))
> 	return;
> 
> that makes it much more readable.


No problem


> > +
> > +void atl1c_start_phy_polling(struct atl1c_hw *hw, u16 clk_sel) {
> > +	u32 val;
> > +	int i;
> > +
> > +	if (hw->ctrl_flags&  ATL1C_FPGA_VERSION) {
> > +		val = MDIO_CTRL_SPRES_PRMBL |
> > +			FIELDX(MDIO_CTRL_CLK_SEL, clk_sel) |
> > +			FIELDX(MDIO_CTRL_REG, 1) |
> > +			MDIO_CTRL_START |
> > +			MDIO_CTRL_OP_READ;
> > +		AT_WRITE_REG(hw, REG_MDIO_CTRL, val);
> > +		for (i = 0; i<  MDIO_MAX_AC_TO; i++) {
> > +			AT_READ_REG(hw, REG_MDIO_CTRL,&val);
> > +			if (0 == (val&  MDIO_CTRL_BUSY))
> > +				break;
> > +			udelay(10);
> > +		}
> > +		val |= MDIO_CTRL_AP_EN;
> > +		val&= ~MDIO_CTRL_START;
> > +		AT_WRITE_REG(hw, REG_MDIO_CTRL, val);
> > +		udelay(30);
> > +	}
> > +}
> 
> Seems like the for() busy-checking of the register could use their own function
> since it is used both in : atl1c_stop_phy_polling() and atl1c_start_phy_polling().
> 

Good suggestion. I will update.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
