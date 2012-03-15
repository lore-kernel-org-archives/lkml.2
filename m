Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032219Ab2COThG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:37:06 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:38435 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031784Ab2COThD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:37:03 -0400
MIME-Version: 1.0
Message-ID: <2928450b-b3bd-462f-9994-7b30810d6a83@default>
Date: Thu, 15 Mar 2012 12:36:48 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Avi Kivity <avi@redhat.com>, Konrad Wilk <konrad.wilk@oracle.com>
Cc: Akshay Karle <akshay.a.karle@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, ashu tripathi <er.ashutripathi@gmail.com>,
        nishant gulhane <nishant.s.gulhane@gmail.com>,
        amarmore2006 <amarmore2006@gmail.com>,
        Shreyas Mahure <shreyas.mahure@gmail.com>,
        mahesh mohan <mahesh6490@gmail.com>
Subject: RE: [RFC 0/2] kvm: Transcendent Memory (tmem) on KVM
References: <1331224181.2585.16.camel@aks> <4F621FC0.7050800@redhat.com>
 <ac318852-4ccd-4739-893c-52f5cddee6c7@default> <4F622E90.5080001@redhat.com>
 <20120315180233.GF452@phenom.dumpdata.com> <4F6230B1.4010004@redhat.com>
In-Reply-To: <4F6230B1.4010004@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4F6244DD.0030,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Avi Kivity [mailto:avi@redhat.com]
> Sent: Thursday, March 15, 2012 12:11 PM
> To: Konrad Rzeszutek Wilk
> Cc: Dan Magenheimer; Akshay Karle; linux-kernel@vger.kernel.org; kvm@vger.kernel.org; ashu tripathi;
> nishant gulhane; amarmore2006; Shreyas Mahure; mahesh mohan
> Subject: Re: [RFC 0/2] kvm: Transcendent Memory (tmem) on KVM
> 
> On 03/15/2012 08:02 PM, Konrad Rzeszutek Wilk wrote:
> > >
> > > Nice.  This takes care of the tail-end of the streaming (the more
> > > important one - since it always involves a cold copy).  What about the
> > > other side?  Won't the read code invoke cleancache_get_page() for every
> > > page? (this one is just a null hypercall, so it's cheaper, but still
> > > expensive).
> >
> > That is something we should fix - I think it was mentioned in the frontswap
> > email thread the need for batching and it certainly seems required as those
> > hypercalls aren't that cheap.
> 
> In fact when tmem was first proposed I asked for two changes - make it
> batchable, and make it asynchronous (so we can offload copies to a dma
> engine, etc).  Of course that would have made tmem significantly more
> complicated.

(Sorry, I'm not typing fast enough to keep up with the thread...)

Hi Avi --

In case it wasn't clear from my last reply, RAMster shows
that tmem CAN be used asynchronously... by making it more
complicated, but without making the core kernel changes more
complicated.

In RAMster, pages are locally cached (compressed using zcache)
and then, depending on policy, a separate thread sends the pages
to a remote machine.  So the first part (compress and store locally)
still must be synchronous, but the second part (transmit to
another -- remote or possibly host? -- system) can be done
asynchronously.  The RAMster code has to handle all the race
conditions, which is a pain but seems to work.

This is all working today in RAMster (which is in linux-next).
Batching is still not implemented by any tmem backend, but RAMster
demonstrates how the backend implementation COULD do batching without
any additional core kernel changes.  I.e. no changes necessary
to frontswap or cleancache.

So, you see, I *was* listening. I just wasn't willing to fight
the uphill battle of much more complexity in the core kernel
for a capability that could be implemented differently.

That said, I still think it remains to be proven that
reducing the number of hypercalls by 2x or 3x (or whatever
the batching factor you choose) will make a noticeable
performance difference.  But if it does, batching can
be done... and completely hidden in the backend.

(I hope Andrea is listening ;-)

Dan

