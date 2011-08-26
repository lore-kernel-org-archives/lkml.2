Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab1H0O6m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:58:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965Ab1H0O6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:58:39 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:55 2011
Message-Id: <20110826215055.459804399@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefan Bader <stefan.bader@canonical.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [25/35] xen: Do not enable PV IPIs when vector callback not present
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

commit 3c05c4bed4ccce3f22f6d7899b308faae24ad198 upstream.

Fix regression for HVM case on older (<4.1.1) hypervisors caused by

  commit 99bbb3a84a99cd04ab16b998b20f01a72cfa9f4f
  Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
  Date:   Thu Dec 2 17:55:10 2010 +0000

    xen: PV on HVM: support PV spinlocks and IPIs

This change replaced the SMP operations with event based handlers without
taking into account that this only works when the hypervisor supports
callback vectors. This causes unexplainable hangs early on boot for
HVM guests with more than one CPU.

BugLink: http://bugs.launchpad.net/bugs/791850

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Tested-and-Reported-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/smp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -521,8 +521,6 @@ static void __init xen_hvm_smp_prepare_c
 	native_smp_prepare_cpus(max_cpus);
 	WARN_ON(xen_smp_intr_init(0));
 
-	if (!xen_have_vector_callback)
-		return;
 	xen_init_lock_cpu(0);
 	xen_init_spinlocks();
 }
@@ -546,6 +544,8 @@ static void xen_hvm_cpu_die(unsigned int
 
 void __init xen_hvm_smp_init(void)
 {
+	if (!xen_have_vector_callback)
+		return;
 	smp_ops.smp_prepare_cpus = xen_hvm_smp_prepare_cpus;
 	smp_ops.smp_send_reschedule = xen_smp_send_reschedule;
 	smp_ops.cpu_up = xen_hvm_cpu_up;


