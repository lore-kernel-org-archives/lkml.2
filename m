Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934397Ab1KJDYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:24:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934364Ab1KJDYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:24:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:09 2011
Message-Id: <20111109212709.058337803@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Beulich <jbeulich@suse.com>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [085/262] apic, i386/bigsmp: Fix false warnings regarding logical APIC ID mismatches
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <JBeulich@suse.com>

commit 838312be46f3abfbdc175f81c3e54a857994476d upstream.

These warnings (generally one per CPU) are a result of
initializing x86_cpu_to_logical_apicid while apic_default is
still in use, but the check in setup_local_APIC() being done
when apic_bigsmp was already used as an override in
default_setup_apic_routing():

 Overriding APIC driver with bigsmp
 Enabling APIC mode:  Physflat.  Using 5 I/O APICs
 ------------[ cut here ]------------
 WARNING: at .../arch/x86/kernel/apic/apic.c:1239
 ...
 CPU 1 irqstacks, hard=f1c9a000 soft=f1c9c000
 Booting Node   0, Processors  #1
 smpboot cpu 1: start_ip = 9e000
 Initializing CPU#1
 ------------[ cut here ]------------
 WARNING: at .../arch/x86/kernel/apic/apic.c:1239
 setup_local_APIC+0x137/0x46b() Hardware name: ...
 CPU1 logical APIC ID: 2 != 8
 ...

Fix this (for the time being, i.e. until
x86_32_early_logical_apicid() will get removed again, as Tejun
says ought to be possible) by overriding the previously stored
values at the point where the APIC driver gets overridden.

v2: Move this and the pre-existing override logic into
    arch/x86/kernel/apic/bigsmp_32.c.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/4E835D16020000780005844C@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/apic.h      |    2 +-
 arch/x86/kernel/apic/bigsmp_32.c |   20 ++++++++++++++++----
 arch/x86/kernel/apic/probe_32.c  |   10 ++--------
 3 files changed, 19 insertions(+), 13 deletions(-)

--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -495,7 +495,7 @@ static inline void default_wait_for_init
 	return;
 }
 
-extern struct apic *generic_bigsmp_probe(void);
+extern void generic_bigsmp_probe(void);
 
 
 #ifdef CONFIG_X86_LOCAL_APIC
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -255,12 +255,24 @@ static struct apic apic_bigsmp = {
 	.x86_32_early_logical_apicid	= bigsmp_early_logical_apicid,
 };
 
-struct apic * __init generic_bigsmp_probe(void)
+void __init generic_bigsmp_probe(void)
 {
-	if (probe_bigsmp())
-		return &apic_bigsmp;
+	unsigned int cpu;
 
-	return NULL;
+	if (!probe_bigsmp())
+		return;
+
+	apic = &apic_bigsmp;
+
+	for_each_possible_cpu(cpu) {
+		if (early_per_cpu(x86_cpu_to_logical_apicid,
+				  cpu) == BAD_APICID)
+			continue;
+		early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
+			bigsmp_early_logical_apicid(cpu);
+	}
+
+	pr_info("Overriding APIC driver with %s\n", apic_bigsmp.name);
 }
 
 apic_driver(apic_bigsmp);
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -200,14 +200,8 @@ void __init default_setup_apic_routing(v
 	 * - we find more than 8 CPUs in acpi LAPIC listing with xAPIC support
 	 */
 
-	if (!cmdline_apic && apic == &apic_default) {
-		struct apic *bigsmp = generic_bigsmp_probe();
-		if (bigsmp) {
-			apic = bigsmp;
-			printk(KERN_INFO "Overriding APIC driver with %s\n",
-			       apic->name);
-		}
-	}
+	if (!cmdline_apic && apic == &apic_default)
+		generic_bigsmp_probe();
 #endif
 
 	if (apic->setup_apic_routing)


