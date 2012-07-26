Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab2GZTGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 15:06:00 -0400
Received: from canardo.mork.no ([148.122.252.1]:47192 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab2GZTF7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 15:05:59 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: <wei_wang@realsil.com.cn>
Cc: <gregkh@linuxfoundation.org>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] drivers/misc: Add realtek pci card reader driver
Organization: m
References: <1343185364-8241-1-git-send-email-wei_wang@realsil.com.cn>
Date: Thu, 26 Jul 2012 21:05:38 +0200
In-Reply-To: <1343185364-8241-1-git-send-email-wei_wang@realsil.com.cn> (wei
	wang's message of "Wed, 25 Jul 2012 11:02:44 +0800")
Message-ID: <87y5m6jqbh.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<wei_wang@realsil.com.cn> writes:

> +static bool msi_en = 1;
> +module_param(msi_en, bool, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(msi_en, "Enable MSI");
> +
> +static bool adma_mode = 1;
> +module_param(adma_mode, bool, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(adma_mode, "ADMA Mode");

Why would I want to disable these features?  And what if I have two
devices and want different settings for them?


> +int rtsx_pci_read_register(struct rtsx_pdev *pdev, u16 addr, u8 *data)
> +{
> +	u32 val = 2 << 30;
> +	int i;
> +
> +	if (data)
> +		*data = 0;

Why would anyone want to call this function with a NULL pointer?

> +
> +	val |= (u32)(addr & 0x3FFF) << 16;
> +	rtsx_pci_writel(pdev, RTSX_HAIMR, val);
> +
> +	for (i = 0; i < MAX_RW_REG_CNT; i++) {
> +		val = rtsx_pci_readl(pdev, RTSX_HAIMR);
> +		if ((val & (1 << 31)) == 0)
> +			break;
> +	}
> +
> +	if (i >= MAX_RW_REG_CNT)
> +		return -ETIMEDOUT;
> +
> +	if (data)
> +		*data = (u8)(val & 0xFF);

And even if they did, why do go through the read and then check again?
Register reading side effects?  Would be nice if that was mentioned in a
comment. 

> +		pr_debug("SG table count = %d\n", pdev->sgi);

dev_dbg here and many other places, maybe?  Always nice to see which
device is spitting out such messages.
> +	BUG_ON(!buf || (buf_len <= 0));

OK?  And then I do what? Give you a call?

> +	pr_info("%s: pdev->msi_en = %d, pci->irq = %d\n",
> +			__func__, pdev->msi_en, pdev->pci->irq);

Same as for the debugging:  dev_info is nicer.

> +		pr_err("rtsx_sdmmc: unable to grab IRQ %d, disabling device\n",
> +				pdev->pci->irq);


Likewise for other levels.

> +static unsigned char get_card_type(u32 card_status)
> +{
> +	unsigned char type = 0;
> +
> +	switch (card_status) {
> +	case XD_EXIST:
> +		type = RTSX_TYPE_XD;
> +		break;
> +
> +	case MS_EXIST:
> +		type = RTSX_TYPE_MS;
> +		break;
> +
> +	case SD_EXIST:
> +		type = RTSX_TYPE_SD;
> +		break;
> +
> +	default:
> +		type = 0;
> +		break;

Seems a bit redundant given that you initialized it to 0.

> +static u32 get_card_status(unsigned char type)
> +{
> +	u32 card_status = 0;
> +
> +	switch (type) {
> +	case RTSX_TYPE_XD:
> +		card_status = XD_EXIST;
> +		break;
> +
> +	case RTSX_TYPE_MS:
> +		card_status = MS_EXIST;
> +		break;
> +
> +	case RTSX_TYPE_SD:
> +		card_status = SD_EXIST;
> +		break;
> +
> +	default:
> +		card_status = 0;
> +		break;

Same as above.

> +static int rtsx_pci_extra_init_hw(struct rtsx_pdev *pdev)
> +{
> +	pr_warn("%s\n", __func__);
> +	return 0;
> +}
> +
> +static int rtsx_pci_optimize_phy(struct rtsx_pdev *pdev)
> +{
> +	pr_warn("%s\n", __func__);
> +	return 0;
> +}
> +
> +static void rtsx_pci_turn_on_led(struct rtsx_pdev *pdev)
> +{
> +	pr_warn("%s\n", __func__);
> +}
> +
> +static void rtsx_pci_turn_off_led(struct rtsx_pdev *pdev)
> +{
> +	pr_warn("%s\n", __func__);
> +}
> +
> +static void rtsx_pci_enable_auto_blink(struct rtsx_pdev *pdev)
> +{
> +	pr_warn("%s\n", __func__);
> +}
> +
> +static void rtsx_pci_disable_auto_blink(struct rtsx_pdev *pdev)
> +{
> +	pr_warn("%s\n", __func__);
> +}

Can all these stubs really be necessary?  


> +static void rtsx_pci_init_ops(struct rtsx_pdev *pdev)
> +{
> +	switch (PCI_PID(pdev)) {
> +	case 0x5209:
> +		pr_info("Initialize 0x5209\n");
> +		pdev->ops.extra_init_hw = rts5209_extra_init_hw;
> +		pdev->ops.optimize_phy = rts5209_optimize_phy;
> +		pdev->ops.turn_on_led = rts5209_turn_on_led;
> +		pdev->ops.turn_off_led = rts5209_turn_off_led;
> +		pdev->ops.enable_auto_blink = rts5209_enable_auto_blink;
> +		pdev->ops.disable_auto_blink = rts5209_disable_auto_blink;
> +		break;
> +
> +	case 0x5229:
> +		pr_info("Initialize 0x5229\n");
> +		pdev->ops.extra_init_hw = rts5229_extra_init_hw;
> +		pdev->ops.optimize_phy = rts5229_optimize_phy;
> +		pdev->ops.turn_on_led = rts5229_turn_on_led;
> +		pdev->ops.turn_off_led = rts5229_turn_off_led;
> +		pdev->ops.enable_auto_blink = rts5229_enable_auto_blink;
> +		pdev->ops.disable_auto_blink = rts5229_disable_auto_blink;
> +		break;
> +
> +	default:
> +		pr_warn("Initialize dummy ops\n");
> +		pdev->ops.extra_init_hw = rtsx_pci_extra_init_hw;
> +		pdev->ops.optimize_phy = rtsx_pci_optimize_phy;
> +		pdev->ops.turn_on_led = rtsx_pci_turn_on_led;
> +		pdev->ops.turn_off_led = rtsx_pci_turn_off_led;
> +		pdev->ops.enable_auto_blink = rtsx_pci_enable_auto_blink;
> +		pdev->ops.disable_auto_blink = rtsx_pci_disable_auto_blink;
> +	}

Maybe three static "pdev_ops" structs, and make pdev->ops a pointer?


> +static int rtsx_pci_init_hw(struct rtsx_pdev *pdev)
> +{
> +	int err;
> +
> +	rtsx_pci_writel(pdev, RTSX_HCBAR, pdev->host_cmds_addr);
> +
> +	rtsx_pci_enable_bus_int(pdev);
> +
> +	/* Power on SSC */
> +	err = rtsx_pci_write_register(pdev, FPDCTL, SSC_POWER_DOWN, 0);
> +	if (err < 0)
> +		return err;
> +
> +	udelay(200);

Why?  Yes, I can guess but it's always nice to have a small comment
documenting why you insert such things.  In particular how the timeout
was selected.  Is this based on a datasheet recommendation, or just some
guesstimate?


> +
> +	err = pdev->ops.optimize_phy(pdev);
> +	if (err < 0)
> +		return err;


Is there any chance this would fail because the poweron timeout was too
short?  If so, then maybe you should wait and retry?

> +static int __init rtsx_pci_drv_init(void)
> +{
> +	pr_info(DRV_NAME ": Realtek PCI-E Card Reader adapter driver\n");

This is unnecessary noise.

> +	for (i = 0xFDA0; i <= 0xFDAE; i++)
> +		rtsx_pci_add_cmd(pdev, READ_REG_CMD, i, 0, 0);
> +	for (i = 0xFD52; i <= 0xFD69; i++)
> +		rtsx_pci_add_cmd(pdev, READ_REG_CMD, i, 0, 0);

These constants look like magic to me.  Maybe add a comment or use a
macro to give them a describing name?

> +	rtsx_pci_send_cmd(pdev, 100);
> +
> +	ptr = rtsx_pci_get_cmd_data(pdev);
> +	for (i = 0xFDA0; i <= 0xFDAE; i++)
> +		pr_debug("0x%04X: 0x%02x\n", i, *(ptr++));
> +	for (i = 0xFD52; i <= 0xFD69; i++)
> +		pr_debug("0x%04X: 0x%02x\n", i, *(ptr++));

And they are repeated, so macros would help avoiding errors in any case.

> +static int sd_wait_voltage_stable_1(struct rtsx_pdev *pdev)
> +{
> +	int err;
> +	u8 stat;
> +
> +	mdelay(1);

Another timeout needing explanation.

> +
> +	/* SD_CMD, SD_DAT3~0 should be drived to low by card;
> +	 * If either one of SD_CMD,SD_DAT3~0 is not low,
> +	 * abort the voltage switch sequence;
> +	 */
> +	err = rtsx_pci_read_register(pdev, SD_BUS_STAT, &stat);
> +	if (err < 0)
> +		return err;
> +
> +	if (stat & (SD_CMD_STATUS | SD_DAT3_STATUS | SD_DAT2_STATUS |
> +				SD_DAT1_STATUS | SD_DAT0_STATUS))
> +		return -EINVAL;
> +
> +	/* Stop toggle SD clock */
> +	err = rtsx_pci_write_register(pdev, SD_BUS_STAT,
> +			0xFF, SD_CLK_FORCE_STOP);
> +	if (err < 0)
> +		return err;
> +
> +	return 0;
> +}
> +
> +static int sd_wait_voltage_stable_2(struct rtsx_pdev *pdev)
> +{
> +	int err;
> +	u8 stat, mask, val;
> +
> +	wait_timeout(50);

And another one.


> +
> +	/* Toggle SD clock again */
> +	err = rtsx_pci_write_register(pdev, SD_BUS_STAT,
> +			0xFF, SD_CLK_TOGGLE_EN);
> +	if (err < 0)
> +		return err;
> +
> +	wait_timeout(10);

And one more.  I realize that this may be obviously correct to anyone
understanding what's going on here, but you need to write this so that
*I* can understand it :-)

> +	if (CHK_PCI_PID(pdev, 0x5209))
> +		ldo_off = 0x06;
> +	else
> +		ldo_off = 0x00;

Hmm, I didn't expect any pid checks here.  Could this deserve a field in
the device struct so that it could be set up at init time, or would that
be a waste?

> +static int pci_sdmmc_send_cmd_get_rsp(struct rtsx_adapter *adapter, u8 cmd_idx,
> +		u32 arg, unsigned int resp_type, u32 *resp)
> +{
> +	struct rtsx_pdev *pdev = dev_get_drvdata(adapter->dev.parent);
> +	int err = 0;
> +	int timeout = 100;
> +	int i;
> +	u8 *ptr;
> +	int stat_idx = 0;
> +	u8 rsp_type;
> +	int rsp_len = 5;
> +
> +	BUG_ON(!resp);

Yuck!

Just a few random comments from your random reader.  Use it as you
like. I didn't really read it all. It's a huge driver...




Bjørn
