Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698Ab1JCWNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 18:13:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:53680 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab1JCWNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 18:13:47 -0400
Date: Tue, 4 Oct 2011 00:13:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matt Fleming <matt@console-pimps.org>
cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Mosberger-Tang <davidm@egauge.net>
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
In-Reply-To: <1317675520.3375.82.camel@mfleming-mobl1.ger.corp.intel.com>
Message-ID: <alpine.LFD.2.02.1110032345050.1489@ionos>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>  <m21uuxirxi.fsf@firstfloor.org>  <1317461738.3375.46.camel@mfleming-mobl1.ger.corp.intel.com>  <CA+55aFyscb=PcUDrEUhFbH89+W-KYEKrqKHeNN3dqmZD1GF_Hw@mail.gmail.com> 
 <1317656613.3375.78.camel@mfleming-mobl1.ger.corp.intel.com>  <20111003163559.GA3957@redhat.com> <1317675520.3375.82.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Oct 2011, Matt Fleming wrote:

> On Mon, 2011-10-03 at 18:35 +0200, Oleg Nesterov wrote:
> > On 10/03, Matt Fleming wrote:
> > >
> > > Oh, are you referring to Oleg's email about the slow down under kvm?
> > > Yeah, admittedly that's a pretty clear indicator that something is wrong
> > > with the approach in this patch series.
> > 
> > Or there was something wrong with my testing, please recheck. I specially
> > mentioned I was surprised by the numbers. May be kvm, or lockdep...
> 
> No, I don't think there was anything wrong with your testing method. I
> ran your command-line under Qemu and saw similar results - with the
> patches applied the single-threaded case slows down (not by 50%, it
> looks more like 25%, but that's still unacceptable and not at all what I
> had anticipated).

After staring a bit at your patch I think that you need to tackle that
from a different angle.

The main nuisance of sighand->siglock is the exit race protection and
that's why we need to take it for evrything and some more.

In order to distangle the posix-(cpu)-timer and other stuffs
protection from that single lock, you need to introduce "independent"
locks which basically do the same dance as lock_task_sighand() does
and have to be taken in the exit() path in a well defined order before
manipulating task->sighand.

That way you still cover the exit races, but you can break up the
locking for particular subsystems w/o the need of (much) nesting.

Thanks,

	tglx






