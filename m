Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab0JZTuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:50:22 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:18600 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab0JZTuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:50:21 -0400
X-IronPort-AV: E=Sophos;i="4.58,242,1286150400"; 
   d="scan'208";a="2536370"
Date: Tue, 26 Oct 2010 20:49:31 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [Xen-devel] Re: [PATCH 1/5] xen: events: use irq_alloc_desc(_at)
 instead of open-coding an IRQ allocator.
In-Reply-To: <1288080948.10179.57.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1010261847150.1407@kaball-desktop>
References: <1288023736.11153.40.camel@zakaz.uk.xensource.com>  <1288023813-31989-1-git-send-email-ian.campbell@citrix.com>  <20101025173522.GA5590@dumpdata.com>  <1288029736.10179.35.camel@localhost.localdomain>
 <1288080948.10179.57.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010, Ian Campbell wrote:
> On Mon, 2010-10-25 at 19:02 +0100, Ian Campbell wrote:
> > 
> > 
> > > What do you see when you pass in a PCI device and say give the guest
> > 32 CPUs??
> > 
> > I can try tomorrow and see, based on what you say above without
> > implementing what I described I suspect the answer will be "carnage". 
> 
> Actually, it looks like multi-vcpu is broken, I only see 1 regardless of
> how many I configured. It's not clear if this is breakage in Linus'
> tree, something I pulled in from one of Jeremy's, yours or Stefano's
> trees or some local pebcak. I'll investigate...
 
I found the bug, it was introduced by:

"xen: use vcpu_ops to setup cpu masks"

I have added the fix at the end of my branch and I am also appending the
fix here.

---


xen: initialize cpu masks for pv guests in xen_smp_init

Pv guests don't have ACPI and need the cpu masks to be set
correctly as early as possible so we call xen_fill_possible_map from
xen_smp_init.
On the other hand the initial domain supports ACPI so in this case we skip
xen_fill_possible_map and rely on it. However Xen might limit the number
of cpus usable by the domain, so we filter those masks during smp
initialization using the VCPUOP_is_up hypercall.
It is important that the filtering is done before
xen_setup_vcpu_info_placement.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 1386767..834dfeb 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -28,6 +28,7 @@
 #include <asm/xen/interface.h>
 #include <asm/xen/hypercall.h>
 
+#include <xen/xen.h>
 #include <xen/page.h>
 #include <xen/events.h>
 
@@ -156,6 +157,25 @@ static void __init xen_fill_possible_map(void)
 {
 	int i, rc;
 
+	if (xen_initial_domain())
+		return;
+
+	for (i = 0; i < nr_cpu_ids; i++) {
+		rc = HYPERVISOR_vcpu_op(VCPUOP_is_up, i, NULL);
+		if (rc >= 0) {
+			num_processors++;
+			set_cpu_possible(i, true);
+		}
+	}
+}
+
+static void __init xen_filter_cpu_maps(void)
+{
+	int i, rc;
+
+	if (!xen_initial_domain())
+		return;
+
 	num_processors = 0;
 	disabled_cpus = 0;
 	for (i = 0; i < nr_cpu_ids; i++) {
@@ -179,6 +199,7 @@ static void __init xen_smp_prepare_boot_cpu(void)
 	   old memory can be recycled */
 	make_lowmem_page_readwrite(xen_initial_gdt);
 
+	xen_filter_cpu_maps();
 	xen_setup_vcpu_info_placement();
 }
 
@@ -195,8 +216,6 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 	if (xen_smp_intr_init(0))
 		BUG();
 
-	xen_fill_possible_map();
-
 	if (!alloc_cpumask_var(&xen_cpu_initialized_map, GFP_KERNEL))
 		panic("could not allocate xen_cpu_initialized_map\n");
 
@@ -487,5 +506,6 @@ static const struct smp_ops xen_smp_ops __initdata = {
 void __init xen_smp_init(void)
 {
 	smp_ops = xen_smp_ops;
+	xen_fill_possible_map();
 	xen_init_spinlocks();
 }
