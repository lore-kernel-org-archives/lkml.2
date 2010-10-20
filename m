Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab0JTWoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 18:44:09 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58295 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab0JTWoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 18:44:07 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.69.160]
In-Reply-To: <201010192308.02018.arnd@arndb.de>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
 <201010191921.21007.arnd@arndb.de> <AANLkTinXR7OcfTpA6cWhRGzceekD6KQgnxOLeBKXP3WB@mail.gmail.com>
 <201010192308.02018.arnd@arndb.de>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 21 Oct 2010 00:43:45 +0200
Message-ID: <AANLkTikz-_qhjygzek4tR0CtDLih3ZQyy1mPKnXAiOiV@mail.gmail.com>
Subject: Re: [PATCH 1/3] drivers: misc: add omap_hwspinlock driver
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Hari Kanigeri <h-kanigeri2@ti.com>,
        Suman Anna <s-anna@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        akpm@linux-foundation.org, linux-omap@vger.kernel.org,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 11:08 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> Right. There are two more things to consider though:
>
> If you know that interrupts are disabled, you may still want to avoid
> having to save the interrupt flag to the stack, to save some cycles
> saving and restoring it. I don't know how expensive that is on ARM,
> some other architectures take an microseconds to restore the interrupt
> enabled flag from a register.

To do this we need to introduce a new set of API which will not
disable interrupts, and which should only be used when the caller
knows that interrupts are already disabled.

This will save some cycles, but my concern is that this API will be
abused by drivers, and will eventually be used to take the hwspinlocks
for lengthy period of times (which might even involve sleeping).

Given that the access to the L4 interconnect is anyway slow I also
feel that the gain is negligible.

Nevertheless, it's a viable way to squeeze some cycles.

We don't have a use case in which we know the interrupts are already
disabled, but when we will, we will consider adding such API.

> Even in the case where you know that interrupts are enabled, you may
> want to avoid saving the interrupt flag to the stack, the simpler
> API (one argument instead of two) gives less room for screwing up.

This sounds like adding a set of API that resembles spin_{unlock,lock}_irq.

My gut feeling here is that while this may be useful and simple at
certain places, it is somewhat error prone; a driver which would
erroneously use this at the wrong place will end up enabling
interrupts where it really shouldn't.

Don't you feel that proving a simple spin_lock_irqsave-like API is
actually safer and less error prone ?

I guess that is one of the reasons why spin_lock_irqsave is much more
popular than spin_lock_irq - people just know it will never screw up.

Thanks,
Ohad.
