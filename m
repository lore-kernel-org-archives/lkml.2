Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab0GMIm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 04:42:58 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36172 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab0GMImy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 04:42:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6041"; a="47310681"
Message-ID: <4C3C2706.4020005@codeaurora.org>
Date: Tue, 13 Jul 2010 14:12:46 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Kevin McNeely <kev@cypress.com>, David Brown <davidb@codeaurora.org>,
        Fred <fwk@ubuntu.linuxcertified.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Simtec Linux Team <linux@simtec.co.uk>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Antonio Ospite <ospite@studenti.unina.it>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        khali@linux-fr.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] i2c: cyttsp i2c touchscreen driver init submit
References: <kev@cypress.com> <1278968210-6827-1-git-send-email-kev@cypress.com> <4C3C1654.9010204@codeaurora.org> <20100713075544.GA16013@core.coreip.homeip.net>
In-Reply-To: <20100713075544.GA16013@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/13/2010 1:25 PM, Dmitry Torokhov wrote:
> On Tue, Jul 13, 2010 at 01:01:32PM +0530, Trilok Soni wrote:
>> Hi Kevin,
>>
>> Thanks for posting this driver.
>>
>> Adding Jean Delvar for i2c bits.
>>
>> On 7/13/2010 2:26 AM, Kevin McNeely wrote:
>>> From: Fred <fwk@ubuntu.linuxcertified.com>
>>
>> E-mail id looks wrong. Do you mean fwk@cypress.com?
>>
>>>
>>> This is a new touchscreen driver for the Cypress Semiconductor
>>> cyttsp family of devices.  This driver is for the i2c version
>>> of cyttsp parts.
>>
>> Please explain in commit text which exact version of the chips this driver is supporting.
>> It is hard to make out that from this text.
>>>
>>> Signed-off-by: Kevin McNeely <kev@cypress.com>
>>> ---
>>>  drivers/input/touchscreen/Kconfig      |   13 +
>>>  drivers/input/touchscreen/Makefile     |    1 +
>>>  drivers/input/touchscreen/cyttsp-i2c.c | 2016 ++++++++++++++++++++++++++++++++
>>>  include/linux/cyttsp.h                 |  649 ++++++++++
>>
>> Please move this file to include/linux/input directory.
>>
> 
> Or even keep it in drivers/input/touchscreen/

They are having platform data structure in this header file which might be accessed from the board-xxx.c
files under mach-xxx directories of ARM like architecture.

> 
>>
>>>
>>> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
>>> index 3b9d5e2..a7a69a0 100644
>>> --- a/drivers/input/touchscreen/Kconfig
>>> +++ b/drivers/input/touchscreen/Kconfig
>>> @@ -603,4 +603,17 @@ config TOUCHSCREEN_TPS6507X
>>>  	  To compile this driver as a module, choose M here: the
>>>  	  module will be called tps6507x_ts.
>>>  
>>> +config TOUCHSCREEN_CYTTSP_I2C
>>> +	default n
>>
>> Do we need to provide this if it is no by default?
>>
>>> +	tristate "Cypress TTSP i2c touchscreen"
>>> +	depends on I2C
>>> +	help
>>> +	  Say Y here if you have a Cypress TTSP touchscreen
>>> +	  connected to your system's i2c bus.
>>
>> What is TTSP?
>>
>>> +
>>> +	  If unsure, say N.
>>> +
>>> +	  To compile this driver as a module, choose M here: the
>>> +	  module will be called cyttsp_i2c.
>>> +
>>>  endif
>>
> 
> Since there is SPI part should we prepare for the support and split
> bus-independent parts off? Are you working on SPI support?

I don't think the current patch is divided neatly to drive this chip over
multiple bus protocols.

> 
>>
>>> diff --git a/drivers/input/touchscreen/cyttsp-i2c.c b/drivers/input/touchscreen/cyttsp-i2c.c
>>> new file mode 100644
>>> index 0000000..8397aa1
>>> --- /dev/null
>>> +++ b/drivers/input/touchscreen/cyttsp-i2c.c
>>> @@ -0,0 +1,2016 @@
>>> +/* Source for:
>>> + * Cypress TrueTouch(TM) Standard Product I2C touchscreen driver.
>>> + * drivers/input/touchscreen/cyttsp-i2c.c
>>
>> No file paths please. Already commented on it by Christoph.
>>
>>> + *
>>> + * Copyright (C) 2009, 2010 Cypress Semiconductor, Inc.
>>> + *
>>> + * This program is free software; you can redistribute it and/or
>>> + * modify it under the terms of the GNU General Public License
>>> + * version 2, and only version 2, as published by the
>>> + * Free Software Foundation.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + *
>>> + * You should have received a copy of the GNU General Public License along
>>> + * with this program; if not, write to the Free Software Foundation, Inc.,
>>> + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
>>> + *
>>> + * Cypress reserves the right to make changes without further notice
>>> + * to the materials described herein. Cypress does not assume any
>>> + * liability arising out of the application described herein.
>>> + *
>>> + * Contact Cypress Semiconductor at www.cypress.com
>>
>> I would like Dmitry to comment on it. Dmitry?
>>
> 
> Not a lwayer but I do not really see an issue here. It is still GPL and
> they as copyright holders obviously can modify the code. What exactly
> troubles you here?

No issue from my side too.

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
