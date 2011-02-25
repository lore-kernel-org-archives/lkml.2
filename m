Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab1BYSMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:12:49 -0500
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:39383 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755790Ab1BYSMr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:12:47 -0500
From: Philip Rakity <prakity@marvell.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jae hoon Chung <jh80.chung@gmail.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 25 Feb 2011 10:12:35 -0800
Subject: Re: [PATCH] sdhci: always use max timeout for xfers
Thread-Topic: [PATCH] sdhci: always use max timeout for xfers
Thread-Index: AcvVF5ShqvPSUiw7TLKhw9sJ+n6PYw==
Message-ID: <9C437661-BFCC-4F73-989E-06589E0D37CA@marvell.com>
References: <D8739074-546D-4531-A8E9-23E9F7A33EB5@marvell.com>
 <20110225180248.GA15491@pengutronix.de>
In-Reply-To: <20110225180248.GA15491@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 25, 2011, at 10:02 AM, Wolfram Sang wrote:

> Hi Philip,
> 
> On Fri, Feb 25, 2011 at 09:54:35AM -0800, Philip Rakity wrote:
>> Rather then special case busy etc .. lets just use the max value.  
> 
> OK.
> 
>> 
>> Did not remove BROKEN_TIMEOUT QUIRK so existing code will compile
>> we can remove this once existing platform drivers delete usage and get
>> quirk back.
> 
> If we wait for that, we'll probably wait till eternity ;) I'd vote that
> removing the quirk should be part of the patch.

I concur (see below)

> 
>> 
>> Patch starts after ====
>> =====
> 
> The usual nomenclature is that such comments simply go between '---' and the
> diffstat. Most tools are prepared for this...
> 
>> The card/host controller may sometimes return a value that is
>> too low and cause the h/w to timeout a transfer that would have
>> worked.  Using the maximum value avoids this.
>> 
>> Signed-off-by: Philip Rakity <prakity@marvell.com>
>> ---
> 
> ... to handle them here.
> 
>> drivers/mmc/host/sdhci.c |   48 ++++-----------------------------------------
>> 1 files changed, 5 insertions(+), 43 deletions(-)
>> 
>> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
>> index 655617c..dd99da8 100644
>> --- a/drivers/mmc/host/sdhci.c
>> +++ b/drivers/mmc/host/sdhci.c
>> @@ -592,53 +592,15 @@ static void sdhci_adma_table_post(struct sdhci_host *host,
>> 		data->sg_len, direction);
>> }
>> 
>> -static u8 sdhci_calc_timeout(struct sdhci_host *host, struct mmc_data *data)
>> +static inline u8 sdhci_calc_timeout(void)
>> {
>> -	u8 count;
>> -	unsigned target_timeout, current_timeout;
>> -
>> 	/*
>> -	 * If the host controller provides us with an incorrect timeout
>> -	 * value, just skip the check and use 0xE.  The hardware may take
>> +	 * The host controller/card can provide us with an incorrect timeout
>> +	 * value, just use the maximum value 0xE.  The hardware may take
>> 	 * longer to time out, but that's much better than having a too-short
>> 	 * timeout value.
>> 	 */
>> -	if (host->quirks & SDHCI_QUIRK_BROKEN_TIMEOUT_VAL)
>> -		return 0xE;
>> -
>> -	/* timeout in us */
>> -	target_timeout = data->timeout_ns / 1000 +
>> -		data->timeout_clks / host->clock;
>> -
>> -	if (host->quirks & SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK)
>> -		host->timeout_clk = host->clock / 1000;
> 
> This quirk could go then as well?

I am all for that -- did not want to touch other drivers but will remove for sdhci-pxa if
patch is okay.  

> 
>> -
>> -	/*
>> -	 * Figure out needed cycles.
>> -	 * We do this in steps in order to fit inside a 32 bit int.
>> -	 * The first step is the minimum timeout, which will have a
>> -	 * minimum resolution of 6 bits:
>> -	 * (1) 2^13*1000 > 2^22,
>> -	 * (2) host->timeout_clk < 2^16
>> -	 *     =>
>> -	 *     (1) / (2) > 2^6
>> -	 */
>> -	count = 0;
>> -	current_timeout = (1 << 13) * 1000 / host->timeout_clk;
>> -	while (current_timeout < target_timeout) {
>> -		count++;
>> -		current_timeout <<= 1;
>> -		if (count >= 0xF)
>> -			break;
>> -	}
>> -
>> -	if (count >= 0xF) {
>> -		printk(KERN_WARNING "%s: Too large timeout requested!\n",
>> -			mmc_hostname(host->mmc));
>> -		count = 0xE;
>> -	}
>> -
>> -	return count;
>> +	return 0xE;
> 
> Why don't you remove the function entirely?

better to rename it --- to set_maximum_timeout  since a little clearer.
left the old name for historical reasons -- if no need I will change it

> 
>> }
>> 
>> static void sdhci_set_transfer_irqs(struct sdhci_host *host)
>> @@ -671,7 +633,7 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
>> 	host->data = data;
>> 	host->data_early = 0;
>> 
>> -	count = sdhci_calc_timeout(host, data);
>> +	count = sdhci_calc_timeout();
>> 	sdhci_writeb(host, count, SDHCI_TIMEOUT_CONTROL);
>> 
>> 	if (host->flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA))
> 
> Thanks,
> 
>   Wolfram
> 
> -- 
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |

