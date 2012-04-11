Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760029Ab2DKB5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 21:57:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50670 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759940Ab2DKB5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 21:57:53 -0400
X-IronPort-AV: E=Sophos;i="4.75,402,1330876800"; 
   d="scan'208";a="4725464"
Message-ID: <4F84E50E.2090008@cn.fujitsu.com>
Date: Wed, 11 Apr 2012 09:57:34 +0800
From: zhangyanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: avi@redhat.com, mtosatti@redhat.com
CC: ebiederm@xmission.com, luto@mit.edu, joerg.roedel@amd.com,
        dzickus@redhat.com, paul.gortmaker@windriver.com, gregkh@suse.de,
        ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH 3/4] ksysfs: export VMCSINFO via sysfs
References: <4F84E0DF.8040206@cn.fujitsu.com>
In-Reply-To: <4F84E0DF.8040206@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 09:57:12,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 09:57:16,
	Serialize complete at 2012/04/11 09:57:16
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates sysfs file to export where VMCSINFO is allocated,
as below:
        $ cat /sys/kernel/vmcsinfo
        1cb88a0 2000
number on the left-hand side is the physical address of VMCSINFO,
while the one on the right-hand side is the max size of VMCSINFO.

Signed-off-by: zhangyanfei <zhangyanfei@cn.fujitsu.com>
---
 kernel/ksysfs.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 4e316e1..becbb68 100644
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
@@ -133,6 +135,20 @@ KERNEL_ATTR_RO(vmcoreinfo);
 
 #endif /* CONFIG_KEXEC */
 
+#ifdef CONFIG_X86
+static ssize_t vmcsinfo_show(struct kobject *kobj,
+			     struct kobj_attribute *attr, char *buf)
+{
+	if (cpu_has_vmx())
+		return sprintf(buf, "%lx %x\n",
+			       paddr_vmcsinfo_note(),
+			       (unsigned int)vmcsinfo_max_size);
+	return 0;
+}
+KERNEL_ATTR_RO(vmcsinfo);
+
+#endif /* CONFIG_X86 */
+
 /* whether file capabilities are enabled */
 static ssize_t fscaps_show(struct kobject *kobj,
 				  struct kobj_attribute *attr, char *buf)
@@ -182,6 +198,9 @@ static struct attribute * kernel_attrs[] = {
 	&kexec_crash_size_attr.attr,
 	&vmcoreinfo_attr.attr,
 #endif
+#ifdef CONFIG_X86
+	&vmcsinfo_attr.attr,
+#endif
 	NULL
 };
 
-- 
1.7.1
