Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab0JKVj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 17:39:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756417Ab0JKVj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 17:39:27 -0400
Date: Mon, 11 Oct 2010 17:39:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Alok Kataria <akataria@vmware.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Haren Myneni <hbabu@us.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
        jeremy@xensource.com
Subject: Re: [RFC PATCH] Bug during kexec...not all cpus are stopped
Message-ID: <20101011213901.GR12743@redhat.com>
References: <1286570087.8769.27.camel@ank32.eng.vmware.com>
 <1286816964.1372.2.camel@ank32.eng.vmware.com>
 <m1lj64ppri.fsf@fess.ebiederm.org>
 <1286826083.1372.15.camel@ank32.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286826083.1372.15.camel@ank32.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 12:41:23PM -0700, Alok Kataria wrote:
> Hi Eric,
> 
> Thanks for taking a look.
> 
> On Mon, 2010-10-11 at 11:07 -0700, Eric W. Biederman wrote:
> > Alok Kataria <akataria@vmware.com> writes:
> > 
> > > Copying a few more maintainers on the thread...
> > > On Fri, 2010-10-08 at 13:34 -0700, Alok Kataria wrote:
> > >> Before starting the new kernel kexec calls machine_shutdown to stop all
> > >> the cpus, which internally calls native_smp_send_stop. AFAIU, kexec
> > >> expects that all the cpus are now halted after that call returns.
> > >> Now, looking at the code for native_smp_send_stop, it assumes that all
> > >> the processors have processed the REBOOT ipi in 1 second after the IPI
> > >> was sent.
> > >> native_smp_send_stop()
> > >> ---------------------------------------------------------
> > >>      apic->send_IPI_allbutself(REBOOT_VECTOR);
> > >>
> > >>         /* Don't wait longer than a second */
> > >>         wait = USEC_PER_SEC;
> > >>         while (num_online_cpus() > 1 && wait--)
> > >>              udelay(1);
> > >> ---------------------------------------------------------
> > >>
> > >> It just returns after that 1 second irrespective of whether all cpus
> > >> were halted or not. This brings up a issue in the kexec case, since we
> > >> can have the BSP starting the new kernel and AP's still processing the
> > >> REBOOT IPI simultaneously.
> > >>
> > >> Many distribution kernels use kexec to load the newly installed kernel
> > >> during the installation phase, in virtualized environment with the host
> > >> heavily overcommitted, we have seen some instances when vcpu fails to
> > >> process the IPI in the allotted 1 sec and as a result the AP's end up
> > >> accessing uninitialized state (the BSP has already gone ahead with
> > >> setting up the new state) and causing GPF's.
> > >>
> > >> IMO, kexec expects machine_shutdown to return only after all cpus are
> > >> stopped.
> > >>
> > >> The patch below should fix the issue, comments ??
> > >>
> > >> --
> > >> machine_shutdown now takes a parameter "wait", if it is true, it waits
> > >> until all the cpus are halted. All the callers except kexec still
> > >> fallback to the earlier version of the shutdown call, where it just
> > >> waited for max 1 sec before returning.
> > 
> > The approach seems reasonable.  However on every path except for the
> > panic path I would wait for all of the cpus to stop, as that is what
> > those code paths are expecting.  Until last year smp_send_stop always
> > waited until all of the cpus stopped.  So I think changing
> > machine_shutdown should not need to happen.
> > 
> > This patch cannot be used as is because it changes the parameters to
> > smp_send_stop() and there are more than just x86 implementations out
> > there.
> > 
> > Let me propose a slightly different tactic.  We need to separate
> > the panic path from the normal path to avoid confusion.  At the
> > generic level smp_send_stop is exclusively used for the panic
> > path.  So we should keep that, and rename the x86 non-panic path
> > function something else.
> > 
> > Can you rename the x86 smp_send_stop function say stop_all_other_cpus().
> > 
> > At which point we could implement smp_send_stop as:
> > stop_all_other_cpus(0);
> > 
> > And everywhere else would call stop_all_other_cpus(1) waiting for
> > the cpus to actually stop.
> 
> Done, I have added a stop_other_cpus function which calls
> smp_ops.stop_other_cpus(1)
> 
> > 
> > I really think we want to wait for the cpus to stop in all cases except
> > for panic/kdump where we expect things to be broken and we are doing
> > our best to make things work anyway.
> Now it does, except in the panic case.
> 
> Jeremy, I have modified the xen_reboot bits too so that it now waits
> until all cpus are actually stopped, please take a look.
> 
> --
> 
> x86 smp_ops now has a new op, stop_other_cpus which takes a parameter "wait"
> this allows the caller to specify if it wants to stop untill all the cpus
> have processed the stop IPI. This is required specifically for the kexec case
> where we should wait for all the cpus to be stopped before starting the new
> kernel.

> We now wait for the cpus to stop in all cases except for panic/kdump where
> we expect things to be broken and we are doing our best to make things
> work anyway.

I don't think that kdump path uses smp_send_stop().

IIUC, on x86, we directly send NMI to other cpus.

native_machine_crash_shutdown()
  kdump_nmi_shootdown_cpus()
        nmi_shootdown_cpus()
           smp_send_nmi_allbutself
                apic->send_IPI_allbutself(NMI_VECTOR);

So above description should be limited to only panic() path.

On a side note, I am wondering why panic() and kdump path can't share the
shutdown routine.

Vivek
