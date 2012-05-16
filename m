Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708Ab2EPH51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:57:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43333 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759690Ab2EPH5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:57:25 -0400
X-IronPort-AV: E=Sophos;i="4.75,602,1330876800"; 
   d="scan'208";a="4967703"
Message-ID: <4FB35D98.8080500@cn.fujitsu.com>
Date: Wed, 16 May 2012 15:56:08 +0800
From: zhangyanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com
CC: ebiederm@xmission.com, luto@mit.edu, Joerg Roedel <joerg.roedel@amd.com>,
        dzickus@redhat.com, paul.gortmaker@windriver.com,
        ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH v2 4/5] ksysfs: Export VMCSINFO via sysfs
References: <4FB35C48.30708@cn.fujitsu.com>
In-Reply-To: <4FB35C48.30708@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/16 15:56:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/16 15:56:13,
	Serialize complete at 2012/05/16 15:56:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates two sysfs files to export where VMCSINFO is
allocated and what maximum size of VMCSINFO is, as below:
        $ cat /sys/kernel/vmcsinfo
        1cb88a0
        $ cat /sys/kernel/vmcsinfo_maxsize
        1000
/sys/kernel/vmcsinfo shows the physical address of VMCSINFO,
while /sys/kernel/vmcsinfo_maxsize shows the max size of VMCSINFO.

Signed-off-by: zhangyanfei <zhangyanfei@cn.fujitsu.com>
---
 kernel/ksysfs.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 4e316e1..8a27ece 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -18,6 +18,8 @@
 #include <linux/stat.h>
 #include <linux/sched.h>
 #include <linux/capability.h>
+#include <asm/vmcsinfo.h>
+#include <asm/virtext.h>
 
 #define KERNEL_ATTR_RO(_name) \
 static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
@@ -133,6 +135,29 @@ KERNEL_ATTR_RO(vmcoreinfo);
 
 #endif /* CONFIG_KEXEC */
 
+#ifdef CONFIG_X86
+static ssize_t vmcsinfo_show(struct kobject *kobj,
+			     struct kobj_attribute *attr, char *buf)
+{
+	if (cpu_has_vmx())
+		return sprintf(buf, "%lx\n",
+			       paddr_vmcsinfo_note());
+	return 0;
+}
+KERNEL_ATTR_RO(vmcsinfo);
+
+static ssize_t vmcsinfo_maxsize_show(struct kobject *kobj,
+				     struct kobj_attribute *attr, char *buf)
+{
+	if (cpu_has_vmx())
+		return sprintf(buf, "%x\n",
+			       (unsigned int)vmcsinfo_max_size);
+	return 0;
+}
+KERNEL_ATTR_RO(vmcsinfo_maxsize);
+
+#endif /* CONFIG_X86 */
+
 /* whether file capabilities are enabled */
 static ssize_t fscaps_show(struct kobject *kobj,
 				  struct kobj_attribute *attr, char *buf)
@@ -182,6 +207,10 @@ static struct attribute * kernel_attrs[] = {
 	&kexec_crash_size_attr.attr,
 	&vmcoreinfo_attr.attr,
 #endif
+#ifdef CONFIG_X86
+	&vmcsinfo_attr.attr,
+	&vmcsinfo_maxsize_attr.attr,
+#endif
 	NULL
 };
 
-- 
1.7.1
