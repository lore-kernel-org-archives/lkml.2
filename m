Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2EZSaD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 14:30:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48976 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab2EZSaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 14:30:00 -0400
Date: Sat, 26 May 2012 11:29:37 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: William Dauchy <wdauchy@gmail.com>, shli@fusionio.com,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        xen-devel@lists.xensource.com, Shaohua Li <shli@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [Xen-devel] swap: don't do discard if no discard option added
In-Reply-To: <20120521181558.GA7829@phenom.dumpdata.com>
Message-ID: <alpine.LSU.2.00.1205261113470.2033@eggly.anvils>
References: <CAJ75kXbC3gqQAaghKo2i1L650dw9-vrFuEwoy4defagoyR8p4Q@mail.gmail.com> <20120521181558.GA7829@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012, Konrad Rzeszutek Wilk wrote:
> On Mon, May 21, 2012 at 12:30:45AM +0200, William Dauchy wrote:
> > Hello,
> > 
> > On Xen, when booting a guest with a system disk and an additional swap
> > disk I'm getting a calltrace.
> > xen hypervisor: 4.1.2; linux dom0: v3.3.6; linux guest: v3.2.17
> > When booting without a swap disk, I don't have the issue.
> > I also tested a guest with v3.3.6: same problem. But from v3.4-rc2,
> > the issue is fixed.
> > I cherry-picked:
> 
> > 052b198 swap: don't do discard if no discard option added
> 
> So you are asking for 052b198 to be back-ported.
> 
> I am OK with that but I think Shaohua needs to Ack that and
> ask Greg to put it on stable@kernel.org

Since that commit did indeed go into v3.4, I won't quarrel with it
now going to stable.

But the commit went in to work around the slow discard implementation
on OCZ Vertex II SSDs.

Please, could someone explain to me the meaning of the stacktrace
below (which is missing a WARNING or BUG line?), and how disabling
swap discard fixes it?

At present I see no connection (beyond the fact that the patch fixes
the symptom): in the absence of understanding, I have to beware that
the underlying issue may remain unfixed.

Hugh

> 
> 
> 
> > Applied and tested on top of v3.2.17 and v3.3.6, it fixes the issue.
> > 
> > Pid: 0, comm: swapper/0 Not tainted 3.2.17-x86_64 #12
> > Call Trace:
> >  <IRQ>
> >  [<ffffffff810919da>] ? handle_irq_event_percpu+0x3a/0x140
> >  [<ffffffff81091b29>] ? handle_irq_event+0x49/0x80
> >  [<ffffffff81094e7d>] ? handle_edge_irq+0x6d/0x120
> >  [<ffffffff81229088>] ? __xen_evtchn_do_upcall+0x1b8/0x280
> >  [<ffffffff8122a442>] ? xen_evtchn_do_upcall+0x22/0x40
> >  [<ffffffff8133f4fe>] ? xen_do_hypervisor_callback+0x1e/0x30
> >  <EOI>
> >  [<ffffffff810013aa>] ? hypercall_page+0x3aa/0x1000
> >  [<ffffffff810013aa>] ? hypercall_page+0x3aa/0x1000
> >  [<ffffffff8100768c>] ? xen_safe_halt+0xc/0x20
> >  [<ffffffff81013563>] ? default_idle+0x23/0x40
> >  [<ffffffff8100b073>] ? cpu_idle+0x63/0xb0
> >  [<ffffffff81654c43>] ? start_kernel+0x362/0x36d
> >  [<ffffffff81657491>] ? xen_start_kernel+0x558/0x55e
> > Code: 39 ed 0f 84 1c 02 00 00 44 8b 7b 48 4c 8b 73 50 41 83 ef 01 41
> > 21 ef 49 6b c7 70 4d 8b 64 06 40 49 69 c4 d0 00 00 00 48 8d 14 03 <48>
> > 8b 8a 78 02 00 00 48 89 4c 24 10 80 ba 09 02 00 00 00 74 6d
> > RIP  [<ffffffff8125ed66>] blkif_interrupt+0x66/0x320
> >  RSP <ffff88001fc03e18>
> > ---[ end trace dfd4e5623eb06620 ]---
