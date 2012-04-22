Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab2DVTBr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 15:01:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:53043 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab2DVTBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 15:01:45 -0400
Date: Sun, 22 Apr 2012 21:01:36 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        target-devel@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Subject: Re: linux-next: Tree for Apr 20 (usb & target)
Message-ID: <20120422190136.GA31242@linutronix.de>
References: <20120420155151.3fcac4c2d1002ade5ccf44ac@canb.auug.org.au>
 <4F91D9D9.6020609@xenotime.net>
 <1334999263.30707.129.camel@haakon2.linux-iscsi.org>
 <20120421153402.GA22953@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120421153402.GA22953@kroah.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH | 2012-04-21 08:34:02 [-0700]:

>> > CONFIG_MODULES is not enabled.
>> > CONFIG_TCM_USB_GADGET=y
>> > CONFIG_USB_GADGET=y
>> 
>> Sebastian + Greg-KH (Cc'ed), any ideas why this is the case here..?
>
>I have no idea, sorry.

The short version:
in order to fix this either move the usb-target-gadget to
drivers/usb/gadget/Kconfig and make sure only one gadget can be compiled
at a time or add some kind of depends.

The longer version:
This is a short comming of the gadget framework. We are able to build
multiple UDCs at a time and we can build multiple gadgets _as_ modules.
Since we can not bind & configure via an interface the whole thing works
right now via "modprobe $gadget. There is some infrastructure to accept
multiple UDCs/gadget but the *whole* thing is not complete.
In non-modules mode you can only select one gadget at a time. With the
target gadget living outside of usb/gadget selection it is possible to
select both at the same time which causes the duplicate symbols here.
A "quick" fix is not to define all the functions static and put
maybe_unsued on each function to avoid warnings. This is only duct tape
on top and I would prefer that nobody is sending such a patch. The
result is hardly usefull by a user.
A real fix would to get rid of the "#includes foo.c" and use a helper
module/library instead.
I tried this once and notice that the whole thing relies on
static/global variables which are initialized once on modprobe. So
with the second module loaded (read as rmmod $mod1 && modprobe $mod2)
the gadget framework explodes. Once I noticed that, the patches got out
of Felipe's tree before anyone noticed something. That means we should
first get rid of the global variables and then maybe try again :)

Sebastian
