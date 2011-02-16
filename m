Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347Ab1BPBB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:01:29 -0500
Received: from kroah.org ([198.145.64.141]:46024 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933231Ab1BPAut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:50:49 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:11 2011
Message-Id: <20110216002111.843368135@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:21:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 128/176] powerpc/numa: Fix bug in unmap_cpu_from_node
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 429f4d8d20b91e4a6c239f951c06a56a6ac22957 upstream.

When converting to the new cpumask code I screwed up:

-       if (cpu_isset(cpu, numa_cpumask_lookup_table[node])) {
-               cpu_clear(cpu, numa_cpumask_lookup_table[node]);
+       if (cpumask_test_cpu(cpu, node_to_cpumask_map[node])) {
+               cpumask_set_cpu(cpu, node_to_cpumask_map[node]);

This was introduced in commit 25863de07af9 (powerpc/cpumask: Convert NUMA code
to new cpumask API)

Fix it.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/mm/numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -181,7 +181,7 @@ static void unmap_cpu_from_node(unsigned
 	dbg("removing cpu %lu from node %d\n", cpu, node);
 
 	if (cpumask_test_cpu(cpu, node_to_cpumask_map[node])) {
-		cpumask_set_cpu(cpu, node_to_cpumask_map[node]);
+		cpumask_clear_cpu(cpu, node_to_cpumask_map[node]);
 	} else {
 		printk(KERN_ERR "WARNING: cpu %lu not found in node %d\n",
 		       cpu, node);


