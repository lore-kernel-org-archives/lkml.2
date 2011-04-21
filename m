Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab1DUVbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:31:36 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35616 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab1DUVbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:31:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Sd/z8r9kp0Du+M8QllLElQ2RV8P40ajrt9kJsS1pijGsthJr7zxwPRfo2ceXR1MrEc
         5MKKfxqOBb8KFWLz9vuQ==
Date: Thu, 21 Apr 2011 14:31:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        James Bottomley <jejb@parisc-linux.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: [patch] parisc: enable CONFIG_NUMA for DISCONTIGMEM and fix build
 errors
In-Reply-To: <alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1104211430280.20201@chino.kir.corp.google.com>
References: <1303317178.2587.30.camel@mulgrave.site> <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com> <20110421220351.9180.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com> <alpine.DEB.2.00.1104211500170.5741@router.home>
 <alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

CONFIG_DISCONTIGMEM requires CONFIG_NUMA because it represents its memory 
regions as individual nodes that lack remote proximity, hence it already 
has a default CONFIG_NODES_SHIFT of 3.

This configuration causes build errors, however, so fix them as well.

This was first realized when CONFIG_DISCONTIGMEM was used with 
CONFIG_SLUB which depends heavily on CONFIG_NUMA being enabled or 
disabled to support these memory regions.

A long-term fix is to separate the memory region abstraction required for 
DISCONTIGMEM away from NUMA and then build NUMA on top of it with 
proximity domains.

[rientjes@google.com: implicitly enable NUMA for DISCONTIGMEM, changelog]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/parisc/Kconfig            |    3 +++
 include/asm-generic/topology.h |    4 ----
 include/linux/topology.h       |    2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -244,6 +244,9 @@ config ARCH_DISCONTIGMEM_DEFAULT
 	def_bool y
 	depends on ARCH_DISCONTIGMEM_ENABLE
 
+config NUMA
+	def_bool ARCH_DISCONTIGMEM_ENABLE
+
 config NODES_SHIFT
 	int
 	default "3"
diff --git a/include/asm-generic/topology.h b/include/asm-generic/topology.h
--- a/include/asm-generic/topology.h
+++ b/include/asm-generic/topology.h
@@ -27,8 +27,6 @@
 #ifndef _ASM_GENERIC_TOPOLOGY_H
 #define _ASM_GENERIC_TOPOLOGY_H
 
-#ifndef	CONFIG_NUMA
-
 /* Other architectures wishing to use this simple topology API should fill
    in the below functions as appropriate in their own <asm/topology.h> file. */
 #ifndef cpu_to_node
@@ -60,8 +58,6 @@
 				 cpumask_of_node(pcibus_to_node(bus)))
 #endif
 
-#endif	/* CONFIG_NUMA */
-
 #if !defined(CONFIG_NUMA) || !defined(CONFIG_HAVE_MEMORYLESS_NODES)
 
 #ifndef set_numa_mem
diff --git a/include/linux/topology.h b/include/linux/topology.h
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -209,7 +209,7 @@ int arch_update_cpu_topology(void);
 
 #ifdef CONFIG_NUMA
 #ifndef SD_NODE_INIT
-#error Please define an appropriate SD_NODE_INIT in include/asm/topology.h!!!
+#define SD_NODE_INIT SD_ALLNODES_INIT
 #endif
 
 #endif /* CONFIG_NUMA */
