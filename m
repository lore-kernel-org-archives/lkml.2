Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab2EDDe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 23:34:27 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:52068 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab2EDDe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 23:34:26 -0400
Subject: Re: linux-next: Tree for Apr 20 (usb & target)
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        target-devel@vger.kernel.org, Felipe Balbi <balbi@ti.com>
In-Reply-To: <20120422190136.GA31242@linutronix.de>
References: <20120420155151.3fcac4c2d1002ade5ccf44ac@canb.auug.org.au>
	 <4F91D9D9.6020609@xenotime.net>
	 <1334999263.30707.129.camel@haakon2.linux-iscsi.org>
	 <20120421153402.GA22953@kroah.com>  <20120422190136.GA31242@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 May 2012 20:34:23 -0700
Message-ID: <1336102463.22393.121.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-22 at 21:01 +0200, Sebastian Andrzej Siewior wrote:
> * Greg KH | 2012-04-21 08:34:02 [-0700]:
> 
> >> > CONFIG_MODULES is not enabled.
> >> > CONFIG_TCM_USB_GADGET=y
> >> > CONFIG_USB_GADGET=y
> >> 
> >> Sebastian + Greg-KH (Cc'ed), any ideas why this is the case here..?
> >
> >I have no idea, sorry.
> 
> The short version:
> in order to fix this either move the usb-target-gadget to
> drivers/usb/gadget/Kconfig and make sure only one gadget can be compiled
> at a time or add some kind of depends.
> 
> The longer version:
> This is a short comming of the gadget framework. We are able to build
> multiple UDCs at a time and we can build multiple gadgets _as_ modules.
> Since we can not bind & configure via an interface the whole thing works
> right now via "modprobe $gadget. There is some infrastructure to accept
> multiple UDCs/gadget but the *whole* thing is not complete.
> In non-modules mode you can only select one gadget at a time. With the
> target gadget living outside of usb/gadget selection it is possible to
> select both at the same time which causes the duplicate symbols here.
> A "quick" fix is not to define all the functions static and put
> maybe_unsued on each function to avoid warnings. This is only duct tape
> on top and I would prefer that nobody is sending such a patch. The
> result is hardly usefull by a user.
> A real fix would to get rid of the "#includes foo.c" and use a helper
> module/library instead.
> I tried this once and notice that the whole thing relies on
> static/global variables which are initialized once on modprobe. So
> with the second module loaded (read as rmmod $mod1 && modprobe $mod2)
> the gadget framework explodes. Once I noticed that, the patches got out
> of Felipe's tree before anyone noticed something. That means we should
> first get rid of the global variables and then maybe try again :)
> 

Hey Sebastian & USB folks,

So I'm catching up on for-next-merge stuff after being away last week,
and ended up following your advice to just move tcm_usb_gadget code into
drivers/usb/gadget/ in to address the legacy requirements above..

After the recommended change, the in-kernel config using a single gadget
driver (the target) are able to build.  Thanks for the detailed
explanation btw.. ;)

I've made the same change for tcm_usb_gadget in lio-core, and updated
for-next-merge with the following merge patch:

http://git.kernel.org/?p=linux/kernel/git/nab/target-pending.git;a=commit;h=0c41520201bc0933d65b8644173802778f426234

Please let me know if you have any other changes that should go into
sunday's linux-next build.

Thanks!

--nab

