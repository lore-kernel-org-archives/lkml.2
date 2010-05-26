Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832Ab0EZARI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 20:17:08 -0400
Received: from sprinkles.athenacr.com ([64.95.46.210]:45100 "EHLO
	sprinkles.inp.in.athenacr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758455Ab0EZARG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 20:17:06 -0400
Message-ID: <4BFC687A.9040304@athenacr.com>
Date: Tue, 25 May 2010 20:16:58 -0400
From: Brian Bloniarz <bmb@athenacr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
References: <4BF58B59.7080901@athenacr.com> <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com> <ce764b91-11b0-44a5-9cf9-96977652bbd5@default> <1274727116.2954.5.camel@localhost.localdomain> <4BFADF9D.9050209@zytor.com 1274733566.2954.73.camel@localhost.localdomain> <3ec7f284-1507-47fb-b5a2-eea29f68c627@default> <4BFAFE17.8060105@zytor.com> <4BFB2902.50308@athenacr.com>
In-Reply-To: <4BFB2902.50308@athenacr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2010 09:33 PM, Brian Bloniarz wrote:
> So what's wrong with just adding a
> /sys/devices/system/clocksource/clocksource0/tsc_khz?

As an RFC:

Add clocksource.sys_register & sys_unregister so the
current clocksource can add supplemental information to
/sys/devices/system/clocksource/clocksource0/

Export tsc_khz when current_clocksource==tsc so that
daemons like NTP can account for the variability of
calibration results.

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 9faf91a..9c99965 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -76,6 +76,11 @@ unsigned long long
 sched_clock(void) __attribute__((alias("native_sched_clock")));
 #endif
 
+int sysfs_tsc_register(struct sys_device *clocksource_dev,
+		       struct clocksource *cs);
+void sysfs_tsc_unregister(struct sys_device *clocksource_dev,
+			  struct clocksource *cs);
+
 int check_tsc_unstable(void)
 {
 	return tsc_unstable;
@@ -757,6 +762,8 @@ static struct clocksource clocksource_tsc = {
 #ifdef CONFIG_X86_64
 	.vread                  = vread_tsc,
 #endif
+	.sys_register           = sysfs_tsc_register,
+	.sys_unregister         = sysfs_tsc_unregister,
 };
 
 void mark_tsc_unstable(char *reason)
@@ -967,3 +974,22 @@ void __init tsc_init(void)
 	init_tsc_clocksource();
 }
 
+static ssize_t show_tsc_khz(
+	struct sys_device *dev, struct sysdev_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%u\n", tsc_khz);
+}
+
+static SYSDEV_ATTR(tsc_khz, 0444, show_tsc_khz, NULL);
+
+int sysfs_tsc_register(struct sys_device *clocksource_dev,
+                         struct clocksource *cs)
+{
+    return sysdev_create_file(clocksource_dev, &attr_tsc_khz);
+}
+
+void sysfs_tsc_unregister(struct sys_device *clocksource_dev,
+                          struct clocksource *cs)
+{
+    sysdev_remove_file(clocksource_dev, &attr_tsc_khz);
+}
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 5ea3c60..d9f6f13 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -15,6 +15,7 @@
 #include <linux/cache.h>
 #include <linux/timer.h>
 #include <linux/init.h>
+#include <linux/sysdev.h>
 #include <asm/div64.h>
 #include <asm/io.h>
 
@@ -156,6 +157,8 @@ extern u64 timecounter_cyc2time(struct timecounter *tc,
  * @vread:		vsyscall based read
  * @suspend:		suspend function for the clocksource, if necessary
  * @resume:		resume function for the clocksource, if necessary
+ * @sys_register:	optional, register additional sysfs attributes
+ * @sys_unregister:	optional, unregister sysfs attributes
  */
 struct clocksource {
 	/*
@@ -194,6 +197,10 @@ struct clocksource {
 	struct list_head wd_list;
 	cycle_t wd_last;
 #endif
+	int (*sys_register)(struct sys_device *clocksource_dev,
+			    struct clocksource *cs);
+	void (*sys_unregister)(struct sys_device *clocksource_dev,
+			       struct clocksource *cs);
 };
 
 /*
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index f08e99c..d8b69a5 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -41,6 +41,8 @@ void timecounter_init(struct timecounter *tc,
 }
 EXPORT_SYMBOL_GPL(timecounter_init);
 
+void sysfs_alter_clocksource(struct clocksource *old, struct clocksource *new);
+
 /**
  * timecounter_read_delta - get nanoseconds since last call of this function
  * @tc:         Pointer to time counter
@@ -572,6 +574,7 @@ static void clocksource_select(void)
 	}
 	if (curr_clocksource != best) {
 		printk(KERN_INFO "Switching to clocksource %s\n", best->name);
+		sysfs_alter_clocksource(curr_clocksource, best);
 		curr_clocksource = best;
 		timekeeping_notify(curr_clocksource);
 	}
@@ -834,6 +837,8 @@ static struct sys_device device_clocksource = {
 	.cls	= &clocksource_sysclass,
 };
 
+static int sysfs_active = 0;
+
 static int __init init_clocksource_sysfs(void)
 {
 	int error = sysdev_class_register(&clocksource_sysclass);
@@ -848,10 +853,34 @@ static int __init init_clocksource_sysfs(void)
 		error = sysdev_create_file(
 				&device_clocksource,
 				&attr_available_clocksource);
+
+	if (!error)
+	{
+		mutex_lock(&clocksource_mutex);
+		if(curr_clocksource->sys_register)
+			error = curr_clocksource->sys_register(
+				&device_clocksource, curr_clocksource);
+		mutex_unlock(&clocksource_mutex);
+	}
+
+	if (!error)
+		sysfs_active = 1;
 	return error;
 }
 
 device_initcall(init_clocksource_sysfs);
+
+void sysfs_alter_clocksource(struct clocksource *old,
+        struct clocksource *new)
+{
+	if(!sysfs_active)
+		return;
+	if(old->sys_unregister)
+		old->sys_unregister(&device_clocksource, old);
+	if(new->sys_register)
+		new->sys_register(&device_clocksource, new);
+}
+
 #endif /* CONFIG_SYSFS */
 
 /**
