Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab1KBVOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 17:14:40 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:48625 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab1KBVOg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 17:14:36 -0400
MIME-Version: 1.0
Message-ID: <cb397723-5297-493d-9bbd-522a6400a5a6@default>
Date: Wed, 2 Nov 2011 14:14:16 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Cyclonus J <cyclonusj@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        Chris Mason <chris.mason@oracle.com>, JBeulich@novell.com,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: RE: [GIT PULL] mm: frontswap (for 3.2 window)
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
 <75efb251-7a5e-4aca-91e2-f85627090363@default>
 <20111027215243.GA31644@infradead.org> <1319785956.3235.7.camel@lappy>
 <CAOzbF4fnD=CGR-nizZoBxmFSuAjFC3uAHf3wDj5RLneJvJhrOQ@mail.gmail.comCAOJsxLGOTw7rtFnqeHvzFxifA0QgPVDHZzrEo=-uB2Gkrvp=JQ@mail.gmail.com>
 <552d2067-474d-4aef-a9a4-89e5fd8ef84f@default20111031181651.GF3466@redhat.com>
 <60592afd-97aa-4eaf-b86b-f6695d31c7f1@default>
 <20111031223717.GI3466@redhat.com>
 <1b2e4f74-7058-4712-85a7-84198723e3ee@default 4EB1AD53.2000600@redhat.com>
In-Reply-To: <4EB1AD53.2000600@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6562.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4EB1B2AD.0108,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Rik van Riel [mailto:riel@redhat.com]
> Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
> 
> On 10/31/2011 07:36 PM, Dan Magenheimer wrote:
> >> From: Andrea Arcangeli [mailto:aarcange@redhat.com]
> 
> >>> real work to do instead and (2) that vmexit/vmenter is horribly
> >>
> >> Sure the CPU has another 1000 VM to schedule. This is like saying
> >> virtio-blk isn't needed on desktop virt becauase the desktop isn't
> >> doing much I/O. Absurd argument, there are another 1000 desktops doing
> >> I/O at the same time of course.
> >
> > But this is truly different, I think at least for the most common
> > cases, because the guest is essentially out of physical memory if it
> > is swapping.  And the vmexit/vmenter (I assume, I don't really
> > know KVM) gives the KVM scheduler the opportunity to schedule
> > another of those 1000 VMs if it wishes.
> 
> I believe the problem Andrea is trying to point out here is
> that the proposed API cannot handle a batch of pages to be
> pushed into frontswap/cleancache at one time.

That wasn't the part of Andrea's discussion I meant, but I
am getting foggy now, so let's address your point rather
than mine.
 
> Even if the current back-end implementations are synchronous
> and can only do one page at a time, I believe it would still
> be a good idea to have the API able to handle a vector with
> a bunch of pages all at once.
> 
> That way we can optimize the back-ends as required, at some
> later point in time.
> 
> If enough people start using tmem, such bottlenecks will show
> up at some point :)

It occurs to me that batching could be done locally without
changing the in-kernel "API" (i.e. frontswap_ops)... the
guest-side KVM tmem-backend-driver could do the compression
into guest-side memory and make a single
hypercall=vmexit/vmenter whenever it has collected enough for
a batch. The "get" and "flush" would have to search this guest-side
local cache and, if not local, make a hypercall.

This is more or less what RAMster does, except it (currently)
still transmits the "batch" one (pre-compressed) page at a time.

And, when I think about it deeper (with my currently admittedly
fried brain), this may even be the best way to do batching
anyway.  I can't think offhand where else you would put
a "put batch" hook in the swap subsystem because I think
the current swap subsystem batching code only works with
adjacent "entry" numbers.

And, one more thing occurs to me then... this shows the KVM
"ABI" (hypercall) is not constrained by the existing Xen
ABI.  It can be arbitrarily more functional.

/me gets hand slapped remotely from Oracle HQ ;-)
