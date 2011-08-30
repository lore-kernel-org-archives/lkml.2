Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab1H3Lpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 07:45:47 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:53129 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab1H3Lpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 07:45:46 -0400
X-IronPort-AV: E=Sophos;i="4.68,302,1312156800"; 
   d="scan'208";a="7508511"
Subject: Re: [Xen-devel] Re: kernel BUG at mm/swapfile.c:2527! [was 3.0.0
 Xen	pv guest - BUG: Unable to handle]
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "Christopher S. Aker" <caker@theshore.net>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110829150734.GB24825@dumpdata.com>
References: <9CAEB881-07FE-437C-8A6B-DB7B690CEABE@linode.com>
	 <4E5BA49D.5060800@theshore.net>  <20110829150734.GB24825@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 30 Aug 2011 12:45:44 +0100
Message-ID: <1314704744.28989.2.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 16:07 +0100, Konrad Rzeszutek Wilk wrote: 
> On Mon, Aug 29, 2011 at 10:39:25AM -0400, Christopher S. Aker wrote:
> > And another related from 2.6.39:
> 
> I just don't get how you are the only person seeing this - and you have
> been seeing this from 2.6.32... The dom0 you have - is it printing at least
> something when this happens (or before)? Or the Xen hypervisor:
> maybe a message about L1 pages not found?

It'd be worth ensuring that the requires guest_loglvl and loglvl
parameters to allow this is in place on the hypervisor command line. 

Are these reports against totally unpatched kernel.org domU kernels?

> And the dom0 is 2.6.18, right? - Did you update it (I know that the Red Hat guys
> have been updating a couple of things on it).
> 
> Any chance I can get access to your setup and try to work with somebody
> to reproduce this?
> 
> > 
> > ------------[ cut here ]------------
> > kernel BUG at mm/swapfile.c:2527!

This is "BUG_ON(*map == 0);" which is subtly different from the error in
the original post from Peter which was a "unable to handle kernel paging
request" at EIP c01ab854, with a pagetable walk showing PTE==0.

I'd bet the dereference corresponds to the "*map" in that same place but
Peter can you convert that address to a line of code please?

map came from a kmap_atomic() not far before this point so it appears
that it is mapping the wrong page (so *map != 0) and/or mapping a
non-existent page (leading to the fault).

Warning, wild speculation follows...

Is it possible that we are in lazy paravirt mode at this point such that
the mapping hasn't really occurred yet, leaving either nothing or the
previous mapping? (would the current paravirt lazy state make a useful
general addition to the panic message?)

The definition of kmap_atomic is a bit confusing: 
        /*
         * Make both: kmap_atomic(page, idx) and kmap_atomic(page) work.
         */
        #define kmap_atomic(page, args...) __kmap_atomic(page)
but it appears that the KM_USER0 at the callsite is ignored and instead
we end up using the __kmap_atomic_idx stuff (fine). I wondered if it is
possible we are overflowing the number of slots but there is an explicit
BUG_ON for that case in kmap_atomic_idx_push. Oh, wait, that's iff
CONFIG_DEBUG_HIGHMEM, which appears to not be enabled. I think it would
be worth trying, it doesn't look to have too much overhead. 

Another possibility which springs to mind is the pfn->mfn laundering
going wrong. Perhaps as a skanky debug hack remembering the last pte
val, address, mfn, pfn etc and dumping them on error would give a hint?
I wouldn't expect that to result in a non-present mapping though, rather
I would expect either the wrong thing or the guest to be killed by the
hypervisor

Would it be worth doing a __get_user(map) (or some other "safe" pointer
dereference) right after the mapping is established, catching a fault if
one occurs so we can dump some additional debug in that case? I'm not
entirely sure what to suggest dumping though.

Ian.

> > invalid opcode: 0000 [#1] SMP
> > last sysfs file: /sys/devices/system/cpu/cpu3/topology/core_id
> > Modules linked in:
> > 
> > Pid: 17680, comm: postgres Tainted: G    B       2.6.39-linode33 #3
> > EIP: 0061:[<c01b4b26>] EFLAGS: 00210246 CPU: 0
> > EIP is at swap_count_continued+0x176/0x180
> > EAX: f57bac57 EBX: eba2c200 ECX: f57ba000 EDX: 00000000
> > ESI: ebfd7c20 EDI: 00000080 EBP: 00000c57 ESP: c670fe0c
> >  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0069
> > Process postgres (pid: 17680, ti=c670e000 task=e93415d0 task.ti=c670e000)
> > Stack:
> >  e9e3a340 00013c57 ee15fc57 00000000 c01b60b1 c0731000 c06982d5 401b4b73
> >  ceebc988 e9e3a340 00013c57 00000000 c01b60f7 ceebc988 b7731000 c670ff04
> >  c01a7183 4646e045 80000005 e62ce348 28999063 c0103fc5 7f662000 00278ae0
> > Call Trace:
> >  [<c01b60b1>] ? swap_entry_free+0x121/0x140
> >  [<c06982d5>] ? _raw_spin_lock+0x5/0x10
> >  [<c01b60f7>] ? free_swap_and_cache+0x27/0xd0
> >  [<c01a7183>] ? zap_pte_range+0x1b3/0x480
> >  [<c0103fc5>] ? pte_pfn_to_mfn+0xb5/0xd0
> >  [<c01a7568>] ? unmap_page_range+0x118/0x1a0
> >  [<c0105b17>] ? xen_force_evtchn_callback+0x17/0x30
> >  [<c01a771b>] ? unmap_vmas+0x12b/0x1e0
> >  [<c01aba01>] ? exit_mmap+0x91/0x140
> >  [<c0134b2b>] ? mmput+0x2b/0xc0
> >  [<c01386ba>] ? exit_mm+0xfa/0x130
> >  [<c0698330>] ? _raw_spin_lock_irq+0x10/0x20
> >  [<c013a2b5>] ? do_exit+0x125/0x360
> >  [<c0105b17>] ? xen_force_evtchn_callback+0x17/0x30
> >  [<c013a52c>] ? do_group_exit+0x3c/0xa0
> >  [<c013a5a1>] ? sys_exit_group+0x11/0x20
> >  [<c0698631>] ? syscall_call+0x7/0xb
> > Code: ff 89 d8 e8 7d ec f6 ff 01 e8 8d 76 00 c6 00 00 ba 01 00 00 00
> > eb b2 89 f8 3c 80 0f 94 c0
> > e9 b9 fe ff ff 0f 0b eb fe 0f 0b eb fe <0f> 0b eb fe 0f 0b eb fe 66
> > 90 53 31 db 83 ec 0c 85 c0 7
> > 4 39 89
> > EIP: [<c01b4b26>] swap_count_continued+0x176/0x180 SS:ESP 0069:c670fe0c
> > ---[ end trace c2dcb41c89b0a9f7 ]---
> > 
> > Thanks,
> > -Chris
> > 
> > 
> > _______________________________________________
> > Xen-devel mailing list
> > Xen-devel@lists.xensource.com
> > http://lists.xensource.com/xen-devel
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel



