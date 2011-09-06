Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab1IFUdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 16:33:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52521 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab1IFUdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 16:33:43 -0400
Date: Tue, 6 Sep 2011 22:33:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] clockevents: Use an atomic RCU notifier for clockevents
Message-ID: <20110906203338.GL7761@one.firstfloor.org>
References: <1314652136-11350-1-git-send-email-andi@firstfloor.org> <alpine.LFD.2.02.1109062120420.2723@ionos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1109062120420.2723@ionos>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 09:23:55PM +0200, Thomas Gleixner wrote:
> On Mon, 29 Aug 2011, Andi Kleen wrote:
> 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Use an atomic_notifier instead of a raw_notifier for the clockevents
> > notification.
> > 
> > This avoids a global lock in the idle path, is a scalability
> > problem. With this patch we don't have a global lock anymore
> > at least on systems with an always running timer.
> 
> And why is that code called on a system with an always running local
> apic timer at all? The broadcast horror is explicitely only for those
> systems with wreckaged hardware.

Because the notifier is before the check for always running local apic timer.

clockevents_notify ->
clockevents_do_notify ->           
	raw_spin_lock_irqsave(&clockevents_lock, flags);
	clockevents_do_notify(reason, arg);

tick_notifier ->
tick_notify -> 
tick_broadcast_on_off -> 
tick_do_broadcast_on_off

	/* check */
	if (!dev || !(dev->features & CLOCK_EVT_FEAT_C3STOP))
		goto out;

You also get bonus points for a incredible convoluted call chain,
about 50% of it being unnecessary and full of scalability problems.

-Andi
