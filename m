Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab0EQCpq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 22:45:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33658 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752101Ab0EQCpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 22:45:45 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Tony Lindgren <tony@atomide.com>, Matthew Garrett <mjg@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>, Paul Walmsley <paul@pwsan.com>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       magnus.damm@gmail.com, "Theodore Ts'o" <tytso@mit.edu>,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>,
       =?ISO-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
In-Reply-To: <201005152214.33691.rjw@sisk.pl> (sfid-20100516_004146_399772_1CAA65CE)
References: <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com>
	 <201005142350.01222.rjw@sisk.pl> <87k4r69k61.fsf@deeprootsystems.com>
	 <201005152214.33691.rjw@sisk.pl> (sfid-20100516_004146_399772_1CAA65CE)
Content-Type: text/plain; charset="UTF-8"
Organization: Wolfson Microelectronics
Date: Sun, 16 May 2010 20:44:19 +0100
Message-ID: <1274039059.5719.129.camel@finisterre.wolfsonmicro.main>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-15 at 22:14 +0200, Rafael J. Wysocki wrote:
> On Saturday 15 May 2010, Kevin Hilman wrote:
> > "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> > > On Friday 14 May 2010, Kevin Hilman wrote:

> > >> If it truly is the lack of a suspend blocker API that is preventing
> > >> the merge of these out of tree drivers, I second Mark's proposal[1] to
> > >> merge a noop version of the API while the technical issues continue to
> > >> be discussed.

> > > I'm against that, sorry.

> > OK, I'll bite... Why?

> Because in that case the real feature will always be opposed as "unnecessary"
> and never merged.  I very much prefer to decide whether to merge it or reject
> it right now.

FWIW (as the person who made the suggestion) I do think that it is
something one might call expedient rather than actually good.

> > It was expressed because I find the arguments above for merging
> > because it prevents out-of-tree drivers from merging quite
> > unconvincing.  This is not just about opportunistic suspend + suspend
> > blockers specifically but comes from several years experience in the
> > embedded Linux world.

> In this particular case, the lack of the mainline's support for opportunistic
> suspend (in the form of "wakelocks" to be precise) has been given as a main
> obstacle against merging of several drivers at least.

Where are these objections coming from? The only example I've seen cited
is the G1 stuff, which is a fairly special case for a number of reasons
(including the underlying MSM BSP, which was pretty substantial itself).

> And this is not the only reason to push the opportunistic suspend feature
> upstream IMO.

Agreed, my purpose here is mostly to push back on what sound like
unrealistic expectations about what we're getting.

> Second, (as said above) there is a number of drivers _already_ depending
> on it and that number is only going to grow given the popularity of Android.
> They are not mainlined in part because their authors don't see a benefit from
> doing so (usually the benefit is that you don't have to maintain your code out
> of the tree, because the mainline does it for you to some extent, so if you
> need to maintain a separate version yourself, the benefit is zero).

Wakelocks are going to be a fairly minor part of any decision here -
it'd be pretty surprising if they take much effort to remove from a
driver. What's much more of an issue is that you've got essentially the
same situation as you have with the enterprise Linux distributions, a
fixed kernel version that vendors need to target. The differences that
implies are far more substantial than wakelocks for many areas of the
kernel, especially at the points in the cycle where the fixed kernel has
drifted furthest from the current mainline.

Things aren't quite the same as with the enterprise distributions,
though - the lifecycles for many parts in the consumer space are much,
much shorter than those in the enterprise markets. They can be
sufficiently short to mean that a mainline driver won't show up where
customers need it soon enough. For example, Google is currently
preparing an Android release based on 2.6.32 the merge window for which
was in September last year, over six months ago. This is an extremely
long latency if you're working on something in the region of a twelve
month cycle. The lack of standardisation for register interfaces in the
embedded space means that the generation to generation differences can
easily be sufficiently substantial to make a new driver the only
sensible option.

This isn't to say that the old parts just suddenly vanish, and clearly
there's an advantage from ongoing mainline inclusion, but the tradeoffs
are a bit different to those in other markets.

There's also a less pressure from end users towards mainline inclusion -
even on Linux people in the embedded space are used to having to get
code from multiple vendors working together so the lack of mainline
support isn't the sort of issue it would be with something like server
class hardware. This is changing over time as more and more vendors buy
into mainline but there's a way to go yet. If the part requires changes
outside the driver itself (a new or updated kernel interface, for
example) there's a pressure to just deal with it in the driver in a way
which is going to be unacceptable for mainline, possibly even involving
per-system code modifications in the driver. Sometimes ongoing mainline
development will mean that the driver needs updating anyway in ways that
are much more substantial than ripping out wakelocks would be.

Having wakelocks in does make things easier for drivers using them but
we need to recognise that all sorts of other things that are much harder
to deal with will also come up.

