Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab0HWP4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 11:56:03 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55212 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753909Ab0HWP4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 11:56:00 -0400
Subject: Re: [PATCH 0/3] Generalise ARM perf-events backend for oprofile
From: Will Deacon <will.deacon@arm.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1282560381-7700-1-git-send-email-matt@console-pimps.org>
References: <1282560381-7700-1-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Aug 2010 16:51:17 +0100
Message-ID: <1282578677.17710.14.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Aug 2010 15:51:21.0940 (UTC) FILETIME=[08945140:01CB42DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Mon, 2010-08-23 at 11:46 +0100, Matt Fleming wrote:
> The perf-events backend for OProfile that Will Deacon wrote in
> 8c1fc96f6fd1f361428ba805103af0d0eee65179 ("ARM: 6072/1: oprofile: use
> perf-events framework as backend") is of use to more architectures
> than just ARM. Move the code into drivers/oprofile/ so that SH can use
> it instead of the nearly identical copy of its OProfile code.
> 
> The benefit of the backend is that it becomes necessary to only
> maintain one copy of the PMU accessor functions for each architecture,
> with bug fixes and new features benefiting both OProfile and perf.
> 
The downside is that it's only really applicable if all the subarch
targets which have OProfile support have equivalent perf support. I know
this is the case for SH and ARM, but I'm not sure about other
architectures.

> Note that I haven't been able to test these patches on an ARM board to
> see if I've caused any regressions. If anyone else could do that I'd
> appreciate it.
> 
I tried to test them but they don't compile:

arch/arm/oprofile/common.c: In function 'oprofile_arch_exit':
arch/arm/oprofile/common.c:234: error: 'perf_events' undeclared (first use in this function)
arch/arm/oprofile/common.c:234: error: (Each undeclared identifier is reported only once
arch/arm/oprofile/common.c:234: error: for each function it appears in.)
arch/arm/oprofile/common.c:237: error: 'perf_num_counters' undeclared (first use in this function)
arch/arm/oprofile/common.c:246: error: 'counter_config' undeclared (first use in this function)

This is because the oprofile_arch_exit implementation for ARM frees
data structures that were previously allocated in oprofile_arch_init.
Since this is now done in op_perf_create_files, I'm not sure where the
freeing should be done. OProfile can be compiled as a module, so this
does need to be implemented somewhere (plus, if oprofile_arch_init fails
oprofile_arch_exit is called immediately). Perhaps an op_perf_exit()
function could be called from the arch code?

Looking at the existing ARM implementation, it's not entirely safe in
the case that oprofile_arch_init fails and needs something like:

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index 0691176..15d379f 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -275,10 +275,12 @@ out:
        return ret;
 }
 
-static void  exit_driverfs(void)
+static void __exit exit_driverfs(void)
 {
-       platform_device_unregister(oprofile_pdev);
-       platform_driver_unregister(&oprofile_driver);
+       if (!IS_ERR_OR_NULL(oprofile_pdev)) {
+               platform_device_unregister(oprofile_pdev);
+               platform_driver_unregister(&oprofile_driver);
+       }
 }
 #else
 static int __init init_driverfs(void) { return 0; }
@@ -363,10 +365,8 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
        }
 
        ret = init_driverfs();
-       if (ret) {
-               kfree(counter_config);
+       if (ret)
                return ret;
-       }
 
        for_each_possible_cpu(cpu) {
                perf_events[cpu] = kcalloc(perf_num_counters,
@@ -396,13 +396,14 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
        return ret;
 }
 
-void oprofile_arch_exit(void)
+void __exit oprofile_arch_exit(void)
 {
        int cpu, id;
        struct perf_event *event;
 
+       exit_driverfs();
+
        if (*perf_events) {
-               exit_driverfs();
                for_each_possible_cpu(cpu) {
                        for (id = 0; id < perf_num_counters; ++id) {
                                event = perf_events[cpu][id];
@@ -422,5 +423,5 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
        pr_info("oprofile: hardware counters not available\n");
        return -ENODEV;
 }
-void oprofile_arch_exit(void) {}
+void __exit oprofile_arch_exit(void) {}
 #endif /* CONFIG_HW_PERF_EVENTS */


I can submit this as a separate patch or you can fold it into your changes
to avoid any conflicts.

Cheers,

Will

