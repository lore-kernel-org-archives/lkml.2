Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab0DWOoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 10:44:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16873 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab0DWOoN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 10:44:13 -0400
MIME-Version: 1.0
Message-ID: <4830bd20-77b7-46c8-994b-8b4fa9a79d27@default>
Date: Fri, 23 Apr 2010 07:43:17 -0700 (PDT)
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
 <4BD16D09.2030803@redhat.com> <b01d7882-1a72-4ba9-8f46-ba539b668f56@default
 4BD1A74A.2050003@redhat.com>
In-Reply-To: <4BD1A74A.2050003@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4BD1B222.00A6:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Something else that bothers me is the double swapping.  Sure we're
> >> making swapin faster, but we we're still loading the io subsystem
> with
> >> writes.  Much better to make swap-to-ram authoritative (and have the
> >> hypervisor swap it to disk if it needs the memory).
> >>
> > Hmmm.... I now realize you are thinking of applying frontswap to
> > a hosted hypervisor (e.g. KVM). Using frontswap with a bare-metal
> > hypervisor (e.g. Xen) works fully synchronously, guarantees swap-in
> > will succeed, never double-swaps, and doesn't load the io subsystem
> > with writes.  This all works very nicely today with a fully
> > synchronous "backend" (e.g. with tmem in Xen 4.0).
> 
> Perhaps I misunderstood.  Isn't frontswap in front of the normal swap
> device?  So we do have double swapping, first to frontswap (which is in
> memory, yes, but still a nonzero cost), then the normal swap device.
> The io subsystem is loaded with writes; you only save the reads.
> Better to swap to the hypervisor, and make it responsible for
> committing
> to disk on overcommit or keeping in RAM when memory is available.  This
> way we avoid the write to disk if memory is in fact available (or at
> least defer it until later).  This way you avoid both reads and writes
> if memory is available.

Each page is either in frontswap OR on the normal swap device,
never both.  So, yes, both reads and writes are avoided if memory
is available and there is no write issued to the io subsystem if
memory is available.  The is_memory_available decision is determined
by the hypervisor dynamically for each page when the guest attempts
a "frontswap_put".  So, yes, you are indeed "swapping to the
hypervisor" but, at least in the case of Xen, the hypervisor
never swaps any memory to disk so there is never double swapping.
 
> > If I understand correctly, SSDs work much more efficiently when
> > writing 64KB blocks.  So much more efficiently in fact that waiting
> > to collect 16 4KB pages (by first copying them to fill a 64KB buffer)
> > will be faster than page-at-a-time DMA'ing them.  If so, the
> > frontswap interface, backed by an asynchronous "buffering layer"
> > which collects 16 pages before writing to the SSD, may work
> > very nicely.  Again this is still just speculation... I was
> > only pointing out that zero-copy DMA may not always be the best
> > solution.
> 
> The guest can easily (and should) issue 64k dmas using scatter/gather.
> No need for copying.

In many cases, this is true.  For the swap subsystem, it may not always
be true, though I see recent signs that it may be headed in that
direction.  In any case, unless you see this SSD discussion as
critical to the proposed acceptance of the frontswap patchset,
let's table it until there's some prototyping done.

Thanks,
Dan
