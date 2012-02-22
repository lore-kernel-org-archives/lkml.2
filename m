Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab2BVVBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 16:01:05 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39576 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab2BVVBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 16:01:03 -0500
Date: Wed, 22 Feb 2012 13:00:59 -0800
From: Tejun Heo <tj@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: mroos@linux.ee, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        sam@ravnborg.org
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
Message-ID: <20120222210059.GA22536@google.com>
References: <20120221010537.GA15898@dhcp-172-17-108-109.mtv.corp.google.com>
 <alpine.SOC.1.00.1202220213180.4171@math.ut.ee>
 <20120222174825.GA32694@google.com>
 <20120222.154417.1110838022563953071.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222.154417.1110838022563953071.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David.

On Wed, Feb 22, 2012 at 03:44:17PM -0500, David Miller wrote:
> > Can you please try the following patch?  If it still fails to boot,
> > please attach the failing log.  Thank you.
> 
> Interesting, but two things strike me.
> 
> First, this seems like it would only cause problems if the caller
> specified a too small size parameter, and then wrote past the 'size'
> bytes of the buffer.  And if so, this means we have an improperly
> sized allocation somewhere, probably in the OF tree fetching code.

There's another, less likely, possibility.  It made the allocation
table much larger and the lowest address used ended up lower.
0x0000007fc8fa40 vs 0x0000007fc94000.  Not too much of difference and
just allocating some more memory should rule out or confirm it.

> For example, maybe we mis-calculate the size of an OF device node
> property before we fetch it from the firmware, therefore allocate
> too small a buffer, and the property fetch operation splats all
> over the end of the buffer.  Another possibility is that the
> property length reported by the firmware is wrong and too small.
> 
> BTW, this kind of bug would be easy to catch, simply put a magic
> number signature into all unallocated memblock memory then at
> allocation time check that signature.  If we signal an error when we
> don't see the proper signature and turn on the OF tree building
> logging, we can see exactly which operation writes past the end of a
> buffer.

Yeah, redzonning can definitely help but I'm not sure whether we want
to go full on allocation debugging and all for early allocator.  The
thing doesn't even support freeing.

> Second, you'd need similar handling in other call chains such as
> memblock_double_array()'s invocation of memblock_find_in_range().
> It seems a bad idea to hide how size is modified, so probably it's
> best to pass the address of the size parameter and modify the
> caller's value in that way so that the size used in the reserve
> matches up.

I suspect the size modification was added later to avoid expanding
allocation table early during boot and we can do that only for
memblock_alloc*() calls as they don't have matching free interface.
If we modify explicit reservations, we have to propagate the modified
size to each user and so on.  Given that the allocation table is
discarded after boot completion and there aren't too many explicit
reservations, I don't think we need to expand size aligning to all
find_in_range users.  I guess it all depends on how complete allocator
we want for early boot.

Thanks.

-- 
tejun
