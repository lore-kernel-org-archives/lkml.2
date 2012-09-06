Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab2IFLIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:08:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab2IFLID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:08:03 -0400
Date: Thu, 6 Sep 2012 14:09:22 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: Fix kconfig option
Message-ID: <20120906110922.GD32325@redhat.com>
References: <20120903044133.GA9980@moria.home.lan>
 <87wr0ae26e.fsf@rustcorp.com.au>
 <20120906074113.GA5902@koverstreet-glaptop>
 <20120906084403.GD17656@redhat.com>
 <20120906092512.GB5902@koverstreet-glaptop>
 <20120906094956.GB22816@redhat.com>
 <20120906100247.GA27355@koverstreet-glaptop>
 <20120906101842.GB32325@redhat.com>
 <20120906103143.GA22299@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120906103143.GA22299@moria.home.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 03:31:44AM -0700, Kent Overstreet wrote:
> On Thu, Sep 06, 2012 at 01:18:43PM +0300, Michael S. Tsirkin wrote:
> > On Thu, Sep 06, 2012 at 03:02:48AM -0700, Kent Overstreet wrote:
> > > On Thu, Sep 06, 2012 at 12:49:56PM +0300, Michael S. Tsirkin wrote:
> > > > On Thu, Sep 06, 2012 at 02:25:12AM -0700, Kent Overstreet wrote:
> > > > > On Thu, Sep 06, 2012 at 11:44:03AM +0300, Michael S. Tsirkin wrote:
> > > > > > On Thu, Sep 06, 2012 at 12:41:13AM -0700, Kent Overstreet wrote:
> > > > > > > On Tue, Sep 04, 2012 at 03:53:53PM +0930, Rusty Russell wrote:
> > > > > > > > Kent Overstreet <koverstreet@google.com> writes:
> > > > > > > > 
> > > > > > > > > CONFIG_VIRTIO isn't exposed, everything else is supposed to select it
> > > > > > > > > instead.
> > > > > > > > 
> > > > > > > > This is a slight mis-understanding.  It's supposed to be selected by
> > > > > > > > the particular driver, probably virtio_pci in your case.
> > > > > > > 
> > > > > > > So are you saying virtio-blk depends on virtio-pci? If so, the kconfig
> > > > > > > should have that.
> > > > > > > 
> > > > > > > As is, VIRTIO_BLK just has:
> > > > > > > 	depends on EXPERIMENTAL && VIRTIO
> > > > > > > 
> > > > > > > which is flat out broken.
> > > > > > 
> > > > > > I don't think anything is broken.
> > > > > > Can you show an example of a broken configuration?
> > > > > 
> > > > > Do you not understand the difference between depends an selects?
> > > > > Or did you not read my original mail?
> > > > > Flip off everything in drivers -> virtio
> > > > > 
> > > > > Now go to drivers -> block and try to turn on virtio-blk.
> > > > > 
> > > > > It's not listed!
> > > > 
> > > > Yes. Because you disabled all virtio backends.
> > > > It does not make sense to have any frontends.
> > > 
> > > How's a user - or even another kernel developer who isn't familiar with
> > > virtio - supposed to know that?
> > > 
> > > I still don't know what exactly a virtio backend is - the term isn't
> > > even mentioned anywhere that I've seen.
> > > 
> > > Whatever it is though virtio-blk should be depending on _that_, not a
> > > config option that _isn't exposed in the menu_!
> > > 
> > > > > Now go back to drivers -> virtio and turn on (randomly) balloon.
> > > > > 
> > > > > Go back to drivers -> block, and now you can turn on virtio-blk!
> > > > > 
> > > > > Do you see what's wrong with this picture?
> > > > 
> > > > Yes. You got unlucky with your random guess.
> > > > It's a bug in balloon kconfig: it should not
> > > > select virtio.
> > > > I sent a patch to fix that yesterday.
> > > 
> > > Then it's also a bug in the comments at the top of
> > > drivers/virtio/Kconfig.
> > > 
> > > And besides that, how the _hell_ is a user supposed to know to turn on
> > > VIRTIO_PCI before VIRTIO_BLK? It's not documented anywhere (if that is
> > > what's supposed to happen! I still don't know)
> > 
> > Well, what kind of device do you have? Tell us :)
> > If it's a virtio pci device,
> > you need to enable virtio-pci and virtio-blk.
> 
> I run qemu with -drive if=virtio. You tell me!

-drive if= is a compatibility option. qemu makes
an effort to guess what it is you want to do.
Result is usually correct but it means people building
their own kernels get confused.

For x86 kvm the modern equivalent is:

-device virtio-blk-pci,drive=foobar -drive if=no,...

If you use this you get what you asked for :).

Yes this usage is not documented anywhere, but this is
not guest driver's problem.

> Better yet, tell me how the user is supposed to figure it out!

As usual when you do not know which driver to select.
Boot a distro kernel and look around.
Where is your virtio device? On a pci bus?
There you are.

> > 
> > > and even if it was
> > > documented, having one kconfig option depend on something that's exposed
> > > in a _completely different menu_ is just made of fail.
> > 
> > Fine, but why pick on virtio?
> > This is extremely common in kconfig.
> > For example, a ton of network drivers depend
> > on PCI, it's exactly the same thing.
> 
> Never noticed where CONFIG_PCI is exposed in bus options?

I see it:

CONFIG_PCI:
  │ Find out whether you have a PCI motherboard. PCI is the name of a │  
  │ bus system, i.e. the way the CPU talks to the other stuff inside │  
  │ your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or │  
  │ VESA. If you have PCI, say Y, otherwise N.  │  

> Nope, not the same thing.

You just happen to know what PCI is but not what VIRTIO PCI is.
This is fair enough, but not sure how to help in this case.
Your patch won't help though.

-- 
MST
