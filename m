Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030286Ab2CNCFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:05:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36409 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965194Ab2CNCFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:05:30 -0400
X-AuditID: cbfee612-b7c09ae0000024ca-50-4f5ffce92c6a
Date: Wed, 14 Mar 2012 02:05:29 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH 4/5] max17042: Fix value scaling for VCELL and avgVCELL
To: bruce robertson <bruce.e.robertson@intel.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Cc: "dirk.brandewie@gmail.com" <dirk.brandewie@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "Jason.Wortham@maxim-ic.com" <Jason.Wortham@maxim-ic.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120314020200446@myungjoo.ham
Msgkey: 20120314020200446@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120314020200446@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <1210375.125631331690727274.JavaMail.weblogic@epml04>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2E25crk025312

bruce robertson<bruce.e.robertson@intel.com>, 2012-03-14 06:00 (GMT+09:00)
> 
> Anton Vorontsov writes:
> 
> > On Tue, Jan 24, 2012 at 09:26:07AM -0800, dirk.brandewie@gmail.com wrote:
> >> From: Bruce Robertson 
> >> 
> >> The bottom three bits of the register are don't care bits.  The LSB
> >> value is 625 uV.  Adjust the returned values appropriately
> >> 
> >> Signed-off-by: Bruce Robertson 
> >> Signed-off-by: Dirk Brandewie 
> >> Acked-by: MyungJoo Ham 
> >
> > I guess this was fixed long ago by the following patch:
> >
> > commit cf7a8c03db792894f436db5f3ffc44d947b9b068
> > Author: MyungJoo Ham 
> > Date:   Wed Aug 17 10:18:34 2011 +0900
> >
> >     max17042_battery: Bugfix of incorrect voltage register value interpretation
> >
> >     The calculation had error in getting voltage values from
> >     MAX17042 registers. The least bit denotes 78.125uV (625/8).
> 
> The multipliers I see in the patch are 83 making the voltages somewhat
> high and the low 3 bits are not masked off. I'm probably misreading the code.

The patch, commit cf7a8c03db, uses 78.125uV/bit, not 83uV/bit. The code before that patch uses 83uV/bit.

$ git show cf7a8c03db792894f436db5f3ffc44d947b9b068
[...]
diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 61fb6d7..a6dc9c7 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -111,12 +111,12 @@ static int max17042_get_property(struct power_supply *psy,
                val->intval *= 10000; /* Units of LSB = 10mV */
                break;
        case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-               val->intval = max17042_read_reg(chip->client,
-                               MAX17042_VCELL) * 83; /* 1000 / 12 = 83 */
+               val->intval = max17042_read_reg(chip->client, MAX17042_VCELL)
+                           * 625 / 8;
                break;
        case POWER_SUPPLY_PROP_VOLTAGE_AVG:
-               val->intval = max17042_read_reg(chip->client,
-                               MAX17042_AvgVCELL) * 83;
+               val->intval = max17042_read_reg(chip->client, MAX17042_AvgVCELL)
+                           * 625 / 8;
                break;
        case POWER_SUPPLY_PROP_CAPACITY:
                val->intval = max17042_read_reg(chip->client,


> 
> >
> >     Signed-off-by: MyungJoo Ham 
> >     Signed-off-by: Philip Rakity 
> >     Signed-off-by: Kyungmin Park 
> >     Signed-off-by: Anton Vorontsov 
> >
> > Thanks,
> 
> 
> 


--
MyungJoo Ham (ÇÔ¸íÁÖ), PHD
System S/W Lab, S/W Platform Team, Software Center
Samsung Electronics
Cell: +82-10-6714-2858

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
