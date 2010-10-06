Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018Ab0JFXJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 19:09:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:56153 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab0JFXJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 19:09:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,293,1283756400"; 
   d="scan'208";a="333088008"
Message-ID: <4CAD01A9.9050907@intel.com>
Date: Wed, 06 Oct 2010 16:09:29 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "caiqian@redhat.com" <caiqian@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:core/memblock] x86, memblock: Fix crashkernel allocation
References: <4CABAF2A.5090501@kernel.org> <tip-9f4c13964b58608fbce05540743281ea3146c0e8@git.kernel.org> <20101006151449.GA7378@redhat.com> <4CACF531.2060407@intel.com> <20101006224704.GD7378@redhat.com>
In-Reply-To: <20101006224704.GD7378@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2010 03:47 PM, Vivek Goyal wrote:
> 
> I really don't mind fixing the things properly in long term, just that I am
> running out of ideas regarding how to fix it in proper way.
> 
> To me the best thing would be that this whole allocation thing be dyanmic
> from user space where kexec will run, determine what it is loading, 
> determine what are the memory contstraints on these segments (min, upper
> limit, alignment etc), and then ask kernel for reserving contiguous
> memory. This kind of dynamic reservation will remove lot of problems
> associated with crashkernel= reservations.
> 
> But I am not aware of anyway of doing dynamic allocation and it certainly
> does not seem to be easy to be able to allocated 128M of memory contiguously.
> 
> Because we don't have a way to reserve memory dynamically later, we end up
> doing a big chunk of reservation using kernel command line and later
> figure out what to load where. Now with this approach kexec has not even run
> so how it can tell you what are the memory constraints.
> 
> So to me one of the ways of properly fixing is adding some kind of
> capability to reserve the memory dynamically (may be using sys_kexec())
> and get rid of this notion of reserving memory at boot time.

The problem, of course, will allocating very large chunks of memory at
runtime is that there are going to be some number of non-movable and
non-evictable pages that are going to break up the contiguous ranges.
However, the mm recently added support for moving most pages, which
should make that kind of allocation a lot more feasible.  I haven't
experimented how well it works in practice, but I rather suspect that as
long as the crashkernel is installed sufficiently early in the boot
process it should have a very good probability of success.  Another
option, although one which has its own hackiness issues, is to do a
conservative allocation at boot time in preparation of the kexec call,
which is then freed.  This doesn't really address the issue of location,
though, which is part of the problem here.

> The other concern you raised is hiding constraints from kernel. At this
> point of time the only problem with crashkernel=X@0 syntax is that it
> does not tell you whether to look for memory bottom up or top down. How
> about if we specify it explicitly in the syntax so that kernel does not
> have to assume things?

See below.

> In fact the initial crashkernel syntax was. crashkernel=X@Y. This meant
> allocated X amount of memory at location Y. This left no ambiguity and
> kernel did not have to assume things. It had the problem though that 
> we might not have physical RAM at location Y. So I think that's when
> somebody came up with the idea of crashkernel=X@0 so that we ideally
> want memory at location 0, but if you can't provide that, then provide
> anything available next scanning bottom up. 
> 
> So the only part missing from syntax is explicitly speicifying "next
> available location scanning bottom up". If we add that to syntax then
> kernel does not have to make assumptions. (except the alignment part).
> 
> So how about modifying syntax to crashkernel=X@Y#BU.
> 
> The "#BU" part can be optional and in that case kernel is free to allocate
> memory either top down or bottom up.
> 
> Or any other string which can communicate the bottom up part in a more 
> intutive manner.

The whole problem here is that "bottoms up" isn't the true constraint --
it's a proxy for "this chunk needs < address X, this chunk needs <
address Y, ..." which is the real issue.  This is particularly messy
since low memory is a (sometimes very) precious resource that is used by
a lot of things (BIOS stubs, DMA-mask-limited hardware devices, and
perhaps especially 1:1 mappable pages on 32 bits, and so on), and one of
the major reasons we want to switch to a top-down allocation scheme is
to not waste a precious resource when we don't have to.

The one improvement one could to the crashkernel= syntax is perhaps
"crashkernel=X<Y" meaning "allocate entirely below Y", since that is (at
least in part) the real constraint.  It could even be extended to
multiple segments: "crashkernel=X<Y,Z<W,..." if we really need to...
that way you have your preallocation.

	-hpa
