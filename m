Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab1FPHAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:00:21 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36345 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754979Ab1FPHAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:15 -0400
X-Sasl-enc: qW4Jh37rxvRpVRFmiJFL+avKm3ZSAoksFsGCCkKVUS8s 1308207614
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:30 2011
Message-Id: <20110616000229.976547436@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kerstin Jonsson <kerstin.jonsson@ericsson.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [10/89] powerpc/4xx: Fix regression in SMP on 476
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: kerstin jonsson <kerstin.jonsson@ericsson.com>

commit c560bbceaf6b06e52f1ef20131b76a3fdc0a2c19 upstream.

commit c56e58537d504706954a06570b4034c04e5b7500 breaks SMP support in PPC_47x chip.
 secondary_ti must be set to current thread info before callin kick_cpu or else
 start_secondary_47x will jump into void when trying to return to c-code.
 In the current setup secondary_ti is initialized before the CPU idle task is started
 and only the boot core will start. I am not sure this is the correct solution, but it
 makes SMP possible in my chip.
 Note! The HOTPLUG support probably need some fixing to, There is no trampoline code
 available in head_44x.S - start_secondary_resume?

Signed-off-by: Kerstin Jonsson <kerstin.jonsson@ericsson.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/smp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -410,8 +410,6 @@ int __cpuinit __cpu_up(unsigned int cpu)
 {
 	int rc, c;
 
-	secondary_ti = current_set[cpu];
-
 	if (smp_ops == NULL ||
 	    (smp_ops->cpu_bootable && !smp_ops->cpu_bootable(cpu)))
 		return -EINVAL;
@@ -421,6 +419,8 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	if (rc)
 		return rc;
 
+	secondary_ti = current_set[cpu];
+
 	/* Make sure callin-map entry is 0 (can be leftover a CPU
 	 * hotplug
 	 */


