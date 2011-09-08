Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab1IHMhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:37:08 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:43940 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab1IHMhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:37:05 -0400
X-IronPort-AV: E=Sophos;i="4.68,350,1312156800"; 
   d="scan'208";a="7675350"
Date: Thu, 8 Sep 2011 13:45:15 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: disable PV spinlocks on HVM
In-Reply-To: <4E67E10A.3020809@goop.org>
Message-ID: <alpine.DEB.2.00.1109081340150.12963@kaball-desktop>
References: <1315327307-392-1-git-send-email-stefano.stabellini@eu.citrix.com> <4E67E10A.3020809@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Sep 2011, Jeremy Fitzhardinge wrote:
> On 09/06/2011 09:41 AM, stefano.stabellini@eu.citrix.com wrote:
> > From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> >
> > PV spinlocks cannot possibly work with the current code because they are
> > enabled after pvops patching has already been done, and because PV
> > spinlocks use a different data structure than native spinlocks so we
> > cannot switch between them dynamically. A spinlock that has been taken
> > once by the native code (__ticket_spin_lock) cannot be taken by
> > __xen_spin_lock even after it has been released.
> >
> > Reported-by: Stefan Bader <stefan.bader@canonical.com>
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  arch/x86/xen/smp.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> > index e79dbb9..51339b4 100644
> > --- a/arch/x86/xen/smp.c
> > +++ b/arch/x86/xen/smp.c
> > @@ -522,7 +522,6 @@ static void __init xen_hvm_smp_prepare_cpus(unsigned int max_cpus)
> >  	WARN_ON(xen_smp_intr_init(0));
> >  
> >  	xen_init_lock_cpu(0);
> > -	xen_init_spinlocks();
> >  }
> 
> Should I add this back here on the pv ticketlock branch?
 
I think that Konrad is going to pick it up and send it as an important
bug fix, CC'ing stable too.
However I also have another patch to enable PV spinlock on HVM again,
that relies on your pv ticket lock work. This one should probably go
at the end of your series (appended).

---


xen: initialize PV spinlocks for HVM guests before patching is done

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 51339b4..e24e9a2 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -551,4 +551,5 @@ void __init xen_hvm_smp_init(void)
 	smp_ops.cpu_die = xen_hvm_cpu_die;
 	smp_ops.send_call_func_ipi = xen_smp_send_call_function_ipi;
 	smp_ops.send_call_func_single_ipi = xen_smp_send_call_function_single_ipi;
+	xen_init_spinlocks();
 }
