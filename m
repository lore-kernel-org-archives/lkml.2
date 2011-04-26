Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab1DZGiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 02:38:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54123 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab1DZGiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 02:38:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mYnrpEcj36Qzk/a2R+SWLVAUOY3857hLK7Le7bSWYIA/hcH8IjpHGL39OfMu/B4pvT
         2PROx3fBzr1GoWz0F///tKeZlWdmjpig2zjimGUmEghYR6WDdDrT8ZXjKhIIfLOGbpA/
         XkKvKqdxBx4nAJ1fWWtFCydzYz9VDPWW3PMZA=
Message-ID: <4DB6684C.7050505@gmail.com>
Date: Tue, 26 Apr 2011 10:38:04 +0400
From: Igor Plyatov <plyatov@gmail.com>
Reply-To: plyatov@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Stanislaw Gruszka <stf_xl@wp.pl>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ATA: pata_at91.c bugfixes
References: <1303299877-12088-1-git-send-email-plyatov@gmail.com> <20110423093623.GA3410@localhost.localdomain>
In-Reply-To: <20110423093623.GA3410@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stanislaw!

Thank you for patch review!

> Hi Igor
>
> On Wed, Apr 20, 2011 at 03:44:37PM +0400, Igor Plyatov wrote:
>> * Fix "initial_timing" structure initialisation. The "struct ata_timing" must
>>    contain 10 members, but ".dmack_hold" member was not initialised.
>> * The AT91SAM9 microcontrollers use special coding scheme for SMC_SETUP,
>>    SMC_PULSE, SMC_CYCLE registers.
>>    Old driver operates correctly only with low master clock values, but
>>    with high master clock it incorrectly calculates SMC values and stops
>>    to operate, because SMC can be setup only to admissible ranges in special
>>    format.
>>    New code correctly calculates SMC registers values, adjusts calculated
>>    to admissible ranges, enlarges cycles if required and converts values
>>    into SMC's format.
>> * Old driver calculates CS_SETUP and CS_PULSE cycles incorrectly
>>    because of wrong assumptions.
>>    New code calculates:
>>        CS_SETUP = SETUP/2
> If you to this, then {RD,WR}_SETUP have to be equal SETUP + SETUP/2
> to generate proper setup (t0) time on IDE bus. I think the best way is
> set CS_SETUP and CS_HOLD to 0 (what your code do if SETUP and HOLD<=1),
> but to do this you need to take care of data float (t6z)

Why so?

This is not clear for me. Maybe we talk about different things or I have 
wrong
understanding of ATA timings.
Can you please look at "Standard Read Cycle" for AT91SAM9 MCU
http://www.kicad.ru/files/AT91SAM9G20%20bus%20timing.pdf
, CompactFlash connection schematic
http://www.kicad.ru/files/CF%20for%20AT91SAM9%20(True%20IDE%20mode).pdf
and comment my thoughts?

Here is a legend for "Standard Read Cycle" timing diagram.
------------------------------------------------------------------------------
Read (NRD) signal parameters:
* t0 = cycle = NRD_CYCLE
* t1 = setup = NRD_SETUP
* t2 = pulse = NRD_PULSE
* t9 = hold = NRD_HOLD

Chip Select (NCS) signal parameters:
* cs_setup = NCS_RD_SETUP
* cs_pulse = NCS_RD_PULSE
* cs_cycle = cycle

Notes:
* The NCS_RD_CYCLE is equal to the NRD_CYCLE for AT91SAM9, because they
   start/finish simultaneously (HW related).
* The NCS signal is not the same as CS1, CS2 ATA signals! It used only to
   enable data bus transceiver U2.

So NCS parameters calculated as
     cs_setup = setup/2
     cs_pulse = pulse + setup/2 + hold/2 = (pulse + cycle)/2
>> +static const struct ata_timing initial_timing = {
>> +	.mode		= XFER_PIO_0,
>> +	.setup		= 70,
>> +	.act8b		= 290,
>> +	.rec8b		= 240,
>> +	.cyc8b		= 600,
>> +	.active		= 165,
>> +	.recover	= 150,
>> +	.dmack_hold	= 0,
>> +	.cycle		= 600,
>> +	.udma		= 0
>> +};
> Is this really needed, why not use ata_timing_find_mode(XFER_PIO_0)?

OK. Fixed.

>> +static int adjust_smc_value(unsigned int *value, int *prange,
>> +				unsigned int size)
>> +{
>> +	unsigned char i;
>> +	int remainder;
>> +
>> +	for (i = 0; i<  size; i = i + 2) {
>> +		if (*value<  prange[i]) {
>> +			remainder = prange[i] - *value;
>> +			*value = prange[i]; /* nearest valid value */
>> +			return remainder;
>> +		}
>> +		else if ((prange[i]<= *value)&&  (*value<= prange[i+1])) {
>> +			return 0;
>> +		}
>> +	}
>> +	*value = prange[size - 1]; /* assign maximal possible value */
>> +
>> +	return -1; /* invalid value */
>> +}
> [snip]
>> +static void calc_smc_vals(struct device *dev,
>> +				unsigned int *setup, unsigned int *cs_setup,
>> +				unsigned int *pulse, unsigned int *cs_pulse,
>> +				unsigned int *cycle)
>> +{
>> +	int ret_val;
>> +	int cs_hold;
>> +	int range_setup[] = {	/* SMC_SETUP valid ranges */
>> +		0, 31,		/* first  range */
>> +		128, 159,	/* second range */
>> +	};
>> +	int range_pulse[] = {	/* SMC_PULSE valid ranges */
>> +		0, 63,		/* first  range */
>> +		256, 319,	/* second range */
>> +	};
>> +	int range_cycle[] = {	/* SMC_CYCLE valid ranges */
>> +		0, 127,		/* first  range */
>> +		256, 383,	/* second range */
>> +		512, 639,	/* third  range */
>> +		768, 895,	/* fourth range */
>> +	};
> Introducing helper structure like
>
> struct smc_range {
> 	u16 min, max;
> };
>
> would be a bit cleaner way of coding that (hint: ARRAY_SIZE could be used
> instead of sizeof then)
OK. Fixed.
>> -	dev_dbg(dev, "ATA timings: nrd_setup = %lu nrd_pulse = %lu nrd_cycle = %lu\n",
>> -			nrd_setup, nrd_pulse, read_cycle);
>> -	dev_dbg(dev, "ATA timings: nwe_setup = %lu nwe_pulse = %lu nwe_cycle = %lu\n",
>> -			nwe_setup, nwe_pulse, write_cycle);
>> -	dev_dbg(dev, "ATA timings: ncs_read_setup = %lu ncs_read_pulse = %lu\n",
>> -			ncs_read_setup, ncs_read_pulse);
>> -	dev_dbg(dev, "ATA timings: ncs_write_setup = %lu ncs_write_pulse = %lu\n",
>> -			ncs_write_setup, ncs_write_pulse);
> It's worth to have some debugging prints to check if values are calculated
> properly.

They exists already in the calc_smc_vals() function, but now I move them 
to set_smc_timing().

> Thanks
> Stanislaw
Best regards!
-- 
Igor Plyatov

