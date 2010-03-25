Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab0CYXdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 19:33:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:31297 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab0CYXdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 19:33:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=Z6PYQU7gHqxxxxs909rAwdNpWkji6iARzMUIvr9oU/sxpB4SMevVEpdVP0DYabOOr
	rP6eWGU/dde2XS7SeQqgg==
Date: Thu, 25 Mar 2010 16:33:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Len Brown <lenb@kernel.org>
cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [patch] acpi: map pxms to low node ids
Message-ID: <alpine.DEB.2.00.1003251632380.29031@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pxms are mapped to low node ids to maintain generic kernel use of
functions such as pxm_to_node() that are used to determine device
affinity.  Otherwise, there is no pxm-to-node and node-to-pxm matching
rule for x86_64 users of NUMA emulation where a single pxm may be bound
to multiple NUMA nodes.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/acpi/numa.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -61,8 +61,10 @@ int node_to_pxm(int node)
 
 void __acpi_map_pxm_to_node(int pxm, int node)
 {
-	pxm_to_node_map[pxm] = node;
-	node_to_pxm_map[node] = pxm;
+	if (pxm_to_node_map[pxm] == NUMA_NO_NODE || node < pxm_to_node_map[pxm])
+		pxm_to_node_map[pxm] = node;
+	if (node_to_pxm_map[node] == PXM_INVAL || pxm < node_to_pxm_map[node])
+		node_to_pxm_map[node] = pxm;
 }
 
 int acpi_map_pxm_to_node(int pxm)
