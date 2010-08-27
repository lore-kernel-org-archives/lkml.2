Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab0H0PQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 11:16:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33376 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753469Ab0H0PQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 11:16:25 -0400
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
In-Reply-To: <20100827124344.GJ22783@erda.amd.com>
References: <cover.1282848651.git.matt@console-pimps.org>
	 <442a16796990290ca3ebaaa3d0ab317e7b0a30a5.1282848651.git.matt@console-pimps.org>
	 <20100827124344.GJ22783@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 16:15:25 +0100
Message-ID: <1282922125.22128.5.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Aug 2010 15:15:28.0886 (UTC) FILETIME=[AEE95960:01CB45FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On Fri, 2010-08-27 at 13:43 +0100, Robert Richter wrote:
> On 26.08.10 15:09:16, Matt Fleming wrote:
> > From: Will Deacon <will.deacon@arm.com>
> >
> > The current implementation is not entirely safe in the case that
> > oprofile_arch_init() fails. We need to make sure that we always call
> > exit_driverfs() if we've called init_driverfs(). Also, avoid a potential
> > double free when freeing 'counter_config', e.g. don't free
> > 'counter_config' in both oprofile_arch_init() and oprofile_arch_exit().
> >
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > ---
> >  arch/arm/oprofile/common.c |   15 ++++++++-------
> >  1 files changed, 8 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
> > index 0691176..482779c 100644
> > --- a/arch/arm/oprofile/common.c
> > +++ b/arch/arm/oprofile/common.c
> > @@ -275,10 +275,12 @@ out:
> >       return ret;
> >  }
> > 
> > -static void  exit_driverfs(void)
> > +static void exit_driverfs(void)
> >  {
> > -     platform_device_unregister(oprofile_pdev);
> > -     platform_driver_unregister(&oprofile_driver);
> > +     if (!IS_ERR_OR_NULL(oprofile_pdev)) {
> > +             platform_device_unregister(oprofile_pdev);
> > +             platform_driver_unregister(&oprofile_driver);
> > +     }
> 
> The root cause that makes this check necessary is that
> oprofile_arch_exit() is called though oprofile_arch_init() failed. We
> should better fix this instead. I have to admit we will then have to
> check all architectural implementations.
> 

I took a look through all of the oprofile_arch_{init,exit} functions
and it looks like only ARM needs fixing. Nobody else does any allocation
here [well, until Matt's unified version comes into play].

> >  }
> >  #else
> >  static int __init init_driverfs(void) { return 0; }
> > @@ -363,10 +365,8 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
> >       }
> > 
> >       ret = init_driverfs();
> > -     if (ret) {
> > -             kfree(counter_config);
> 
> We should not return from oprofile_arch_init() with allocated
> resources if the function fails. To fix duplicate kfrees, we should
> free it here and then set counter_config to NULL. It should also be
> freed if for_each_possible_cpu() or op_name_from_perf_id() fails.
> 
> Also, the pointer should be NULLed after freeing in
> oprofile_arch_exit(). There, we also don't need the NULL pointer check
> as it is save to call kfree(NULL).


How about something like this? This removes the exit call
from the init code and sets pointers to NULL after they have been
freed. We still have to do some checking so that we don't try to
release a NULL perf event:

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index 0691176..12253eb 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -275,10 +275,12 @@ out:
 	return ret;
 }
 
-static void  exit_driverfs(void)
+static void __exit exit_driverfs(void)
 {
-	platform_device_unregister(oprofile_pdev);
-	platform_driver_unregister(&oprofile_driver);
+	if (!IS_ERR_OR_NULL(oprofile_pdev)) {
+		platform_device_unregister(oprofile_pdev);
+		platform_driver_unregister(&oprofile_driver);
+	}
 }
 #else
 static int __init init_driverfs(void) { return 0; }
@@ -365,6 +367,7 @@ int __init oprofile_arch_init(struct
oprofile_operations *ops)
 	ret = init_driverfs();
 	if (ret) {
 		kfree(counter_config);
+		counter_config = NULL;
 		return ret;
 	}
 
@@ -374,8 +377,10 @@ int __init oprofile_arch_init(struct
oprofile_operations *ops)
 		if (!perf_events[cpu]) {
 			pr_info("oprofile: failed to allocate %d perf events "
 					"for cpu %d\n", perf_num_counters, cpu);
-			while (--cpu >= 0)
+			while (--cpu >= 0) {
 				kfree(perf_events[cpu]);
+				perf_events[cpu] = NULL;
+			}
 			return -ENOMEM;
 		}
 	}
@@ -396,25 +401,27 @@ int __init oprofile_arch_init(struct
oprofile_operations *ops)
 	return ret;
 }
 
-void oprofile_arch_exit(void)
+void __exit oprofile_arch_exit(void)
 {
 	int cpu, id;
 	struct perf_event *event;
 
-	if (*perf_events) {
-		exit_driverfs();
-		for_each_possible_cpu(cpu) {
-			for (id = 0; id < perf_num_counters; ++id) {
-				event = perf_events[cpu][id];
-				if (event != NULL)
-					perf_event_release_kernel(event);
-			}
-			kfree(perf_events[cpu]);
+	exit_driverfs();
+
+	for_each_possible_cpu(cpu) {
+		if (!perf_events[cpu])
+			continue;
+
+		for (id = 0; id < perf_num_counters; ++id) {
+			event = perf_events[cpu][id];
+			if (event != NULL)
+				perf_event_release_kernel(event);
 		}
+
+		kfree(perf_events[cpu]);
 	}
 
-	if (counter_config)
-		kfree(counter_config);
+	kfree(counter_config);
 }
 #else
 int __init oprofile_arch_init(struct oprofile_operations *ops)
@@ -422,5 +429,5 @@ int __init oprofile_arch_init(struct
oprofile_operations *ops)
 	pr_info("oprofile: hardware counters not available\n");
 	return -ENODEV;
 }
-void oprofile_arch_exit(void) {}
+void __exit oprofile_arch_exit(void) {}
 #endif /* CONFIG_HW_PERF_EVENTS */
diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index b336cd9..3094af0 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -257,15 +257,11 @@ static int __init oprofile_init(void)
 		printk(KERN_INFO "oprofile: using timer interrupt.\n");
 		err = oprofile_timer_init(&oprofile_ops);
 		if (err)
-			goto out_arch;
+			goto out;
 	}
 	err = oprofilefs_register();
-	if (err)
-		goto out_arch;
-	return 0;
 
-out_arch:
-	oprofile_arch_exit();
+out:
 	return err;
 }
 

Thanks,

Will

