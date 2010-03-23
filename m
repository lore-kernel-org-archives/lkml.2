Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab0CWPlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:41:18 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:62692 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754380Ab0CWPlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:41:16 -0400
Message-ID: <4BA8E11A.2020300@gmail.com>
Date: Tue, 23 Mar 2010 16:41:14 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100305 Lightning/1.0b2pre Shredder/3.0.3
MIME-Version: 1.0
To: rt2x00 Users List <users@rt2x00.serialmonkey.com>
CC: Ondrej Zary <linux@rainbow-software.org>,
       Ivo Van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH RFC] rt2500usb: disable broken HW	encryption
 by default
References: <201003221601.36559.linux@rainbow-software.org>	<201003231027.34095.linux@rainbow-software.org>	<a32f33a41003230236q348c8aeata724042a9c3d9537@mail.gmail.com> <201003231609.57505.linux@rainbow-software.org>
In-Reply-To: <201003231609.57505.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Mar 2010 15:41:15.0635 (UTC) FILETIME=[45FDC430:01CACA9F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/10 16:09, Ondrej Zary wrote:
> On Tuesday 23 March 2010, Ivo Van Doorn wrote:
>> On Tue, Mar 23, 2010 at 10:27 AM, Ondrej Zary
>>
>> <linux@rainbow-software.org> wrote:
>>> On Monday 22 March 2010, Ivo Van Doorn wrote:
>>>>>> But I though it was mentioned that disabling HW crypto didn't solve
>>>>>> the issue due to a second bug in a later kernel?
>>>>>
>>>>> That was a false positive. Probably because the device was not
>>>>> unplugged between the tests (and looks like the driver does not
>>>>> initialize the chip completely). It's not reliable, it sometimes stops
>>>>> working after reboot.
>>>>
>>>> Ah well that at least simplifies the problem. I'll have to retest
>>>> rt2500usb soon to see why the HW crypto failed. I am sure I had it
>>>> working for WEP, WPA and WPA2
>>>> before I submitted the patch.
>>>
>>> So let's try to fix it instead of disabling.
>>>
>>> First, the unrealiability (keeping HW encryption disabled). With the
>>> driver loaded but not doing anything more, the register dumps are same
>>> for both working and non-working case (dump-init.txt).
>>>
>>> dump-good-connected.txt is a dump after successful association and DHCP
>>> dump-bad-attempt.txt is a dump after successful association during
>>> non-working DHCP attempt
>>> dump-bad-after.txt is a dump after DHCP timed out
>>
>> With association working, but DHCP failing it most likely means that
>> somehow the frame was malformatted.
>> The code for HW crypto alters the frame (alters IV/EIV/ICV data etc).
>> And that is commonly the source of
>> problems, because what has to be done depends heavily on the encryption
>> type.
>>
>> So could you verify which of the encryption types (WEP,WPA,WPA2) is
>> failing or working? That would give a starting
>> position on which bytes might be corrupted.
> 
> I was testing only with WPA2 before. I did some more testing today. The results:
> 
> No encryption - works always
> WEP - sometimes works, sometimes not - same with and without HW encryption
> WPA - sometimes works, sometimes not - same with and without HW encryption
> WPA2 - never works with HW encryption
>      - sometimes works, sometimes not without HW encryptionn
> 
> So it seems that there are two problems:
>  1. random problems with any encryption
>  2. WPA2 is broken with HW encryption
> 
> When the "random" problem appears, this appears in dmesg:
> wlan1: authenticate with 00:13:d4:0f:f3:17 (try 1)
> wlan1: authenticated
> wlan1: associate with 00:13:d4:0f:f3:17 (try 1)
> wlan1: RX AssocResp from 00:13:d4:0f:f3:17 (capab=0x411 status=0 aid=2)
> wlan1: associated
> phy0 -> rt2500usb_set_device_state: Error - Device failed to enter state 3 (-16).
> phy0 -> rt2500usb_set_device_state: Error - Device failed to enter state 3 (-16).
> No probe response from AP 00:13:d4:0f:f3:17 after 500ms, disconnecting.
> 
> Disabling call to rt2500usb_set_state() in rt2500usb_set_device_state() seems
> to fix problem 1. After this change, WEP and WPA work always regardless of
> HW encryption (and WPA2 works always without it).
> 

For this last issue, could you check with powersaving disabled. Just execute
iwconfig wlan1 power off before associating.

The powersaving code looks a bit odd here, and we've had issues with this in the
other rt2x00 drivers as well.

---
Gertjan.
