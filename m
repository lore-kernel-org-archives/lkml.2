Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab0DIXeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 19:34:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755380Ab0DIXeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 19:34:16 -0400
Message-ID: <4BBFB925.7080606@redhat.com>
Date: Fri, 09 Apr 2010 20:32:53 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
       James Hogan <james@albanarts.com>, Jon Smirl <jonsmirl@gmail.com>,
       Pavel Machek <pavel@ucw.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net, jarod@redhat.com,
       jarod@wilsonet.com, kraxel@redhat.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>	 <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com>	 <4BAB7659.1040408@redhat.com> <201004090821.10435.james@albanarts.com>	 <1270810226.3764.34.camel@palomino.walls.org> <4BBF253A.8030406@redhat.com>	 <g2k829197381004091455m20368cc6r63df4a4f00d36b45@mail.gmail.com> <1270851240.3038.51.camel@palomino.walls.org>
In-Reply-To: <1270851240.3038.51.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Walls wrote:
> On Fri, 2010-04-09 at 17:55 -0400, Devin Heitmueller wrote:
>> On Fri, Apr 9, 2010 at 9:01 AM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>> [1] Basically, a keycode (like KEY_POWER) could be used to wake up the machine. So, by
>>> associating some scancode to KEY_POWER via ir-core, the driver can program the hardware
>>> to wake up the machine with the corresponding scancode. I can't see a need for a change at
>>> ir-core to implement such behavior. Of course, some attributes at sysfs can be added
>>> to enable or disable this feature, and to control the associated logic, but we first
>>> need to implement the wakeup feature at the hardware driver, and then adding some logic
>>> at ir-core to add the non-hardware specific code there.
>> Really?  Have you actually seen any hardware where a particular scan
>> code can be used to wake up the hardware?  The only hardware I have
>> seen has the ability to unsuspend on arrival of IR traffic, but you
>> didn't have the granularity to dictate that it only wake up on
>> particular scancodes.
> 
> The CX23888 and CX23102 can do it.  Basically any IR pulse pattern your
> heart desires; within reason.  And any carrier freq you want too; within
> reason.
> 
> But let's be real, the cx23885, cx231xx, and cx25840 modules are nowhere
> near properly supporing suspend/resume for their main video and DMA
> functions, AFAIK.

AFAIK, only saa7134 have a good suspend/resume code [1]. You may be watching TV,
do a suspend and waking the hardware again, and you'll keep seeing the same
channel (I tested it some time ago, when the proper suspend code were added,
on analog mode, with alsa enabled). Other drivers can suspend/resume, but
they won't properly restore the video registers, so, you'll see artifacts when
it returns.

So, yes, you're right: before any suspend/resume code on those drivers, we
first need to add some code to properly handle kernel threads and work queues
during suspend, and to restore all the registers to a sane state at resume,
before implementing IR wakeup on them.

In the case of mceusb, as there is already an userspace code for it on lirc,
it would probably not be that hard to make this feature to work with ir-core.

[1] Yet, none of the in-hardware decoders allow resume, AFAIK. With a software
decoder, the IR IRQ might be used to wake, but this means that everything,
even a glitch, would wake the hardware, so this won't work neither.

-- 

Cheers,
Mauro
