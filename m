Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037Ab2DKB6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 21:58:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:38403 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755899Ab2DKB6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 21:58:50 -0400
X-IronPort-AV: E=Sophos;i="4.75,402,1330876800"; 
   d="scan'208";a="4725479"
Message-ID: <4F84E54A.1080903@cn.fujitsu.com>
Date: Wed, 11 Apr 2012 09:58:34 +0800
From: zhangyanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: avi@redhat.com, mtosatti@redhat.com
CC: ebiederm@xmission.com, luto@mit.edu, joerg.roedel@amd.com,
        dzickus@redhat.com, paul.gortmaker@windriver.com, gregkh@suse.de,
        ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH 4/4] kexec: Add crash_save_vmcsinfo to update VMCSINFO
References: <4F84E0DF.8040206@cn.fujitsu.com>
In-Reply-To: <4F84E0DF.8040206@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 09:58:12,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 09:58:14,
	Serialize complete at 2012/04/11 09:58:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

crash_save_vmcsinfo updates the VMCSINFO when kernel crashes.
If no VMCSINFO has been saved before, this function will do nothing.

Signed-off-by: zhangyanfei <zhangyanfei@cn.fujitsu.com>
---
 include/linux/kexec.h |    1 +
 kernel/kexec.c        |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 0d7d6a1..6e8ff13 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -145,6 +145,7 @@ void arch_crash_save_vmcoreinfo(void);
 __printf(1, 2)
 void vmcoreinfo_append_str(const char *fmt, ...);
 unsigned long paddr_vmcoreinfo_note(void);
+void crash_save_vmcsinfo(void);
 
 #define VMCOREINFO_OSRELEASE(value) \
 	vmcoreinfo_append_str("OSRELEASE=%s\n", value)
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 4e2e472..19843ef 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -38,6 +38,7 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/sections.h>
+#include <asm/vmcsinfo.h>
 
 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t __percpu *crash_notes;
@@ -1094,6 +1095,7 @@ void crash_kexec(struct pt_regs *regs)
 
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
+			crash_save_vmcsinfo();
 			machine_crash_shutdown(&fixed_regs);
 			machine_kexec(kexec_crash_image);
 		}
@@ -1458,6 +1460,18 @@ unsigned long __attribute__ ((weak)) paddr_vmcoreinfo_note(void)
 	return __pa((unsigned long)(char *)&vmcoreinfo_note);
 }
 
+#ifdef CONFIG_X86
+void crash_save_vmcsinfo(void)
+{
+	if (!vmcsinfo_size)
+		return;
+	vmcsinfo_append_str("CRASHTIME=%ld", get_seconds());
+	update_vmcsinfo_note();
+}
+#else
+void crash_save_vmcsinfo(void) {}
+#endif /* CONFIG_X86 */
+
 static int __init crash_save_vmcoreinfo_init(void)
 {
 	VMCOREINFO_OSRELEASE(init_uts_ns.name.release);
-- 
1.7.1
