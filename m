Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab2BEWlp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:41:45 -0500
Received: from 1wt.eu ([62.212.114.60]:61979 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098Ab2BEW0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:35 -0500
Message-Id: <20120205220951.204993240@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:30 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 41/91] xen/smp: Warn user why they keel over - nosmp or noapic and what to use instead.
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
 1 files changed, 10 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/arch/x86/xen/smp.c
===================================================================
--- longterm-2.6.27.orig/arch/x86/xen/smp.c	2012-02-05 22:34:33.783914838 +0100
+++ longterm-2.6.27/arch/x86/xen/smp.c	2012-02-05 22:34:40.668915455 +0100
@@ -33,6 +33,7 @@
 #include <xen/page.h>
 #include <xen/events.h>
 
+#include <xen/hvc-console.h>
 #include "xen-ops.h"
 #include "mmu.h"
 
@@ -182,6 +183,15 @@
 {
 	unsigned cpu;
 
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


