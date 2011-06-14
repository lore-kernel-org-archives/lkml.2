Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab1FNTsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 15:48:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64255 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab1FNTsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 15:48:50 -0400
Date: Tue, 14 Jun 2011 15:48:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Tobias Diedrich <ranma+xen@tdiedrich.de>, xen-users@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: 3.0.0-rc2: Xen: High amount of kernel "reserved" memory, about
 33% in 256MB DOMU [workaround included]
Message-ID: <20110614194810.GA26728@dumpdata.com>
References: <20110613205003.GD20616@yumi.tdiedrich.de>
 <20110613215900.GB19117@dumpdata.com>
 <20110614001055.GB7417@yumi.tdiedrich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110614001055.GB7417@yumi.tdiedrich.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090208.4DF7BB1B.0072:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 02:10:55AM +0200, Tobias Diedrich wrote:
> Konrad Rzeszutek Wilk wrote:
> > On Mon, Jun 13, 2011 at 10:50:03PM +0200, Tobias Diedrich wrote:
> > > Hi,
> > > 
> > > another issue I'm seeing with 3.0-rc2 and Xen is that there is an
> > > unexpectedly high amount of kernel reserved memory.
> > 
> > > 
> > > I suspect that Linux allocates page table entries and corresponding
> > > data structures for the whole 6GB areas of the provided 'physical
> > > RAM map' even though it has rather big unusable holes in it.
> > 
> > Can you run it with 'memblock=debug debug loglevel=8 initcall_debug'?
> > It should tell you where it tries (and for much space) the pagetables.

Ugh. In the meantime I would suggest you do the combination of:

Xen hypervisor line: "dom0_mem=max:512M" and on the Linux line: "mem=512M" to
cut down on the extra pagetable creation..

.. snip ..
> [    0.000000] init_memory_mapping: 0000000000000000-0000000010000000
> [    0.000000]  0000000000 - 0010000000 page 4k
> [    0.000000] kernel direct mapping tables up to 10000000 @ ff7e000-10000000
> [    0.000000]     memblock_x86_reserve_range: [0x0ff7e000-0x0ffe9fff]          PGTABLE
> [    0.000000] xen: setting RW the range ffea000 - 10000000

So ff7e->ffea pages, or 432kBytes
> [    0.000000] init_memory_mapping: 0000000100000000-000000016fef0000
> [    0.000000]  0100000000 - 016fef0000 page 4k
> [    0.000000] kernel direct mapping tables up to 16fef0000 @ f3f7000-ff7e000
> [    0.000000]     memblock_x86_reserve_range: [0x0f3f7000-0x0f778fff]          PGTABLE
> [    0.000000] xen: setting RW the range f779000 - ff7e000

And here from f3f7 through f779, so 3592kB or 3.5MB for un-used potential balloon memory.
