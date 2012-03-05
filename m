Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab2CEUZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 15:25:13 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:58618 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669Ab2CEUZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 15:25:11 -0500
Message-ID: <1330979077.2191.96.camel@work-vm>
Subject: Re: WARNING: Adjusting tsc more then 11%
From: John Stultz <john.stultz@linaro.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Dave Jones <davej@redhat.com>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 05 Mar 2012 12:24:37 -0800
In-Reply-To: <20120305195619.GB17489@zod.bos.redhat.com>
References: <20120305154411.GA29668@redhat.com>
	 <1330972323.2191.74.camel@work-vm> <20120305192338.GA30491@redhat.com>
	 <1330977010.2191.84.camel@work-vm>
	 <20120305195619.GB17489@zod.bos.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030520-2398-0000-0000-000004CC447C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 14:56 -0500, Josh Boyer wrote:
> On Mon, Mar 05, 2012 at 11:50:10AM -0800, John Stultz wrote:
> > On Mon, 2012-03-05 at 14:23 -0500, Dave Jones wrote:
> > > On Mon, Mar 05, 2012 at 10:32:03AM -0800, John Stultz wrote:
> > >  > On Mon, 2012-03-05 at 10:44 -0500, Dave Jones wrote:
> > > 
> > >  > > any idea what could have changed to start tripping that up ?
> > >  > > 
> > >  > > The reports seem to have started around 3.3-rc4.
> > >  > 
> > >  > Huh. No I don't know what would have started causing such a warning. I
> > >  > had expected that there would be some edge hardware that might trip that
> > >  > warning, but I'd expect the noise to start there w/ 3.2 after it was
> > >  > introduced. There's only been spelling & comment changes to the
> > >  > timekeeping core in the 3.3-rc series.
> > > 
> > > thinking about this some more, while the reports starts around rc4, this
> > > may have been caused by something prior to that, as anyone moving from
> > > Fedora 16 or earlier to F17 alpha would have jumped quite a kernel version or two.
> > 
> > Was F16 3.1 based? The warning was added in 3.2, so if you skipped it,
> > it may not be new behavior then.
> > 
> > >  > Do you know if this is an occasional thing on any of the affected
> > >  > hardware, or if it happens after every reboot?
> > > 
> > > Out of all the people running the Fedora 17 alpha, this has only shown
> > > up those four times, so it does seem to be a rare thing.
> > > I suspect we'll get more instances of it as more people start testing.
> > > 
> > > Three of the reporters noted that it happened on boot.
> > > 
> > >  > Are any of the reported boxes systems you have access to in order to
> > >  > reproduce?
> > > 
> > > unfortunately not.
> > 
> > Ok. Well, just to level set: the warning is informative, and points to
> > unexpected, but not necessarily unsafe behavior.
> > 
> > In fact, the risk (where mult is adjusted to be large enough to cause an
> > overflow) we're warning about have been present 2.6.36 or even possibly
> > before. The change in 3.2 which added the warning also added a more
> > conservative mult calculation, so we're less likely to get overflow
> > prone large mult values.
> 
> Is there a reason you decided to use a WARN_ONCE, which dumps a full stack
> trace, instead of just printk(KERN_ERR ?

Well, the WARN_ONCE behavior is really nice, since just a printk would
end up possibly filling the logs, since you might get one every tick.

> > So it would be great to get further feedback from folks who are seeing
> > this warning, so we can really hammer this out, but I don't want the
> > warning spooking anyone into thinking things are terribly broken.
> 
> Right... people see backtraces and start thinking "my kernel is broken."
> 
> I'm certainly not meaning to pick on you for this.  Lately it seems all
> the rage to throw WARN_ONs for all kinds of error paths and leave the user
> to figure out how screwed they are.

Its a trade-off, since we really do want to know if our code has been
pushed outside of its expected boundaries (either by unexpected hadware
behavior or by expectations being raised, like long nohz idle times), so
we have to get folks attention somewhat. The type of error reporting
Dave's managed to collect here is really great.

But at the same time, I agree there has been a few cases where the code
is limited more narrowly then the reality of existing hardware, and we
end up with a constant stream of error messages that get waved off as
broken hardware.

There we need to either fix the code or drop the warnings, but I think
it gets hard when we really want to know about "unexpected behavior,
except on some wide swath of hardware that always acts poorly", where
conditionalizing the warnings isn't easy.

thanks
-john



