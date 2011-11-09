Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab1KIKS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 05:18:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab1KIKS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 05:18:27 -0500
Date: Wed, 9 Nov 2011 12:13:18 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        avi@redhat.com, penberg@cs.helsinki.fi
Subject: Re: [PATCH RFC] virtio-spec: flexible configuration layout
Message-ID: <20111109101318.GB20612@redhat.com>
References: <87wrbkvh3v.fsf@rustcorp.com.au>
 <20111101114542.GA13434@redhat.com>
 <1320150813.3847.24.camel@lappy>
 <20111101124223.GA14060@redhat.com>
 <8739e7uy87.fsf@rustcorp.com.au>
 <20111102233110.GA20289@redhat.com>
 <20111108214021.GA4538@redhat.com>
 <1320828366.31056.16.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1320828366.31056.16.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 10:46:06AM +0200, Sasha Levin wrote:
> On Tue, 2011-11-08 at 23:40 +0200, Michael S. Tsirkin wrote:
> > Here's a spec change documenting what my C patch does
> > (almost - I tweaked the layout a bit, but the idea is the same).
> > Some more cleanups are needed but I thought I'd send it
> > for early flames/comments.
> > 
> > The idea is simple: we split functionally unrelated
> > register groups to independent structures, and let
> > the device place is anywhere using a capability
> > in PCI configuration space.
> > 
> > It can then go into MMIO space which is cheaper than PIO.
> > 
> > A legacy portion of the configuration is mirrored
> > in the first BAR, to keep legacy drivers working.
> > Any new fields can be added in existing structures
> > at the end, so they won't affect legacy.
> 
> If newer specs add more structures at the end of the config space, and
> use the same config space for legacy, that space now becomes device
> specific config space and not new-shiny-feature space, so we must
> remember to handle those cases.

Yes. Devices should mirror virtio header and device structures
in MMIO and point Structures there. It seems unavoidable for
device structures (because legacy layout is dynamic
and we don't want to keep doing that), so I thought it's not worth the
trouble for virtio header either.

Notification and ISR Structures can point into PIO.

I'll add some more text to clarify that.

> > Alternatively we can add new structures with new
> > structure IDs, pointed to from PCI configuration space.
> > 
> > As we don't yet have devices or drivers with 64 bit features,
> > I decided we don't need high feature bits in legacy space.
> > This also frees up feature bit 31 as we don't need it
> > to enable high feature bits anymore.
> 
> KVM tool actually has support for 64bit features, we can probably remove
> that when Pekka isn't looking :)

It's not yet released so maybe it's not an issue yet.
If it's too late I can re-add them to legacy too.

Pekka, 64 features aren't yet used and we are discussing
changing the layout for that field. Mind taking it out
of kvm tool for now?

> > 
> > As this solves the dynamic placement of MSIX vectors
> > and high feature bits,
> > I thought it's easier to just reserve space for that
> > programming than give it a separate structure. This
> > can be changed by a patch on top.
> > 
> > Note that data path is split from configuration.
> > 
> > PDF will follow.
> > ----
> > 
> 
> The device initialization sequence might use an update as well.

What is needed? Add an item where the driver scans the PCI capability
list to detect the layout?

> Maybe
> also a description of how device handles missing structure IDs.
> 
> [snip]

Hmm. I just have
'Drivers should fall back on this legacy structure if a
 Virtio Structure capability is missing in the PCI capability
 list'. 

What else would be helpful? An example? 

> > +
> > +\begin_layout Standard
> > +
> > +\change_inserted 1986246365 1320781133
> > +These registers are specified using vendor-specific PCI capability located
> > + on capability list in PCI configuration space of the device.
> > + This virtio structure capability uses little-endian format; all bits are
> > + read-only:
> > +\end_layout
> > +
> > +\begin_layout Standard
> > +
> > +\change_inserted 1986246365 1320772579
> > +\begin_inset Tabular
> 
> Just a note, these tables are way too wide to work properly in PDFs :)

True, looks like I need to abbreviate

> > +<lyxtabular version="3" rows="4" columns="34">
> > +<features tabularvalignment="middle">
> > +<column alignment="center" valignment="top" width="0pt">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0">
> > +<column alignment="center" valignment="top" width="0pt">
> > +<row>
> 
> [snip]
> 
> > +
> > +\begin_layout Standard
> > +
> > +\change_inserted 1986246365 1320779667
> > +Purpose:
> > +\end_layout
> > +
> > +\begin_layout Standard
> > +
> > +\change_inserted 1986246365 1320780912
> > +
> > +\emph on
> > +Capability ID
> > +\emph default
> > +, 
> > +\emph on
> > +Next Capability Pointer
> > +\emph default
> > +, 
> > +\emph on
> > +Capability Length
> > +\emph default
> > + - these fields are specified by PCI local bus specification, Rev 3.0
> 
> I'm not sure what capability length is, can't find it in the spec
> either.
> 
> [snip]

It's the legth of the vendor specific capability structure in bytes.
'the byte immediately following the “Next”
 pointer in the capability structure is defined to be a length field'
It's on page 330 in my copy.



> > +\begin_layout Plain Layout
> > +ie.
> > + once you enable MSI-X on the device, the other fields move.
> > + If you turn it off again, they move back!
> 
> Is it still true? We're talking about the new layout here (there are
> several of this footnote, this one is located right *before* the section
> which talks about legacy config space.
> 
> [snip]

Of course not.  I'll move the footnote, this only applies to the
legacy naturally.

> > + 
> > +\change_deleted 1986246365 1320784929
> > +If more than 31 feature bits are supported, the device indicates so by setting
> > + feature bit 31 (see 
> 
> The bit numbers below this text should be corrected as well.

Will fix. Thanks!

> -- 
> 
> Sasha.
