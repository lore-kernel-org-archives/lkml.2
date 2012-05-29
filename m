Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab2E2RMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 13:12:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58574 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab2E2RMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 13:12:40 -0400
MIME-Version: 1.0
In-Reply-To: <4FC41903.1060705@gmail.com>
References: <tip-r74n3n8hhuc2ynbrnp3vt954@git.kernel.org>
	<CAE9FiQWat=55Ygp-f6ovJx+CD=Knjic9Xvpp+Ngf-o19zNUy7g@mail.gmail.com>
	<1336671883.27020.128.camel@laptop>
	<CAE9FiQWB23V=XoyzQaq1X+JNtUcV=4bLQ1sGCMOTjKRqAV7XuQ@mail.gmail.com>
	<4FC41903.1060705@gmail.com>
Date: Tue, 29 May 2012 10:12:40 -0700
X-Google-Sender-Auth: NO8ngH6MFcbFZMUi9zn1WNnm6a4
Message-ID: <CAE9FiQVpVRiipjmBj0qCSRdE2FP3QBdHk0C1BF-NJxPCcy7Dsg@mail.gmail.com>
Subject: Re: [tip:sched/core] sched/numa: Rewrite the CONFIG_NUMA sched domain support
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@kernel.org,
        torvalds@linux-foundation.org, cmetcalf@tilera.com,
        tony.luck@intel.com, sivanich@sgi.com, akpm@linux-foundation.org,
        ralf@linux-mips.org, greg.pearson@hp.com, ink@jurassic.park.msu.ru,
        tglx@linutronix.de, rth@twiddle.net, kamezawa.hiroyu@jp.fujitsu.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        anton@samba.org, lethal@linux-sh.org, davem@davemloft.net,
        benh@kernel.crashing.org, dhowells@redhat.com, mattst88@gmail.com,
        fenghua.yu@intel.com, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 5:32 PM, Jiang Liu <liuj97@gmail.com> wrote:
> Hi Yinghai,
>        Does this patch fix your issue? https://lkml.org/lkml/2012/5/9/183.
> I have encountered a similar issue on an IA64 platform and the patch above
> works around it. But the root cause is a BIOS bug that the order of CPUs
> in MADT table doesn't conform to the ACPI specification and the first CPU
> in MADT is not the BSP, which breaks some assumption of the booting code
> and causes the core dump.

yes, with another patch from PeterZ.

---
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6396,8 +6396,7 @@ static void sched_init_numa(void)
                       sched_domains_numa_masks[i][j] = mask;

                       for (k = 0; k < nr_node_ids; k++) {
-                               if (node_distance(cpu_to_node(j), k) >
-                                               sched_domains_numa_distance[i])
+                               if (node_distance(j, k) >
sched_domains_numa_distance[i])
                                       continue;

                               cpumask_or(mask, mask, cpumask_of_node(k));
