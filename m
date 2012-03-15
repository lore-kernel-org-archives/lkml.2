Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161350Ab2COTux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:50:53 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26821 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161312Ab2COTuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:50:51 -0400
Date: Thu, 15 Mar 2012 15:46:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Avi Kivity <avi@redhat.com>, Akshay Karle <akshay.a.karle@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ashu tripathi <er.ashutripathi@gmail.com>,
        nishant gulhane <nishant.s.gulhane@gmail.com>,
        amarmore2006 <amarmore2006@gmail.com>,
        Shreyas Mahure <shreyas.mahure@gmail.com>,
        mahesh mohan <mahesh6490@gmail.com>
Subject: Re: [RFC 0/2] kvm: Transcendent Memory (tmem) on KVM
Message-ID: <20120315194644.GB3486@phenom.dumpdata.com>
References: <1331224181.2585.16.camel@aks>
 <4F621FC0.7050800@redhat.com>
 <ac318852-4ccd-4739-893c-52f5cddee6c7@default>
 <4F622E90.5080001@redhat.com>
 <20120315180233.GF452@phenom.dumpdata.com>
 <4F6230B1.4010004@redhat.com>
 <2928450b-b3bd-462f-9994-7b30810d6a83@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2928450b-b3bd-462f-9994-7b30810d6a83@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4F624819.0001,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 12:36:48PM -0700, Dan Magenheimer wrote:
> > From: Avi Kivity [mailto:avi@redhat.com]
> > Sent: Thursday, March 15, 2012 12:11 PM
> > To: Konrad Rzeszutek Wilk
> > Cc: Dan Magenheimer; Akshay Karle; linux-kernel@vger.kernel.org; kvm@vger.kernel.org; ashu tripathi;
> > nishant gulhane; amarmore2006; Shreyas Mahure; mahesh mohan
> > Subject: Re: [RFC 0/2] kvm: Transcendent Memory (tmem) on KVM
> > 
> > On 03/15/2012 08:02 PM, Konrad Rzeszutek Wilk wrote:
> > > >
> > > > Nice.  This takes care of the tail-end of the streaming (the more
> > > > important one - since it always involves a cold copy).  What about the
> > > > other side?  Won't the read code invoke cleancache_get_page() for every
> > > > page? (this one is just a null hypercall, so it's cheaper, but still
> > > > expensive).
> > >
> > > That is something we should fix - I think it was mentioned in the frontswap
> > > email thread the need for batching and it certainly seems required as those
> > > hypercalls aren't that cheap.
> > 
> > In fact when tmem was first proposed I asked for two changes - make it
> > batchable, and make it asynchronous (so we can offload copies to a dma
> > engine, etc).  Of course that would have made tmem significantly more
> > complicated.
> 
> (Sorry, I'm not typing fast enough to keep up with the thread...)
> 
> Hi Avi --
> 
> In case it wasn't clear from my last reply, RAMster shows
> that tmem CAN be used asynchronously... by making it more
> complicated, but without making the core kernel changes more
> complicated.
> 
> In RAMster, pages are locally cached (compressed using zcache)
> and then, depending on policy, a separate thread sends the pages
> to a remote machine.  So the first part (compress and store locally)
> still must be synchronous, but the second part (transmit to
> another -- remote or possibly host? -- system) can be done
> asynchronously.  The RAMster code has to handle all the race
> conditions, which is a pain but seems to work.
> 
> This is all working today in RAMster (which is in linux-next).
> Batching is still not implemented by any tmem backend, but RAMster
> demonstrates how the backend implementation COULD do batching without
> any additional core kernel changes.  I.e. no changes necessary
> to frontswap or cleancache.
> 
> So, you see, I *was* listening. I just wasn't willing to fight
> the uphill battle of much more complexity in the core kernel
> for a capability that could be implemented differently.

Dan, please stop this.

The frontswap work is going through me and my goal is to provide
the batching and asynchronous option. It might take longer than
anticipated b/c it might require redoing some of the code - that
is OK. We can do this in steps too - first do the synchronous
(as is right now in implementation) and then add on the batching
and asynchrnous work. This means breaking the ABI/API, and I believe
Avi would like the ABI be as much baked as possible so that he does
not have to provide a v2 (or v3) of the tmem support in KVM.

I appreciate you having done that in RAMster but the "transmit"
option is what we need to batch. Think of Scatter Gather DMA.

> 
> That said, I still think it remains to be proven that
> reducing the number of hypercalls by 2x or 3x (or whatever
> the batching factor you choose) will make a noticeable

I was thinking 32 - about the same number that we do in
Xen with PV MMU upcalls. We also batch it there with multicalls.

> performance difference.  But if it does, batching can
> be done... and completely hidden in the backend.
> 
> (I hope Andrea is listening ;-)
> 
> Dan
