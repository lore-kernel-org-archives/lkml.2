Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab2BPO7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:59:06 -0500
Received: from relay1.sgi.com ([192.48.179.29]:36098 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056Ab2BPO7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:59:02 -0500
Date: Thu, 16 Feb 2012 08:59:00 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
Message-ID: <20120216145900.GA3772@sgi.com>
References: <20111108191149.GA7236@sgi.com>
 <alpine.LFD.2.02.1202151512420.2794@ionos>
 <20120215143710.GA10543@sgi.com>
 <alpine.LFD.2.02.1202151547520.2794@ionos>
 <20120215153438.GB11343@sgi.com>
 <alpine.LFD.2.02.1202152131280.2794@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1202152131280.2794@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 09:36:47PM +0100, Thomas Gleixner wrote:
> On Wed, 15 Feb 2012, Dimitri Sivanich wrote:
> > On Wed, Feb 15, 2012 at 03:52:06PM +0100, Thomas Gleixner wrote:
> > > So the first CPU which registers a clock event device takes it. That's
> > > the boot CPU, no matter what.
> > >
> > Both kernel tracing and the original patch that I proposed for this
> > showed plainly (at the time) that the tick_do_timer_cpu was not always cpu 0
> > prior to modifying it for nohz=off.  Maybe that is no longer the case?
> 
> This logic has not been changed in years.

I did some tracing of all points where tick_do_timer_cpu is set in the
3.3.0-rc3+ kernel.

> 
> tick_do_timer_cpu is initialized to TICK_DO_TIMER_BOOT and the first
> cpu which registers either a global or a per cpu clock event device
> takes it over. This is at least on x86 always the boot cpu, i.e. cpu0.
> After that point nothing touches that variable when nohz is disabled
> (runtime or compile time).

At that point it is set to cpu 0.  However, when we go into highres mode
it does change.  Below are the two places it was set during boot with
nohz=off on one of our x86 based machines.

[    0.000000] tick_setup_device: tick_do_timer_cpu 0
[    1.924098] tick_broadcast_setup_oneshot: tick_do_timer_cpu 17

So in this example it's now cpu 17, and it stays that way from that point on.

A traceback at that point shows tick_init_highres is indeed initiating this:

[    1.924863]  [<ffffffff81087e01>] tick_broadcast_setup_oneshot+0x71/0x160
[    1.924863]  [<ffffffff81087f23>] tick_broadcast_switch_to_oneshot+0x33/0x50
[    1.924863]  [<ffffffff81088841>] tick_switch_to_oneshot+0x81/0xd0
[    1.924863]  [<ffffffff810888a0>] tick_init_highres+0x10/0x20
[    1.924863]  [<ffffffff81061e71>] hrtimer_run_pending+0x71/0xd0

> 
> So I really want to see proper proof why that would not be the
> case. If it really happens then we fix the root cause instead of
> adding random sysfs interfaces.

If you're willing to consider it a bug that tick_do_timer_cpu is not cpu 0,
than I'm very much in agreement.

> 
> Thanks,
> 
> 	tglx
