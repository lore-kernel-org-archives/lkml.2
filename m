Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977Ab0JFWQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 18:16:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:32733 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759981Ab0JFWQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 18:16:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,293,1283756400"; 
   d="scan'208";a="561382835"
Message-ID: <4CACF531.2060407@intel.com>
Date: Wed, 06 Oct 2010 15:16:17 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, yinghai@kernel.org,
        caiqian@redhat.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/memblock] x86, memblock: Fix crashkernel allocation
References: <4CABAF2A.5090501@kernel.org> <tip-9f4c13964b58608fbce05540743281ea3146c0e8@git.kernel.org> <20101006151449.GA7378@redhat.com>
In-Reply-To: <20101006151449.GA7378@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2010 08:14 AM, Vivek Goyal wrote:
> 
> I really don't understand why to put a upper limit of DEFAULT_BZIMAGE_ADDR_MAX.
> It does not make much sense to internally impose an upper limit on
> reserved memory area if reserver has not specified one.
> 
> Why can't we provide a function which does a search from bottom up for
> the required size of memory. If the memory finally reserved does not meet
> the constraints needed by kexec, then kexec load will fail. Kernel does
> not have to try to figure out the upper limit in this case.
> 
> Current state of affairs are not perfect, but coming up with artificial
> upper limit here is further deterioriating the situation, IMHO.
> 
> Regarding the question of specifying the upper limit by kexec on command
> line, I think it is hard. Kexec needs to load multiple segments and some
> needs to go in really low memory area and some can be in higher memory
> area. What is the upper limit in this case. If we take the upper limit
> of lowest memory segment, then we will just not have sufficient memory
> to load all segments.
> 
> That would mean split the reserved region into multiple parts and one
> should specifiy separate upper limit for each region. That would make
> the whole thing complex.
> 
> So can we atleast maintain the status quo where we search for crashkernel
> memory bottom up without any upper limits instread of top down.
> 

The reason the "whole thing is complex" is because your constraints are
complex, and you're still trying to hide them from the kernel.  And what
is absolutely incomprehensible to me is that you seem to think this is okay.

I really, REALLY, ***REALLY*** don't want to burden the kernel with a
bunch of constraints which are invisible to it, where things will
randomly fail because the implementation changed.  We have too much of
that already, and it causes an enormous amount of problems all over the
kernel.

Of course, we're already painted into a corner with a bad design that
isn't going to change overnight, and of course, this is hardly the first
time this has happened -- we do find our way out of tight spots on a
regular basis.  Perhaps you're right and the best thing is to add an
explicit bottoms-up allocator function for now, *BUT* I would also like
to see a firm commitment to fix the underlying architectural problem for
real, and not just "maintain the status quo" indefinitely, which is what
your emails make me think you're expecting.

It's worth noting that we used to have the same problem in the kernel
overall, until Jeremy did a whole lot of work adding the brk allocator
specifically to make sure that our allocations end up deterministic.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

