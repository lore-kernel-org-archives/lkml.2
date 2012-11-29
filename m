Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945975Ab2K2AE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:04:56 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42512 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945946Ab2K2AEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:04:54 -0500
Message-ID: <50B6A66E.8030406@linux.vnet.ibm.com>
Date: Wed, 28 Nov 2012 16:03:58 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: 32/64-bit NUMA consolidation behavior regresion
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112900-3534-0000-0000-00000FA74A9A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

I was bisecting a boot problem on a 32-bit NUMA kernel and it bisected
down to commit 8db78cc4.  It turns out that, with this patch,
pcpu_need_numa() changed its return value on my system from 1 to 0.
What that basically meant was that we stopped using the remapped lowmem
areas for percpu data.

My system is just qemu booted with:

-smp 8 -m 8192 -numa node,nodeid=0,cpus=0-3 -numa node,nodeid=1,cpus=4-7

Watch the "PERCPU:" line early in boot, and you can see the "Embedded"
come and go with or without your patch:

[    0.000000] PERCPU: Embedded 11 pages/cpu @f3000000 s30592 r0 d14464
vs
[    0.000000] PERCPU: 11 4K pages/cpu @f83fe000 s30592 r0 d14464

I believe this has to do with the hunks in your patch that do:

-#ifdef CONFIG_X86_64
        init_cpu_to_node();
-#endif
...
-#ifdef CONFIG_X86_32
-DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, 0);
-#else
 DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
-#endif
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);

I don't have a fix handy because I'm working on the original problem,
but I just happened to run across this during a bisect.

