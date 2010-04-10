Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab0DJAil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 20:38:41 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:35814 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145Ab0DJAih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 20:38:37 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-01.arcor-online.net 57F53332676
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR  system?
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andy Walls <awalls@radix.net>,
       Devin Heitmueller <dheitmueller@kernellabs.com>,
       James Hogan <james@albanarts.com>, Jon Smirl <jonsmirl@gmail.com>,
       Pavel Machek <pavel@ucw.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net, jarod@redhat.com,
       jarod@wilsonet.com, kraxel@redhat.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       superm1@ubuntu.com
In-Reply-To: <4BBFB925.7080606@redhat.com>
References: <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
	 <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com>
	 <4BAB7659.1040408@redhat.com> <201004090821.10435.james@albanarts.com>
	 <1270810226.3764.34.camel@palomino.walls.org> <4BBF253A.8030406@redhat.com>
	 <g2k829197381004091455m20368cc6r63df4a4f00d36b45@mail.gmail.com>
	 <1270851240.3038.51.camel@palomino.walls.org> <4BBFB925.7080606@redhat.com>
Content-Type: text/plain
Date: Sat, 10 Apr 2010 02:38:23 +0200
Message-Id: <1270859903.8003.16.camel@pc07.localdom.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Am Freitag, den 09.04.2010, 20:32 -0300 schrieb Mauro Carvalho Chehab:
> Andy Walls wrote:
> > On Fri, 2010-04-09 at 17:55 -0400, Devin Heitmueller wrote:
> >> On Fri, Apr 9, 2010 at 9:01 AM, Mauro Carvalho Chehab
> >> <mchehab@redhat.com> wrote:
> >>> [1] Basically, a keycode (like KEY_POWER) could be used to wake up the machine. So, by
> >>> associating some scancode to KEY_POWER via ir-core, the driver can program the hardware
> >>> to wake up the machine with the corresponding scancode. I can't see a need for a change at
> >>> ir-core to implement such behavior. Of course, some attributes at sysfs can be added
> >>> to enable or disable this feature, and to control the associated logic, but we first
> >>> need to implement the wakeup feature at the hardware driver, and then adding some logic
> >>> at ir-core to add the non-hardware specific code there.
> >> Really?  Have you actually seen any hardware where a particular scan
> >> code can be used to wake up the hardware?  The only hardware I have
> >> seen has the ability to unsuspend on arrival of IR traffic, but you
> >> didn't have the granularity to dictate that it only wake up on
> >> particular scancodes.
> > 
> > The CX23888 and CX23102 can do it.  Basically any IR pulse pattern your
> > heart desires; within reason.  And any carrier freq you want too; within
> > reason.
> > 
> > But let's be real, the cx23885, cx231xx, and cx25840 modules are nowhere
> > near properly supporing suspend/resume for their main video and DMA
> > functions, AFAIK.
> 
> AFAIK, only saa7134 have a good suspend/resume code [1]. You may be watching TV,
> do a suspend and waking the hardware again, and you'll keep seeing the same
> channel (I tested it some time ago, when the proper suspend code were added,
> on analog mode, with alsa enabled). Other drivers can suspend/resume, but
> they won't properly restore the video registers, so, you'll see artifacts when
> it returns.

Yes, that was Maxim with enough testers around and Matthias Schwarzott
had fixes.

To remind, we don't recover from suspend on DVB, needs to reload the
driver once. We are also not MFE ready with mixed init calls through v4l
and dvb.

But yes, analog is on leading edge on that ;)

Cheers,
Hermann

> So, yes, you're right: before any suspend/resume code on those drivers, we
> first need to add some code to properly handle kernel threads and work queues
> during suspend, and to restore all the registers to a sane state at resume,
> before implementing IR wakeup on them.
> 
> In the case of mceusb, as there is already an userspace code for it on lirc,
> it would probably not be that hard to make this feature to work with ir-core.
> 
> [1] Yet, none of the in-hardware decoders allow resume, AFAIK. With a software
> decoder, the IR IRQ might be used to wake, but this means that everything,
> even a glitch, would wake the hardware, so this won't work neither.
> 

