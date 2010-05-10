Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab0EJXb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:31:29 -0400
Received: from kroah.org ([198.145.64.141]:33295 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932486Ab0EJWwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:40 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:24 2010
Message-Id: <20100510223324.601081932@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [080/117] powerpc: Move checks in pseries_mach_cpu_die()
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

commit 0212f2602a38e740d5a96aba4cebfc2ebc993ecf upstream.

Rearrange condition checks for better code readability and
	prevention of possible race conditions when
	preferred_offline_state can potentially change during the
	execution of pseries_mach_cpu_die().  The patch will make
	pseries_mach_cpu_die() put cpu in one of the consistent states
	and not hit the run over BUG()

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/pseries/hotplug-cpu.c |   30 +++++++++++++--------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -140,25 +140,25 @@ static void pseries_mach_cpu_die(void)
 		if (!get_lppaca()->shared_proc)
 			get_lppaca()->donate_dedicated_cpu = 0;
 		get_lppaca()->idle = 0;
-	}
 
-	if (get_preferred_offline_state(cpu) == CPU_STATE_ONLINE) {
-		unregister_slb_shadow(hwcpu, __pa(get_slb_shadow()));
+		if (get_preferred_offline_state(cpu) == CPU_STATE_ONLINE) {
+			unregister_slb_shadow(hwcpu, __pa(get_slb_shadow()));
 
-		/*
-		 * Call to start_secondary_resume() will not return.
-		 * Kernel stack will be reset and start_secondary()
-		 * will be called to continue the online operation.
-		 */
-		start_secondary_resume();
+			/*
+			 * Call to start_secondary_resume() will not return.
+			 * Kernel stack will be reset and start_secondary()
+			 * will be called to continue the online operation.
+			 */
+			start_secondary_resume();
+		}
+	}
 
-	} else if (get_preferred_offline_state(cpu) == CPU_STATE_OFFLINE) {
+	/* Requested state is CPU_STATE_OFFLINE at this point */
+	WARN_ON(get_preferred_offline_state(cpu) != CPU_STATE_OFFLINE);
 
-		set_cpu_current_state(cpu, CPU_STATE_OFFLINE);
-		unregister_slb_shadow(hard_smp_processor_id(),
-					__pa(get_slb_shadow()));
-		rtas_stop_self();
-	}
+	set_cpu_current_state(cpu, CPU_STATE_OFFLINE);
+	unregister_slb_shadow(hwcpu, __pa(get_slb_shadow()));
+	rtas_stop_self();
 
 	/* Should never get here... */
 	BUG();


