Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab0CYNky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 09:40:54 -0400
Received: from lucidpixels.com ([75.144.35.66]:39741 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab0CYNkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:40:52 -0400
Date: Thu, 25 Mar 2010 09:40:51 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       xorg@lists.freedesktop.org
cc: Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.33: Xorg+khubd lockup (D-state) BUG / ioctl EVIOCGNAME
 failed: Inappropriate ioctl for device / PreInit returned NULL
In-Reply-To: <alpine.DEB.2.00.1003250833040.13307@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.1003250935030.21591@p34.internal.lan>
References: <alpine.DEB.2.00.1003250800200.13307@p34.internal.lan> <alpine.DEB.2.00.1003250833040.13307@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Mar 2010, Justin Piszcz wrote:

>
>
> On Thu, 25 Mar 2010, Justin Piszcz wrote:
>
> The same problem has been reported by another person, he says his entire 
> system freezes, which, it appears to do unless you can SSH into the box:
> http://www.openoffice.org/issues/show_bug.cgi?id=76797
>
> Look at his lspci listing.
> james@dv6105us:~$ lspci
> 00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
> 00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
> 00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
>
> Here is mine:
> $ lspci
> 00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
> 00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
> 00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
> 00:00.3 RAM memory: nVidia Corporation C51 Memory Controller 5 (rev a2)
>
> Looks like the bug may be in the USB subsystem for this chipset.
>
> Justin.
>
>

Hi,

And there it goes again *LOCK*
root      2190  0.5  1.5  37832 31424 tty7     Ds+  09:00   0:12 /usr/bin/X :0 vt7 -nolisten tcp -auth /var/lib/xdm/authdir/authfiles/A:0-N5V00o

When this happens, the keyboard also stops working (if you try to go to
the console), e.g. caps lock doesn't light up anymore, etc..

Here is the oops with frame pointer enabled:

  2280.291281] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2280.291283] Xorg          D f38d5edc     0  2190   2177 0x00400004
[ 2280.291287]  f38d5ef0 00203082 00000002 f38d5edc c3203324 00000000 f38d5ec8 c13eb91d
[ 2280.291292]  c13f4c40 f7115234 f69904dc 00203292 001af807 f3845f40 c3203324 f38d5ecc
[ 2280.291296]  c15da000 c15dd324 c15e0480 00000001 f71150b0 f80ae94e f38d5ed0 f38d5ed4
[ 2280.291301] Call Trace:
[ 2280.291309]  [<c13eb91d>] ? schedule_timeout+0x11d/0x170
[ 2280.291318]  [<f80ae94e>] ? unlink1+0x2e/0xe0 [usbcore]
[ 2280.291322]  [<c128a13f>] ? put_device+0xf/0x20
[ 2280.291327]  [<f80afdcd>] usb_kill_urb+0x5d/0x90 [usbcore]
[ 2280.291331]  [<c105f840>] ? autoremove_wake_function+0x0/0x40
[ 2280.291334]  [<f812b7ae>] usbhid_close+0x6e/0x80 [usbhid]
[ 2280.291338]  [<c1304936>] hidinput_close+0x16/0x20
[ 2280.291342]  [<c12ed5c9>] input_close_device+0x49/0x70
[ 2280.291344]  [<c12f08f0>] evdev_release+0x80/0xa0
[ 2280.291348]  [<c10ab99e>] __fput+0xce/0x1c0
[ 2280.291351]  [<c10abaa5>] fput+0x15/0x20
[ 2280.291353]  [<c10a8a97>] filp_close+0x47/0x70
[ 2280.291356]  [<c10a8b1a>] sys_close+0x5a/0xa0
[ 2280.291358]  [<c1023550>] sysenter_do_call+0x12/0x26
[ 2400.291277] INFO: task Xorg:2190 blocked for more than 120 seconds.
[ 2400.291280] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2400.291283] Xorg          D f38d5edc     0  2190   2177 0x00400004
[ 2400.291287]  f38d5ef0 00203082 00000002 f38d5edc c3203324 00000000 f38d5ec8 c13eb91d
[ 2400.291292]  c13f4c40 f7115234 f69904dc 00203292 001af807 f3845f40 c3203324 f38d5ecc
[ 2400.291296]  c15da000 c15dd324 c15e0480 00000001 f71150b0 f80ae94e f38d5ed0 f38d5ed4
[ 2400.291300] Call Trace:
[ 2400.291307]  [<c13eb91d>] ? schedule_timeout+0x11d/0x170
[ 2400.291315]  [<f80ae94e>] ? unlink1+0x2e/0xe0 [usbcore]
[ 2400.291319]  [<c128a13f>] ? put_device+0xf/0x20
[ 2400.291324]  [<f80afdcd>] usb_kill_urb+0x5d/0x90 [usbcore]
[ 2400.291328]  [<c105f840>] ? autoremove_wake_function+0x0/0x40
[ 2400.291331]  [<f812b7ae>] usbhid_close+0x6e/0x80 [usbhid]
[ 2400.291335]  [<c1304936>] hidinput_close+0x16/0x20
[ 2400.291338]  [<c12ed5c9>] input_close_device+0x49/0x70
[ 2400.291341]  [<c12f08f0>] evdev_release+0x80/0xa0
[ 2400.291345]  [<c10ab99e>] __fput+0xce/0x1c0
[ 2400.291347]  [<c10abaa5>] fput+0x15/0x20
[ 2400.291350]  [<c10a8a97>] filp_close+0x47/0x70
[ 2400.291352]  [<c10a8b1a>] sys_close+0x5a/0xa0
[ 2400.291355]  [<c1023550>] sysenter_do_call+0x12/0x26

Justin.
