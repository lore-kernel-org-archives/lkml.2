Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab2HVFwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:52:50 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:49080 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754081Ab2HVFws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:52:48 -0400
Message-ID: <503473A9.4060805@ti.com>
Date: Wed, 22 Aug 2012 11:22:41 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: balbi@ti.com
CC: spi-devel-general@lists.sourceforge.net, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] spi: omap2-mcspi: Remove the macro MOD_REG_BIT
References: <1345529864-7937-1-git-send-email-shubhrajyoti@ti.com> <1345529864-7937-3-git-send-email-shubhrajyoti@ti.com> <20120821090508.GC10347@arwen.pp.htv.fi>
In-Reply-To: <20120821090508.GC10347@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,
Thanks for the review

On Tuesday 21 August 2012 02:35 PM, Felipe Balbi wrote:
> On Tue, Aug 21, 2012 at 11:47:43AM +0530, Shubhrajyoti D wrote:
>> Remove the macro MOD_REG_BIT instead make the bit field modifications
>> directly. This deletes a branch operation in cases where the the set
>> is predecided.While at it optimise two sequential bit clear in one step.
>                ^^
> 	       you need a space here, besides you can add the ack below
Will fix that and resend.
>> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
>
>> ---
>>  drivers/spi/spi-omap2-mcspi.c |   28 ++++++++++++++--------------
>>  1 files changed, 14 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
>> index dd887eb..5642111 100644
>> --- a/drivers/spi/spi-omap2-mcspi.c
>> +++ b/drivers/spi/spi-omap2-mcspi.c
>> @@ -140,13 +140,6 @@ struct omap2_mcspi_cs {
>>  	u32			chconf0;
>>  };
>>  
>> -#define MOD_REG_BIT(val, mask, set) do { \
>> -	if (set) \
>> -		val |= mask; \
>> -	else \
>> -		val &= ~mask; \
>> -} while (0)
>> -
>>  static inline void mcspi_write_reg(struct spi_master *master,
>>  		int idx, u32 val)
>>  {
>> @@ -205,7 +198,11 @@ static void omap2_mcspi_set_dma_req(const struct spi_device *spi,
>>  	else
>>  		rw = OMAP2_MCSPI_CHCONF_DMAW;
>>  
>> -	MOD_REG_BIT(l, rw, enable);
>> +	if (enable)
>> +		l |= rw;
>> +	else
>> +		l &= ~rw;
>> +
>>  	mcspi_write_chconf0(spi, l);
>>  }
>>  
>> @@ -224,7 +221,11 @@ static void omap2_mcspi_force_cs(struct spi_device *spi, int cs_active)
>>  	u32 l;
>>  
>>  	l = mcspi_cached_chconf0(spi);
>> -	MOD_REG_BIT(l, OMAP2_MCSPI_CHCONF_FORCE, cs_active);
>> +	if (cs_active)
>> +		l |= OMAP2_MCSPI_CHCONF_FORCE;
>> +	else
>> +		l &= ~OMAP2_MCSPI_CHCONF_FORCE;
>> +
>>  	mcspi_write_chconf0(spi, l);
>>  }
>>  
>> @@ -239,9 +240,8 @@ static void omap2_mcspi_set_master_mode(struct spi_master *master)
>>  	 * to single-channel master mode
>>  	 */
>>  	l = mcspi_read_reg(master, OMAP2_MCSPI_MODULCTRL);
>> -	MOD_REG_BIT(l, OMAP2_MCSPI_MODULCTRL_STEST, 0);
>> -	MOD_REG_BIT(l, OMAP2_MCSPI_MODULCTRL_MS, 0);
>> -	MOD_REG_BIT(l, OMAP2_MCSPI_MODULCTRL_SINGLE, 1);
>> +	l &= ~(OMAP2_MCSPI_MODULCTRL_STEST | OMAP2_MCSPI_MODULCTRL_MS);
>> +	l |= OMAP2_MCSPI_MODULCTRL_SINGLE;
>>  	mcspi_write_reg(master, OMAP2_MCSPI_MODULCTRL, l);
>>  
>>  	ctx->modulctrl = l;
>> @@ -1276,9 +1276,9 @@ static int omap2_mcspi_resume(struct device *dev)
>>  			 * We need to toggle CS state for OMAP take this
>>  			 * change in account.
>>  			 */
>> -			MOD_REG_BIT(cs->chconf0, OMAP2_MCSPI_CHCONF_FORCE, 1);
>> +			cs->chconf0 |= OMAP2_MCSPI_CHCONF_FORCE;
>>  			__raw_writel(cs->chconf0, cs->base + OMAP2_MCSPI_CHCONF0);
>> -			MOD_REG_BIT(cs->chconf0, OMAP2_MCSPI_CHCONF_FORCE, 0);
>> +			cs->chconf0 &= ~OMAP2_MCSPI_CHCONF_FORCE;
>>  			__raw_writel(cs->chconf0, cs->base + OMAP2_MCSPI_CHCONF0);
>>  		}
>>  	}
>> -- 
>> 1.7.5.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

