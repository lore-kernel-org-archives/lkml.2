Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1JONXU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 09:23:20 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:40343 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab1JONXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 09:23:18 -0400
X-Greylist: delayed 1036 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Oct 2011 09:23:18 EDT
Date: Sat, 15 Oct 2011 09:05:52 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Maxim Uvarov <maxim.uvarov@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com
Subject: Re: [PATCH] XEN_DOMAIN_MEMORY options.
Message-ID: <20111015130552.GC18864@andromeda.dapyr.net>
References: <1318631811-21559-1-git-send-email-maxim.uvarov@oracle.com> <4E98BEF5.10801@goop.org> <4E98C6CE.4020508@oracle.com> <4E98C8B1.20304@goop.org> <4E98D739.4000705@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E98D739.4000705@oracle.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 05:43:37PM -0700, Maxim Uvarov wrote:
> On 10/14/2011 04:41 PM, Jeremy Fitzhardinge wrote:
> >On 10/14/2011 04:33 PM, Maxim Uvarov wrote:
> >>On 10/14/2011 04:00 PM, Jeremy Fitzhardinge wrote:
> >>>On 10/14/2011 03:36 PM, Maxim Uvarov wrote:
> >>>>Hello,
> >>>>
> >>>>Please find here patches for XEN_MAX_DOMAIN_MEMORY:
> >>>>
> >>>>[PATCH 1/2] xen: Fix XEN_MAX_DOMAIN_MEMORY to be selectable
> >>>>[PATCH 2/2] xen: Make XEN_MAX_DOMAIN_MEMORY have more sensible
> >>>>defaults for 32-bit builds
> >>>
> >>>What's the rationale?
> >>>
> >>>      J
> >>
> >>The first patch is actually bug fix. You can not define just "int"
> >>without description in Kconfig. As the result this option will not be
> >>visible in menuconfig. Even if you will change it in .config make
> >>oldconfig will set it up for default value. So you need to add any
> >>description to it as all others int options have.
> >
> >No, that was deliberate, because I don't really think there's a need to
> >change it.
> >
> 
> From that point of view it's not clear why this option is still in Kconfig?

Well, we do need to alter it to 512GB. Actually -  putting that extra
burden on initial pagetables to reserve extra 384 pages might be a bit
too much. Even thought later on we reclaim it if we do not use it.

Either way, we should be able to boot a PV guest with 512GB, so why not
just make that the default for 64-bit?
> 
> Jeremy, can you please share more details about this? I see people are 
> having troubles with this option and in different kernels I see 
> different work arounds  for it. For example:
> http://lists.xensource.com/archives/html/xen-devel/2011-01/msg01841.html

.. which ultimately was due to bugs in the initial page tables setup in
the generic code and in the Xen MMU (fixed in 2.6.39):

279b706 x86,xen: introduce x86_init.mapping.pagetable_reserve
b9269dc xen: mask_rw_pte mark RO all pagetable pages up to pgt_buf_top
ee17645 xen: mask_rw_pte: do not apply the early_ioremap checks on x86_32
d8aa5ec xen: update mask_rw_pte after kernel page tables init changes
e5f15b4 x86: Cleanup highmap after brk is conclude

What are the "I see people are having troubles with this option" ?
(Anything before 2.6.39 is very much related to those bug-fixes I
just pointed out).

> 
> Maxim.
> >>
> >>Second patch is more optional and it's just suggestion to use for 32
> >>bit more corresponding value.
> >
> >While it would be very silly to put 128GB of actual RAM on a 32-bit
> >machine, systems can have non-contiguous RAM placed at high addresses,
> >which would no longer be accessible.

Do you have some ideas of which machines that might be?
