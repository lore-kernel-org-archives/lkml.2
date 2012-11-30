Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab2K3Umt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 15:42:49 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40106 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab2K3Ums (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 15:42:48 -0500
Date: Fri, 30 Nov 2012 12:42:37 -0800
From: Tejun Heo <tj@kernel.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: 32/64-bit NUMA consolidation behavior regresion
Message-ID: <20121130204237.GH3873@htj.dyndns.org>
References: <50B6A66E.8030406@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B6A66E.8030406@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dave.

On Wed, Nov 28, 2012 at 04:03:58PM -0800, Dave Hansen wrote:
> My system is just qemu booted with:
> 
> -smp 8 -m 8192 -numa node,nodeid=0,cpus=0-3 -numa node,nodeid=1,cpus=4-7
> 
> Watch the "PERCPU:" line early in boot, and you can see the "Embedded"
> come and go with or without your patch:
> 
> [    0.000000] PERCPU: Embedded 11 pages/cpu @f3000000 s30592 r0 d14464
> vs
> [    0.000000] PERCPU: 11 4K pages/cpu @f83fe000 s30592 r0 d14464
...
> I don't have a fix handy because I'm working on the original problem,
> but I just happened to run across this during a bisect.

Just tested 3.7-rc7 w/ qemu and it works as expected here.

Can you please boot with the following debug patch and report the boot
message before and after?

Thanks.

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 5cdff03..1133dc8 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -71,9 +71,13 @@ static bool __init pcpu_need_numa(void)
 	for_each_possible_cpu(cpu) {
 		int node = early_cpu_to_node(cpu);
 
+		printk("XXX pcpu_need_numa: cpu%d@%d online=%d ND=%p\n",
+		       cpu, node, node_online(node), NODE_DATA(node));
 		if (node_online(node) && NODE_DATA(node) &&
-		    last && last != NODE_DATA(node))
+		    last && last != NODE_DATA(node)) {
+			printk("XXX need numa\n");
 			return true;
+		}
 
 		last = NODE_DATA(node);
 	}
