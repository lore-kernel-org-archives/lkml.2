Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab2DSGsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 02:48:00 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:53335 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab2DSGr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 02:47:57 -0400
Date: Wed, 18 Apr 2012 23:47:51 -0700
From: Steven Noonan <steven@uplinklabs.net>
To: Lin Ming <mlin@ss.pku.edu.cn>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Marcus Granado <marcus.granado@citrix.com>, xen-devel@lists.xen.org,
        Ben Guthro <ben@guthro.net>
Subject: Re: [PATCH 0/2] fix "perf top" soft lockups under Xen
Message-ID: <20120419064751.GA6268@asmodeus.uplinklabs.net>
References: <CAF1ivSZqe54_gAQNZW_teiApObkXsC5iu04Siy1OEnm9M9AcUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF1ivSZqe54_gAQNZW_teiApObkXsC5iu04Siy1OEnm9M9AcUA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 02:14:57PM +0800, Lin Ming wrote:
> (Forgot mail subject, add it)
> 
> On Sun, Apr 15, 2012 at 2:09 PM, Lin Ming <mlin@ss.pku.edu.cn> wrote:
> > Hi all,
> >
> > These 2 patches try to fix the "perf top" soft lockups under Xen
> > reported by Steven at: https://lkml.org/lkml/2012/2/9/506
> >
> > I tested it with 3.4-rc2 and "perf top" works well now.
> >
> > Steven,
> > Could you please help to test it too?
> >
> > The soft lockup code path is:
> >
> > __irq_work_queue
> >  arch_irq_work_raise
> >    apic->send_IPI_self(IRQ_WORK_VECTOR);
> >      apic_send_IPI_self
> >        __default_send_IPI_shortcut
> >          __xapic_wait_icr_idle
> >
> > static inline void __xapic_wait_icr_idle(void)
> > {
> >        while (native_apic_mem_read(APIC_ICR) & APIC_ICR_BUSY)
> >                cpu_relax();
> > }
> >
> > The lockup happens at above while looop.
> >
> > The cause is that Xen has not implemented the APIC IPI interface yet.
> > Xen has IPI interface: xen_send_IPI_one, but it's only used in
> > xen_smp_send_reschedule, xen_smp_send_call_function_ipi and
> > xen_smp_send_call_function_single_ipi, etc.
> >
> > So we need to implement Xen's APIC IPI interface as Ben's patch does.
> > And implement Xen's IRQ_WORK_VECTOR handler.
> >
> > Ben Guthro (1):
> >      xen: implement apic ipi interface
> >
> > Lin Ming (1):
> >      xen: implement IRQ_WORK_VECTOR handler
> >
> >  arch/x86/include/asm/xen/events.h |    1 +
> >  arch/x86/xen/enlighten.c          |    7 ++
> >  arch/x86/xen/smp.c                |  111 +++++++++++++++++++++++++++++++++++-
> >  arch/x86/xen/smp.h                |   12 ++++
> >  4 files changed, 127 insertions(+), 4 deletions(-)
> >
> > Any comment is appreciated.
> > Lin Ming

OK, finally got around to testing this. Sorry about the delay, been
rather busy at work.

These two patches definitely fix the lockups, but 'perf test' doesn't
pass every test:

	 1: vmlinux symtab matches kallsyms:
	--- start ---
	Looking at the vmlinux_path (6 entries long)
	dso__load_sym: cannot get elf header.
	Using /lib/modules/3.3.2-00002-gf57130d/build/vmlinux for symbols
	Maps only in vmlinux:
	 ffffffff81ae61b1-ffffffff81b9d7b7 0 [kernel].init.text
	 ffffffff81b9d7b8-ffffffff9fffffff 0 [kernel].exit.text
	Maps in vmlinux with a different name in kallsyms:
	Maps only in kallsyms:
	---- end ----
	vmlinux symtab matches kallsyms: Ok
	 2: detect open syscall event:
	--- start ---
	---- end ----
	detect open syscall event: Ok
	 3: detect open syscall event on all cpus:
	--- start ---
	---- end ----
	detect open syscall event on all cpus: Ok
	 4: read samples using the mmap interface:
	--- start ---
	---- end ----
	read samples using the mmap interface: Ok
	 5: parse events tests:
	--- start ---
	---- end ----
	parse events tests: Ok
	 6: Validate PERF_RECORD_* events & perf_sample fields:
	--- start ---
	perf_evlist__open: Bad file descriptor
	---- end ----
	Validate PERF_RECORD_* events & perf_sample fields: FAILED!

I couldn't figure out what exactly was failing in that test with a
quick inspection... Someone else want to take a stab at it? If someone
wants to give me patches that add extra output, I could run those too.

Anyway:

Tested-by: Steven Noonan <steven@uplinklabs.net>

- Steven
