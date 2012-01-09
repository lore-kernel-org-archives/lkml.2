Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab2AIJXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 04:23:33 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:54886 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab2AIJXb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 04:23:31 -0500
Date: Mon, 9 Jan 2012 10:23:20 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] s390 patches for 3.3
Message-ID: <20120109102320.4603fe5e@de.ibm.com>
In-Reply-To: <20120109084728.612edbda@de.ibm.com>
References: <20120107200122.5a78669d@de.ibm.com>
 <CA+55aFy1F6vrLYZ-S+-jq0AiSVOQ15NoFosW3GmMbyKzYyjEqQ@mail.gmail.com>
 <20120109084728.612edbda@de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
x-cbid: 12010909-2966-0000-0000-000002D34C94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jan 2012 08:47:28 +0100
Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Sun, 8 Jan 2012 15:17:38 -0800
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Sat, Jan 7, 2012 at 11:01 AM, Martin Schwidefsky
> > <schwidefsky@de.ibm.com> wrote:
> > >
> > > please pull from 'for-linus' branch of
> > >
> > >        git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus
> > >
> > > to receive the following updates:
> > 
> > Where did the diffstat go? I'm pretty sure you usually send it, and I
> > really want diffstat (in addition to the shortlog) to verify pull
> > requests..
> 
> From the merge window pulls I usually remove the patch itself. Seems like
> I removed the diffstat as well. Once more with feeling:
> 
> please pull from 'for-linus' branch of
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus
> 

Crap, commit 83a24e32908476 "[S390] topology: get rid of ifdefs" now creates a
non-trivial merge conflict with upstream. And commits 4baeb964d96d38df 
"[S390] topology: cleanup z10 topology handling" and d68bddb7329a4d47
"[S390] topology: increase poll frequency if change is anticipated" depend on
83a24e32908476. I sorted it out in my local tree but I know that you don't
like late rebases. This is how I fixed the conflict:

diff -urpN linux/arch/s390/kernel/smp.c linux-s390/arch/s390/kernel/smp.c
--- linux/arch/s390/kernel/smp.c	2012-01-09 10:16:34.000000000 +0100
+++ linux-s390/arch/s390/kernel/smp.c	2012-01-09 10:18:20.000000000 +0100
@@ -926,42 +926,8 @@ out:
 static DEVICE_ATTR(configure, 0644, cpu_configure_show, cpu_configure_store);
 #endif /* CONFIG_HOTPLUG_CPU */
 
-<<<<<<< HEAD
-static ssize_t cpu_polarization_show(struct device *dev,
-				     struct device_attribute *attr, char *buf)
-{
-	int cpu = dev->id;
-	ssize_t count;
-
-	mutex_lock(&smp_cpu_state_mutex);
-	switch (smp_cpu_polarization[cpu]) {
-	case POLARIZATION_HRZ:
-		count = sprintf(buf, "horizontal\n");
-		break;
-	case POLARIZATION_VL:
-		count = sprintf(buf, "vertical:low\n");
-		break;
-	case POLARIZATION_VM:
-		count = sprintf(buf, "vertical:medium\n");
-		break;
-	case POLARIZATION_VH:
-		count = sprintf(buf, "vertical:high\n");
-		break;
-	default:
-		count = sprintf(buf, "unknown\n");
-		break;
-	}
-	mutex_unlock(&smp_cpu_state_mutex);
-	return count;
-}
-static DEVICE_ATTR(polarization, 0444, cpu_polarization_show, NULL);
-
 static ssize_t show_cpu_address(struct device *dev,
 				struct device_attribute *attr, char *buf)
-=======
-static ssize_t show_cpu_address(struct sys_device *dev,
-				struct sysdev_attribute *attr, char *buf)
->>>>>>> FETCH_HEAD
 {
 	return sprintf(buf, "%d\n", __cpu_logical_map[dev->id]);
 }
@@ -971,12 +937,7 @@ static struct attribute *cpu_common_attr
 #ifdef CONFIG_HOTPLUG_CPU
 	&dev_attr_configure.attr,
 #endif
-<<<<<<< HEAD
 	&dev_attr_address.attr,
-	&dev_attr_polarization.attr,
-=======
-	&attr_address.attr,
->>>>>>> FETCH_HEAD
 	NULL,
 };
 
