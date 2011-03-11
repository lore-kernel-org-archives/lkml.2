Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab1CKP3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:29:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63030 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab1CKP3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:29:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/7] mfd: add pruss mfd driver.
Date: Fri, 11 Mar 2011 16:28:57 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        sachi@mistralsolutions.com, Samuel Ortiz <sameo@linux.intel.com>,
        nsekhar@ti.com, open list <linux-kernel@vger.kernel.org>,
        m-watkins@ti.com, "Marc Kleine-Budde" <mkl@pengutronix.de>
References: <1299592667-21367-1-git-send-email-subhasish@mistralsolutions.com> <1299592667-21367-2-git-send-email-subhasish@mistralsolutions.com>
In-Reply-To: <1299592667-21367-2-git-send-email-subhasish@mistralsolutions.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103111628.57549.arnd@arndb.de>
X-Provags-ID: V02:K0:fofbctvDyajQiWMz9WaqDTuYYOZQeghFuxYyVXct1w0
 572b+FOj1cfQkmv6zm0x7tqmxqRsh++zKKfxR75V5D+QHc3heV
 ohxlQvQfqzby6gWFOtc6wdQt49PHBZ9G9K6tQiMigc48FVuSrx
 e9s+h66HPjUv0n76hUbWG53l0SNtFWDeEApokMfPM5RsaaeJeM
 NVnobz6Ln526BToefw4dA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 March 2011, Subhasish Ghosh wrote:

> +struct da8xx_pruss {
> +	struct device *dev;
> +	spinlock_t lock;
> +	struct resource *res;
> +	struct clk *clk;
> +	u32 clk_freq;
> +	void __iomem *ioaddr;
> +};

> +s32 pruss_disable(struct device *dev, u8 pruss_num)
> +{
> +	struct da8xx_pruss *pruss = dev_get_drvdata(dev->parent);
> +	struct da8xx_prusscore_regs *h_pruss;
> +	struct pruss_map *pruss_mmap = (struct pruss_map *)pruss->ioaddr;
> +	u32 temp_reg;
> +	u32 delay_cnt;

Can you explain the significance of pruss_num? As far as I
can tell, you always pass constants in here, so it should
be possible to determine the number from the device.

> +	if ((pruss_num != DA8XX_PRUCORE_0) && (pruss_num != DA8XX_PRUCORE_1))
> +		return -EINVAL;
> +
> +	spin_lock(&pruss->lock);
> +	if (pruss_num == DA8XX_PRUCORE_0) {
> +		/* pruss deinit */
> +		__raw_writel(0xFFFFFFFF, (PRUSS_INTC_STATCLRINT0 & 0xFFFF));
> +		/* Disable PRU0  */
> +		h_pruss = (struct da8xx_prusscore_regs *)
> +			&pruss_mmap->core[DA8XX_PRUCORE_0];
> +
> +		temp_reg = __raw_readl(&h_pruss->CONTROL);
> +		temp_reg = (temp_reg &
> +				~DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK) |
> +				((DA8XX_PRUCORE_CONTROL_COUNTENABLE_DISABLE <<
> +				DA8XX_PRUCORE_CONTROL_COUNTENABLE_SHIFT) &
> +				DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK);
> +		__raw_writel(temp_reg, &h_pruss->CONTROL);

Better use readl/writel, the __raw_ variants are not reliable in general.

> +		for (delay_cnt = 0x10000; delay_cnt > 0; delay_cnt--) {
> +
> +			temp_reg = __raw_readl(&h_pruss->CONTROL);
> +			temp_reg = (temp_reg &
> +				~DA8XX_PRUCORE_CONTROL_ENABLE_MASK) |
> +				((DA8XX_PRUCORE_CONTROL_ENABLE_DISABLE <<
> +				DA8XX_PRUCORE_CONTROL_ENABLE_SHIFT) &
> +				DA8XX_PRUCORE_CONTROL_ENABLE_MASK);
> +			__raw_writel(temp_reg, &h_pruss->CONTROL);
> +		}
> +
> +		/* Reset PRU0 */
> +		for (delay_cnt = 0x10000; delay_cnt > 0; delay_cnt--)
> +			__raw_writel(DA8XX_PRUCORE_CONTROL_RESETVAL,
> +					&h_pruss->CONTROL);

Why do you need to reset it 65536 times? Is once not enough?

> +	} else if (pruss_num == DA8XX_PRUCORE_1) {
> +		/* pruss deinit */
> +		__raw_writel(0xFFFFFFFF, (PRUSS_INTC_STATCLRINT1 & 0xFFFF));
> +		/* Disable PRU1 */
> +		h_pruss = (struct da8xx_prusscore_regs *)
> +			&pruss_mmap->core[DA8XX_PRUCORE_1];
> +		temp_reg = __raw_readl(&h_pruss->CONTROL);
> +		temp_reg = (temp_reg &
> +				~DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK) |
> +				((DA8XX_PRUCORE_CONTROL_COUNTENABLE_DISABLE <<
> +				DA8XX_PRUCORE_CONTROL_COUNTENABLE_SHIFT) &
> +				DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK);
> +		__raw_writel(temp_reg, &h_pruss->CONTROL);
> +
> +		for (delay_cnt = 0x10000; delay_cnt > 0; delay_cnt--) {
> +
> +			temp_reg = __raw_readl(&h_pruss->CONTROL);
> +			temp_reg = (temp_reg &
> +				~DA8XX_PRUCORE_CONTROL_ENABLE_MASK) |
> +				((DA8XX_PRUCORE_CONTROL_ENABLE_DISABLE <<
> +				DA8XX_PRUCORE_CONTROL_ENABLE_SHIFT) &
> +				DA8XX_PRUCORE_CONTROL_ENABLE_MASK);
> +			__raw_writel(temp_reg, &h_pruss->CONTROL);
> +		}
> +
> +		/* Reset PRU1 */
> +		for (delay_cnt = 0x10000; delay_cnt > 0; delay_cnt--)
> +			__raw_writel(DA8XX_PRUCORE_CONTROL_RESETVAL,
> +							&h_pruss->CONTROL);
> +	}
> +	spin_unlock(&pruss->lock);

This is almost the exact same code as for the DA8XX_PRUCORE_0 case.
Please be a little more creative in order to avoid such code duplication.

> +	return 0;
> +}
> +EXPORT_SYMBOL(pruss_disable);

