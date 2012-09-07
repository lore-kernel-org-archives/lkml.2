Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab2IGAZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 20:25:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab2IGAZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 20:25:37 -0400
Date: Thu, 6 Sep 2012 17:25:33 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: Fix kconfig option
Message-ID: <20120907002533.GB16360@google.com>
References: <20120903044133.GA9980@moria.home.lan>
 <87wr0ae26e.fsf@rustcorp.com.au>
 <20120906074113.GA5902@koverstreet-glaptop>
 <20120906084403.GD17656@redhat.com>
 <20120906092512.GB5902@koverstreet-glaptop>
 <20120906094956.GB22816@redhat.com>
 <20120906100247.GA27355@koverstreet-glaptop>
 <87zk52hg9i.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zk52hg9i.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 09:10:25AM +0930, Rusty Russell wrote:
> Kent Overstreet <koverstreet@google.com> writes:
> 
> > On Thu, Sep 06, 2012 at 12:49:56PM +0300, Michael S. Tsirkin wrote:
> >> On Thu, Sep 06, 2012 at 02:25:12AM -0700, Kent Overstreet wrote:
> >> > Do you not understand the difference between depends an selects?
> >> > Or did you not read my original mail?
> 
> Now you're getting insulting.

Yes, but at least I'm not being intentionally obtuse.

> It's normal for options to depend on other options.  Sometimes they're
> directly nested (eg. E1000 depends on NETDEVICES, and it's nested under
> that option), sometimes they're not (eg. E1000 depends on PCI, which is
> selected elsewhere).
> 
> The fact that you are only just realizing this is not Michael's problem.

Like I said, I'm well aware of that. The issue here isn't the
dependency, it's that it depends on something that isn't exposed
anywhere!

Think about it from the user's pov. They check what VIRTIO_BLK depends
on - just VIRTIO.

So they try to figure out how to flip on VIRTIO, or what VIRTIO even is.

See how that last step might be problematic? CONFIG_VIRTIO is not
exposed! It doesn't even seem to control anything!

Go back to your example. Checking the dependencies for E1000 would tell
you the user needs to flip on CONFIG_PCI. Done. Easy.

User checks the dependencies here and... what do _you_ expect people to
do?

Look, depending on a kconfig option that's supposed to be user
controllable but isn't exposed anywhere is flat out broken. The fact
that it's in a different submenu just makes it worse.

The problem is that VIRTIO_BLK's dependencies are not actually specified
in the kconfig. If it depends on VIRTIO_PCI, that's what the kconfig
should say. If it depends on having any of multiple virtio backends
enabled, then specify that!

depends VIRTIO_PCI || VIRTIO_WHATEVER

Or if you really want to have a fake config option that's enabled if you
have any virtio backend enabled, fix the damn comments and naming!

How is anyone supposed to know that CONFIG_VIRTIO really means "any
virtio backend?" Call it VIRTIO_ANY_BACKEND if that's what it really is.

And, if that is what you're doing with CONFIG_VIRTIO (I'm still not
sure) the comment at the top of drivers/virtio/Kconfig is _wrong_:

# Virtio always gets selected by whoever wants it.
VIRTIO
        tristate

How is _anyone_ supposed to know that really means "VIRTIO gets selected
by things that provide a virtio backend?"

C'mon, you've had to debug other people's code before. What would _you_
think if you were tripped up by something like that?

> >> > Flip off everything in drivers -> virtio
> >> > 
> >> > Now go to drivers -> block and try to turn on virtio-blk.
> >> > 
> >> > It's not listed!
> >> 
> >> Yes. Because you disabled all virtio backends.
> >> It does not make sense to have any frontends.
> >
> > How's a user - or even another kernel developer who isn't familiar with
> > virtio - supposed to know that?
> 
> I get annoyed that menuconfig doesn't show options whose dependencies
> aren't possible, too.  (I got bitten the other way: it doesn't show
> dependencies which can't be disabled, and I was trying to turn KALLSYMS
> off).
> 
> But as I found out just last week, the '/' key allows you to find any
> option, and shows what dependencies it has, and their values.

Yep, use it all the time. 
