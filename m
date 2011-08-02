Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab1HBQY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 12:24:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1673 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab1HBQYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 12:24:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=IzWxHv/kw4R3X+6pW7scJ7UMRVz2kr8J2b9RKhsSg7rg29R25mpfcbCzFoxqj9F40
	IsiuETtw+P/vXQE9yo3Sw==
Date: Tue, 2 Aug 2011 09:24:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, hughd@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] Lockless SLUB slowpaths for v3.1-rc1
In-Reply-To: <alpine.DEB.2.00.1108020913180.18965@router.home>
Message-ID: <alpine.DEB.2.00.1108020915370.1114@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1107290145080.3279@tiger> <alpine.DEB.2.00.1107291002570.16178@router.home> <alpine.DEB.2.00.1107311136150.12538@chino.kir.corp.google.com> <alpine.DEB.2.00.1107311253560.12538@chino.kir.corp.google.com> <1312145146.24862.97.camel@jaguar>
 <alpine.DEB.2.00.1107311426001.944@chino.kir.corp.google.com> <CAOJsxLHB9jPNyU2qztbEHG4AZWjauCLkwUVYr--8PuBBg1=MCA@mail.gmail.com> <alpine.DEB.2.00.1108012101310.6871@chino.kir.corp.google.com> <alpine.DEB.2.00.1108020913180.18965@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Aug 2011, Christoph Lameter wrote:

> > Yes, slub _did_ use more memory than slab until the alignment of
> > struct page.  That cost an additional 128MB on each of these 64GB
> > machines, while the total slab usage on the client machine systemwide is
> > ~75MB while running netperf TCP_RR with 160 threads.
> 
> I guess that calculation did not include metadata structures (alien caches
> and the NR_CPU arrays in kmem_cache) etc? These are particularly costly on SLAB.
> 

It certainly is costly on slab, but that 75MB number is from a casual 
observation of grep Slab /proc/meminfo while running the benchmark.  For 
slub, that turns into ~55MB.  The true slub usage, though, includes the 
struct page alignment for cmpxchg16b which added 128MB of padding into its 
memory usage even though it appears to be unattributed to slub.  A casual 
grep MemFree /proc/meminfo reveals the lost 100MB for the slower 
allocator, in this case.  And the per-cpu partial list will add even 
additional slab usage for slub, so this is where my "throwing more memory 
at slub to get better performance" came from.  I understand that this is a 
large NUMA machine, though, and the cost of slub may be substantially 
lower on smaller machines.

If you look through the various arch defconfigs, you'll see that we 
actually do a pretty good job of enabling CONFIG_SLAB for large systems.  
I wish we had a clear dividing line in the x86 kconfig that would at least 
guide users toward one allocator over another though, otherwise they 
receive little help.