EXPORT_SYMBOL_GPL, please. Also for the other symbols.

> +s32 pruss_writeb(struct device *dev, u32 offset,
> +		u8 *pdatatowrite, u16 bytestowrite)
> +{
> +	struct da8xx_pruss *pruss = dev_get_drvdata(dev->parent);
> +	u8 *paddresstowrite;
> +	u16 loop;
> +	offset = (u32)pruss->ioaddr + offset;
> +	paddresstowrite = (u8 *) (offset);
> +
> +	for (loop = 0; loop < bytestowrite; loop++)
> +		__raw_writeb(*pdatatowrite++, paddresstowrite++);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(pruss_writeb);

I would recommend providing a simpler variant of your all I/O accessors,
which write a single word. Most of the users of these simply
pass bytestowrite=1 anyway, so the caller can become more readable.

Also, my comments about __raw_* and Marc's comments about the
type cast apply to all of these.

> +static int pruss_mfd_add_devices(struct platform_device *pdev)
> +{
> +	struct da8xx_pruss_devices *dev_data = pdev->dev.platform_data;
> +	struct device *dev = &pdev->dev;
> +	struct mfd_cell cell;
> +	u32 err, count;
> +
> +	for (count = 0; dev_data[count].dev_name != NULL; count++) {
> +		memset(&cell, 0, sizeof(struct mfd_cell));
> +		cell.id			= count;
> +		cell.name		= dev_data[count].dev_name;
> +		cell.platform_data	= dev_data[count].pdata;
> +		cell.data_size		= dev_data[count].pdata_size;
> +		cell.resources		= dev_data[count].resources;
> +		cell.num_resources	= dev_data[count].num_resources;
> +
> +		err = mfd_add_devices(dev, 0, &cell, 1, NULL, 0);
> +		if (err) {
> +			dev_err(dev, "cannot add mfd cells\n");
> +			return err;
> +		}
> +		dev_info(dev, "mfd: added %s device\n",
> +				dev_data[count].dev_name);
> +	}
> +
> +	return err;
> +}

This would get much simpler if you just replaced the da8xx_pruss_devices
array with an mfd_cell array.

	Arnd
