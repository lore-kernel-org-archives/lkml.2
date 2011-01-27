Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab1A0Q0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 11:26:40 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:17885 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab1A0Q0j (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 27 Jan 2011 11:26:39 -0500
Date: Thu, 27 Jan 2011 10:25:08 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, x86@kernel.org,
        xen-devel@lists.xensource.com, jeremy@goop.org, mingo@redhat.com,
        mingo@elte.hu
Subject: Re: [Xen-devel] [PATCH] xen: convert p2m to a 3 level tree -
 partial revert
Message-ID: <20110127152508.GC3282@dumpdata.com>
References: <20110127144843.GA23746@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110127144843.GA23746@router-fw-old.local.net-space.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 03:48:43PM +0100, Daniel Kiper wrote:
> Hi,
> 
> Durning work on Xen memory hotplug I discoverd that
> 2.6.38-rc2 does not boot on domU. After some investigation
> it appeared that 58e05027b530ff081ecea68e38de8d59db8f87e0
> commit changed CONFIG_XEN_MAX_DOMAIN_MEMORY constant value
> to 128. This change does not allow to boot kernel on domU
> with small memory size (I could confirm that it is even
> not possible to boot kernel on domU with 2 GiB). Guest

Strange.. I've been booting with 1G, 2G, 3G, 4G guests.

Could you give more details? Is this a 32-bit guest? 64-bit?
What does your xm file look like?

> crash silently without any warning. Durning further
> research I found out that there is another commit published
> recently (8e1b4cf2108488ccfb9a3e7ed7cd85a435e01d4b) which attempts
> to fix this issue, however, it does not work on my platform.
> I decided to reenable CONFIG_XEN_MAX_DOMAIN_MEMORY option in
> kernel config and enable users to choose resonable values for
> their machines until better fix will be published. I think this
> solution is good because allow users to boot domU with newest
> kernel and allow developers to continue their work without
> time presure which could lead to new bugs.

I think you are hitting a completly different bug. This
patch of yours changes the size of the structure - so it could
be that you are hitting a page-table overwrite. This is something
that Stefano has been looking at - you might want to take a look at
"x86: When destroying mappings between _brk_end and _end, do not go over _end"
(it is present in his git tree).

Or you might be hitting the issue I've which is pin_pagetable_init
failing. Can you run 'xenctx' on your guest and see
where it crashed? If you crank up the serial log or Xen logging
options do you see anything?

Does it look like this:
http://darnok.org/xen/p2m-v47-stefano-nx.txt
(I added some extra logging so it might not be exact).

