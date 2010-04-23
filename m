Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810Ab0DWP5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:57:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19415 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671Ab0DWP5R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:57:17 -0400
MIME-Version: 1.0
Message-ID: <b559c57a-0acb-4338-af21-dbfc3b3c0de5@default>
Date: Fri, 23 Apr 2010 08:56:17 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
       hugh.dickins@tiscali.co.uk, ngupta@vflare.org, JBeulich@novell.com,
       chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, npiggin@suse.de, akpm@linux-foundation.org,
       riel@redhat.com
Subject: RE: Frontswap [PATCH 0/4] (was Transcendent Memory): overview
References: <20100422134249.GA2963@ca-server1.us.oracle.com>
 <4BD06B31.9050306@redhat.com> <53c81c97-b30f-4081-91a1-7cef1879c6fa@default>
 <4BD07594.9080905@redhat.com> <b1036777-129b-4531-a730-1e9e5a87cea9@default>
 <4BD16D09.2030803@redhat.com> <b01d7882-1a72-4ba9-8f46-ba539b668f56@default>
 <4BD1A74A.2050003@redhat.com> <4830bd20-77b7-46c8-994b-8b4fa9a79d27@default
 4BD1B427.9010905@redhat.com>
In-Reply-To: <4BD1B427.9010905@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090207.4BD1C33F.0070:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Each page is either in frontswap OR on the normal swap device,
> > never both.  So, yes, both reads and writes are avoided if memory
> > is available and there is no write issued to the io subsystem if
> > memory is available.  The is_memory_available decision is determined
> > by the hypervisor dynamically for each page when the guest attempts
> > a "frontswap_put".  So, yes, you are indeed "swapping to the
> > hypervisor" but, at least in the case of Xen, the hypervisor
> > never swaps any memory to disk so there is never double swapping.
> 
> I see.  So why not implement this as an ordinary swap device, with a
> higher priority than the disk device?  this way we reuse an API and
> keep
> things asynchronous, instead of introducing a special purpose API.

Because the swapping API doesn't adapt well to dynamic changes in
the size and availability of the underlying "swap" device, which
is very useful for swap to (bare-metal) hypervisor.

> Doesn't this commit the hypervisor to retain this memory?  If so, isn't
> it simpler to give the page to the guest (so now it doesn't need to
> swap at all)?

Yes the hypervisor is committed to retain the memory.  In
some ways, giving a page of memory to a guest (via ballooning)
is simpler and in some ways not.  When a guest "owns" a page,
it can do whatever it wants with it, independent of what is best
for the "whole" virtualized system.  When the hypervisor
"owns" the page on behalf of the guest but the guest can't
directly address it, the hypervisor has more flexibility.
For example, tmem optionally compresses all frontswap pages,
effectively doubling the size of its available memory.
In the future, knowing that a guest application can never
access the pages directly, it might store all frontswap pages in
(slower but still synchronous) phase change memory or "far NUMA"
memory.

> What about live migration?  do you live migrate frontswap pages?

Yes, fully supported in Xen 4.0.  And as another example of
flexibility, note that "lazy migration" of frontswap'ed pages
might be quite reasonable.

> >> The guest can easily (and should) issue 64k dmas using
> scatter/gather.
> >> No need for copying.
> >>
> > In many cases, this is true.  For the swap subsystem, it may not
> always
> > be true, though I see recent signs that it may be headed in that
> > direction.
> 
> I think it will be true in an overwhelming number of cases.  Flash is
> new enough that most devices support scatter/gather.

I wasn't referring to hardware capability but to the availability
and timing constraints of the pages that need to be swapped.

> > In any case, unless you see this SSD discussion as
> > critical to the proposed acceptance of the frontswap patchset,
> > let's table it until there's some prototyping done.
>
> It isn't particularly related.

Agreed.
