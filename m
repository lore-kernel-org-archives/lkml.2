Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab0LUQje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 11:39:34 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:37725 "HELO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751020Ab0LUQjd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 11:39:33 -0500
From: Philip Rakity <prakity@marvell.com>
To: zhangfei gao <zhangfei.gao@gmail.com>
CC: Takashi Iwai <tiwai@suse.de>, Chris Ball <cjb@laptop.org>,
        Aries Lee <arieslee@jmicron.com>, Qiming Wu <wuqm@marvell.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 21 Dec 2010 08:36:22 -0800
Subject: Re: [PATCH] mmc: Test bus-width for old MMC devices (v2)
Thread-Topic: [PATCH] mmc: Test bus-width for old MMC devices (v2)
Thread-Index: AcuhLTVYJ0RCpNpWQzS1UDlXGQu+tg==
Message-ID: <E81C83FE-E3AD-49DA-86BE-95631F1B81CD@marvell.com>
References: <s5hfwtzbj8v.wl%tiwai@suse.de>
 <20101216234032.GA17239@void.printf.net>
 <50D31EC8-BD9E-4920-8CEB-2AD10DF9C5C5@marvell.com>
 <20101217034342.GA19673@void.printf.net>	<s5hy67o95to.wl%tiwai@suse.de>
 <AANLkTimSt5a998m1oqdppsWjGCVid0-Ub81pKgsPR36f@mail.gmail.com>
In-Reply-To: <AANLkTimSt5a998m1oqdppsWjGCVid0-Ub81pKgsPR36f@mail.gmail.com>
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



Can you please try this diff and see if it works for you.

Will do formal patch after your testing.  What card is failing ?   

Please let me know the manufacturing information so can add card to my test suite.

Philip

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 1d8409f..77072c8 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -558,6 +558,8 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 					 EXT_CSD_BUS_WIDTH,
 					 ext_csd_bits[idx][0]);
 			if (!err) {
+				mmc_set_bus_width_ddr(card->host,
+						      bus_width, MMC_SDR_MODE);
 				/*
 				 * If controller can't handle bus width test,
 				 * use the highest bus width to maintain
@@ -565,8 +567,6 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 				 */
 				if (!(host->caps & MMC_CAP_BUS_WIDTH_TEST))
 					break;
-				mmc_set_bus_width_ddr(card->host,
-						      bus_width, MMC_SDR_MODE);
 				err = mmc_bus_test(card, bus_width);
 				if (!err)
 					break;
@@ -586,7 +586,8 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 		} else if (ddr) {
 			mmc_card_set_ddr_mode(card);
 			mmc_set_bus_width_ddr(card->host, bus_width, ddr);
-		}
+		} else 
+			mmc_set_bus_width (card->host, bus_width);
 	}
 
 	if (!oldcard)


Philip

On Dec 21, 2010, at 2:59 AM, zhangfei gao wrote:

> On Fri, Dec 17, 2010 at 3:11 AM, Takashi Iwai <tiwai@suse.de> wrote:
>> At Fri, 17 Dec 2010 03:43:42 +0000,
>> Chris Ball wrote:
>>> 
>>> Hi Philip,
>>> 
>>> On Thu, Dec 16, 2010 at 06:33:49PM -0800, Philip Rakity wrote:
>>>> It is not possible for bus_width to be not initialized.  This would imply ARRAY_SIZE(bus_widths) is 1.  Certainly not true.
>>> 
>>> Right, I agree.  We should fix the warning anyway.
>> 
>> Well, this is always a gray-zone question.  One prefers fixing it
>> either via uninitialized_var() or by setting a bogus value.  But, this
>> would cover any possible real bug in future.  Thus another prefers
>> ignoring it, because it's just a compiler bug (mostly of old gcc).
>> 
>> After all, it's up to maintainer, so take as you like :)
>> 
>> 
>> thanks,
>> 
>> Takashi
>> 
>> 
>>>> We could just initialize by changing
>>>> +           unsigned idx, bus_width;
>>>> to
>>>> +           unsigned idx, bus_width = 0;
>>> 
>>> Okay, I've pushed to mmc-next with that change.
>>> 
>>>> I wonder what compiler are you using so we can avoid this issue in future.
>>> 
>>> Ah, good point -- I was building with a gcc 4.1.2 ARM cross-compiler,
>>> and using a gcc 4.5.1 cross-build instead avoids the warning.
>>> 
>>> Thanks,
>>> 
>>> --
>>> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
>>> One Laptop Per Child
>>> 
>> 
> 
> Could you help adding this modification?
> We found error happen since bus_width is not set at these condition:
> 1. ddr=0
> 2. not set MMC_CAP_BUS_WIDTH_TEST
> 
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index 1d8409f..86cac0d 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -586,7 +586,11 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
> 		} else if (ddr) {
> 			mmc_card_set_ddr_mode(card);
> 			mmc_set_bus_width_ddr(card->host, bus_width, ddr);
> -		}
> +
> +		} else
> +			mmc_set_bus_width(card->host,
> +					bus_widths[idx]);
> +
> 	}
> 
> 	if (!oldcard)

