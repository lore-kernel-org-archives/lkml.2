Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab0H0SHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 14:07:35 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45850 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755191Ab0H0SHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 14:07:32 -0400
Subject: Re: [PATCH 1/4] oprofile: Handle initialisation failure more
 gracefully
From: Will Deacon <will.deacon@arm.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, linux-arch@vger.kernel.org
In-Reply-To: <20100827163839.GR22783@erda.amd.com>
References: <cover.1282848651.git.matt@console-pimps.org>
	 <442a16796990290ca3ebaaa3d0ab317e7b0a30a5.1282848651.git.matt@console-pimps.org>
	 <20100827124344.GJ22783@erda.amd.com>
	 <1282922125.22128.5.camel@e102144-lin.cambridge.arm.com>
	 <20100827163839.GR22783@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 19:06:45 +0100
Message-ID: <1282932405.2899.22.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Aug 2010 18:06:48.0785 (UTC) FILETIME=[9E357410:01CB4612]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

Thanks for taking the time to look at this.

On Fri, 2010-08-27 at 17:38 +0100, Robert Richter wrote:
> On 27.08.10 11:15:25, Will Deacon wrote:

> > How about something like this? This removes the exit call
> > from the init code and sets pointers to NULL after they have been
> > freed. We still have to do some checking so that we don't try to
> > release a NULL perf event:
> >
> > diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
> > index 0691176..12253eb 100644
> > --- a/arch/arm/oprofile/common.c
> > +++ b/arch/arm/oprofile/common.c
> > @@ -275,10 +275,12 @@ out:
> >       return ret;
> >  }
> > 
> > -static void  exit_driverfs(void)
> > +static void __exit exit_driverfs(void)
> >  {
> > -     platform_device_unregister(oprofile_pdev);
> > -     platform_driver_unregister(&oprofile_driver);
> > +     if (!IS_ERR_OR_NULL(oprofile_pdev)) {
> 
> This check is obsolete here as we do not call oprofile_arch_exit() on
> failure.
> 
Sorry, I was being braindead and thought oprofile_arch_exit might be
called via oprofile_exit. As it happens, this is only called because of
module_exit so we know that initialisation will have completed.

In light of this and your comments, I've simplified the code. Once
people are happy with it, I'll post it as a couple of patches:

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index 0691176..c2c4a2e 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -275,7 +275,7 @@ out:
        return ret;
 }
 
-static void  exit_driverfs(void)
+static void __exit exit_driverfs(void)
 {
        platform_device_unregister(oprofile_pdev);
        platform_driver_unregister(&oprofile_driver);
@@ -359,14 +359,13 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
        if (!counter_config) {
                pr_info("oprofile: failed to allocate %d "
                                "counters\n", perf_num_counters);
-               return -ENOMEM;
+               ret = -ENOMEM;
+               goto out;
        }
 
        ret = init_driverfs();
-       if (ret) {
-               kfree(counter_config);
-               return ret;
-       }
+       if (ret)
+               goto out;
 
        for_each_possible_cpu(cpu) {
                perf_events[cpu] = kcalloc(perf_num_counters,
@@ -374,9 +373,8 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
                if (!perf_events[cpu]) {
                        pr_info("oprofile: failed to allocate %d perf events "
                                        "for cpu %d\n", perf_num_counters, cpu);
-                       while (--cpu >= 0)
-                               kfree(perf_events[cpu]);
-                       return -ENOMEM;
+                       ret = -ENOMEM;
+                       goto out;
                }
        }
 
@@ -393,28 +391,33 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
        else
                pr_info("oprofile: using %s\n", ops->cpu_type);
 
+out:
+       if (ret) {
+               kfree(counter_config);
+               for_each_possible_cpu(cpu)
+                       kfree(perf_events[cpu]);
+       }
+
        return ret;
 }
 
-void oprofile_arch_exit(void)
+void __exit oprofile_arch_exit(void)
 {
        int cpu, id;
        struct perf_event *event;
 
-       if (*perf_events) {
-               exit_driverfs();
-               for_each_possible_cpu(cpu) {
-                       for (id = 0; id < perf_num_counters; ++id) {
-                               event = perf_events[cpu][id];
-                               if (event != NULL)
-                                       perf_event_release_kernel(event);
-                       }
-                       kfree(perf_events[cpu]);
+       for_each_possible_cpu(cpu) {
+               for (id = 0; id < perf_num_counters; ++id) {
+                       event = perf_events[cpu][id];
+                       if (event)
+                               perf_event_release_kernel(event);
                }
+
+               kfree(perf_events[cpu]);
        }
 
-       if (counter_config)
-               kfree(counter_config);
+       kfree(counter_config);
+       exit_driverfs();
 }
 #else
 int __init oprofile_arch_init(struct oprofile_operations *ops)
@@ -422,5 +425,5 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
        pr_info("oprofile: hardware counters not available\n");
        return -ENODEV;
 }
-void oprofile_arch_exit(void) {}
+void __exit oprofile_arch_exit(void) {}
 #endif /* CONFIG_HW_PERF_EVENTS */
diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index b336cd9..b4a6857 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -257,16 +257,9 @@ static int __init oprofile_init(void)
                printk(KERN_INFO "oprofile: using timer interrupt.\n");
                err = oprofile_timer_init(&oprofile_ops);
                if (err)
-                       goto out_arch;
+                       return err;
        }
-       err = oprofilefs_register();
-       if (err)
-               goto out_arch;
-       return 0;
-
-out_arch:
-       oprofile_arch_exit();
-       return err;
+       return oprofilefs_register();
 }

 
Once again, thanks for looking at this and have a good weekend,

Will


