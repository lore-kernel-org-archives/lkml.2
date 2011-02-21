Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab1BUUYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 15:24:46 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:5863 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751349Ab1BUUYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 15:24:45 -0500
Message-ID: <4D62CA32.5090007@bluewatersys.com>
Date: Tue, 22 Feb 2011 09:25:22 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alexander Stein <alexander.stein@systec-electronic.com>
CC: Wolfram Sang <w.sang@pengutronix.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Eric Miao <eric.y.miao@gmail.com>, Peter Tyser <ptyser@xes-inc.com>,
        linux-kernel@vger.kernel.org, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 1/4] gpiolib: Add "unknown" direction support
References: <1297904216-15219-1-git-send-email-ptyser@xes-inc.com> <201102211207.29291.alexander.stein@systec-electronic.com> <20110221112240.GH2616@pengutronix.de> <201102211238.16554.alexander.stein@systec-electronic.com>
In-Reply-To: <201102211238.16554.alexander.stein@systec-electronic.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 12:38 AM, Alexander Stein wrote:
> On Monday 21 February 2011, 12:22:40 Wolfram Sang wrote:
>> On Mon, Feb 21, 2011 at 12:07:27PM +0100, Alexander Stein wrote:
>>> On Monday 21 February 2011, 10:47:56 Wolfram Sang wrote:
>>>>> We had exported our 5V_enable gpio to sysfs to allow a user-space
>>>>> application to enable/disable devices connected to 5V circuit.
>>>>> But on the other hand we had to read the current status of this gpio
>>>>> in the power-fail interrupt handler to distinguish between
>>>>> false-positive (5V disabled) and a correct detection.
>>>>
>>>> What about gpio_export() (description in Documentation/gpio.txt)?
>>>
>>> Ah, I didn't know about this. I just expected this is only used from
>>> sysfs part. But you have to make sure your .ko is loaded before
>>> userspace is accessing sysfs and tries to export the GPIO.
>>
>> Eh? Userspace doesn't export the GPIO in that case.
> 
> Sure, but you have to make sure you have it exported or userspace will fail.
> 
>>> Or is it "allowed" by the API convention to gpio_request and gpio_export
>>> (and set direction) a GPIO in the machine startup code which will later
>>> be used in a different place?
>>
>> different place = userspace? Well, that's the main intention of
>> gpio_export(). (I have the feeling we are missing each other here,
>> thoguh) I'd suggest looking a bit further in the docs/code. It should
>> make clear what is possible.
> 
> No, with different place I mean a kernel module driver which will be loaded 
> later using insmod. In this case this module is just expecting the GPIO has 
> already be exported and set proper direction without requesting the GPIO 
> itself.

If the module does the gpio_request, then it should also do the
gpio_export (and gpio_unexport/gpio_free on module exit). In this case
when the module is not loaded the gpio is not in use by the kernel and
user space is able to access it via sysfs. When the module is in use the
gpio_export call will make the gpio available via sysfs.

If the gpio_request is done in your platform code, then the gpio_export
should also go in the platform code. This way the gpio is always in use
by the kernel, but also exported to userspace so it will be available
via sysfs.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
