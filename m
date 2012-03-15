Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031989Ab2COSGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:06:43 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:23260 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab2COSGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:06:41 -0400
Date: Thu, 15 Mar 2012 14:02:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Avi Kivity <avi@redhat.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Akshay Karle <akshay.a.karle@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, ashu tripathi <er.ashutripathi@gmail.com>,
        nishant gulhane <nishant.s.gulhane@gmail.com>,
        amarmore2006 <amarmore2006@gmail.com>,
        Shreyas Mahure <shreyas.mahure@gmail.com>,
        mahesh mohan <mahesh6490@gmail.com>
Subject: Re: [RFC 0/2] kvm: Transcendent Memory (tmem) on KVM
Message-ID: <20120315180233.GF452@phenom.dumpdata.com>
References: <1331224181.2585.16.camel@aks>
 <4F621FC0.7050800@redhat.com>
 <ac318852-4ccd-4739-893c-52f5cddee6c7@default>
 <4F622E90.5080001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F622E90.5080001@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090204.4F622FAC.0088,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 08:01:52PM +0200, Avi Kivity wrote:
> On 03/15/2012 07:49 PM, Dan Magenheimer wrote:
> > > One of the potential problems with tmem is reduction in performance when
> > > the cache hit rate is low, for example when streaming.
> > > 
> > > Can you test this by creating a large file, for example with
> > > 
> > >   dd < /dev/urandom > file bs=1M count=100000
> > > 
> > > and then measuring the time to stream it, using
> > > 
> > >   time dd < file > /dev/null
> > > 
> > > with and without the patch?
> > > 
> > > Should be done on a cleancache enabled guest filesystem backed by a
> > > virtio disk with cache=none.
> > > 
> > > It would be interesting to compare kvm_stat during the streaming, with
> > > and without the patch.
> >
> > Hi Avi --
> >
> > The "WasActive" patch (https://lkml.org/lkml/2012/1/25/300) 
> > is intended to avoid the streaming situation you are creating here.
> > It increases the "quality" of cached pages placed into zcache
> > and should probably also be used on the guest-side stubs (and/or maybe
> > the host-side zcache... I don't know KVM well enough to determine
> > if that would work).
> >
> > As Dave Hansen pointed out, the WasActive patch is not yet correct
> > and, as akpm points out, pageflag bits are scarce on 32-bit systems,
> > so it remains to be seen if the WasActive patch can be upstreamed.
> > Or maybe there is a different way to achieve the same goal.
> > But I wanted to let you know that the streaming issue is understood
> > and needs to be resolved for some cleancache backends just as it was
> > resolved in the core mm code.
> 
> Nice.  This takes care of the tail-end of the streaming (the more
> important one - since it always involves a cold copy).  What about the
> other side?  Won't the read code invoke cleancache_get_page() for every
> page? (this one is just a null hypercall, so it's cheaper, but still
> expensive).

That is something we should fix - I think it was mentioned in the frontswap
email thread the need for batching and it certainly seems required as those
hypercalls aren't that cheap.
