Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab1C3HNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 03:13:42 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42855 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab1C3HNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 03:13:41 -0400
Message-ID: <17BF3847C06240EC921FB684D3120DEC@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Arnd Bergmann" <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Samuel Ortiz" <sameo@linux.intel.com>,
        <nsekhar@ti.com>, "open list" <linux-kernel@vger.kernel.org>,
        <m-watkins@ti.com>, "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "Stalin Srinivasan" <stalin.s@mistralsolutions.com>
References: <1299592667-21367-1-git-send-email-subhasish@mistralsolutions.com> <1299592667-21367-2-git-send-email-subhasish@mistralsolutions.com> <201103111628.57549.arnd@arndb.de>
In-Reply-To: <201103111628.57549.arnd@arndb.de>
Subject: Re: [PATCH v3 1/7] mfd: add pruss mfd driver.
Date: Wed, 30 Mar 2011 12:46:07 +0530
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


>> +s32 pruss_disable(struct device *dev, u8 pruss_num)
>> +{
>> + struct da8xx_pruss *pruss = dev_get_drvdata(dev->parent);
>> + struct da8xx_prusscore_regs *h_pruss;
>> + struct pruss_map *pruss_mmap = (struct pruss_map *)pruss->ioaddr;
>> + u32 temp_reg;
>> + u32 delay_cnt;
>
> Can you explain the significance of pruss_num? As far as I
> can tell, you always pass constants in here, so it should
> be possible to determine the number from the device.

SG - The number is not programmed in the device, I need something to decide 
which PRU to disable
or enable.

>> + ~DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK) |
>> + ((DA8XX_PRUCORE_CONTROL_COUNTENABLE_DISABLE <<
>> + DA8XX_PRUCORE_CONTROL_COUNTENABLE_SHIFT) &
>> + DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK);
>> + __raw_writel(temp_reg, &h_pruss->CONTROL);
>
> Better use readl/writel, the __raw_ variants are not reliable in general.

SG - Have changed this to iowrite32 and variants.


>> +
>> + /* Reset PRU0 */
>> + for (delay_cnt = 0x10000; delay_cnt > 0; delay_cnt--)
>> + __raw_writel(DA8XX_PRUCORE_CONTROL_RESETVAL,
>> + &h_pruss->CONTROL);
>
> Why do you need to reset it 65536 times? Is once not enough?

SG - I am not sure why this was done, but I have removed it now.

>> + }
>> + spin_unlock(&pruss->lock);
>
> This is almost the exact same code as for the DA8XX_PRUCORE_0 case.
> Please be a little more creative in order to avoid such code duplication.

SG - Ok, cleanup done.


>> +
>> + for (loop = 0; loop < bytestowrite; loop++)
>> + __raw_writeb(*pdatatowrite++, paddresstowrite++);
>> +
>> + return 0;
>> +}
>> +EXPORT_SYMBOL(pruss_writeb);
>
> I would recommend providing a simpler variant of your all I/O accessors,
> which write a single word. Most of the users of these simply
> pass bytestowrite=1 anyway, so the caller can become more readable.

SG - At some sections in the code I am using upto 8 bytescount.
            If its ok, I would want to keep it as is.

>
> Also, my comments about __raw_* and Marc's comments about the
> type cast apply to all of these.

SG - Changed to iowrite32 variants and also used make C=1


>> + err = mfd_add_devices(dev, 0, &cell, 1, NULL, 0);
>> + if (err) {
>> + dev_err(dev, "cannot add mfd cells\n");
>> + return err;
>> + }
>> + dev_info(dev, "mfd: added %s device\n",
>> + dev_data[count].dev_name);
>> + }
>> +
>> + return err;
>> +}
>
> This would get much simpler if you just replaced the da8xx_pruss_devices
> array with an mfd_cell array.

SG - Will do. 

