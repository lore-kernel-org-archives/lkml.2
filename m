Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab1I1OJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:09:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898Ab1I1OJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:09:48 -0400
Date: Wed, 28 Sep 2011 10:09:33 -0400
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, Matthew Garrett <mjg@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH -next] pstore: replace spin_lock with
 spin_trylock_irqsave in panic path
Message-ID: <20110928140933.GR5795@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C56C9B823@USINDEVS01.corp.hds.com>
 <20110927173413.GJ5795@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301EE4211E3@orsmsx505.amr.corp.intel.com>
 <20110927175919.GK5795@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301EE421365@orsmsx505.amr.corp.intel.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C56C9B8AD@USINDEVS01.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C56C9B8AD@USINDEVS01.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 03:46:08PM -0400, Seiji Aguchi wrote:
> Hi,
> 
> >Yes we care - saving panic data is most likely the single most important
> >thing that pstore does.  I just have severe doubts that it will actually
> >save anything useful if we just blindly continue if we can't get the lock.
> 
> I agree with Tony. We may not get useful information if pstore just blindly continues
> while other cpus are running.
> 
> >Is this patch based on a real-life case of a system deadlocking? I'd
> >like to know if we are just talking around the theoretical case that
> >the lock may be held at panic time - or something that has actually been
> >seen in real life.
> 
> This patch is _not_ based on real-life case. I would like to avoid potential deadlock.
> 
> If Don disagrees to  my "return" code, I have another idea which moves pstore_dump() behind smp_send_stop().
> smp_send_stop() stops other cpus by sending IPI.
> So pstore can continue reliably and get useful information by just busting spinlock.

Yeah, Vivek had a similar idea to have the common panic path mimic what
they do with kdump, stop all the cpus except for the crashing one, to
serialize the crashing path.  This would allow us to more easily bust
spinlocks without worrying about what the other cpus are doing.

The kdump solution involves using NMI whereas smp_send_stop (on x86)
avoids it because of past issues and instead uses the IRQ line.  This
won't work if pstore_dump uses a spin_try_lock_irqsave() because the IRQ
line will be disable and never get the smp_send_stop() message (unless I
am reading the code wrong).

[reads the kernel/panic.c code] oh, I see this already exists, you would
just move the smp_send_stop() command up a couple lines of code.

[Side note] perhaps we should change the behaviour of smp_send_stop to use
NMI and create a blacklist of machines to use the IRQ line instead.  I
assume the list of broken machines is small as Red Hat has been kdumping
kernels since 2.6.18 with little evidence that machines were failing
because NMI wasn't working properly.


Cheers,
Don

