Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab1CWEVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 00:21:46 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49928 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab1CWEVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 00:21:45 -0400
Date: Wed, 23 Mar 2011 00:21:41 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: andy.green@linaro.org, Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com, grant.likely@secretlab.ca
Subject: Re: RFC: Platform data for onboard USB assets
In-Reply-To: <1300850595.2402.320.camel@pasglop>
Message-ID: <alpine.LFD.2.00.1103222336030.11889@xanadu.home>
References: <4D79F068.2080009@linaro.org> <AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com> <1300828125.2402.300.camel@pasglop>  <4D8924B6.8040403@linaro.org> <1300842219.2402.309.camel@pasglop> <alpine.LFD.2.00.1103222138320.11889@xanadu.home>
 <1300850595.2402.320.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011, Benjamin Herrenschmidt wrote:

> I think the technical aspects have been essentially answered. The
> important part of the thread is what the "right" approach to identifying
> the on-board device (vs. an equivalent device being hot-plugged), and I
> think we all agreed this has to be the physical port "path" (in case
> there's hubs or switches on the way).

Yes, no one appears to disagree there.

> The argument boils down to should we encourage adding an additional
> in-kernel platform_data based hooks for dynamically probed busses such
> as USB as well ? or go for a udev based solution for the time being
> which would probably work as well in practice and focus on getting the
> device-tree based solution for the long term instead.

The udev solution has its set of drawbacks.  Using udev is perfect for 
arbitrary user policies.  But here we're talking about a particular 
device which happens to be soldered on a particular board, and adding 
that knowledge to udev which is a separately maintained piece of 
software from the kernel is rather redundant while the kernel already 
knows perfectly well on which hardware it is running.  And as Andy 
pointed out, the kernel's job is to abstract hardware peculiarities, not 
to force them to user space.

> > With regards to DT on ARM I'm rather "softly" convinced this is a good 
> > thing.  However seeing a persisting lack of truly technical answers to 
> > Andy's questions is rather disturbing, and makes me wish for much more 
> > than the current hype around DT which appears to fall flat when 
> > challenged.
> 
> I don't think any technical answer is missing. Dynamic platform data is
> possible and in fact the platform could do it today using bus notifiers
> and "hooking up" the platform data on the fly if needed I suppose.

... or even perform the needed intra-kernel API call to do the desired 
change to the registered device if possible, such as overriding the 
random MAC that the driver creates.

> Does it make sense however to add platform data for generic probed
> devices ? I don't think so.

Generally speaking, this wouldn't make sense.  but this is a case where 
a generically probed device happens to be used in a very specific 
hardware design with its own quirks.  in that very particular case then 
it certainly makes some sense.

But if a standard notifier callback can be invoked once the device has 
been probed and before udev is invoked, and if that notifier callback 
can modify the defaults that were set by the generic drivers, then I 
don't think there would be a need for any additional infrastructure that 
only a very few oddball devices would use anyway.

> For some reason Andy doesn't seem to consider the lack of type
> information as a problem, Grant and I do, I don't know where we can go
> from there, it's a very technical argument and I don't feel like I need
> to teach people on this list what are the drawbacks on relying on void *
> pointers to structures attached to devices like that that -will- go
> wrong.

Still, as Andy said, the void pointer is quickly converted to a fully 
typed structure, and then it is rather hard to have a driver working if 
the platform data structure is mismatched between the driver and the 
actual device registration.  So, while this is true that there is a 
possibility for misuse, in practice this is rather unlikely to go very 
far without being noticed, and therefore this argument alone is rather 
weak in support of a significant world order change.

> I simply believe that this is the wrong solution for the problem. I
> would very much prefer having a way for the driver to retrieve "platform
> attributes".

No dispute there.  But some of us also would prefer a more pragmatic 
solution in the mean time, given DT is not there yet.

> This is essentially what the name/value properties of the device-tree
> provide, but it could be abstracted in a way that doesn't require the
> device-tree and allows drivers to be unchanged whether the thing is
> backed with a DT or by platform callbacks as long as there's a minimum
> amount of thought given to naming the property reasonably.
> 
> For some reason I didn't find Andy answers conductive to a reasonable
> discussion and indeed I admit I probably switched to dismiss/troll mode
> a bit too quickly, so let's the heat go down a bit here and see if we
> can find a common ground.

I don't think Andy is rejecting any alternatives, given it is practical 
in the short term.  That unfortunately pretty much rules out DT for the 
time being.

> If you guys can agree on my above proposal, we could maybe come up with
> some "get_device_attribute(dev, name)" kind of interface, that would
> then boild down to platform calls or device-tree transparently (or arch
> calls optionally populated by generic device-tree based helpers
> etc....).

I wholeheartedly agree with that idea.  One thing that bothers me about DT 
is its tendency to show up deep into the guts of kernel code all over 
the place.  If a generic abstraction can be put in place, such as this 
get_device_attribute() example, then it is far more convenient to use 
DT, or _eventually_ use DT, or even _not_ use it in some cases but 
something else, without battling over the actual interface.

> This would be much better I believe that having those random structures
> hooked up to void * pointers floating around and also generally more
> flexible vs. platforms that provide or don't provide some of this
> information (platforms might provide a subset etc...)

Agreed.

> > There is one hard fact that no one can ignore: DT support on ARM still 
> > has a long way to go before it is truly usable.  The world just can't 
> > stop turning until this is ready.
> 
> Right but more efforts could be put into making that happen :-)

Indeed.  But that would be a discussion for another thread.


Nicolas
