Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab1KKGYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 01:24:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:22613 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab1KKGYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 01:24:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,493,1315206000"; 
   d="scan'208";a="83866365"
Subject: Re: [patch 1/5]thp: improve the error code path
From: Shaohua Li <shaohua.li@intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20111110141412.GW5075@redhat.com>
References: <1319511521.22361.135.camel@sli10-conroe>
	 <20111025114406.GC10182@redhat.com>
	 <1319593680.22361.145.camel@sli10-conroe>
	 <1320643049.22361.204.camel@sli10-conroe>
	 <20111110021853.GQ5075@redhat.com>
	 <1320892395.22361.229.camel@sli10-conroe>
	 <alpine.DEB.2.00.1111091828500.32414@chino.kir.corp.google.com>
	 <20111110030646.GT5075@redhat.com>
	 <alpine.DEB.2.00.1111092039110.27280@chino.kir.corp.google.com>
	 <1320904609.22361.239.camel@sli10-conroe>
	 <20111110141412.GW5075@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Nov 2011 14:33:37 +0800
Message-ID: <1320993217.22361.253.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-10 at 22:14 +0800, Andrea Arcangeli wrote:
> On Thu, Nov 10, 2011 at 01:56:49PM +0800, Shaohua Li wrote:
> > +static struct kobject *hugepage_kobj;
> 
> It's minor nitpick but we don't need to put this in .bss, passing it
> as hugepage_init_sysfs(struct kobject **hugepage_kobj) and storing it
> there in case the error returned by hugepage_init_sysfs is zero should
> be fine. The feature cannot be unloaded so we can lose the pointer
> after init is complete.
> 
> Then I think we can be done with this... and it looks better now.
all right. here it is.

Improve the error code path. Delete unnecessary sysfs file for example.
Also remove the #ifdef xxx to make code better.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 mm/huge_memory.c |   71 ++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 50 insertions(+), 21 deletions(-)

Index: linux/mm/huge_memory.c
===================================================================
--- linux.orig/mm/huge_memory.c	2011-11-10 15:51:03.000000000 +0800
+++ linux/mm/huge_memory.c	2011-11-11 13:32:44.000000000 +0800
@@ -487,41 +487,68 @@ static struct attribute_group khugepaged
 	.attrs = khugepaged_attr,
 	.name = "khugepaged",
 };
-#endif /* CONFIG_SYSFS */
 
-static int __init hugepage_init(void)
+static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
 {
 	int err;
-#ifdef CONFIG_SYSFS
-	static struct kobject *hugepage_kobj;
-#endif
 
-	err = -EINVAL;
-	if (!has_transparent_hugepage()) {
-		transparent_hugepage_flags = 0;
-		goto out;
-	}
-
-#ifdef CONFIG_SYSFS
-	err = -ENOMEM;
-	hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
-	if (unlikely(!hugepage_kobj)) {
+	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
+	if (unlikely(!*hugepage_kobj)) {
 		printk(KERN_ERR "hugepage: failed kobject create\n");
-		goto out;
+		return -ENOMEM;
 	}
 
-	err = sysfs_create_group(hugepage_kobj, &hugepage_attr_group);
+	err = sysfs_create_group(*hugepage_kobj, &hugepage_attr_group);
 	if (err) {
 		printk(KERN_ERR "hugepage: failed register hugeage group\n");
-		goto out;
+		goto delete_obj;
 	}
 
-	err = sysfs_create_group(hugepage_kobj, &khugepaged_attr_group);
+	err = sysfs_create_group(*hugepage_kobj, &khugepaged_attr_group);
 	if (err) {
 		printk(KERN_ERR "hugepage: failed register hugeage group\n");
-		goto out;
+		goto remove_hp_group;
 	}
-#endif
+
+	return 0;
+
+remove_hp_group:
+	sysfs_remove_group(*hugepage_kobj, &hugepage_attr_group);
+delete_obj:
+	kobject_put(*hugepage_kobj);
+	return err;
+}
+
+static void __init hugepage_exit_sysfs(struct kobject *hugepage_kobj)
+{
+	sysfs_remove_group(hugepage_kobj, &khugepaged_attr_group);
+	sysfs_remove_group(hugepage_kobj, &hugepage_attr_group);
+	kobject_put(hugepage_kobj);
+}
+#else
+static inline int hugepage_init_sysfs(struct kobject **hugepage_kobj)
+{
+	return 0;
+}
+
+static inline void hugepage_exit_sysfs(struct kobject *hugepage_kobj)
+{
+}
+#endif /* CONFIG_SYSFS */
+
+static int __init hugepage_init(void)
+{
+	int err;
+	struct kobject *hugepage_kobj;
+
+	if (!has_transparent_hugepage()) {
+		transparent_hugepage_flags = 0;
+		return -EINVAL;
+	}
+
+	err = hugepage_init_sysfs(&hugepage_kobj);
+	if (err)
+		return err;
 
 	err = khugepaged_slab_init();
 	if (err)
@@ -545,7 +572,9 @@ static int __init hugepage_init(void)
 
 	set_recommended_min_free_kbytes();
 
+	return 0;
 out:
+	hugepage_exit_sysfs(hugepage_kobj);
 	return err;
 }
 module_init(hugepage_init)


