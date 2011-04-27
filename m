Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab1D0GjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 02:39:13 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54432 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab1D0GjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 02:39:11 -0400
Message-ID: <EDC1056430EF4DA8A0D850CE1DEA28FC@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Samuel Ortiz" <sameo@linux.intel.com>,
        <nsekhar@ti.com>, "open list" <linux-kernel@vger.kernel.org>,
        <m-watkins@ti.com>, <linux-arm-kernel@lists.infradead.org>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <1303474109-6212-2-git-send-email-subhasish@mistralsolutions.com> <4DB1A603.2090208@pengutronix.de>
In-Reply-To: <4DB1A603.2090208@pengutronix.de>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver.
Date: Wed, 27 Apr 2011 12:09:47 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,


- Is it ok to have u32 etc for __iomem cookie ?

> +
> +s32 pruss_disable(struct device *dev, u8 pruss_num)
make it a int function

SG -- Ok will do

> +
> +	/* Reset PRU */
> +	iowrite32(PRUCORE_CONTROL_RESETVAL,
> +				&h_pruss->control);
> +	spin_unlock(&pruss->lock);
> +
> +	return 0;

make it a void function?

SG -- This should be int, in case of invalid pru num, we ret an error.


> +}
> +EXPORT_SYMBOL_GPL(pruss_disable);
> +
> +s32 pruss_enable(struct device *dev, u8 pruss_num)
int?

SG -- Ok will do


> +
> +	if ((pruss_num != PRUCORE_0) && (pruss_num != PRUCORE_1))
> +		return -EINVAL;
> +
> +	h_pruss = &pruss_mmap->core[pruss_num];
> +
> +	/* Reset PRU  */
> +	spin_lock(&pruss->lock);
> +	iowrite32(PRUCORE_CONTROL_RESETVAL, &h_pruss->control);

no need to lock the ram reset below?

SG -- I don't think its required. We just reset the RAM during init and 
since each pru can only be attached to only one device, the access
        will be already serialized based upon the pru num.


> +	/* Reset any garbage in the ram */
> +	if (pruss_num == PRUCORE_0)
> +		for (i = 0; i < PRUSS_PRU0_RAM_SZ; i++)
> +			iowrite32(0x0, &pruss_mmap->dram0[i]);
> +	else if (pruss_num == PRUCORE_1)
> +		for (i = 0; i < PRUSS_PRU1_RAM_SZ; i++)
> +			iowrite32(0x0, &pruss_mmap->dram1[i]);
if you make a array for these
+struct pruss_map {
+	u8 dram0[512];
+	u8 res1[7680];

+	u8 dram1[512];
+	u8 res2[7680];
..}
you don't need the if..else..

SG - The dram/iram is not contiguous, there is a reserved space in between, 
how do I declare an array for it.


> +/* Load the specified PRU with code */
> +s32 pruss_load(struct device *dev, u8 pruss_num,
> +			u32 *pruss_code, u32 code_size_in_words)
> +{
> +	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
> +	struct pruss_map __iomem *pruss_mmap = pruss->ioaddr;
> +	u32 __iomem *pruss_iram;
> +	u32 i;
> +
> +	if (pruss_num == PRUCORE_0)
> +		pruss_iram = (u32 __iomem *)&pruss_mmap->iram0;
> +	else if (pruss_num == PRUCORE_1)
> +		pruss_iram = (u32 __iomem *)&pruss_mmap->iram1;
> +	else
same here

SG - same here.


> +s32 pruss_run(struct device *dev, u8 pruss_num)
int?

SG - Ok, Will do.


> +	while (cnt--) {
> +		temp_reg = ioread32(&h_pruss->control);
> +		if (((temp_reg & PRUCORE_CONTROL_RUNSTATE_MASK) >>
> +				PRUCORE_CONTROL_RUNSTATE_SHIFT) ==
> +				PRUCORE_CONTROL_RUNSTATE_HALT)
> +			break;
how long might this take? what about some delay, sleep, or reschedule?

SG - This does not take more than 10 to 20 counts,


> +s32 pruss_writeb(struct device *dev, u32 offset, u8 pdatatowrite)
> +{
> +	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
> +	void __iomem *paddresstowrite;
we usually don't use "p" variable names for pointers

SG - Ok, will remove.


> +s32 pruss_rmwb(struct device *dev, u32 offset, u8 mask, u8 val)
void function?

SG - Ok, will do.

> +
> +s32 pruss_readb(struct device *dev, u32 offset, u8 *pdatatoread)
void?

SG - Ok, will do.

> +{
> +	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
> +	void __iomem *paddresstoread;
> +
> +	paddresstoread = pruss->ioaddr + offset ;
> +	*pdatatoread = ioread8(paddresstoread);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pruss_readb);
> +
> +s32 pruss_readb_multi(struct device *dev, u32 offset,
> +		u8 *pdatatoread, u16 bytestoread)
viod?

SG - Ok, will do.

> +{
> +	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
> +	u8 __iomem *paddresstoread;
> +	u16 i;
int?

SG - Ok, will do.



> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pruss_readb_multi);
> +
> +s32 pruss_writel(struct device *dev, u32 offset,
> +		u32 pdatatowrite)
void?

SG - Ok, will do.


> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pruss_writel);
> +
> +s32 pruss_writel_multi(struct device *dev, u32 offset,
> +		u32 *pdatatowrite, u16 wordstowrite)
void?

SG - Ok, will do.

> +{
> +	struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
> +	u32 __iomem *paddresstowrite;
> +	u16 i;
> +
> +	paddresstowrite = pruss->ioaddr + offset;
> +
> +	for (i = 0; i < wordstowrite; i++)
> +		iowrite32(*pdatatowrite++, paddresstowrite++);
memcopy_to_iomem?

SG -- I did not understand, could you please elaborate.


> +
> +s32 pruss_rmwl(struct device *dev, u32 offset, u32 mask, u32 val)
void?

SG - Ok, will do.


> +}
> +EXPORT_SYMBOL_GPL(pruss_rmwl);
> +
> +s32 pruss_readl(struct device *dev, u32 offset, u32 *pdatatoread)
void? or return the read value

SG - Ok, will do.

 

