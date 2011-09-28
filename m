Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab1I1Wkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:40:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab1I1Wkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:40:31 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:32 2011
Message-Id: <20110928220132.683133493@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [070/244] xen/smp: Warn user why they keel over - nosmp or noapic and what to use instead.
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit ed467e69f16e6b480e2face7bc5963834d025f91 upstream.

We have hit a couple of customer bugs where they would like to
use those parameters to run an UP kernel - but both of those
options turn of important sources of interrupt information so
we end up not being able to boot. The correct way is to
pass in 'dom0_max_vcpus=1' on the Xen hypervisor line and
the kernel will patch itself to be a UP kernel.

Fixes bug: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=637308

Acked-by: Ian Campbell <Ian.Campbell@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/smp.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -32,6 +32,7 @@
 #include <xen/page.h>
 #include <xen/events.h>
 
+#include <xen/hvc-console.h>
 #include "xen-ops.h"
 #include "mmu.h"
 
@@ -207,6 +208,15 @@ static void __init xen_smp_prepare_cpus(
 	unsigned cpu;
 	unsigned int i;
 
+	if (skip_ioapic_setup) {
+		char *m = (max_cpus == 0) ?
+			"The nosmp parameter is incompatible with Xen; " \
+			"use Xen dom0_max_vcpus=1 parameter" :
+			"The noapic parameter is incompatible with Xen";
+
+		xen_raw_printk(m);
+		panic(m);
+	}
 	xen_init_lock_cpu(0);
 
 	smp_store_cpu_info(0);


