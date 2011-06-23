Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab1FWEDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 00:03:44 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41654 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab1FWEDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 00:03:43 -0400
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com> <1308794413-11069-2-git-send-email-dirk.brandewie@gmail.com> <BANLkTin9Ouf76VEFRam+eo=H7Gw3Tv6OLA@mail.gmail.com> <4E02BA68.2010108@gmail.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <4E02BA68.2010108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 01/11] spi-dw: expose platform data stucture.
From: "glikely@secretlab.ca" <grant.likely@secretlab.ca>
Date: Wed, 22 Jun 2011 22:03:31 -0600
To: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Message-ID: <127d80e7-0bb6-4961-891e-2ab791ac6368@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dirk Brandewie <dirk.brandewie@gmail.com> wrote:

>On 06/22/2011 08:47 PM, Grant Likely wrote:
>> On Wed, Jun 22, 2011 at 8:00 PM,<dirk.brandewie@gmail.com>  wrote:
>>> From: Dirk Brandewie<dirk.brandewie@gmail.com>
>>>
>>> Expose the platform data structure for use by client drivers. ATM
>>> there are not any in-tree drivers using the driver (that I can
>>> find). This patch exposes the platform data needed for client
>drivers.
>>
>> ?  Why would client drivers want to muck with this configuration?  I
>> can understand the dw_spi driver being able to have per-spi_device
>> configuration, but spi_drivers absolutely should not have visibility
>> into bus-specific details.  Am I misunderstanding something.
>>
>
>Most of these config options don't need to be client configurable IMHO
>but they 
>are being used ATM by drivers that aren't upstream and the current
>controller 
>driver uses them.  This patch is to give a smooth transition
>(bisectable) to my 
>change that reworks the core message and transfer handling code.
>
>This allows me to provide patches to the developers of the out of tree
>drivers 
>that should be coming in RSN and exposes the interface they are using
>now.

My question still stands. Are you expecting spi_driver code to manipulate this data?

g.

>
>--Dirk
>> g.
>>
>>>
>>> Signed-off-by: Dirk Brandewie<dirk.brandewie@gmail.com>
>>> ---
>>>   drivers/spi/spi-dw.c       |    3 ---
>>>   drivers/spi/spi-dw.h       |   18 +-----------------
>>>   include/linux/spi/spi-dw.h |   42
>++++++++++++++++++++++++++++++++++++++++++
>>>   3 files changed, 43 insertions(+), 20 deletions(-)
>>>   create mode 100644 include/linux/spi/spi-dw.h
>>>
>>> diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
>>> index ece5f69..61f7ed8 100644
>>> --- a/drivers/spi/spi-dw.c
>>> +++ b/drivers/spi/spi-dw.c
>>> @@ -38,9 +38,6 @@
>>>   #define QUEUE_RUNNING  0
>>>   #define QUEUE_STOPPED  1
>>>
>>> -#define MRST_SPI_DEASSERT      0
>>> -#define MRST_SPI_ASSERT                1
>>> -
>>>   /* Slave spi_dev related */
>>>   struct chip_data {
>>>         u16 cr0;
>>> diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
>>> index 7a5e78d..92bee30 100644
>>> --- a/drivers/spi/spi-dw.h
>>> +++ b/drivers/spi/spi-dw.h
>>> @@ -3,6 +3,7 @@
>>>
>>>   #include<linux/io.h>
>>>   #include<linux/scatterlist.h>
>>> +#include<linux/spi/spi-dw.h>
>>>
>>>   /* Bit fields in CTRLR0 */
>>>   #define SPI_DFS_OFFSET                 0
>>> @@ -49,11 +50,6 @@
>>>   /* TX RX interrupt level threshold, max can be 256 */
>>>   #define SPI_INT_THRESHOLD              32
>>>
>>> -enum dw_ssi_type {
>>> -       SSI_MOTO_SPI = 0,
>>> -       SSI_TI_SSP,
>>> -       SSI_NS_MICROWIRE,
>>> -};
>>>
>>>   struct dw_spi_reg {
>>>         u32     ctrl0;
>>> @@ -208,18 +204,6 @@ static inline void spi_umask_intr(struct dw_spi
>*dws, u32 mask)
>>>         dw_writel(dws, imr, new_mask);
>>>   }
>>>
>>> -/*
>>> - * Each SPI slave device to work with dw_api controller should
>>> - * has such a structure claiming its working mode (PIO/DMA etc),
>>> - * which can be save in the "controller_data" member of the
>>> - * struct spi_device
>>> - */
>>> -struct dw_spi_chip {
>>> -       u8 poll_mode;   /* 0 for contoller polling mode */
>>> -       u8 type;        /* SPI/SSP/Micrwire */
>>> -       u8 enable_dma;
>>> -       void (*cs_control)(u32 command);
>>> -};
>>>
>>>   extern int dw_spi_add_host(struct dw_spi *dws);
>>>   extern void dw_spi_remove_host(struct dw_spi *dws);
>>> diff --git a/include/linux/spi/spi-dw.h b/include/linux/spi/spi-dw.h
>>> new file mode 100644
>>> index 0000000..787b154
>>> --- /dev/null
>>> +++ b/include/linux/spi/spi-dw.h
>>> @@ -0,0 +1,42 @@
>>> +/*
>>> + *
>>> + * Copyright (c) 2009, Intel Corporation.
>>> + *
>>> + * This program is free software; you can redistribute it and/or
>modify it
>>> + * under the terms and conditions of the GNU General Public
>License,
>>> + * version 2, as published by the Free Software Foundation.
>>> + *
>>> + * This program is distributed in the hope it will be useful, but
>WITHOUT
>>> + * ANY WARRANTY; without even the implied warranty of
>MERCHANTABILITY or
>>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
>License for
>>> + * more details.
>>> + *
>>> + * You should have received a copy of the GNU General Public
>License along with
>>> + * this program; if not, write to the Free Software Foundation,
>Inc.,
>>> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
>>> + */
>>> +
>>> +#ifndef _SPI_DW_H_
>>> +#define _SPI_DW_H_
>>> +enum spi_dw_ssi_type {
>>> +       SSI_MOTO_SPI = 0,
>>> +       SSI_TI_SSP,
>>> +       SSI_NS_MICROWIRE,
>>> +};
>>> +
>>> +#define MRST_SPI_DEASSERT      0
>>> +#define MRST_SPI_ASSERT                1
>>> +
>>> +/*
>>> + * Each SPI slave device to work with dw_api controller should
>>> + * has such a structure claiming its working mode (PIO/DMA etc),
>>> + * which can be save in the "controller_data" member of the
>>> + * struct spi_device
>>> + */
>>> +struct spi_dw_chip {
>>> +       u8 poll_mode;   /* 0 for contoller polling mode */
>>> +       u8 type;        /* SPI/SSP/Micrwire */
>>> +       u8 enable_dma;
>>> +       void (*cs_control)(u32 command);
>>> +};
>>> +#endif
>>> --
>>> 1.7.3.4
>>>
>>>
>>>
>------------------------------------------------------------------------------
>>> Simplify data backup and recovery for your virtual environment with
>vRanger.
>>> Installation's a snap, and flexible recovery options mean your data
>is safe,
>>> secure and there when you need it. Data protection magic?
>>> Nope - It's vRanger. Get your free trial download today.
>>> http://p.sf.net/sfu/quest-sfdev2dev
>>> _______________________________________________
>>> spi-devel-general mailing list
>>> spi-devel-general@lists.sourceforge.net
>>> https://lists.sourceforge.net/lists/listinfo/spi-devel-general
>>>
>>
>>
>>

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
