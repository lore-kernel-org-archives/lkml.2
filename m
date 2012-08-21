Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab2HUGzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 02:55:16 -0400
Received: from bosmailout11.eigbox.net ([66.96.185.11]:45881 "EHLO
	bosmailout11.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab2HUGzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 02:55:13 -0400
X-Greylist: delayed 2537 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Aug 2012 02:55:13 EDT
X-Authority-Analysis: v=2.0 cv=aPZHX8Bm c=1 sm=1
 a=lghRLfjGutYZE2O92ubooA==:17 a=bc2JKO6qiGsA:10 a=kfTud4QeKxsA:10
 a=TNaJx8l5llIA:10 a=8nJEP1OIZ-IA:10 a=ZbotsqAEwLAA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=dgM3qMr4dAp3Bs2uI40A:9 a=wPNLvfGTeEIA:10
 a=anyYG9rjTBM1sAjEBQ8Cew==:117
X-EN-OrigOutIP: 10.20.18.11
X-EN-IMPSID: pJCr1j0040EKspE01JCrBe
Message-ID: <503326CE.40301@yahoo.es>
Date: Tue, 21 Aug 2012 14:12:30 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: viresh kumar <viresh.kumar@linaro.org>
CC: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH] Fixes for dw_dmac and atmel-mci for AP700x
References: <502BC31E.4070200@yahoo.es> <502BDD0E.4030106@yahoo.es> <502CA8FC.7090705@atmel.com> <502CB89B.4070302@yahoo.es> <502CC326.8020605@atmel.com> <502CC6A0.3050603@atmel.com> <502F52E7.9050804@yahoo.es> <CACiLriS-GZg24TJqJGQ=P04n-Zk3FdHtGgh5VeqGcCMHG6TnMw@mail.gmail.com> <50310F10.2080701@yahoo.es> <CAOh2x=kOxninn=o1i2-HE1is-G8vfi1ER_JjUQY=N0wTYwAotw@mail.gmail.com>
In-Reply-To: <CAOh2x=kOxninn=o1i2-HE1is-G8vfi1ER_JjUQY=N0wTYwAotw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.56.110
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,


On 8/21/2012 12:42 PM, viresh kumar wrote:
> I have added linux-kernel list in cc as there might be other users of
> this patch.
> Also, please try to keep spear-devel list in cc for dw_dmac as we are using this
> driver for SPEAr.

Yes sure, I didn't want to bother the lists with the first preparations of this patch.

> On Sun, Aug 19, 2012 at 9:36 PM, Hein Tibosch <hein_tibosch@yahoo.es> wrote:
>> dw_dmac:
>> - After 2.6.39, the registers were accessed using readl/writel
>>   in stead of the __raw_readl and __raw_writel causing a 16-bit
>>   swap of all values (little endian access)
> Ahhhh!! Firstly we can't use __raw* for architectures >= ARMv6. It is not
> only for endianess but for memory barriers. Why are they getting swapped
> for your case? Does your processor and dw_dmac have different endianess?

If I'm not wrong: the __raw_* functions will access the i/o memory in native endianess.
As far as I know, all AVR32 drivers are currently using the __raw* functions. I never
encountered  a problem with that.

> And if i am not wrong, we should always try not to use __raw* variants just
> due to endianess things... instead use either readl/writel OR
> readl_/writel_ relaxed.
> I am not sure if relaxed versions are available for architectures
> other than ARM.

Would you agree to have this depend on CONFIG_AVR ?

>> - Access to memory was sometimes done in chunks of 64-bits,
>>   which gives an undefined value of 0x03 for SRC/DST_TR_WIDTH
>>   field in the CTLxL register
> Looks fine. But there should be a separate patch for this.
>
>> - The SMS field in the CTLxL register received the wrong value:
>>   0 in stead of 1
> I believe it is not for dw_dmac?

That's correct, I'll put it in a separate Atmel patch (at32ap700x.c)

So for the AP700x fixes for the MCI/DMA driver I'm thinking of this
series of patches:

To you, cc spear-devel & linux-kernel
- include/linux/dw_dmac.h:
  adding field max_mem_width to limit SRC/DST_TR_WIDTH
- dw_dmac.c:
  check max_mem_width before setting SRC/DST_TR_WIDTH
- dw_dmac_regs.h:
  use __raw* functions for AVR32, readl/writel for all others

To Ludovic Desroches, linux-mmc:
- atmel-mci.c:
  avoid using peripheral DMA controller (PDC) in case of AVR32
- atmel-mci.c:
  only use the ATMCI_DMA register if supported by arch

To Hans-Christian, linux-kernel cc Andrew:
- at32ap700x.c:
  set src_master=1 to get SMS (Source Master Select) correct
  set max_mem_width=2 to get SRC/DST_TR_WIDTH correct

Ok?

Thanks, Hein
