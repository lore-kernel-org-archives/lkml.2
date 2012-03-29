Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933880Ab2C2VBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:01:30 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40744 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933123Ab2C2VBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 17:01:23 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [GIT PULL] Disintegrate and kill asm/system.h
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Neuling <mikey@neuling.org>
Cc: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        arnd@arndb.de, hpa@zytor.com, sfr@canb.auug.org.au
In-Reply-To: <1332994469.3010.7.camel@pasglop>
References: <5599.1332958811@redhat.com> <30702.1332989444@neuling.org> <1332994469.3010.7.camel@pasglop>
Date: Thu, 29 Mar 2012 15:01:17 -0600
Message-Id: <20120329210117.A9A073E06B4@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2012 15:14:29 +1100, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> On Thu, 2012-03-29 at 13:50 +1100, Michael Neuling wrote:
> > Grant: why does powerpc_debugfs_root appear in generic code?  This seems
> > very bogus.
> 
> Yes, Grant, you should move that to a different (generic) debugfs file,
> the mapping information is valuable debug data for all architectures
> that use the remapper, not just powerpc and it's not an ABI (no tool I
> know of rely on the location of that debugfs file) so feel free to move
> it around.

I could simply drop the powerpc_debugfs_root argument from
debugfs_create_file() and replace it with NULL.  As you say, this is
not an ABI and this will solve the problem.

On Wed, 28 Mar 2012 22:02:41 -0700, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> Grant - what's the plan about that CONFIG_VIRQ_DEBUG thing? In theory
> something like it could be useful as a generic thing, but at least
> right now it is clearly powerpc-specific (not just that the config
> option only exists for powerpc: it has that whole
> 'powerpc_debugfs_root' thing in it)?
> 
> Stephen's patch very much looks like the right thing, but if there was
> some plan to actually make this generic ...

The plan is to make it generic.  I just ran out of time for this
cycle to generalize it.  I moved all of irqdomain out of arch/powerpc
wholesale, which included the debug bits, and then generalized it in
place.  That was the safest way to transition without causing
breakage.

Moving it back into powerpc land is a step backwards. I've attached a
patch that makes it generic instead.  It has been tested on ARM.

I've pushed it out to the following branch:

git://git.secretlab.ca/git/linux-2.6 irqdomain/merge

---

[PATCH] irqdomain: Remove powerpc dependency from debugfs file

The debugfs code is really generic for all platforms.  This patch removes the
powerpc-specific directory reference and makes it available to all
architectures.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/powerpc/Kconfig.debug |   10 ----------
 kernel/irq/Kconfig         |   10 ++++++++++
 kernel/irq/irqdomain.c     |    8 ++++----
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/Kconfig.debug b/arch/powerpc/Kconfig.debug
index 72d55db..e5f2689 100644
--- a/arch/powerpc/Kconfig.debug
+++ b/arch/powerpc/Kconfig.debug
@@ -114,16 +114,6 @@ config DEBUGGER
 	depends on KGDB || XMON
 	default y
 
-config VIRQ_DEBUG
-	bool "Expose hardware/virtual IRQ mapping via debugfs"
-	depends on DEBUG_FS
-	help
-	  This option will show the mapping relationship between hardware irq
-	  numbers and virtual irq numbers. The mapping is exposed via debugfs
-	  in the file powerpc/virq_mapping.
-
-	  If you don't know what this means you don't need it.
-
 config BDI_SWITCH
 	bool "Include BDI-2000 user context switcher"
 	depends on DEBUG_KERNEL && PPC32
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 5a38bf4..d8e323d 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -56,6 +56,16 @@ config GENERIC_IRQ_CHIP
 config IRQ_DOMAIN
 	bool
 
+config IRQ_DOMAIN_DEBUG
+	bool "Expose hardware/virtual IRQ mapping via debugfs"
+	depends on IRQ_DOMAIN && DEBUG_FS
+	help
+	  This option will show the mapping relationship between hardware irq
+	  numbers and Linux irq numbers. The mapping is exposed via debugfs
+	  in the file "virq_mapping".
+
+	  If you don't know what this means you don't need it.
+
 # Support forced irq threading
 config IRQ_FORCED_THREADING
        bool
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index af48e59..3601f3f 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -632,7 +632,7 @@ unsigned int irq_linear_revmap(struct irq_domain *domain,
 	return revmap[hwirq];
 }
 
-#ifdef CONFIG_VIRQ_DEBUG
+#ifdef CONFIG_IRQ_DOMAIN_DEBUG
 static int virq_debug_show(struct seq_file *m, void *private)
 {
 	unsigned long flags;
@@ -668,7 +668,7 @@ static int virq_debug_show(struct seq_file *m, void *private)
 			data = irq_desc_get_chip_data(desc);
 			seq_printf(m, "0x%16p  ", data);
 
-			if (desc->irq_data.domain->of_node)
+			if (desc->irq_data.domain && desc->irq_data.domain->of_node)
 				p = desc->irq_data.domain->of_node->full_name;
 			else
 				p = none;
@@ -695,14 +695,14 @@ static const struct file_operations virq_debug_fops = {
 
 static int __init irq_debugfs_init(void)
 {
-	if (debugfs_create_file("virq_mapping", S_IRUGO, powerpc_debugfs_root,
+	if (debugfs_create_file("irq_domain_mapping", S_IRUGO, NULL,
 				 NULL, &virq_debug_fops) == NULL)
 		return -ENOMEM;
 
 	return 0;
 }
 __initcall(irq_debugfs_init);
-#endif /* CONFIG_VIRQ_DEBUG */
+#endif /* CONFIG_IRQ_DOMAIN_DEBUG */
 
 int irq_domain_simple_map(struct irq_domain *d, unsigned int irq,
 			  irq_hw_number_t hwirq)
-- 
1.7.9.1


