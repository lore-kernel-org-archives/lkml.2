Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab1CaRmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 13:42:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45670 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab1CaRmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 13:42:54 -0400
Date: Thu, 31 Mar 2011 18:42:47 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: jacob pan <jacob.jun.pan@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jamie Iles <jamie@jamieiles.com>,
        LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] clocksource: clocksource/clockevent driver for Synopsys
 dw_apb_timer
Message-ID: <20110331174247.GE3371@pulham.picochip.com>
References: <1301584372-26261-1-git-send-email-jamie@jamieiles.com>
 <alpine.LFD.2.00.1103311719420.22418@localhost6.localdomain6>
 <20110331095051.7933c7b9@jacob-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331095051.7933c7b9@jacob-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 09:50:51AM -0700, jacob pan wrote:
> On Thu, 31 Mar 2011 17:33:12 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Thu, 31 Mar 2011, Jamie Iles wrote:
> > 
> > > This patch adds a driver for the Synopsys DesignWare APB timer block
> > > found in some ARM systems.  This uses the timers with an IRQ as a
> > > clockevents device and a timer without an IRQ as a clocksource
> > > device.
> > 
> > Interesting. That's probably the same thing as:
> > 
> >      arch/x86/kernel/apb_timer.c
> > 
> > So if we merge that thing, then we should make sure, that we can
> > replace the x86 one with it.
> > 
> It seems we have room to consolidate, here is my 2c:
> 1. need to support multiple timer channels
> 2. support percpu clockevent, need to deal with cpu online/offline
> 3. early boot needs. I don't know if abp timer is needed for booting on
> ARM platforms. But for Moorestown, we need timer before platform bus
> running. So I guess we cannot enumerate the timer as platform device.

ARM does need it quite early to calibrate the delay loop but I've been 
registering it early by creating an early_platform_device.  The other 
difference is that x86 doesn't support the clk API.

How about factoring out the clockevent and clocksource operations 
(.set_next_event, .set_mode, .read etc) and the bits that actually drive 
the hardware into an apb_timer.c then have stuff that does platform 
device registration or langwell specific stuff in a higher layer?

It looks like arch/x86/kernel/apb_timer.c would still need some lower 
level access to the timers for doing things like the calibration in 
apbt_quick_calibrate() before registering the clocksource.

Jamie
