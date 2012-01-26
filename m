Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab2AZCMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 21:12:12 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11921 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab2AZCMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 21:12:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 25 Jan 2012 18:12:09 -0800
Message-ID: <4F20B651.4050609@nvidia.com>
Date: Thu, 26 Jan 2012 07:41:29 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "tsoni@codeaurora.org" <tsoni@codeaurora.org>,
        "kyle.manna@fuel7.com" <kyle.manna@fuel7.com>,
        "aghayal@codeaurora.org" <aghayal@codeaurora.org>,
        "vapier@gentoo.org" <vapier@gentoo.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1] input: keyboard: Add interrupt keyboard driver.
References: <1326778915-2678-1-git-send-email-ldewangan@nvidia.com> <20120119072941.GA9668@core.coreip.homeip.net> <AE833E40769D9441BEBD31E18A33543503A71ECB3B@BGMAIL01.nvidia.com>
In-Reply-To: <AE833E40769D9441BEBD31E18A33543503A71ECB3B@BGMAIL01.nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 January 2012 01:09 PM, Laxman Dewangan wrote:
> On Thursday, January 19, 2012 1:00 PM, Dmitry Torokhov wrote:
>
>> On Tue, Jan 17, 2012 at 11:11:55AM +0530, Laxman Dewangan wrote:
>>> This driver enables the key detection of the keys which
>>> are connected to interrupt lines.
>>> Each key is capable of generating an interrupt, and the
>>> statesi (pressed or released) cannot be found by any
>>> mechanism.
>>> A key press event generated when interrupt occurs, and
>>> based on the debounce time setting, a key release event
>>> is generated. There is no need to read the state of the
>>> keys.
>>
>> Is it possible to modify gpio_keys to skip requesting and settin up
>> certain gpios and and use it instead of a brand new driver?
> I first tried this approach and found that this makes the gpio_keys
> driver very complex because almost all places where gpio-apis are
> getting called need to put under if condition.
> Also there is some special handling for auto key release events
> Which makes gpio-key driver again complex.
>
>
>

Hi  Dmitry,
Do you have any further comment on above approach?  Here is little bit 
background which can help on understanding.
I am working on some MFD devices and to tried to support the onkey from 
single driver to avoid having driver for each mfd-pmic driver.

When developing this driver, I though of following behaviors of the pmic 
device for power-btn/onkey switches:
1. Separate Interrupt for press and release: (Falling and rising 
interrupt, no level interrupt) So two different interrupt will get 
registered and based on interrupt number the key code and key value will 
get reported to input system. Device like AB8500 (ab8500-ponkey.c).

2. Generates interrupt for only key press, no interrupt for the key 
release (only one interrupt i.e. Falling edge) In this case, it need to 
send the release event automatically after sending press event. So 
whenever there is falling edge on keys, the interrupt get generated, No 
interrupt on pressed level. Devices like ricoh583,  max77663.

3. Keep generating interrupt if key is pressed but no interrupt after 
release (Kind on level (low) interrupt and so multiple interrupts till 
key pressed.) Devices like tps65910..
In this case, the device generates level interrupt and if it acked, 
again generates interrupt. So if we send the key press/release together 
without waiting, we will endup with sending the key event multiple time. 
To avoid this I used the debaince logic as follows:
detect first interrupt, send press event and start timer and wait for 
timer to expire for sending release events. If interrupt again occurs 
before timer expires, restart timer again. Keep doing this until user 
release the key. Once he release the key, there will be no interrupt and 
so timer will be expire after some time i.e. debounce time and then 
report key released.


>> --
>> Dmitry

