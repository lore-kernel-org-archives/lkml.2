Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab2J2UxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:53:11 -0400
Received: from mail2.ruggedcom.com ([204.50.148.11]:10517 "EHLO
	mail2.ruggedcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab2J2UxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:53:08 -0400
Message-ID: <508EEB48.9070508@ruggedcom.com>
Date: Mon, 29 Oct 2012 16:47:04 -0400
From: Richard Retanubun <richardretanubun@ruggedcom.com>
Organization: Ruggedcom
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        Tang Nguyen <TangNguyen@ruggedcom.com>,
        "m.grzeschik@pengutronix.de" <m.grzeschik@pengutronix.de>,
        Arvid Brodin <Arvid.Brodin@xdin.com>,
        linux-usb mailing list <linux-usb@vger.kernel.org>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>
Subject: Re: kmemleak report on isp1763 and sierra MC8705
References: <508B0743.9040806@ruggedcom.com> <20121026233509.GA26646@kroah.com>
In-Reply-To: <20121026233509.GA26646@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/10/12 07:35 PM, Greg KH wrote:
> On Fri, Oct 26, 2012 at 05:57:23PM -0400, Richard Retanubun wrote:
>> Hi Guys,
>>
>> I am debugging a reported kmemleak involving a sierra wireless MC8705 connected
>> through isp1763 on powerpc linux-3.0.22
>
> Does this also happen on 3.6.3?
>
> thanks,
>
> greg k-h

Hi Greg,

Unfortunately, it is not trivial for us to update the kernel on this platform,
Is there a specific experiment/patch I should look at for 3.0.22?

I will be attempting to use 3.6.3 on another platform, but this may take some time.

I am thinking there may be an action that can be done at /sysfs or /procfs to
do the disconnect without actually removing the power to the device.
I tried "echo 1 > /sys/bus/usb/drivers/usb/2-1.2/remove" and then take down the power
but this produced the same leak signature even before I take down the power.

Update on trigger to problem
============================
This will happen as the modem is powered down and /dev/ttyUSB from sierra is teared down
either by powering it off/removing it, or sending at!reset.

It does not happen when the same thing is done using a simple usb to serial converter (pl2303)

Focusing down on one of the dumps:

unreferenced object 0xd3849740 (size 8):
   comm "khubd", pid 1026, jiffies 232553037 (age 506.597s)
   hex dump (first 8 bytes):
     4d 43 38 37 30 35 00 00                          MC8705..
   backtrace:
     [<e30efd74>] usb_cache_string+0x74/0xac [usbcore]
     [<e30e77bc>] usb_enumerate_device+0x44/0xf8 [usbcore]
     [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68

I have a small question. How does the memory kmalloc-ed() in usb_cache_string is supposed to be released?
(during usb_serial_disconnect()?) Is the sierra driver is supposed to participate
in the tear down process (in sierra_release() maybe) and not doing something that is expected?
I am still missing the link between the actions done by the hub_thread() for the caching the stings
and the sierra driver code.

Thanks a lot for your time.
