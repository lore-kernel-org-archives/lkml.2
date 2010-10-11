Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab0JKVsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 17:48:01 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:34077 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756431Ab0JKVsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 17:48:00 -0400
Subject: Re: [RFC PATCH] Bug during kexec...not all cpus are stopped
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Haren Myneni <hbabu@us.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
        "jeremy@xensource.com" <jeremy@xensource.com>
In-Reply-To: <20101011213901.GR12743@redhat.com>
References: <1286570087.8769.27.camel@ank32.eng.vmware.com>
	 <1286816964.1372.2.camel@ank32.eng.vmware.com>
	 <m1lj64ppri.fsf@fess.ebiederm.org>
	 <1286826083.1372.15.camel@ank32.eng.vmware.com>
	 <20101011213901.GR12743@redhat.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 11 Oct 2010 14:47:59 -0700
Message-Id: <1286833679.1372.26.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2010-10-11 at 14:39 -0700, Vivek Goyal wrote:
> On Mon, Oct 11, 2010 at 12:41:23PM -0700, Alok Kataria wrote:

> > --
> > 
> > x86 smp_ops now has a new op, stop_other_cpus which takes a parameter "wait"
> > this allows the caller to specify if it wants to stop untill all the cpus
> > have processed the stop IPI. This is required specifically for the kexec case
> > where we should wait for all the cpus to be stopped before starting the new
> > kernel.
> 
> > We now wait for the cpus to stop in all cases except for panic/kdump where
> > we expect things to be broken and we are doing our best to make things
> > work anyway.
> 
> I don't think that kdump path uses smp_send_stop().

Right, this should be removed from the patch description.

Belows is the new patch description
----------------------------------------------
x86 smp_ops now has a new op, stop_other_cpus which takes a parameter "wait"
this allows the caller to specify if it wants to stop untill all the cpus
have processed the stop IPI. This is required specifically for the kexec case
where we should wait for all the cpus to be stopped before starting the new
kernel.
We now wait for the cpus to stop in all cases except for panic where
we expect things to be broken and we are doing our best to make things
work anyway.
----------------------------------------------

> 
> IIUC, on x86, we directly send NMI to other cpus.
> 
> native_machine_crash_shutdown()
>   kdump_nmi_shootdown_cpus()
>         nmi_shootdown_cpus()
>            smp_send_nmi_allbutself
>                 apic->send_IPI_allbutself(NMI_VECTOR);
> 
> So above description should be limited to only panic() path.
> 
> On a side note, I am wondering why panic() and kdump path can't share the
> shutdown routine.

The comment in native_stop_other_cpus (native_smp_send_stop earlier)
explains why

        /*
         * Use an own vector here because smp_call_function
         * does lots of things not suitable in a panic situation.
         * On most systems we could also use an NMI here,
         * but there are a few systems around where NMI
         * is problematic so stay with an non NMI for now
         * (this implies we cannot stop CPUs spinning with irq off
         * currently)
         */


Thanks,
Alok
> 
> Vivek

