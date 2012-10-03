Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab2JCNjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 09:39:22 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:2223 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab2JCNjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 09:39:21 -0400
X-IronPort-AV: E=Sophos;i="4.80,528,1344211200"; 
   d="scan'208";a="14916519"
Date: Wed, 3 Oct 2012 14:37:53 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH] xen: point xen_start_info to a dummy struct for PV on HVM
 guests
Message-ID: <alpine.DEB.2.02.1210031431080.29232@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PV on HVM guests don't have a start_info page mapped by Xen, so
xen_start_info is just NULL for them.
That is problem because other parts of the code expect xen_start_info to
point to something valid, for example xen_initial_domain() is defined as
follow:

#define xen_initial_domain()    (xen_domain() && \
                 xen_start_info->flags & SIF_INITDOMAIN)


Allocate a dummy start_info struct and point xen_start_info to it, as we
do on ARM.
This is not going to change things for PV guests because
xen_start_info is set by arch/x86/xen/xen-head.S:startup_xen.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index bf788d3..5f242cb 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -96,7 +96,8 @@ EXPORT_SYMBOL(machine_to_phys_mapping);
 unsigned long  machine_to_phys_nr;
 EXPORT_SYMBOL(machine_to_phys_nr);
 
-struct start_info *xen_start_info;
+static struct start_info _xen_start_info;
+struct start_info *xen_start_info = &_xen_start_info;
 EXPORT_SYMBOL_GPL(xen_start_info);
 
 struct shared_info xen_dummy_shared_info;
