Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1CJUhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 15:37:39 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:24975 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab1CJUhi (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 10 Mar 2011 15:37:38 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Cc: xen-devel@lists.xensource.com, Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/e820: Don't mark balloon memory as E820_UNUSABLE when running as guest.
Date: Thu, 10 Mar 2011 15:36:44 -0500
Message-Id: <1299789405-30802-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299789405-30802-1-git-send-email-konrad.wilk@oracle.com>
References: <1299789405-30802-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D793688.0101,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have a guest that asked for:

memory=1024
maxmem=20448

Which means we want 1GB now, and create pagetables so that we can expand
up to 2GB, we would have this E820 layout:

[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  Xen: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  Xen: 00000000000a0000 - 0000000000100000 (reserved)
[    0.000000]  Xen: 0000000000100000 - 0000000080800000 (usable)

Due to patch: "xen/setup: Inhibit resource API from using System RAM E820 gaps as PCI mem gaps."
we would mark the memory past the 1GB mark as unusuable resulting in:

[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  Xen: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  Xen: 00000000000a0000 - 0000000000100000 (reserved)
[    0.000000]  Xen: 0000000000100000 - 0000000040000000 (usable)
[    0.000000]  Xen: 0000000040000000 - 0000000080800000 (unusable)

which meant that we could not balloon up anymore. We could
balloon the guest down. The fix is to run the code introduced
by the above mentioned patch only for the initial domain.

We will have to revisit this once we start introducing a modified
E820 for PCI passthrough so that we can utilize the P2M identity code.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/setup.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 2a4add9..6e676fa 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -200,7 +200,8 @@ char * __init xen_memory_setup(void)
 			 * used as potential resource for I/O address (happens
 			 * when 'allocate_resource' is called).
 			 */
-			if (delta && end < 0x100000000UL)
+			if (delta &&
+				(xen_initial_domain() && end < 0x100000000UL))
 				e820_add_region(end, delta, E820_UNUSABLE);
 		}
 
-- 
1.7.1

