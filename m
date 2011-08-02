Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab1HBRCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 13:02:40 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:37108 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab1HBRCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 13:02:35 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-132.messagelabs.com!1312304549!33855454!20
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.180]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Wim Van Sebroeck <wim@iguana.be>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Tue, 2 Aug 2011 12:02:11 -0500
Subject: RE: [RFC PATCH] watchdog: ep93xx: Use the WatchDog Timer Driver
	Core.
Thread-Topic: [RFC PATCH] watchdog: ep93xx: Use the WatchDog Timer Driver
	Core.
Thread-Index: AcxQ+pkAJnXXDRuZSdih4Pv1FJb/tQAOm6+w
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3882B8541@AUSP01VMBX24.collaborationhost.net>
References: <201108011357.24745.hartleys@visionengravers.com>
 <20110802095729.GO4227@infomag.iguana.be>
In-Reply-To: <20110802095729.GO4227@infomag.iguana.be>
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

On Tuesday, August 02, 2011 2:58 AM, Wim Van Sebroeck wrote:
> Hi H Hartley,

Hello!

> [...]
>> @@ -210,43 +126,31 @@ static int __init ep93xx_wdt_init(void)
>>  {
>>  	int err;
>>  
>> -	err = misc_register(&ep93xx_wdt_miscdev);
>> +	ep93xx_wdd.bootstatus = readl(EP93XX_WDT_WATCHDOG);
>> +	ep93xx_wdd.timeout = timeout;
>> +
>> +	err = watchdog_register_device(&ep93xx_wdd);
>> +	if (err)
>> +		return err;
>>  
>> -	boot_status = __raw_readl(EP93XX_WDT_WATCHDOG) & 0x01 ? 1 : 0;
>> +	setup_timer(&timer, ep93xx_timer_ping, 1);
>
> Shouldn't the bootstatus setting be:
> ep93xx_wdd.bootstatus = readl(EP93XX_WDT_WATCHDOG) & 0x01 ? 1 : 0;
> (or something similar with the WDIOF_OVERHEAT, ... flags).

The ep93xx watchdog status register doesn't line up nicely with the standard
WDIOF_* flags.  The register has these bits defined:

PLSDN		6	Pulse Disable Not
OVRID		5	Software Override of HWDIS
SWDIS		4	Software Watchdog Disable
HWDIS		3	Hardware Watchdog Disable
URST		2	User Reset Detected
3KRST		1	Three-Key Reset Detected
WD		0	Watchdog Reset Detected

The original bootstatus setting just checked for the WD bit.  I would like
to pass the full status register so that userspace can figure out what caused
the reset.  Is this an inappropriate abuse of WDIOC_GETBOOTSTATUS?

Regards,
Hartley