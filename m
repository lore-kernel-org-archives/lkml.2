Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab1HHGkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 02:40:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab1HHGkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 02:40:23 -0400
Date: Mon, 8 Aug 2011 09:40:50 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Chris Wright <chrisw@redhat.com>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio/gen-pci: don't enable interrupts in ISR
Message-ID: <20110808064050.GC5182@redhat.com>
References: <20110804204606.GA19724@linutronix.de>
 <20110804210413.GA29222@redhat.com>
 <20110805191842.GA4224@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805191842.GA4224@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 09:18:42PM +0200, Sebastian Andrzej Siewior wrote:
> * Michael S. Tsirkin | 2011-08-05 00:04:13 [+0300]:
> 
> >> Looking at it further here is only one spot where the lock is hold. So
> >> giving the fact that an ISR is not reentrant and is not executed on two
> >> cpus at the same time why do we need a lock here?
> >
> >I'm not sure anymore. I think the idea was to use
> >it for synchronization down the road somehow,
> >but it never materialized. Let's drop that lock completely.
> Okay. So I post antoher patch with this lock removed and cc stable.
> 
> >> So there is _no_ protection
> >> against read-modify-write of user vs kernel so even that
> >> pci_block_user_cfg_access() is kinda pointless.
> >
> >I didn't get that. pci_block_user_cfg_access is to prevent
> >sysfs access while we read modify-write the command register.
> >Isn't it effective for that?
> It probably works well enough for you because you only care the one bit
> and don't change anything else in the kernel driver.
> 
> Lets assume user land changes another bit in this register:
> 
>     user                                kernel
>  read config()                             |
>    add a bit                               |
>      |                                  interrupt
>      |                                block user land
>      |                              read + clear + write
>      |                               unblock user land
>  write config back                         | 
> 
> 
> You did not *re-read* the config field after the interrupt so kernel's
> modifications are lost. So you get two interrupts accounted while only
> one happend.

So we might get an extra interrupt. This is harmless,
and the window seems small enough for this not to affect
performance. This will also never happen if
userspace is careful to make interrupt unmasking its last action.

> It seems to me that you could drop this "user block" thing
> since you never change anything outside of this command register and it
> does not stop the race.

I don't think so: if we did, we would lose userspace modifications to
other bits such as io enable, and there's no way to guess what their
values should be.

> >> pci_block_user_cfg_access() in open() + ->irqcontrol() should fix this.
> >
> >Why block in open? We don't access the device there, do we?
> Yeah. That might not work for you since you need change other values.
> 
> Sebastian