@@ -1162,51 +1123,7 @@ static ssize_t __ref rescan_store(struct
 static DEVICE_ATTR(rescan, 0200, NULL, rescan_store);
 #endif /* CONFIG_HOTPLUG_CPU */
 
-<<<<<<< HEAD
-static ssize_t dispatching_show(struct device *dev,
-				struct device_attribute *attr,
-				char *buf)
-{
-	ssize_t count;
-
-	mutex_lock(&smp_cpu_state_mutex);
-	count = sprintf(buf, "%d\n", cpu_management);
-	mutex_unlock(&smp_cpu_state_mutex);
-	return count;
-}
-
-static ssize_t dispatching_store(struct device *dev,
-				 struct device_attribute *attr,
-				 const char *buf,
-				 size_t count)
-{
-	int val, rc;
-	char delim;
-
-	if (sscanf(buf, "%d %c", &val, &delim) != 1)
-		return -EINVAL;
-	if (val != 0 && val != 1)
-		return -EINVAL;
-	rc = 0;
-	get_online_cpus();
-	mutex_lock(&smp_cpu_state_mutex);
-	if (cpu_management == val)
-		goto out;
-	rc = topology_set_cpu_management(val);
-	if (!rc)
-		cpu_management = val;
-out:
-	mutex_unlock(&smp_cpu_state_mutex);
-	put_online_cpus();
-	return rc ? rc : count;
-}
-static DEVICE_ATTR(dispatching, 0644, dispatching_show,
-			 dispatching_store);
-
-static int __init topology_init(void)
-=======
 static int __init s390_smp_init(void)
->>>>>>> FETCH_HEAD
 {
 	int cpu, rc;
 
@@ -1216,12 +1133,6 @@ static int __init s390_smp_init(void)
 	if (rc)
 		return rc;
 #endif
-<<<<<<< HEAD
-	rc = device_create_file(cpu_subsys.dev_root, &dev_attr_dispatching);
-	if (rc)
-		return rc;
-=======
->>>>>>> FETCH_HEAD
 	for_each_present_cpu(cpu) {
 		rc = smp_add_present_cpu(cpu);
 		if (rc)
diff -urpN linux/arch/s390/kernel/topology.c linux-s390/arch/s390/kernel/topology.c
--- linux/arch/s390/kernel/topology.c	2012-01-09 10:16:34.000000000 +0100
+++ linux-s390/arch/s390/kernel/topology.c	2012-01-09 10:13:29.000000000 +0100
@@ -366,8 +366,8 @@ void __init s390_init_cpu_topology(void)
 
 static int cpu_management;
 
-static ssize_t dispatching_show(struct sysdev_class *class,
-				struct sysdev_class_attribute *attr,
+static ssize_t dispatching_show(struct device *dev,
+				struct device_attribute *attr,
 				char *buf)
 {
 	ssize_t count;
@@ -378,8 +378,8 @@ static ssize_t dispatching_show(struct s
 	return count;
 }
 
-static ssize_t dispatching_store(struct sysdev_class *dev,
-				 struct sysdev_class_attribute *attr,
+static ssize_t dispatching_store(struct device *dev,
+				 struct device_attribute *attr,
 				 const char *buf,
 				 size_t count)
 {
@@ -405,11 +405,11 @@ out:
 	put_online_cpus();
 	return rc ? rc : count;
 }
-static SYSDEV_CLASS_ATTR(dispatching, 0644, dispatching_show,
+static DEVICE_ATTR(dispatching, 0644, dispatching_show,
 			 dispatching_store);
 
-static ssize_t cpu_polarization_show(struct sys_device *dev,
-				     struct sysdev_attribute *attr, char *buf)
+static ssize_t cpu_polarization_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
 {
 	int cpu = dev->id;
 	ssize_t count;
@@ -435,10 +435,10 @@ static ssize_t cpu_polarization_show(str
 	mutex_unlock(&smp_cpu_state_mutex);
 	return count;
 }
-static SYSDEV_ATTR(polarization, 0444, cpu_polarization_show, NULL);
+static DEVICE_ATTR(polarization, 0444, cpu_polarization_show, NULL);
 
 static struct attribute *topology_cpu_attrs[] = {
-	&attr_polarization.attr,
+	&dev_attr_polarization.attr,
 	NULL,
 };
 
@@ -448,7 +448,7 @@ static struct attribute_group topology_c
 
 int topology_cpu_init(struct cpu *cpu)
 {
-	return sysfs_create_group(&cpu->sysdev.kobj, &topology_cpu_attr_group);
+	return sysfs_create_group(&cpu->dev.kobj, &topology_cpu_attr_group);
 }
 
 static int __init topology_init(void)
@@ -460,6 +460,6 @@ static int __init topology_init(void)
 	set_topology_timer();
 out:
 	update_cpu_core_map();
-	return sysdev_class_create_file(&cpu_sysdev_class, &attr_dispatching);
+	return device_create_file(cpu_subsys.dev_root, &dev_attr_dispatching);
 }
 device_initcall(topology_init);


-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

