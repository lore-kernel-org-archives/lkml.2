Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551Ab2JXMQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:16:49 -0400
Received: from forward5h.mail.yandex.net ([84.201.186.23]:46417 "EHLO
	forward5h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050Ab2JXMQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:16:47 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Tkhai Kirill <tkhai@yandex.ru>
In-Reply-To: <410461350480175@web15d.yandex.ru>
References: <410461350480175@web15d.yandex.ru>
Subject: [PATCH v2]scripts/tags.sh: Add magic for declarations of popular kernel type
MIME-Version: 1.0
Message-Id: <913071351081004@web28h.yandex.ru>
Date: Wed, 24 Oct 2012 16:16:44 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1)Add magic for declarations of variables of popular kernel type
like spinlock_t, list_head, wait_queue_head_t and other.

2)Add a set of specially handled declaration extentions
like __attribute, __aligned and other.

3)Simplify pci_bus_* magic

Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>

---
scripts/tags.sh |   41 ++++++++++++++++++++++++++++++++++-------
 1 files changed, 34 insertions(+), 7 deletions(-)
diff --git a/scripts/tags.sh b/scripts/tags.sh
index 79fdafb..039915f 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -122,12 +122,17 @@ dogtags()
 exuberant()
 {
 	all_sources | xargs $1 -a                               \
-	-I __initdata,__exitdata,__acquires,__releases          \
-	-I __read_mostly,____cacheline_aligned                  \
+	-I __initdata,__exitdata,__initconst,__devinitdata	\
+	-I __devinitconst,__cpuinitdata,__initdata_memblock	\
+	-I __refdata,__attribute				\
+	-I __acquires,__releases,__deprecated			\
+	-I __read_mostly,__aligned,____cacheline_aligned        \
 	-I ____cacheline_aligned_in_smp                         \
 	-I ____cacheline_internodealigned_in_smp                \
+	-I __used,__packed,__packed2__,__must_check,__must_hold	\
 	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL                      \
 	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
+	-I static,const						\
 	--extra=+f --c-kinds=+px                                \
 	--regex-asm='/^(ENTRY|_GLOBAL)\(([^)]*)\).*/\2/'        \
 	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/' \
@@ -155,8 +160,19 @@ exuberant()
 	--regex-c++='/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
 	--regex-c++='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/' \
 	--regex-c++='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'		\
-	--regex-c='/PCI_OP_READ\(([a-z]*[a-z]).*[1-4]\)/pci_bus_read_config_\1/' \
-	--regex-c='/PCI_OP_WRITE\(([a-z]*[a-z]).*[1-4]\)/pci_bus_write_config_\1/'
+	--regex-c='/PCI_OP_READ\((\w*).*[1-4]\)/pci_bus_read_config_\1/' \
+	--regex-c='/PCI_OP_WRITE\((\w*).*[1-4]\)/pci_bus_write_config_\1/' \
+	--regex-c='/DEFINE_(MUTEX|SEMAPHORE|SPINLOCK)\((\w*)/\2/v/'	\
+	--regex-c='/DEFINE_(RAW_SPINLOCK|RWLOCK|SEQLOCK)\((\w*)/\2/v/'	\
+	--regex-c='/DECLARE_(RWSEM|COMPLETION)\((\w*)/\2/v/'		\
+	--regex-c='/DECLARE_BITMAP\((\w*)/\1/v/'			\
+	--regex-c='/(^|\s)(|L|H)LIST_HEAD\((\w*)/\3/v/'			\
+	--regex-c='/(^|\s)RADIX_TREE\((\w*)/\2/v/'			\
+	--regex-c='/DEFINE_PER_CPU\(([^,]*,\s*)(\w*).*\)/\2/v/'		\
+	--regex-c='/DEFINE_PER_CPU_SHARED_ALIGNED\(([^,]*,\s*)(\w*).*\)/\2/v/' \
+	--regex-c='/DECLARE_WAIT_QUEUE_HEAD\((\w*)/\1/v/'		\
+	--regex-c='/DECLARE_(TASKLET|WORK|DELAYED_WORK)\((\w*)/\2/v/'	\
+	--regex-c='/DEFINE_PCI_DEVICE_TABLE\((\w*)/\1/v/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--langdef=kconfig --language-force=kconfig              \
@@ -199,9 +215,20 @@ emacs()
 	--regex='/__CLEARPAGEFLAG_NOOP\(([^,)]*).*/__ClearPage\1/' \
 	--regex='/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
 	--regex='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/' \
-	--regex='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'		\
-	--regex='/PCI_OP_READ\(([a-z]*[a-z]).*[1-4]\)/pci_bus_read_config_\1/' \
-	--regex='/PCI_OP_WRITE\(([a-z]*[a-z]).*[1-4]\)/pci_bus_write_config_\1/'
+	--regex='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'			\
+	--regex='/PCI_OP_READ\((\w*).*[1-4]\)/pci_bus_read_config_\1/'	\
+	--regex='/PCI_OP_WRITE\((\w*).*[1-4]\)/pci_bus_write_config_\1/'\
+	--regex='/DEFINE_(MUTEX|SEMAPHORE|SPINLOCK)\((\w*)/\2/v/'	\
+	--regex='/DEFINE_(RAW_SPINLOCK|RWLOCK|SEQLOCK)\((\w*)/\2/v/'	\
+	--regex='/DECLARE_(RWSEM|COMPLETION)\((\w*)/\2/v/'		\
+	--regex='/DECLARE_BITMAP\((\w*)/\1/v/'				\
+	--regex='/(^|\s)(|L|H)LIST_HEAD\((\w*)/\3/v/'			\
+	--regex='/(^|\s)RADIX_TREE\((\w*)/\2/v/'			\
+	--regex='/DEFINE_PER_CPU\(([^,]*,\s*)(\w*).*\)/\2/v/'		\
+	--regex='/DEFINE_PER_CPU_SHARED_ALIGNED\(([^,]*,\s*)(\w*).*\)/\2/v/' \
+	--regex='/DECLARE_WAIT_QUEUE_HEAD\((\w*)/\1/v/'			\
+	--regex='/DECLARE_(TASKLET|WORK|DELAYED_WORK)\((\w*)/\2/v/'	\
+	--regex='/DEFINE_PCI_DEVICE_TABLE\((\w*)/\1/v/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'
