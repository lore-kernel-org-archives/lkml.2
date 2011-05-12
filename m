Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460Ab1ELSd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:33:28 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:18840 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab1ELSd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:33:27 -0400
Message-ID: <4DCC27F2.5030206@tilera.com>
Date: Thu, 12 May 2011 14:33:22 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [rtc-linux] [PATCH] tile: add an RTC driver for the Tilera hypervisor
References: <201105042004.p44K4hh5011720@farm-0032.internal.tilera.com> <20110511154407.ed3c0480.akpm@linux-foundation.org>
In-Reply-To: <20110511154407.ed3c0480.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/11/2011 6:44 PM, Andrew Morton wrote:
> On Wed, 4 May 2011 15:52:21 -0400
> Chris Metcalf <cmetcalf@tilera.com> wrote:
>> This is a simple RTC driver that lets Tilera hardware boot up and
>> set the clock correctly.
>>
>> ...
>>
>> +static int __init tile_rtc_driver_init(void)
>> +{
>> +	int err;
>> +
>> +	err = platform_driver_register(&tile_rtc_platform_driver);
>> +	if (err)
>> +		return err;
>> +
>> +	tile_rtc_platform_device = platform_device_alloc("rtc-tile", 0);
>> +	if (tile_rtc_platform_device == NULL) {
>> +		platform_driver_unregister(&tile_rtc_platform_driver);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	err = platform_device_add(tile_rtc_platform_device);
>> +	if (err) {
>> +		platform_device_put(tile_rtc_platform_device);
> should we have a platform_driver_unregister() here?

Thanks, good catch.  I restructured this to look more like the rtc-test.c
initializer:

static int __init tile_rtc_driver_init(void)
{
	int err;

	err = platform_driver_register(&tile_rtc_platform_driver);
	if (err)
		return err;

	tile_rtc_platform_device = platform_device_alloc("rtc-tile", 0);
	if (tile_rtc_platform_device == NULL) {
		err = -ENOMEM;
		goto exit_driver_unregister;
	}

	err = platform_device_add(tile_rtc_platform_device);
	if (err)
		goto exit_device_put;

	return 0;

exit_device_put:
	platform_device_put(tile_rtc_platform_device);

exit_driver_unregister:
	platform_driver_unregister(&tile_rtc_platform_driver);
	return err;
}


-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


