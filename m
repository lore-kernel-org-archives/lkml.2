Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab2FMHry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 03:47:54 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:39977
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752245Ab2FMHrv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 03:47:51 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: -8
X-BigFish: VPS-8(zz98dI9371I542M1432Izz1202hzz8275bh8275dhz2dh2a8h668h839h944hd25hf0ah)
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Ben Dooks <ben-linux@fluff.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>
Date: Wed, 13 Jun 2012 03:47:25 -0400
Subject: RE: [PATCH 3/8] i2c: i2c-bfin-twi: Break dead waiting loop if i2c
 device misbehaves.
Thread-Topic: [PATCH 3/8] i2c: i2c-bfin-twi: Break dead waiting loop if i2c
 device misbehaves.
Thread-Index: Ac1H755vXGoS5lZGS2SrSQSC1PP/WwBSPJHA
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D17023632CA4@NWD2CMBX1.ad.analog.com>
References: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
 <1337152826-9850-3-git-send-email-sonic.zhang@analog.com>
 <20120611163044.GD3887@pengutronix.de>
In-Reply-To: <20120611163044.GD3887@pengutronix.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Wolfram Sang [mailto:w.sang@pengutronix.de]
>Sent: Tuesday, June 12, 2012 12:31 AM
>To: Zhang, Sonic
>Cc: Ben Dooks; linux-i2c@vger.kernel.org; LKML; uclinux-dist-
>devel@blackfin.uclinux.org
>Subject: Re: [PATCH 3/8] i2c: i2c-bfin-twi: Break dead waiting loop if i2c device
>misbehaves.
>
>On Wed, May 16, 2012 at 03:20:21PM +0800, sonic.zhang@analog.com wrote:
>> From: Sonic Zhang <sonic.zhang@analog.com>
>>
>> Some fault i2c device may hold the sda/scl line and cause i2c driver
>> wait in the BUS busy loop. This patch breaks this potential dead loop.
>>
>> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>>
>> git-svn-id: svn://localhost/svn/linux-kernel/trunk@9291
>> 526b6c2d-f592-4532-a319-5dd88ccb003d
>
>^
>
>> ---
>>  drivers/i2c/busses/i2c-bfin-twi.c |   14 ++++++++++++--
>>  1 files changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-bfin-twi.c
>> b/drivers/i2c/busses/i2c-bfin-twi.c
>> index 376e331..4abaf59 100644
>> --- a/drivers/i2c/busses/i2c-bfin-twi.c
>> +++ b/drivers/i2c/busses/i2c-bfin-twi.c
>> @@ -294,6 +294,8 @@ static irqreturn_t bfin_twi_interrupt_entry(int irq, void
>*dev_id)
>>      return IRQ_HANDLED;
>>  }
>>
>> +#define BFIN_TWI_BUSY_TIMEOUT       1000
>> +
>
>Please use a unit like microseconds for the timeout.
>

Take a look at the I2C framework code again. I find this loop to poll BUSBUSY bit is not necessary. Just return -EAGAIN, the framework do retry before timeout already.

Regards,

Sonic


>>  /*
>>   * One i2c master transfer
>>   */
>> @@ -303,12 +305,16 @@ static int bfin_twi_do_master_xfer(struct i2c_adapter
>*adap,
>>      struct bfin_twi_iface *iface = adap->algo_data;
>>      struct i2c_msg *pmsg;
>>      int rc = 0;
>> +    unsigned int busy_timeout = BFIN_TWI_BUSY_TIMEOUT;
>>
>>      if (!(read_CONTROL(iface) & TWI_ENA))
>>              return -ENXIO;
>>
>> -    while (read_MASTER_STAT(iface) & BUSBUSY)
>> +    while (read_MASTER_STAT(iface) & BUSBUSY) {
>> +            if (--busy_timeout == 0)
>> +                    return -EBUSY;
>>              yield();
>> +    }
>>
>>      iface->pmsg = msgs;
>>      iface->msg_num = num;
>> @@ -403,12 +409,16 @@ int bfin_twi_do_smbus_xfer(struct i2c_adapter
>> *adap, u16 addr,  {
>>      struct bfin_twi_iface *iface = adap->algo_data;
>>      int rc = 0;
>> +    unsigned int busy_timeout = BFIN_TWI_BUSY_TIMEOUT;
>>
>>      if (!(read_CONTROL(iface) & TWI_ENA))
>>              return -ENXIO;
>>
>> -    while (read_MASTER_STAT(iface) & BUSBUSY)
>> +    while (read_MASTER_STAT(iface) & BUSBUSY) {
>> +            if (--busy_timeout == 0)
>> +                    return -EBUSY;
>>              yield();
>> +    }
>>
>>      iface->writeNum = 0;
>>      iface->readNum = 0;
>> --
>> 1.7.0.4
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-i2c"
>> in the body of a message to majordomo@vger.kernel.org More majordomo
>> info at  http://vger.kernel.org/majordomo-info.html
>
>--
>Pengutronix e.K.                           | Wolfram Sang                |
>Industrial Linux Solutions                 | http://www.pengutronix.de/  |

