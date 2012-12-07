Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424397Ab2LGFnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 00:43:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27898 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1424218Ab2LGFm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 00:42:58 -0500
X-IronPort-AV: E=Sophos;i="4.84,235,1355068800"; 
   d="scan'208";a="6350840"
Message-ID: <50C18168.305@cn.fujitsu.com>
Date: Fri, 07 Dec 2012 13:40:56 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Gleb Natapov <gleb@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH] x86/kexec: crash_vmclear_local_vmcss needs __rcu
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/07 13:42:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/07 13:42:14,
	Serialize complete at 2012/12/07 13:42:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the sparse warning:
arch/x86/kernel/crash.c:49:32: sparse: incompatible types in comparison expression (different address spaces)

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/include/asm/kexec.h |    4 +++-
 arch/x86/kernel/crash.c      |    4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
index 28feeba..16882cd 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -163,7 +163,9 @@ struct kimage_arch {
 };
 #endif
 
-extern void (*crash_vmclear_loaded_vmcss)(void);
+extern void __rcu (*crash_vmclear_loaded_vmcss)(void);
+#define vmclear_func_rcu(vmclear_func) \
+	((void (*)(void)) rcu_dereference(vmclear_func))
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 2f6b8e8..50ce1d6 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -38,7 +38,7 @@ int in_crash_kexec;
  *
  * protected by rcu.
  */
-void (*crash_vmclear_loaded_vmcss)(void) = NULL;
+void __rcu (*crash_vmclear_loaded_vmcss)(void) = NULL;
 EXPORT_SYMBOL_GPL(crash_vmclear_loaded_vmcss);
 
 static inline void cpu_crash_vmclear_loaded_vmcss(void)
@@ -46,7 +46,7 @@ static inline void cpu_crash_vmclear_loaded_vmcss(void)
 	void (*do_vmclear_operation)(void) = NULL;
 
 	rcu_read_lock();
-	do_vmclear_operation = rcu_dereference(crash_vmclear_loaded_vmcss);
+	do_vmclear_operation = vmclear_func_rcu(crash_vmclear_loaded_vmcss);
 	if (do_vmclear_operation)
 		do_vmclear_operation();
 	rcu_read_unlock();
-- 
1.7.1
