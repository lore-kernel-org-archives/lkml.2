Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab1EEHuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 03:50:04 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43446 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab1EEHuB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 03:50:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iWNO/BCAVisSaVVgCXbLHmXLq9VG6hDEwEzoiLXRQc1Bd9blzSurRX8jpSn41h9gZB
         yzhZD9v5oWJ76Rm/uErGc22l8EWXrssJZ40yZn3yy/JPXvBNwUaoH2uZUp9EsSgpoWVN
         jN7wwlgu5cMEGo6ynxLl3FhFL5Zd3Unyk4mFE=
MIME-Version: 1.0
In-Reply-To: <BANLkTimiDjrRy_3seDLBYah8MnJMWxNZ-w@mail.gmail.com>
References: <20101203121338.GB18655@intel.com>
	<BANLkTimiDjrRy_3seDLBYah8MnJMWxNZ-w@mail.gmail.com>
Date: Thu, 5 May 2011 09:50:00 +0200
Message-ID: <BANLkTim9ZhUbmBX02YEmLYL+1PS-0d4wOw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4]enable background operations for supported eMMC card
From: Per Forlin <per.lkml@gmail.com>
To: Chuanxiao Dong <chuanxiao.dong@intel.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, cjb@laptop.org,
        akpm@linux-foundation.org, arjan@linux.intel.com, alan@linux.intel.com,
        kmpark@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 2, 2011 at 9:53 PM, Per Forlin <per.lkml@gmail.com> wrote:
> On Fri, Dec 3, 2010 at 1:13 PM, Chuanxiao Dong <chuanxiao.dong@intel.com> wrote:
>> From 984adc755cf2f7966a89e510a50f085e314fe347 Mon Sep 17 00:00:00 2001
>> From: Chuanxiao Dong <chuanxiao.dong@intel.com>
>> Date: Mon, 22 Nov 2010 16:31:12 +0800
>> Subject: [PATCH 1/4] mmc: Enabled background operations feature if eMMC card supports
>>
>> Background operations is a new feature defined in eMMC4.41 standard.
>> Since this feature is opertional for eMMC card, so driver only enable
>> for those eMMC card which supports this feature
>>
>> Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
>> ---
>>  drivers/mmc/core/mmc.c   |   26 ++++++++++++++++++++++++++
>>  include/linux/mmc/card.h |    2 ++
>>  include/linux/mmc/mmc.h  |    3 +++
>>  3 files changed, 31 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
>> index 77f93c3..471ed82 100644
>> --- a/drivers/mmc/core/mmc.c
>> +++ b/drivers/mmc/core/mmc.c
>> @@ -310,6 +310,14 @@ static int mmc_read_ext_csd(struct mmc_card *card)
>>                        ext_csd[EXT_CSD_SEC_FEATURE_SUPPORT];
>>                card->ext_csd.trim_timeout = 300 *
>>                        ext_csd[EXT_CSD_TRIM_MULT];
>> +
>> +               /* detect whether the eMMC card support BKOPS */
>> +               if (ext_csd[EXT_CSD_BKOPS_SUPPORT] & 0x1) {
>> +                       card->ext_csd.bkops = 1;
>> +                       card->ext_csd.bkops_en =
>> +                               ext_csd[EXT_CSD_BKOPS_EN];
>> +               }
>> +
>>        }
>>
>>        if (ext_csd[EXT_CSD_ERASED_MEM_CONT])
>> @@ -484,6 +492,24 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>>        }
>>
>>        /*
>> +        * enable BKOPS if eMMC card supports.
>> +        */
>> +       if (card->ext_csd.bkops) {
>> +               if (!card->ext_csd.bkops_en) {
>> +                       err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>> +                                       EXT_CSD_BKOPS_EN, 1);
> Is it always wise to set BKOPS_EN to 1 if bkops is supported?
> BKOPS_EN=1 will enable periodic background operations. The card will
> somehow decide periodically when to start background operations. If
> BKOPS_EN=0 the background operations need to be started manually. The
> mmc framework could make the decision when to start background
> operations.
BKOP_EN=0 means act like a pre v4.41 device.  No maintenance required.
Thanks Bruce for pointing this out to me.

> Using dynamic clock control or suspend/resume may cause the periodic
> internal operations to be delayed since it can't run without clocking
> or power.
> Do you have any test results comparing periodic and manual bkops?
> On way forward is to add support for both periodic bkops and manual
> bkops and let the device platform_data specify what to use?
Please discard this comment.

My concern is when to fire BKOPS_START.
Would it make sense to check the BKOPS_STATUS before going to sleep
and start bkops even if level is only "non critical"? This would defer
sleep until bkops are completed.

Regards,
Per
