Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab2BBDYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 22:24:03 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16414 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab2BBDXr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 22:23:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 01 Feb 2012 19:23:35 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
CC: Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ivan Kuten <ivan.kuten@promwad.com>
Date: Thu, 2 Feb 2012 08:53:31 +0530
Subject: RE: [rtc-linux] [PATCH] RTC: Add driver for NXP PCF8523 RTC chip
Thread-Topic: [rtc-linux] [PATCH] RTC: Add driver for NXP PCF8523 RTC chip
Thread-Index: AczhPKQcAkbB3BiDR/6bHxoTQ391zwAG/Kyg
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD0B98F99@BGMAIL02.nvidia.com>
References: <1317815823-27297-1-git-send-email-yauhen.kharuzhy@promwad.com>
 <20120201155235.044d77dc.akpm@linux-foundation.org>
In-Reply-To: <20120201155235.044d77dc.akpm@linux-foundation.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +/*
> > + * In the routines that deal directly with the pcf8523 hardware, we use
> > + * rtc_time -- month 0-11, hour 0-23, yr = calendar year-epoch.

Do we really need to limit year w.r.t. epoch?
Instead why don't you define a macro for base year in your driver itself?
With this, the same driver may be usable forever, without any modifications 
except for this macro (which also need to change once in a century).
If you use year w.r.t. epoch, this driver definitely need modification before year 2070.

> > + */
> > +static int pcf8523_get_datetime(struct i2c_client *client, struct rtc_time
> *tm)
> > +{
> > +	struct pcf8523 *pcf8523 = i2c_get_clientdata(client);
> > +	unsigned char buf[14] = { PCF8523_REG_CTL1 };
> > +	/* the clock can give out invalid datetime, but we cannot return
> > +	 * -EINVAL otherwise hwclock will refuse to set the time on bootup.
> > +	 */

Somehow I feel to set the RTC to a known time, probably the BASE year, in such
error cases.
> 
> This comment seems to imply that the driver allows hwclock to set the
> time to something which we know is incorrect?  If so, wouldn't it be
> better to leave the time at something obviously wrong, such as 1 Jan
> 1970?
> 
> > +	if (rtc_valid_tm(tm) < 0)
> > +		dev_err(&client->dev, "retrieved date/time is not valid.\n");
> > +
> > +	return 0;
> > +}
