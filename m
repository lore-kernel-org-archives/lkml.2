Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789Ab1DNLFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 07:05:50 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:40622 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758738Ab1DNLFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 07:05:49 -0400
X-IronPort-AV: E=Sophos;i="4.64,210,1301875200"; 
   d="scan'208";a="5301241"
Date: Thu, 14 Apr 2011 12:05:42 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/4] x86,xen: introduce
 x86_init.mapping.pagetable_reserve
In-Reply-To: <4DA5EB46.6090302@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1104141147210.22672@kaball-desktop>
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop> <1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com> <4DA48EA9.70109@kernel.org> <alpine.DEB.2.00.1104131125080.22672@kaball-desktop> <4DA5EB46.6090302@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011, H. Peter Anvin wrote:
> On 04/13/2011 03:35 AM, Stefano Stabellini wrote:
> > Yes, that would be ideal, but we cannot do that because we don't know
> > exactly where is pgt_buf_end before allocating the pagetable pages and
> > the pagetable pages need to be marked RO before being hooked into the
> > pagetable. This is why we mark the whole range RO and after the
> > pagetable allocation when we know for sure where is pgt_buf_end we
> > modify the range pgt_buf_end-pgt_buf_top to RW.
> 
> The hell?  You have to fill the pages before you hook them into the page
> tables anyway (this means writing!) and then you have to mark them RO as
> you add them to the page tables... anything else doesn't make any sense
> at all.

Right.
The problem is that at some point init_memory_mapping is going reach the
pagetable pages area and map those pages too (I don't mean hooking the
pagetable pages in the pagetable, I mean mapping them as normal memory
that falls in the range of addresses passed to init_memory_mapping as
argument).
Some of those pages are already pagetable pages (they are in the range
pgt_buf_start-pgt_buf_end) therefore they are going to be mapped RO and
everything is fine.
Some of these pages are not pagetable pages yet (they fall in the range
pgt_buf_end-pgt_buf_top; for example the page at pgt_buf_end) so they
are going to be mapped RW.  When these pages become pagetable pages and
are hooked into the pagetable, xen will find that the guest has already
a RW mapping of them somewhere and fail the operation.

In order to fix the issue I could mark all the pages in the entire range
pgt_buf_start-pgt_buf_top as RO, but then once the pagetable allocation
is completed only the range pgt_buf_start-pgt_buf_end is reserved by
init_memory_mapping therefore the kernel is going to crash as soon as
one of the pages in the range pgt_buf_end-pgt_buf_top is reused.


Initially I suggested to add two hooks: one to allocate the pagetable
pages memory and one to reserve the pagetable pages memory after the
allocation:

http://marc.info/?l=linux-kernel&m=130141955626268

Following Yinghai's suggestion I removed the first hook (currently
unnecessary because we would use the same implementation on native and
on xen) and modified the second one, that became
x86_init.mapping.pagetable_reserve.
