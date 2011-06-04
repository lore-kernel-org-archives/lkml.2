Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab1FDQcZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 12:32:25 -0400
Received: from ams-iport-2.cisco.com ([144.254.224.141]:62020 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab1FDQcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 12:32:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAKZd6k2Q/khL/2dsb2JhbABThEqhB3V3iHGhVY0JkBGBK4NsgQoElUqEKIZD
X-IronPort-AV: E=Sophos;i="4.65,320,1304294400"; 
   d="scan'208";a="33693743"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH] Add support for the Philips SA56004 temperature sensor.
Date: Sat, 4 Jun 2011 18:32:01 +0200
Message-ID: <6E4D2678AC543844917CA081C9D6B33F049B1DE3@XMB-AMS-103.cisco.com>
In-Reply-To: <BANLkTimKB8PtFF72rOeDAmkbM_oq=ZMRgg@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Add support for the Philips SA56004 temperature sensor.
Thread-Index: Acwiu5bFvT78Jf2oQaGEzqYRA8xA/QAGII9A
References: <1307183831-19627-2-git-send-email-sdevrien@cisco.com> <BANLkTimKB8PtFF72rOeDAmkbM_oq=ZMRgg@mail.gmail.com>
From: "Stijn Devriendt (sdevrien)" <sdevrien@cisco.com>
To: "anish singh" <anish198519851985@gmail.com>
Cc: <khali@linux-fr.org>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>, <guenter.roeck@ericsson.com>
X-OriginalArrivalTime: 04 Jun 2011 16:32:02.0412 (UTC) FILETIME=[EEF18AC0:01CC22D4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p54GWeGS032111

> From: anish singh [mailto:anish198519851985@gmail.com] 
>
> I am no expert on HWMON but just want to 
> add some points.
> @@ -454,7 +477,7 @@ static struct lm90_data *lm90_update_device(struct device *dev)
>
>Â  Â  Â  Â  Â  Â  Â  Â if (data->flags & LM90_HAVE_LOCAL_EXT) {
>Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â lm90_read16(client, LM90_REG_R_LOCAL_TEMP,
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  MAX6657_REG_R_LOCAL_TEMPL,
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  data->reg_local_ext,
>Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â &data->temp11[4]);
> I don't think this variable reg_local_ext should exist as 
> register address should be "# defined" and should not be
> part of lm90_data but i do see a case here where we are
> assuming MAX6657 is only having this LM90_HAVE_LOCAL_EXT
> flag set.So i think we should have some more branching here
> to detect the device and pass the corresponding register but as
> i said i am no expert.
>Â 

Only MAX6657 and SA56004 have the local temperature extension
register and unfortunately they reside at different offsets.
Therefore the probing will detect the right chip and, if supported,
use the correct register.

>Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â } else {
>Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â if (lm90_read_reg(client, LM90_REG_R_LOCAL_TEMP,
> @@ -1372,6 +1400,11 @@ static int lm90_probe(struct i2c_client *new_client,
>Â  Â  Â  Â /* Set maximum conversion rate */
>Â  Â  Â  Â data->max_convrate = lm90_params[data->kind].max_convrate;
>
> + Â  Â  Â  if (data->flags & LM90_HAVE_LOCAL_EXT) {
> + Â  Â  Â  Â  Â  Â  Â  data->reg_local_ext = lm90_params[data->kind].reg_local_ext;
> + Â  Â  Â  Â  Â  Â  Â  BUG_ON(data->reg_local_ext == 0);
> + Â  Â  Â  }
> +
> I think this BUG_ON is too harsh in probe.We generally use pr_err
> to print if something which is supposed to be set is not set.As BUG_ON
> will call kernel panic,right?

The reason for adding the BUG_ON rather than the error was that it is
in fact a coding error when the flag is set without specifying the offset.
Such a condition should never make it into a running system and should be
caught during coding or review.
BUG_ON only does an oops, panic is optional depending on panic_on_oops being
set.

Regards,
Stijn
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
