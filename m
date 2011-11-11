Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab1KKND2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 08:03:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756499Ab1KKNDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 08:03:24 -0500
Date: Fri, 11 Nov 2011 14:59:07 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        avi@redhat.com, penberg@kernel.org
Subject: Re: [PATCHv2 RFC] virtio-spec: flexible configuration layout
Message-ID: <20111111125907.GB23902@redhat.com>
References: <20111101124223.GA14060@redhat.com>
 <8739e7uy87.fsf@rustcorp.com.au>
 <20111102233110.GA20289@redhat.com>
 <20111108214021.GA4538@redhat.com>
 <20111109195901.GA28155@redhat.com>
 <1320870287.3730.6.camel@lappy>
 <20111109205208.GA28599@redhat.com>
 <1320872248.3730.11.camel@lappy>
 <87aa83qoao.fsf@rustcorp.com.au>
 <CA+1xoqeH3ErNCELD+NoJHz=eH6FtxersUffoJSj0yQx2o=4g0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+1xoqeH3ErNCELD+NoJHz=eH6FtxersUffoJSj0yQx2o=4g0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 09:39:13AM +0200, Sasha Levin wrote:
> On Fri, Nov 11, 2011 at 6:24 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Wed, 09 Nov 2011 22:57:28 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
> >> On Wed, 2011-11-09 at 22:52 +0200, Michael S. Tsirkin wrote:
> >> > On Wed, Nov 09, 2011 at 10:24:47PM +0200, Sasha Levin wrote:
> >> > > It'll be a bit harder deprecating it in the future.
> >> >
> >> > Harder than ... what ?
> >>
> >> Harder than allowing devices not to present it at all if new layout
> >> config is used. Right now the simple implementation is to use MMIO for
> >> config and device specific, and let it fallback to legacy for ISR and
> >> notifications (and therefore, this is probably how everybody will
> >> implement it), which means that when you do want to deprecate legacy,
> >> there will be extra work to be done then, instead of doing it now.
> >
> > Indeed, I'd like to see two changes to your proposal:
> >
> > (1) It should be all or nothing.  If a driver can find the virtio header
> >    capability, it should only use the capabilties.  Otherwise, it
> >    should fall back to legacy.  Your draft suggests a mix is possible;
> >    I prefer a clean failure (ie. one day don't present a BAR 0 *at
> >    all*, so ancient drivers just fail to load.).
> >
> > (2) There's no huge win in keeping the same layout.  Let's make some
> >    cleanups.  There are more users ahead of us then behind us (I
> >    hope!).
> 
> Actually, if we already do cleanups, here are two more suggestions:
> 
> 1. Make 64bit features a one big 64bit block, instead of having 32bits
> in one place and 32 in another.
> 2. Remove the reserved fields out of the config (the ones that were
> caused by moving the ISR and the notifications out).
> 
> > But I think this is the right direction!
> >
> > Thanks,
> > Rusty.
> >
> 
> Also, an unrelated questions: With PIO, requests were ordered, which
> means that if we wrote to the queue selector and then read from a
> queue register we would read the correct queue info.
> Is the same thing assured to us with MMIO?

For real PCI, reads do not bypass writes in PCI. However this
is only true if both are MMIO or both PIO reads.
I don't think the ordering of MMIO versus PIO is guaranteed.

On KVM, the kernel doesn't do anything to guarantee ordering.
So you get the natural ordering of the CPU.

> If we write to a queue
> selector and immediately read from queue info would we be reading the
> right info, or is there the slight chance that it would get reordered
> and we would be reading queue info first and writing to the selector
> later?

The thing to realize is that write to queue selector with KVM is in the
end performed by host. And reading queue info means that host will be
reading the queue selector. So this is a write followed by read
from the same address. AFAIK no CPUs can reorder such accesses,
so you get the right info.

-- 
MST
