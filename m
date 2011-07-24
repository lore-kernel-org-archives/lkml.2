Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147Ab1GXEAy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 00:00:54 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:56265 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750742Ab1GXEAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 00:00:48 -0400
Message-ID: <4E2B987E.6070107@metafoo.de>
Date: Sun, 24 Jul 2011 05:58:54 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110702 Icedove/3.0.11
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 01/11] watchdog: WatchDog Timer Driver Core - Add basic
 framework
References: <1310392522-9949-1-git-send-email-wim@iguana.be> <4E1B8089.90103@metafoo.de> <20110722193211.GL31767@infomag.iguana.be>
In-Reply-To: <20110722193211.GL31767@infomag.iguana.be>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2011 09:32 PM, Wim Van Sebroeck wrote:
> Hi Lars-Peter,
> 
>> On 07/11/2011 04:19 PM, Wim Van Sebroeck wrote:
>>> +
>>> +int watchdog_dev_unregister(struct watchdog_device *watchdog)
>>> +{
>>> +	/* Check that a watchdog device was registered in the past */
>>> +	if (!test_bit(0, &watchdog_dev_busy) || !wdd)
>>> +		return -ENODEV;
>>> +
>>> +	/* We can only unregister the watchdog device that was registered */
>>> +	if (watchdog != wdd) {
>>> +		pr_err("%s: watchdog was not registered as /dev/watchdog.\n",
>>> +			watchdog->info->identity);
>>> +		return -ENODEV;
>>> +	}
>>> +
>>> +	/* Unregister the miscdevice */
>>> +	misc_deregister(&watchdog_miscdev);
>>> +	wdd = NULL;
>>> +	clear_bit(0, &watchdog_dev_busy);
>>> +	return 0;
>>> +}
>>
>> What happens if the watchdog gets unregistered if the device is still opened?
>> Even though if you'd check wdd for not being NULL in the file callbacks there
>> is still a chance for races if the devices is unregistered at the same time as
>> the callback is running. You'd either need a big lock to protect from having a
>> file callback and unregister running concurrently or add ref-counting to the
>> watchdog_device, the later best done by embedding a struct device and using the
>> device driver model.
> 
> You cannot unload the watchdog-drivers module if /dev/watchdog is still open.
> So if the watchdog_unregister function is in the exit function of the module
> then we are safe. But I think you have a point if that is not the case.
> Solution would be to return an error when the watchdog_unregister_device routine
> is called and the WDOG_DEV_OPEN bit is set. Will create an extra patch for that.
> 

The problem is, that this doesn't fit nicely into the linux device driver
model, because it doesn't allow the removal of a device to fail. So you'll
still end of with undefined behavior.

- Lars
