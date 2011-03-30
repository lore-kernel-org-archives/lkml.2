Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab1C3OLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:11:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34633 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab1C3OLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:11:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=X3yKs+Fo5xehTx9roMkpqyrLL0Mr4MOT8L2UJSkN8gKHa/Y7laUqKaMvZYRXQd2fgO
         NXx7YWerKpZwr/b9SSdpsmV+jVducE7i8Rb9qoQ87v9zcWMXgLJDym2GcR7qYQj5Cdka
         xzBFtikRKOm3VDMyPQ2fox7sHaCdR2+AQcBoI=
Message-ID: <4D933A05.10603@gmail.com>
Date: Wed, 30 Mar 2011 16:11:17 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Rafael J. Wysocki" <rjw@suse.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Resume hangs [was: mmotm 2010-12-02-16-34 uploaded]
References: <Pine.LNX.4.44L0.1102221029100.1968-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1102221029100.1968-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 04:36 PM, Alan Stern wrote:
> On Tue, 22 Feb 2011, Jiri Slaby wrote:
> 
>> On 02/04/2011 08:33 PM, Alan Stern wrote:
>>> On Fri, 4 Feb 2011, Jiri Slaby wrote:
>>>
>>>>>> It seems to suffice... No hangs still. Should I enable pm_async back
>>>>>> again to confirm the issue is still present?
>>>>>
>>>>> Yes, please, it would be good to know for sure.
>>>>
>>>> Ok, confirmed right now :).
>>>>
>>>> I disabled pm_async for USB again. What do you suggest next?
>>>
>>> What happens if you leave pm_async enabled but unplug all the USB 
>>> devices before suspending?  If there are any USB devices you can't 
>>> unplug, you can get an equivalent result by unconfiguring the root 
>>> hubs:
>>>
>>> 	for a in /sys/bus/usb/devices/usb* ; do
>>> 		echo 0 >$a/bConfigurationValue
>>> 	done
>>
>> This doesn't seem to help. The hang happened 3 times during the 2 weeks.
>>
>> I have /etc/pm/sleep.d/99usb-debug with:
>> #!/bin/bash
>>
>> send() {
>>         for a in /sys/bus/usb/devices/usb* ; do
>>                 echo $1 >$a/bConfigurationValue
>>         done
>> }
>>
>> case "$1" in
>>         hibernate|suspend)
>>                         send 0
>>                 ;;
>>         thaw|resume)
>>                         send 1
>>                 ;;
>>         *)
>>                 ;;
>> esac
>>
>> exit 0
>>
>> And it indeed properly enable/disable usb before/after suspend.
> 
> Strange indeed.  It's worth noting that the async stuff affects only
> the normal suspend and resume operations, not the late-suspend and
> early-resume operations.  This means that it all likelihood, the system
> crashes either before finishing the suspend or after doing a fair
> amount of the resume.  And yet that's not consistent with what you see
> on the screen.
> 
> By the way, are you booting with no_console_suspend?  And do you do 
> "echo 8 >/proc/sys/kernel/printk" (or equivalently, Alt-SysRq-8) before 
> suspending?

I'm testing this on my desktop. I found out yesterday, that I had async
completely disabled. So I have no output yet.

I took my dvb-t tuner from desktop and connected it to my notebook. And
got a similar hang during resume right now. It may not be related
though. The trace is:
s2disk          D 0000000000000000     0  6125   5902 0x00000004
 ffff8800797aba78 0000000000000082 ffff8800797ab9f8 0000000000012ac0
 ffff8800797abfd8 0000000000012ac0 ffff8800797abfd8 ffff8800797abfd8
 ffff8800777fe7f0 0000000000012ac0 0000000000012ac0 ffff8800797aa000
Call Trace:
 [<ffffffff8151e2ed>] schedule_timeout+0x28d/0x310
 [<ffffffff8151d410>] wait_for_common+0xc0/0x150
 [<ffffffff8133ad22>] _request_firmware+0x132/0x270
 [<ffffffffa06df2c7>] dvb_usb_download_firmware+0x37/0xf0 [dvb_usb]
 [<ffffffffa06dfbe5>] dvb_usb_device_init+0x165/0x1b0 [dvb_usb]
 [<ffffffffa06d6c27>] af9015_usb_probe+0x87/0xa0 [dvb_usb_af9015]
 [<ffffffff8138d9d2>] usb_probe_interface+0x142/0x270
 [<ffffffff8132f3c0>] really_probe+0x70/0x220
 [<ffffffff8132f757>] driver_probe_device+0x47/0xa0
 [<ffffffff8132e19c>] bus_for_each_drv+0x5c/0x90
 [<ffffffff8132f62f>] device_attach+0x8f/0xb0
 [<ffffffff8138d5b0>] usb_rebind_intf+0x60/0xa0
 [<ffffffff8138d6c7>] do_unbind_rebind+0x77/0xb0
 [<ffffffff8138d76b>] usb_resume+0x6b/0xb0
 [<ffffffff8137f96b>] usb_dev_complete+0xb/0x10
 [<ffffffff81334d1e>] device_complete+0x8e/0xe0
 [<ffffffff81335da1>] dpm_resume_end+0xa1/0x120
 [<ffffffff8109d890>] hibernation_snapshot+0xc0/0x120
 [<ffffffff810a1cde>] snapshot_ioctl+0x3ae/0x590
 [<ffffffff81169794>] do_vfs_ioctl+0x84/0x2f0
 [<ffffffff81169a98>] sys_ioctl+0x98/0xa0
 [<ffffffff81002ed2>] system_call_fastpath+0x16/0x1b
 [<00007fe6c82f8ce7>] 0x7fe6c82f8ce7


The firmware request should time out. I think I waited for longer than
60 s before when I saw the hangs on the desktop, But do you have an idea
why it doesn't load the FW immediately?

The device is:
Bus 001 Device 010: ID 0413:6029 Leadtek Research, Inc. WinFast DTV
Dongle Gold
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x0413 Leadtek Research, Inc.
  idProduct          0x6029 WinFast DTV Dongle Gold
  bcdDevice            2.00
  iManufacturer           1 Leadtek
  iProduct                2 WinFast DTV Dongle Gold
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           71
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.01
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      65
         Report Descriptors:
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval              16
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

thanks,
-- 
js
