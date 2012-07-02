Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab2GBH2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 03:28:25 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:60962 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432Ab2GBH2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 03:28:23 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q627Rfvr001784
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1340966060-2749-1-git-send-email-hayeswang@realtek.com> <1340966060-2749-2-git-send-email-hayeswang@realtek.com> <20120629135111.GB8560@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH net-next 2/2] r8169: support RTL8168G
Date: Mon, 2 Jul 2012 15:27:57 +0800
Message-ID: <8D19B009F8C6423C8E87D4D85B851AF9@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac1V/8ZACUMQqME0R+C2xpzZIyhmawCHoNng
In-Reply-To: <20120629135111.GB8560@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
> > +static void r8168_phy_ocp_write(void __iomem *ioaddr, u32 
> reg, u32 data)
> > +{
> > +	int i;
> > +
> > +	if (reg & 0xffff0001)
> > +		BUG();
> 
> The patch adds a lot of BUG(). BUG is terrible from a system 
> or end user
> viewpoint.
> 
> Were they only a devel helper or are they still supposed to be of use
> in the future ? If the latter applies, why ?
> 

I think if the reg is invalid, there must be something wrong. The code should
have bug, and I should notice develper or someone using the code. I would
replace them with showing messages.

[...]
> > +static void rtl_ocp_write_fw(struct rtl8169_private *tp, 
> struct rtl_fw *rtl_fw)
> > +{
> > +	struct rtl_fw_phy_action *pa = &rtl_fw->phy_action;
> > +	void __iomem *ioaddr = tp->mmio_addr;
> > +	u32 predata, count;
> > +	u32 base_addr;
> > +	size_t index;
> > +
> > +	predata = count = 0;
> > +	base_addr = 0xa400;
> > +
> > +	for (index = 0; index < pa->size; ) {
> > +		u32 action = le32_to_cpu(pa->code[index]);
> > +		u32 data = action & 0x0000ffff;
> > +		u32 regno = (action & 0x0fff0000) >> 16;
> > +
> > +		if (!action)
> > +			break;
> > +
> > +		switch(action & 0xf0000000) {
> > +		case PHY_READ:
> > +			predata = r8168_phy_ocp_read(ioaddr,
> > +					base_addr + (regno -16) * 2);
> > +			count++;
> > +			index++;
> > +			break;
> [duplicated code removed]
> > +		case PHY_WRITE:
> > +			if (regno == 0x1f)
> > +				base_addr = data << 4;
> > +			else
> > +				r8168_phy_ocp_write(ioaddr,
> > +						base_addr + 
> (regno - 0x10) * 2,
> > +						data);
> > +			index++;
> > +			break;
> [duplicated code removed]
> > +		case PHY_WRITE_PREVIOUS:
> > +			r8168_phy_ocp_write(ioaddr, base_addr + 
> (regno -16) * 2,
> > +					    predata);
> > +			index++;
> > +			break;
> 
> I can't believe that the hardware people have designed something which
> needs a different firmware write method, especially as it 
> copies at lot
> of code.
> 
> How did you come to the conclusion that it was not possible 
> to hide this
> stuff behind r8168g_mdio_{read / write} ?
> 
> I would not mind replacing the 
> PHY_{READ/WRITE/WRITE_PREVIOUS} case with
> chipset specific {READ/WRITE/WRITE_PREVIOUS} methods as long as the
> semantic looks the same but going through a different 
> (*write_fw) does not
> trivially seem to be the best abstraction.
> 

The difficulty is how to deal with the base_addr. Although it should not happen,
the base_addr may be modify if two threads access phy at the same time.  I would
replace the method by saving the base_addr with a global variable. Then, the
r8168g_mdio functions could deal with both of the firmware and phy settings.

[...]
> > +static void __devinit rtl_hw_initialize(struct rtl8169_private *tp)
> > +{
> > +	switch (tp->mac_version) {
> > +	case RTL_GIGA_MAC_VER_40:
> > +	case RTL_GIGA_MAC_VER_41:
> > +		rtl_hw_init_8168g(tp);
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +}
> 
> Why doesn't it belong to hw_start ?
> 

According to the initialization process from our hardware, there are something
needed to do before reset. Maybe this considers the rebooting from the other OS
or hwardware behavior.  I don't sure if it is safe, to let them belong to
hw_start.

> Is it completely unneeded if the device requires a rtl8169_hw_reset,
> resumes or such ?
>

By the information from our hardware, these are the initial settings and only
need be done once. 

Best Regards,
Hayes

