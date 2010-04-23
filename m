Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab0DWNsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 09:48:40 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59397 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab0DWNsi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 09:48:38 -0400
MIME-Version: 1.0
Message-ID: <b01d7882-1a72-4ba9-8f46-ba539b668f56@default>
Date: Fri, 23 Apr 2010 06:47:18 -0700 (PDT)
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
 <4BD07594.9080905@redhat.com> <b1036777-129b-4531-a730-1e9e5a87cea9@default
 4BD16D09.2030803@redhat.com>
In-Reply-To: <4BD16D09.2030803@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4BD1A50F.00A0:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Much easier to simulate an asynchronous API with a synchronous
> backend.
> >>
> > Indeed.  But an asynchronous API is not appropriate for frontswap
> > (or cleancache).  The reason the hooks are so simple is because they
> > are assumed to be synchronous so that the page can be immediately
> > freed/reused.
> >
> 
> Swapping is inherently asynchronous, so we'll have to wait for that to
> complete anyway (as frontswap does not guarantee swap-in will succeed).
> I don't doubt it makes things simpler, but also less flexible and
> useful.
> 
> Something else that bothers me is the double swapping.  Sure we're
> making swapin faster, but we we're still loading the io subsystem with
> writes.  Much better to make swap-to-ram authoritative (and have the
> hypervisor swap it to disk if it needs the memory).

Hmmm.... I now realize you are thinking of applying frontswap to
a hosted hypervisor (e.g. KVM). Using frontswap with a bare-metal
hypervisor (e.g. Xen) works fully synchronously, guarantees swap-in
will succeed, never double-swaps, and doesn't load the io subsystem
with writes.  This all works very nicely today with a fully
synchronous "backend" (e.g. with tmem in Xen 4.0).

So, I agree, hiding a truly asynchronous interface behind
frontswap's synchronous interface may have some thorny issues.
I wasn't recommending that it should be done, just speculating
how it might be done.  This doesn't make frontswap any less
useful with a fully synchronous "backend".

> >> Well, copying memory so you can use a zero-copy dma engine is
> >> counterproductive.
> >>
> > Yes, but for something like an SSD where copying can be used to
> > build up a full 64K write, the cost of copying memory may not be
> > counterproductive.
> 
> I don't understand.  Please clarify.

If I understand correctly, SSDs work much more efficiently when
writing 64KB blocks.  So much more efficiently in fact that waiting
to collect 16 4KB pages (by first copying them to fill a 64KB buffer)
will be faster than page-at-a-time DMA'ing them.  If so, the
frontswap interface, backed by an asynchronous "buffering layer"
which collects 16 pages before writing to the SSD, may work
very nicely.  Again this is still just speculation... I was
only pointing out that zero-copy DMA may not always be the best
solution.

Thanks,
Dan
