Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab2JIMX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:23:58 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:13757 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab2JIMXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:23:55 -0400
X-IronPort-AV: E=Sophos;i="4.80,560,1344211200"; 
   d="scan'208";a="15036400"
Date: Tue, 9 Oct 2012 13:22:49 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 08/10] x86, xen, mm: fix mapping_pagetable_reserve
 logic
In-Reply-To: <5073D0C1.4020606@zytor.com>
Message-ID: <alpine.DEB.2.02.1210091240300.29539@kaball.uk.xensource.com>
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org> <1349757558-10856-9-git-send-email-yinghai@kernel.org> <5073C05E.5020402@zytor.com> <CAE9FiQXa9fqLOyqzap6o_0HA=oBRKqkcWm9bdpK9M6R5cQMU-A@mail.gmail.com> <5073D0C1.4020606@zytor.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2012, H. Peter Anvin wrote:
> On 10/09/2012 02:33 PM, Yinghai Lu wrote:
> >>
> >> make_range_readwrite is particularly toxic, though, because it makes it
> >> sound like it something along the lines of set_memory_rw(), which it
> >> most distinctly is not.
> > 
> > it just change some page range from RO back to RW.
> > 
> > so how about update_range_ro_to_rw?
> > 
> 
> You're focusing on what the low-level mechanics of one particular
> implementation (Xen) of the hook, and then try to make it describe the
> hook itself.
> 
> What the hook does, if I am reading it correctly, is take a range that
> used to be page tables and turn it back to "ordinary memory".  As such,
> assuming I'm following the logic correctly, something like
> pagetable_unreserve() seems like a reasonable name.
> 
> However, why during initialization, why do we have to unreserve memory
> that has already been reserved for pagetables?  (Keep in mind there may
> very well be an entirely sensible answer for that question -- I just
> can't tell from the patchset without a much more in-depth analysis.
> Keep in mind that that in-depth analysis sucks up time, and it doesn't
> scale to expect the maintainer to have to do that.)

I can give some hints: find_early_table_space allocates more memory than
needed for pagetable pages, the allocated range is
pgt_buf_start-pgt_buf_top.

In fact init_memory_mapping doesn't use all the memory in that range,
and after building the pagetables calls pagetable_reserve to reserve
only the range of memory that actually used.
On native is just a memblock_reserve, to make sure that pagetable pages
are not reused as normal memory.
On Xen, in addition to that, we also make RW the rest of the range
pgt_buf_start-pgt_buf_top.

The first problem that I can see with this scheme is that
pgt_buf_start-pgt_buf_top is assumed to be the pagetable pages range by
the Xen subsystem while it should be exported with a more appropriate
hook.

If we had a hook in find_early_table_space called "pagetable_reserve"
that tells everybody what is the pagetable pages range in memory, then
we could have a "pagetable_unreserve" hook to release the unused
portions of that memory range. This would make more sense to me.
