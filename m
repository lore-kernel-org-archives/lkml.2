Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab1ASPTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 10:19:08 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59256 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab1ASPTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 10:19:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lUbCysfQM36lQJV6R772CSapAfmMdBFRWnwB+NhrAyhgrbAxEbLmyYwiHLFDPsVx0C
         RIMEU1KCEgJ/bweWweuEpXr6yfS5X+946KtHkI7yEAAwaUk+IXjwQRPoFAXdfJyl7nya
         NDtjZd9qBCz+OtXP7IskeJZQPHzWZgIXK7bWI=
MIME-Version: 1.0
In-Reply-To: <20110119092011.GA23624@darkstar>
References: <20110119092011.GA23624@darkstar>
Date: Wed, 19 Jan 2011 23:18:49 +0800
Message-ID: <AANLkTinNVJXjL9a=Jmp34ktT7OLkGKzpm79j605vvCWe@mail.gmail.com>
Subject: Re: [PATCH] usb otg: use atomic notifier instead of blocking notifier
From: Ming Lei <tom.leiming@gmail.com>
To: Yang Ruirui <ruirui.r.yang@tieto.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Felipe Balbi <felipe.balbi@nokia.com>,
        Heikki Krogerus <ext-heikki.krogerus@nokia.com>,
        Tejun Heo <tj@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Hema HK <hemahk@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yang,

2011/1/19 Yang Ruirui <ruirui.r.yang@tieto.com>:
> [   28.990997] [<c00326a0>] (unwind_backtrace+0x0/0xec) from [<c007a39c>] (print_usage_bug+0x170/0x1b4)
> [   29.007293] [<c007a39c>] (print_usage_bug+0x170/0x1b4) from [<c007a738>] (mark_lock+0x358/0x628)
> [   29.019836] [<c007a738>] (mark_lock+0x358/0x628) from [<c007c118>] (__lock_acquire+0x554/0x1730)
> [   29.032409] [<c007c118>] (__lock_acquire+0x554/0x1730) from [<c007d354>] (lock_acquire+0x60/0x74)
> [   29.045166] [<c007d354>] (lock_acquire+0x60/0x74) from [<c037e6d8>] (down_read+0x48/0x5c)
> [   29.057250] [<c037e6d8>] (down_read+0x48/0x5c) from [<c0070770>] (__blocking_notifier_call_chain+0x2c/0x5c)
> [   29.074920] [<c0070770>] (__blocking_notifier_call_chain+0x2c/0x5c) from [<c00707b4>] (blocking_notifier_call_chain+0x14/0x18)
> [   29.094573] [<c00707b4>] (blocking_notifier_call_chain+0x14/0x18) from [<c02784d8>] (musb_gadget_vbus_draw+0x38/0x60)

I am a little confused, why is blocking_notifier_call_chain called from
musb_gadget_vbus_draw?  See source code of musb_gadget_vbus_draw:

1587 static int musb_gadget_vbus_draw(struct usb_gadget *gadget, unsigned mA)
1588 {
1589     struct musb *musb = gadget_to_musb(gadget);
1590
1591     if (!musb->xceiv->set_power)
1592         return -EOPNOTSUPP;
1593     return otg_set_power(musb->xceiv, mA);
1594 }

>
> Actually the blocking notifier chain runs in process context, so not fit for use here.
>
> For mainline kernel there's such issue as well.
> Here fix this problem by changing to use atomic_notifier.

Are you sure the issue can be reproduced in 2.6.37 or -next tree?

In mainline code(2.6.37), blocking_notifier_call_chain is only called in
threaded irq handler of otg driver wrt. musb driver, so seems enough.

thanks,
-- 
Lei Ming
