Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161257Ab1FAIHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:07:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:43160 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161220Ab1FAIHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:07:51 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:02:44 2011
Message-Id: <20110601080243.807742280@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:14 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [018/146] powerpc: Set nr_cpu_ids early and use it to free PACAs
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ryan Grimm <grimm@us.ibm.com>

commit c1854e00727f50f7ac99e98d26ece04c087ef785 upstream.

Without this, "holes" in the CPU numbering can cause us to
free too many PACAs

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/paca.c         |    2 +-
 arch/powerpc/kernel/setup-common.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/paca.c
+++ b/arch/powerpc/kernel/paca.c
@@ -203,7 +203,7 @@ void __init free_unused_pacas(void)
 {
 	int new_size;
 
-	new_size = PAGE_ALIGN(sizeof(struct paca_struct) * num_possible_cpus());
+	new_size = PAGE_ALIGN(sizeof(struct paca_struct) * nr_cpu_ids);
 
 	if (new_size >= paca_size)
 		return;
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -509,6 +509,9 @@ void __init smp_setup_cpu_maps(void)
 	 */
 	cpu_init_thread_core_maps(nthreads);
 
+	/* Now that possible cpus are set, set nr_cpu_ids for later use */
+	nr_cpu_ids = find_last_bit(cpumask_bits(cpu_possible_mask),NR_CPUS) + 1;
+
 	free_unused_pacas();
 }
 #endif /* CONFIG_SMP */


