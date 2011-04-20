Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab1DTLyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 07:54:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43188 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab1DTLyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 07:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EGLg7JSUPa2F4D/CZLvWFB9YzAnVnGDH2BFQovsJLCkwKEAJOsaBcPGIUfE93NKCxv
         4tzsZo2ZuV5KpCgcUzGIWmgjgspQp0arQNLFGG/hwGVKh1DhdaIOjzuk09S8PH8wOc6c
         iCq9UQcWwUN4Gty2BJ2P4wxbNltsjS/noeKSc=
Message-ID: <4DAEC977.4020504@gmail.com>
Date: Wed, 20 Apr 2011 15:54:31 +0400
From: Igor Plyatov <plyatov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Stanislaw Gruszka <stf_xl@wp.pl>
CC: sshtylyov@mvista.com, jgarzik@pobox.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, geomatsi@gmail.com,
        nicolas.ferre@atmel.com, linux@maxim.org.za,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        christian.glindkamp@taskit.de, ryan@bluewatersys.com,
        pgsellmann@portner-elektronik.at
Subject: Re: [PATCH v2] ide: at91_ide.c bugfix for high master clock
References: <1292100326-637-1-git-send-email-plyatov@gmail.com> <20101213213549.GA2077@r2bh72.net.upc.cz> <20101216235153.GA3793@r2bh72.net.upc.cz>
In-Reply-To: <20101216235153.GA3793@r2bh72.net.upc.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stanislaw!
> On Mon, Dec 13, 2010 at 10:35:49PM +0100, Stanislaw Gruszka wrote:
>> On Sat, Dec 11, 2010 at 11:45:26PM +0300, Igor Plyatov wrote:
>>> The AT91SAM9 microcontrollers with master clock higher then 105 MHz
>>> and PIO0, have overflow of the NCS_RD_PULSE value in the MSB. This
>>> lead to "NCS_RD_PULSE" pulse longer then "NRD_CYCLE" pulse and driver
>>> does not detect IDE device.
>> The overflow happens because MSB (bit 6) is multiplied by 256.
>> NCS pulse length = 256*NCS_RD_PULSE[6] + NCS_RD_PULSE[5:0] clock
>> cycles. So NCS_RD_PULSE 0x41 gives 257 clock cycles not 65 as we
>> expected before. Static memory controller behaviour is undefined
>> when pulse length is bigger than cycle length, so things not work.
>>
>>> +	u16 ncs_rd_pulse;
>>>   	unsigned long mode = AT91_SMC_READMODE | AT91_SMC_WRITEMODE |
>>>   			     AT91_SMC_BAT_SELECT;
>>>
>>> @@ -81,19 +84,29 @@ static void set_smc_timings(const u8 chipselect, const u16 cycle,
>>>   	if (data_float)
>>>   		mode |= AT91_SMC_TDF_(data_float);
>>>
>>> +	ncs_rd_pulse = cycle;
>>> +	if (ncs_rd_pulse>  NCS_RD_PULSE_LIMIT) {
>>> +		ncs_rd_pulse = NCS_RD_PULSE_LIMIT;
>>> +		pr_warn(DRV_NAME ": ncs_rd_pulse limited to maximal value %d\n",
>>> +			ncs_rd_pulse);
>>> +	}
>> I'm fine with that fix. We can possibly still have problems with higher
>> frequencies, but I'm not sure if someone will use that hardware with
>> faster clocks.
> I looked at patch again and change mind, I'm not ok with it. EBI NCS in
> this case controls compact flash CS0, CS1 signals, so NCS pulse define
> a cycle on IDE bus. IDE cycle length can not be smaller than t0 (from
> PIO Mode Timing Diagram), otherwise we do not conform spec.
>
> IMHO what should be done in case of overflow is increase NCS pulse time
> (IDE cycle) and in consequence overall SMC cycle time. Below draw patch
> how this could be done. I do not even tried to compile it (give up with
> that since I do not have hardware to test anyway), just idea how things
> could be possibly done.
>
> diff --git a/drivers/ide/at91_ide.c b/drivers/ide/at91_ide.c
> index 000a78e..277224c 100644
> --- a/drivers/ide/at91_ide.c
> +++ b/drivers/ide/at91_ide.c
> @@ -66,9 +66,8 @@
>
>   #define leave_16bit(cs, mode) at91_sys_write(AT91_SMC_MODE(cs), mode);
>
> -static void set_smc_timings(const u8 chipselect, const u16 cycle,
> -			    const u16 setup, const u16 pulse,
> -			    const u16 data_float, int use_iordy)
> +static void set_smc_timings(const u8 chipselect, u16 cycle, u16 cs_cycle,
> +			    u16 setup, u16 pulse, u16 data_float, int use_iordy)
>   {
>   	unsigned long mode = AT91_SMC_READMODE | AT91_SMC_WRITEMODE |
>   			     AT91_SMC_BAT_SELECT;
> @@ -89,9 +88,9 @@ static void set_smc_timings(const u8 chipselect, const u16 cycle,
>   						   AT91_SMC_NRDSETUP_(setup) |
>   						   AT91_SMC_NCS_RDSETUP_(0));
>   	at91_sys_write(AT91_SMC_PULSE(chipselect), AT91_SMC_NWEPULSE_(pulse) |
> -						   AT91_SMC_NCS_WRPULSE_(cycle) |
> +						   AT91_SMC_NCS_WRPULSE_(cs_cycle) |
>   						   AT91_SMC_NRDPULSE_(pulse) |
> -						   AT91_SMC_NCS_RDPULSE_(cycle));
> +						   AT91_SMC_NCS_RDPULSE_(cs_cycle));
>   	at91_sys_write(AT91_SMC_CYCLE(chipselect), AT91_SMC_NWECYCLE_(cycle) |
>   						   AT91_SMC_NRDCYCLE_(cycle));
>   }
> @@ -106,11 +105,44 @@ static unsigned int calc_mck_cycles(unsigned int ns, unsigned int mck_hz)
>   	return (unsigned int) tmp;
>   }
>
> +/*
> + * In SMC registers values are coded in form:
> + *
> + * mul * ((val&  (limit + 1)) ? 1 : 0) + (val&  limit)
> + *
> + * where limit can be 0x1f, 0x3f or 0x7f, and  mul can be 128 or 256
> + */
> +static int code_smc_values(int *val, const int limit, const int mul)
> +{
> +	int tmp;
> +
> +	if (*val<= limit)
> +		return 0;
> +
> +	/* limit<  val<  mul */
> +	tmp = mul - *val;
> +	if (tmp>  0) {
> +		*val = limit + 1;
> +		return tmp;
> +	}
> +
> +	/* mul + limit<  val */
> +	if (WARN_ON(*val - mul>  limit)) {
> +		/* it's not possible to code that value - set max */
> +		*val = (limit + 1) | limit;
> +		return 0;
> +	}
> +
> +	/* mul<= val<= mul + limit */
> +	*val = (limit + 1) | (*val - mul);
> +	return 0;
> +}
> +
>   static void apply_timings(const u8 chipselect, const u8 pio,
>   			  const struct ide_timing *timing, int use_iordy)
>   {
>   	unsigned int t0, t1, t2, t6z;
> -	unsigned int cycle, setup, pulse, data_float;
> +	unsigned int cycle, cs_cycle, setup, pulse, data_float;
>   	unsigned int mck_hz;
>   	struct clk *mck;
>
> @@ -133,11 +165,29 @@ static void apply_timings(const u8 chipselect, const u8 pio,
>   	setup = calc_mck_cycles(t1, mck_hz);
>   	pulse = calc_mck_cycles(t2, mck_hz);
>   	data_float = calc_mck_cycles(t6z, mck_hz);
> -
> -	pdbg("cycle=%u setup=%u pulse=%u data_float=%u\n",
> -	     cycle, setup, pulse, data_float);
> -
> -	set_smc_timings(chipselect, cycle, setup, pulse, data_float, use_iordy);
> +	cs_cycle = cycle;
> +
> +	pdbg("cycle=%u cs_cycle=%u setup=%u pulse=%u data_float=%u\n",
> +	     cycle, cs_cycle, setup, pulse, data_float);
> +
> +	/* SMC use special coding scheme, see "Coding and Range of Timing
> +	 * Parameters" table from AT91SAM926x datasheets.
> +	 *
> +	 *		SETUP = 128*setup[5] + setup[4:0]
> +	 *		PULSE = 256*pulse[6] + pulse[5:0]
> +	 *		CYCLE = 256*cycle[8:7] + cycle[6:0]
> +	 */
> +	cycle += code_smc_values(&setup, 31, 128);
> +	cycle += code_smc_values(&pulse, 63, 256);
> +	/* cs_cycle is a full pulse wave, setup and hold times are 0 */
> +	cycle += code_smc_values(&cs_cycle, 63, 256);
> +	code_cmc_values(&cycle, 127, 256);
> +
> +	pdbg("cycle=0x%x cs_cycle=0x%x setup=0x%x pulse=0x%x data_float=0x%x\n",
> +	     cycle, cs_cycle, setup, pulse, data_float);
> +
> +	set_smc_timings(chipselect, cycle, cs_cycle, setup, pulse, data_float,
> +			use_iordy);
>   }
>
>   static void at91_ide_input_data(ide_drive_t *drive, struct ide_cmd *cmd,
Unfortunately, yours patch can't work correctly because it does not 
consider all details, but I understand yours idea and fix pata_at91.c 
driver.
You can look to email with "[PATCH] ATA: pata_at91.c bugfixes" subject 
for details.

Best regards!
--
Igor Plyatov
