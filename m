Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab0LAQYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 11:24:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab0LAQYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 11:24:37 -0500
Date: Wed, 1 Dec 2010 11:23:35 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jason Wessel <jason.wessel@windriver.com>,
        Don Zickus <dzickus@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
Subject: Re: perf hw  in kexeced kernel broken in tip
Message-ID: <20101201162335.GB2511@redhat.com>
References: <4CF60095.1020900@kernel.org>
 <1291202867.4023.3.camel@twins>
 <20101201160640.GA2511@redhat.com>
 <1291219906.32004.1671.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291219906.32004.1671.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 05:11:46PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-12-01 at 11:06 -0500, Vivek Goyal wrote:
> > On Wed, Dec 01, 2010 at 12:27:47PM +0100, Peter Zijlstra wrote:
> > > On Wed, 2010-12-01 at 00:00 -0800, Yinghai Lu wrote:
> > > > First kernel:
> > > > [    1.139418] calling  init_hw_perf_events+0x0/0xb77 @ 1
> > > > [    1.159111] Performance Events: PEBS fmt1+, Nehalem events, Intel PMU
> > > > driver.
> > > > [    1.159567] ... version:                3
> > > > [    1.179121] ... bit width:              48
> > > > [    1.179353] ... generic registers:      4
> > > > [    1.179593] ... value mask:             0000ffffffffffff
> > > > [    1.199211] ... max period:             000000007fffffff
> > > > [    1.199554] ... fixed-purpose events:   3
> > > > [    1.219108] ... event mask:             000000070000000f
> > > > [    1.219454] initcall init_hw_perf_events+0x0/0xb77 returned 0 after
> > > > 11719 usecs
> > > > 
> > > > .....
> > > > [   20.220997] checking TSC synchronization [CPU#0 -> CPU#11]: passed.
> > > > [   20.260818] NMI watchdog enabled, takes one hw-pmu counter.
> > > > 
> > > > kexeced kernel.
> > > > 
> > > > 
> > > > [    1.169470] calling  init_hw_perf_events+0x0/0xb77 @ 1
> > > > [    1.189265] Performance Events: PEBS fmt1+, Nehalem events, Broken
> > > > PMU hardware detected, software events only.
> > > > ...
> > > > [   21.010407] NMI watchdog failed to create perf event on cpu14:
> > > > fffffffffffffffe
> > > > 
> > > > caused by:
> > > 
> > > *sigh*, and people ask me why kexec/kdump are such bad ideas..
> > > 
> > > apparently kexec doesn't properly shut down the first kernel and leaves
> > > a counter running, then when we write and read the counter value they
> > > don't match because its still running and voila, crap happens.
> > > 
> > > I've CC'ed the kexec people, maybe they got clue as to how to sort this.
> > 
> > So we can shutdown counters while first kernel is going down. Is there a
> > simple function already which I can call?
> 
> Dunno, the cpu hotplug stuff should suffice I think, but then I don't
> think you actually unplug the boot cpu.
> 
> What does kexec normally do to ensure hardware is left in a sane state?

Typically calls device_shutdown() and sysdev_shutdown() from
kernel_restart_prepare() to shutdown the devices.

Also calls machine_shutdown() which depending on architecture can take
care of various things like stopping other cpus, shutting down LAPIC, 
disabling IOAPIC, disabling hpet, shutting down IOMMU etc
(native_machine_shutdown()).

Thanks
Vivek
