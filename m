Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649Ab2CAIS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 03:18:58 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:59302 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758508Ab2CAIS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 03:18:56 -0500
Message-ID: <4F4F30D6.3000707@linux.vnet.ibm.com>
Date: Thu, 01 Mar 2012 13:48:30 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: sparclinux@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Nick Piggin <npiggin@kernel.dk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/3] CPU hotplug, arch/sparc: Fix CPU hotplug callback registration
References: <87ehtf3lqh.fsf@rustcorp.com.au> <20120227155338.7b5110cd.akpm@linux-foundation.org> <20120228084359.GJ21106@elte.hu> <20120228132719.f375071a.akpm@linux-foundation.org> <4F4DBB26.2060907@linux.vnet.ibm.com> <20120229091732.GA11505@elte.hu> <4F4E083A.2080304@linux.vnet.ibm.com> <4F4F2F7F.5040207@linux.vnet.ibm.com>
In-Reply-To: <4F4F2F7F.5040207@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12030108-3864-0000-0000-000001A46E12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Restructure CPU hotplug setup and callback registration in topology_init
so as to be race-free.

---

 arch/sparc/kernel/sysfs.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/kernel/sysfs.c b/arch/sparc/kernel/sysfs.c
index 654e8aa..22cb881 100644
--- a/arch/sparc/kernel/sysfs.c
+++ b/arch/sparc/kernel/sysfs.c
@@ -300,16 +300,14 @@ static int __init topology_init(void)
 
 	check_mmu_stats();
 
-	register_cpu_notifier(&sysfs_cpu_nb);
-
 	for_each_possible_cpu(cpu) {
 		struct cpu *c = &per_cpu(cpu_devices, cpu);
 
 		register_cpu(c, cpu);
-		if (cpu_online(cpu))
-			register_cpu_online(cpu);
 	}
 
+	register_allcpu_notifier(&sysfs_cpu_nb, true, NULL);
+
 	return 0;
 }
 


