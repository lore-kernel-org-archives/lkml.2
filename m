Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032108Ab2COTQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:16:21 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:35333 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965311Ab2COTQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:16:20 -0400
MIME-Version: 1.0
Message-ID: <a943f71d-219a-4c9a-aa2a-4be83132df14@default>
Date: Thu, 15 Mar 2012 12:16:04 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Wilk <konrad.wilk@oracle.com>, Avi Kivity <avi@redhat.com>
Cc: Akshay Karle <akshay.a.karle@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, ashu tripathi <er.ashutripathi@gmail.com>,
        nishant gulhane <nishant.s.gulhane@gmail.com>,
        amarmore2006 <amarmore2006@gmail.com>,
        Shreyas Mahure <shreyas.mahure@gmail.com>,
        mahesh mohan <mahesh6490@gmail.com>
Subject: RE: [RFC 0/2] kvm: Transcendent Memory (tmem) on KVM
References: <1331224181.2585.16.camel@aks> <4F621FC0.7050800@redhat.com>
 <ac318852-4ccd-4739-893c-52f5cddee6c7@default> <4F622E90.5080001@redhat.com>
 <20120315180233.GF452@phenom.dumpdata.com>
In-Reply-To: <20120315180233.GF452@phenom.dumpdata.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4F624001.0042,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk
> Subject: Re: [RFC 0/2] kvm: Transcendent Memory (tmem) on KVM
> 
> On Thu, Mar 15, 2012 at 08:01:52PM +0200, Avi Kivity wrote:
> > On 03/15/2012 07:49 PM, Dan Magenheimer wrote:
> > >
> > > The "WasActive" patch (https://lkml.org/lkml/2012/1/25/300)
> > > is intended to avoid the streaming situation you are creating here.
> > > It increases the "quality" of cached pages placed into zcache
> > > and should probably also be used on the guest-side stubs (and/or maybe
> > > the host-side zcache... I don't know KVM well enough to determine
> > > if that would work).
> > >
> > > As Dave Hansen pointed out, the WasActive patch is not yet correct
> > > and, as akpm points out, pageflag bits are scarce on 32-bit systems,
> > > so it remains to be seen if the WasActive patch can be upstreamed.
> > > Or maybe there is a different way to achieve the same goal.
> > > But I wanted to let you know that the streaming issue is understood
> > > and needs to be resolved for some cleancache backends just as it was
> > > resolved in the core mm code.
> >
> > Nice.  This takes care of the tail-end of the streaming (the more
> > important one - since it always involves a cold copy).  What about the
> > other side?  Won't the read code invoke cleancache_get_page() for every
> > page? (this one is just a null hypercall, so it's cheaper, but still
> > expensive).
> 
> That is something we should fix - I think it was mentioned in the frontswap
> email thread the need for batching and it certainly seems required as those
> hypercalls aren't that cheap.

And exactly how expensive ARE hypercalls these days?  On the first VT/SVN
systems they were tens of thousands of cycles... now they are closer
to sub-thousand are they not?  (I remember seeing a graph of hypercall
overhead dropping across generations of CPUs... anybody have a pointer to
a public graph of this?)

One of my favorite papers these days is "When Poll is Better than Interrupt"
(http://static.usenix.org/events/fast12/tech/full_papers/Yang.pdf) which
argues that wasting some CPU cycles doing a busy-wait is often more
efficient than slogging through the Block I/O subsystem to set up
and respond to an interrupt, if the device is fast enough.  I wonder if the
same might be true comparing hypercall overhead for tmem vs the path for
KVM to get a page from the host via its normal path?

Ignoring that for now, if excessive hypercalls is a problem, a better
solution than batching may be to modify the Maharashtra approach to
be more like RAMster:  Put zcache in the guest-side and treat the
host like a "remote" system.

But let's wait for the Maharashta team to do some measurements first
before we make any assumptions or change any designs...
