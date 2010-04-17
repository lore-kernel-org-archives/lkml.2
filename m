Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab0DQAyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 20:54:12 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:30695 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758429Ab0DQAyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 20:54:10 -0400
ORGANIZATION: Oracle Linux Eng.
MIME-Version: 1.0
Message-ID: <20100416175142.f4b59683.randy.dunlap@oracle.com>
Date: Fri, 16 Apr 2010 17:51:42 -0700 (PDT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       x86@kernel.org
Cc: Dimitri Sivanich <sivanich@sgi.com>, Russ Anderson <rja@sgi.com>,
       Robin Holt <holt@sgi.com>, Mike Travis <travis@sgi.com>,
       Cliff Wickman <cpw@sgi.com>, Jack Steiner <steiner@sgi.com>
Subject: [PATCH resend] uv_irq.c: fix all sparse warnings
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4BC90658.0018:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix all sparse warnings in building uv_irq.c.

arch/x86/kernel/uv_irq.c:46:17: warning: symbol 'uv_irq_chip' was not declared. Should it be static?
arch/x86/kernel/uv_irq.c:143:50: error: no identifier for function argument
arch/x86/kernel/uv_irq.c:162:13: error: typename in expression
arch/x86/kernel/uv_irq.c:162:13: error: undefined identifier 'restrict'
arch/x86/kernel/uv_irq.c:250:44: error: no identifier for function argument
arch/x86/kernel/uv_irq.c:260:17: error: typename in expression
arch/x86/kernel/uv_irq.c:260:17: error: undefined identifier 'restrict'
arch/x86/kernel/uv_irq.c:233:50: warning: incorrect type in argument 3 (different signedness)
arch/x86/kernel/uv_irq.c:233:50:    expected int *pnode
arch/x86/kernel/uv_irq.c:233:50:    got unsigned int *<noident>
arch/x86/include/asm/uv/uv_hub.h:318:44: warning: incorrect type in argument 2 (different address spaces)
arch/x86/include/asm/uv/uv_hub.h:318:44:    expected void volatile [noderef] <asn:2>*addr
arch/x86/include/asm/uv/uv_hub.h:318:44:    got unsigned long *

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: x86@kernel.org
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Cliff Wickman <cpw@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
---
 arch/x86/include/asm/uv/uv_hub.h |    2 +-
 arch/x86/kernel/uv_irq.c         |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

--- linux-2.6.34-rc4-git4.orig/arch/x86/kernel/uv_irq.c
+++ linux-2.6.34-rc4-git4/arch/x86/kernel/uv_irq.c
@@ -44,7 +44,7 @@ static void uv_ack_apic(unsigned int irq
 	ack_APIC_irq();
 }
 
-struct irq_chip uv_irq_chip = {
+static struct irq_chip uv_irq_chip = {
 	.name		= "UV-CORE",
 	.startup	= uv_noop_ret,
 	.shutdown	= uv_noop,
@@ -141,7 +141,7 @@ int uv_irq_2_mmr_info(int irq, unsigned 
  */
 static int
 arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
-		       unsigned long mmr_offset, int restrict)
+		       unsigned long mmr_offset, int limit)
 {
 	const struct cpumask *eligible_cpu = cpumask_of(cpu);
 	struct irq_desc *desc = irq_to_desc(irq);
@@ -160,7 +160,7 @@ arch_enable_uv_irq(char *irq_name, unsig
 	if (err != 0)
 		return err;
 
-	if (restrict == UV_AFFINITY_CPU)
+	if (limit == UV_AFFINITY_CPU)
 		desc->status |= IRQ_NO_BALANCING;
 	else
 		desc->status |= IRQ_MOVE_PCNTXT;
@@ -214,7 +214,7 @@ static int uv_set_irq_affinity(unsigned 
 	unsigned long mmr_value;
 	struct uv_IO_APIC_route_entry *entry;
 	unsigned long mmr_offset;
-	unsigned mmr_pnode;
+	int mmr_pnode;
 
 	if (set_desc_affinity(desc, mask, &dest))
 		return -1;
@@ -248,7 +248,7 @@ static int uv_set_irq_affinity(unsigned 
  * interrupt is raised.
  */
 int uv_setup_irq(char *irq_name, int cpu, int mmr_blade,
-		 unsigned long mmr_offset, int restrict)
+		 unsigned long mmr_offset, int limit)
 {
 	int irq, ret;
 
@@ -258,7 +258,7 @@ int uv_setup_irq(char *irq_name, int cpu
 		return -EBUSY;
 
 	ret = arch_enable_uv_irq(irq_name, irq, cpu, mmr_blade, mmr_offset,
-		restrict);
+		limit);
 	if (ret == irq)
 		uv_set_irq_2_mmr_info(irq, mmr_offset, mmr_blade);
 	else
--- linux-2.6.34-rc4-git4.orig/arch/x86/include/asm/uv/uv_hub.h
+++ linux-2.6.34-rc4-git4/arch/x86/include/asm/uv/uv_hub.h
@@ -307,7 +307,7 @@ static inline unsigned long uv_read_glob
  * Access Global MMR space using the MMR space located at the top of physical
  * memory.
  */
-static inline unsigned long *uv_global_mmr64_address(int pnode, unsigned long offset)
+static inline volatile void __iomem *uv_global_mmr64_address(int pnode, unsigned long offset)
 {
 	return __va(UV_GLOBAL_MMR64_BASE |
 		    UV_GLOBAL_MMR64_PNODE_BITS(pnode) | offset);
