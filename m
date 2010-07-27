Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab0G0FD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 01:03:57 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61993 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab0G0FD4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 01:03:56 -0400
MIME-Version: 1.0
X-Originating-IP: [192.163.20.231]
In-Reply-To: <20100726221443.GA9916@suse.de>
References: <1280148469-14886-1-git-send-email-pavan_savoy@ti.com>
	<20100726221443.GA9916@suse.de>
Date: Tue, 27 Jul 2010 10:33:55 +0530
X-Google-Sender-Auth: 7okV9NAjqDxJ5ZUmzmAILpcaGEA
Message-ID: <AANLkTinmxtw8cjLihyW+a2dS1J5DrZWgsCwF_s_1kb40@mail.gmail.com>
Subject: Re: [PATCH] RFC: drivers:staging:ti-st: netlink for kim/uim
From: Pavan Savoy <pavan_savoy@ti.com>
To: Greg KH <gregkh@suse.de>
Cc: alan@lxorguk.ukuu.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On Tue, Jul 27, 2010 at 3:44 AM, Greg KH <gregkh@suse.de> wrote:
> On Mon, Jul 26, 2010 at 07:47:49AM -0500, pavan_savoy@ti.com wrote:
>> From: Pavan Savoy <pavan_savoy@ti.com>
>>
>> Greg, Alan,
>>
>> (please do not merge
>> &
>> long mail warning, please have a look..)
>>
>> I hope the driver is close to being good enough to be moved out of
>> staging, as one of the last major TODOs which was multiple device
>> support is being handled here.
>
> Well, there are other things that need to be resolved before the code is
> moved:
>        - document the sysfs attributes
>        - move most of the current sysfs attributes to debugfs

Ok, this could be done. Will send out patches for it.

>
>> However, please comment as to how desperately is this required to get
>> this out of staging, the reason is mentioned below..
>
> It's a big deal for you to have to do.

I mean yes, the basic per-device context is already set right ? The
problem I would have in implementing this thing, is verification,
there is no such platform which as of now hosts 2 WL chips.
Also, it would go against the philosophy of this driver too.
As in If I had a WL-chip-1 for BT and WL-chip-2 for FM on UART1 and
UART2, I would use BT and FM stand-alone, and won't have to use ST.

So, hence my question as to how critical this is ?

>> The per-device context to driver is already provided however, there is
>> this small catch in support for multiple devices.
>> The kernel space needs to communicate to user-space about the device
>> which needs to be used.
>> say:-
>>       ST_O platform device is on ttyS0
>>       ST_1 platform device is on ttyS1
>> and
>>       ST_2 platform device is on ttySPI0
>>
>> each protocol drivers such as BT, FM would be only able to tell which
>> platform device they want to bind to, but that device needs to be
>> opened/ldisc installtion needs to happen from user-space/UIM.
>>
>> background :-
>> UIM is the user-space initialization manager for the TI WL7 chipsets
>> which is responsible for :-
>>       * opening the tty ONLY when absolutely necessary
>>       * set the baud-rate agreed upon between BT, FM and GPS
>>       (usually the max baud-rate)
>>       * installing/tiocsetd the N_TI_WL ldisc
>>       * un-installing ldisc
>>       * closing the device when not being used.
>>
>> KIM is the kernel-space initialization manager for the TI WL7 chipsets
>> which is responsible for :-
>>       * enabling the chip-enable GPIO
>>       * communicate to UIM that the tty needs to be used
>>       (it gets to know via the one of the BT/FM/GPS drivers..)
>>       * wait for UIM to install ldisc
>>       * download firmware once tty context is available
>>       * communicate to UIM about the releasing the tty when no-one's
>>       using (again when protos_registered becomes 0)
>>       * disable the chip enable GPIO.
>>
>> So, as of now these were being interfaced earlier over /sys/uim/pid and
>> signal mechanism, which was then changed to /dev/rfkill and
>> rfkill_events over it.
>
> Yes, much better.
>
>> However,
>> Since with multiple device support is required the KIM somehow needs to
>> inform the UIM to open a particular tty interface - by sending an id or
>> the exact device name itself, this is what this patch does.
>
> Why can't you just select the specific rfkill device through that api?

Yes, doing exactly that. Further more when support for WL6 can be
safely removed, this is going to get even cleaner with 1 rfkill entry
per-WL device and not as many as 3 as of now (WL6 has cases where
although UART is shared, the chip enable GPIOs are different)

> And if it can't select the individual devices, fix that.
>
> Don't create arbitrary netlink interfaces that aren't documented
> anywhere please.

Ok, but coming back to question on top, if I have to implement
multiple device support then KIM needs to send data to UIM such as on
which device the ST ldisc needs to be installed.
What interface shall I use to send such data ?

Thanks,
Pavan
> thanks,
>
> greg k-h
>
