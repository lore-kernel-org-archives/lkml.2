Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602Ab0LUIDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 03:03:19 -0500
Received: from relay02.digicable.hu ([92.249.128.188]:49350 "EHLO
	relay02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab0LUIDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 03:03:18 -0500
Message-ID: <4D105F3F.5070702@freemail.hu>
Date: Tue, 21 Dec 2010 09:03:11 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Max Vozeler <max@vozeler.com>
CC: gregkh <gregkh@suse.de>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>, usbip-devel@lists.sourceforge.net
Subject: Re: usbip: sometimes stalls at kernel_recvmsg()
References: <4D06A004.8070502@freemail.hu> <4D09C056.5020305@freemail.hu> <4D0A97B3.2090701@vozeler.com> <4D0AF910.8070202@freemail.hu> <4D0FD725.5000609@vozeler.com>
In-Reply-To: <4D0FD725.5000609@vozeler.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 94.21.187.135
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Max,
Max Vozeler wrote:
> Hi Németh,
> 
> On 17.12.2010 06:45, Németh Márton wrote:
>>>> Németh Márton wrote:
>>>>> I'm working with usbip and I sometimes see a stall when I run
>>>>> the "lsusb" command from the userspace. 
>>> Does it eventually recover?
>> No, it doesn't. After 120 seconds messages are printed in dmesg
>> that the "lsusb" process is blocked more than 120 seconds.
> 
> Can you describe the sequence of events which
> happened before the hang?

Boot EeePC 901. Attach hama AC-150 webcam. Execute the following
commands as root:

echo 0 >/sys/devices/platform/eeepc/camera
insmod /usr/src/linux/drivers/staging/usbip/usbip_common_mod.ko
insmod /usr/src/linux/drivers/staging/usbip/usbip.ko
usbip_bind_driver --list
usbip_bind_driver --usbip 3-2
usbipd

On a second xterm window execute the following commands:
insmod /usr/src/linux/drivers/staging/usbip/vhci-hcd.ko
lsusb
usbip --list localhost
usbip -a localhost 3-2
usbip -p
strace lsusb

Note that the hama AC-150 webcam has a snapshot button on it which
uses the interrupt endpoint. The interrupt URB is sent in when the
gspca_sonixj driver activates in order to catch the button events.
The hang maybe related, I don't know.

> 
> Was the device detached before or during lsusb?
> 
> Perhaps try echo t > /proc/sysrq-trigger to see
> where exactly lsusb gets stuck.
> 
> I found processes can get stuck in usb_kill_urb 
> if they tried to unlink an URB, but the unlink
> request was not answered before detach.
> 
> Perhaps this is related. I am attaching a patch
> which fixes that bug for me, perhaps you could 
> try if it makes a difference?

I'll try your patch later, thanks.

> 
>>>>> I added some debug messages
>>>>> and it seems that the kernel_recvmsg() in
>>>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/staging/usbip/usbip_common.c;h=210ef16bab8d271a52e5d36cd1994aad57ad99e1;hb=HEAD
>>>>>
>>>>> This is the only place I could find where the TCP messages are arriving in
>>>>> the usbip code.
>>>>>
>>>>> What happens if a message does not arrive? Does it stall forever? 
>>> Yes, it will block until detached or until a TCP
>>> timeout or error closes the connection.
>>>
>>> The TCP timeout can take several minutes.
>> What I don't really understand is that how is it possible that
>> a packet from TCP communication is lost? TCP resends the lost
>> packets automatically. In my case I run both the usbip server
>> and client on the same machine using the host name "localhost".
>> So I assume that there might be a protocol handshake problem
>> here.
> 
> Agreed, it doesn't seem like a TCP error is 
> causing the hang in this case.
> 
> 	Max
> 
> 

