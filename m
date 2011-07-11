Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab1GKPso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 11:48:44 -0400
Received: from usindmx02.hds.com ([207.126.252.13]:36900 "EHLO
	usindmx02.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291Ab1GKPsn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 11:48:43 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        Matthew Garrett <mjg@redhat.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jarod Wilson <jwilson@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Mon, 11 Jul 2011 11:47:17 -0400
Subject: [RFC][PATCH] Replace a function call chain of
 kmsg_dump(KMSG_DUMP_KEXEC) with static function calls
Thread-Topic: [RFC][PATCH] Replace a function call chain of
 kmsg_dump(KMSG_DUMP_KEXEC) with static function calls
Thread-Index: Acw/4c+rVo7kpfojSruO/VmN4MP5Gg==
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C17AAE59A@USINDEVS01.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[Background]
 - Requirement in enterprise area
 From our support service experience, we always need to detect root causes of OS panic.
 Because customers in enterprise area never forgive us if kdump fails and  we can't detect
 root causes of panic due to lack of materials for investigation.

 That is why I would like to add kmsg_dump() in kdump path.

[Upstream status]
   Discussion about kmsg_dump() in kdump path: 
    - Vivek and Eric are worried about reliability of existing kmsg_dump().
    - Especially, Vivek would like to remove a RCU  function call chain in kdump path
　　　 which kernel modules can register their function calls freely. 

   Development of a feature capturing Oops:
    - Pstore has already incorporated in upstream kernel.
 
    - Matthew Garrett is developing efivars driver, a feature capturing Oops via EFI 
      through pstore interface. 

      https://lkml.org/lkml/2011/6/7/437
      https://lkml.org/lkml/2011/6/7/438
      https://lkml.org/lkml/2011/6/7/439
      https://lkml.org/lkml/2011/6/7/440

    - However, these features may not work in kdump path because
      there are spin_lock/mutex_lock in pstore_dump()/efi_pstore_write().
　　　 These locks may cause dead lock and kdump may fail as well.

[Build Status]
  Built this patch on 3.0-rc6 in x86_64.

[Patch Description]

 For meeting Eric/Vivek's requirements and solving issues of pstore/efivars driver,  I propose a following patch.

    - Remove kmsg_dump(KMSG_DUMP_KEXEC) from crash_kexec()
    - Add kmsg_dump_kexec() to crash_kexec()
        kmsg_dump_kexec() moved behind machine_crash_shutdown() so that
        we can output kernel messages without getting any locks.

    - Introduce CONFIG_KMSG_DUMP_KEXEC
        - CONFIG_KMSG_DUMP_KEXEC depends on CONFIG_PRINTK which is required for kmsg_dumper.

        - CONFIG_KMSG_DUMP_KEXEC=n (default)
          Kernel message logging feature doesn't work in kdump path.

        - CONFIG_KMSG_DUMP_KEXEC=y 
          following static functions are called in kdump path.
          - kmsg_dump_kexec(): This is based on kmsg_dump() and just removed spinlock and a function call chain from it.
          - do_kmsg_dump_kexec(): This is based on pstore_dump() and just removed mutex lock from it.
   
        Some people who are not familiar with kexec may add function calls getting spin_lock/mutex_lock in kexec path.
        These function calls causes failure of kexec.
        So, I suggest replace a call chain with static function calls so that we can keep reliability of kexec.
 
     - Add efi_kmsg_dump_kexec() which outputs kernel messages into NVRAM with EFI.
       This is called by do_kmsg_dump_kexec() statically.
       By applying to Matthew Garret's patch below, its kernel messages in NVRAM are visible through /dev/pstore.

        https://lkml.org/lkml/2011/6/7/437
        https://lkml.org/lkml/2011/6/7/438
        https://lkml.org/lkml/2011/6/7/439
        https://lkml.org/lkml/2011/6/7/440

[Test Status]

This patch is tested with lkdtm (Linux Kernel Dump Test Module) on the following environment for proving its reliability.

lkdtm:
   http://lwn.net/Articles/198690/

Hardware:
   Server: Dell PowerEdge T310
   number of logical cpus: 4
   Memory: 4GB


The results are followings.
As you can see below, kdump never fails due to this patch.

-----------------------------------------------------------
cpoint_name       |cpoint_type|kdump | capture Oops via EFI|
-----------------------------------------------------------
INT_HARDWARE_ENTRY|PANIC      |  O   |         O           |
                  |BUG        |  O   |         O           |
                  |EXCEPTION  |  O   |         O           |
                  |LOOP       |  O   |         O           |
                  |OVERFLOW   |  X   |         X           |
----------------------------------------------------------- 
INT_TASKLET_ENTRY |PANIC      |  O   |         O           |
                  |BUG        |  O   |         O           |
                  |EXCEPTION  |  O   |         O           |
                  |LOOP       |  O   |         O           |
                  |OVERFLOW   |  O   |         O           |
----------------------------------------------------------- 
FS_DEVRW          |PANIC      |  O   |         O           |
                  |BUG        |  O   |         O           |
                  |EXCEPTION  |  O   |         O           |
                  |LOOP       |  O   |         O           |
                  |OVERFLOW   |  O   |         O           |
----------------------------------------------------------- 
MEM_SWAPOUT       |PANIC      |  O   |         O           |
                  |BUG        |  O   |         O           |
                  |EXCEPTION  |  O   |         O           |
                  |LOOP       |  O   |         O           |
                  |OVERFLOW   |  X   |         X           |
----------------------------------------------------------- 
TIMERADD          |PANIC      |  O   |         O           |
                  |BUG        |  O   |         O           |
                  |EXCEPTION  |  O   |         O           |
                  |LOOP       |  O   |         O           |
                  |OVERFLOW   |  O   |         O           |
-----------------------------------------------------------
SCSI_DISPATCH_CMD |PANIC      |  O   |         O           |
                  |BUG        |  O   |         O           |
                  |EXCEPTION  |  O   |         O           |
                  |LOOP       |  O   |         O           |
                  |OVERFLOW   |  O   |         O           |
----------------------------------------------------------- 
IDE_CORE_CP       |PANIC      |  O   |         O           |
                  |BUG        |  O   |         O           |
                  |EXCEPTION  |  O   |         O           |
                  |LOOP       |  O   |         O           |
                  |OVERFLOW   |  O   |         O           |
-----------------------------------------------------------
O:Success
X:Fail (Hard reset happened before calling crash_kexec())

(*)I couldn't test INT_HW_IRQ_EN because loading lkdtm modules fails.

 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 arch/x86/platform/efi/efi.c |   99 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h         |    5 ++
 include/linux/kmsg_dump.h   |    8 ++++
 init/Kconfig                |    6 +++
 kernel/kexec.c              |    3 +-
 kernel/printk.c             |   82 +++++++++++++++++++++++++++++++++++
 6 files changed, 201 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c index 474356b..1dd9800 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -69,6 +69,16 @@ early_param("noefi", setup_noefi);  int add_efi_memmap;  EXPORT_SYMBOL(add_efi_memmap);
 
+#define DUMP_NAME_LEN 52
+#define VARIABLE_NAME_LEN 1024
+efi_char16_t variable_name[VARIABLE_NAME_LEN]; efi_guid_t 
+linux_efi_crash_guid = LINUX_EFI_CRASH_GUID;
+
+#define KMSG_DUMP_ATTRIBUTE \
+	(EFI_VARIABLE_NON_VOLATILE | \
+	 EFI_VARIABLE_BOOTSERVICE_ACCESS | \
+	 EFI_VARIABLE_RUNTIME_ACCESS)
+
 static int __init setup_add_efi_memmap(char *arg)  {
 	add_efi_memmap = 1;
@@ -711,3 +721,92 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 	}
 	return 0;
 }
+
+static inline int
+utf16_strncmp(const efi_char16_t *a, const efi_char16_t *b, size_t len) 
+{
+	while (1) {
+		if (len == 0)
+			return 0;
+		if (*a < *b)
+			return -1;
+		if (*a > *b)
+			return 1;
+		if (*a == 0) /* implies *b == 0 */
+			return 0;
+		a++;
+		b++;
+		len--;
+	}
+}
+
+static unsigned long
+utf16_strnlen(efi_char16_t *s, size_t maxlength) {
+	unsigned long length = 0;
+
+	while (*s++ != 0 && length < maxlength)
+		length++;
+	return length;
+}
+
+
+static unsigned long
+utf16_strlen(efi_char16_t *s)
+{
+	return utf16_strnlen(s, ~0UL);
+}
+
+u64 efi_kmsg_dump_kexec(int type, int part, size_t size, char *buf) {
+	char name[DUMP_NAME_LEN];
+	char stub_name[DUMP_NAME_LEN];
+	efi_char16_t efi_name[DUMP_NAME_LEN];
+	efi_guid_t vendor_guid;
+	efi_status_t status;
+	unsigned long variable_name_size;
+	int i;
+
+	if (!efi_enabled)
+		return 0;
+
+	/* Don't get lock */
+
+	memset(variable_name, 0, sizeof(variable_name));
+
+	snprintf(stub_name, sizeof(stub_name), "dump-type%u-%u-", type, part);
+	snprintf(name, sizeof(name), "%s%lu", stub_name, get_seconds());
+
+	for (i = 0; i < DUMP_NAME_LEN; i++)
+		efi_name[i] = stub_name[i];
+
+	/*
+	 * Clean up any entries with the same name
+	 */
+
+	do {
+		variable_name_size = VARIABLE_NAME_LEN;
+		status = efi.get_next_variable(&variable_name_size,
+					       variable_name, &vendor_guid);
+		if (status == EFI_SUCCESS) {
+			if (efi_guidcmp(vendor_guid, linux_efi_crash_guid))
+				continue;
+
+			if (utf16_strncmp(efi_name, variable_name,
+			    utf16_strlen(efi_name)))
+				continue;
+
+			efi.set_variable(variable_name, &linux_efi_crash_guid,
+					 KMSG_DUMP_ATTRIBUTE, 0, NULL);
+		}
+	} while (status != EFI_NOT_FOUND);
+
+	for (i = 0; i < DUMP_NAME_LEN; i++)
+		efi_name[i] = name[i];
+
+	efi.set_variable(efi_name, &linux_efi_crash_guid, KMSG_DUMP_ATTRIBUTE,
+			 size, buf);
+
+	return part;
+}
+
diff --git a/include/linux/efi.h b/include/linux/efi.h index e376270..b5f8944 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -211,6 +211,9 @@ typedef efi_status_t efi_set_virtual_address_map_t (unsigned long memory_map_siz  #define UV_SYSTEM_TABLE_GUID \
     EFI_GUID(  0x3b13a7d4, 0x633e, 0x11dd, 0x93, 0xec, 0xda, 0x25, 0x56, 0xd8, 0x95, 0x93 )
 
+#define LINUX_EFI_CRASH_GUID \
+    EFI_GUID(  0xcfc8fc79, 0xbe2e, 0x4ddc, 0x97, 0xf0, 0x9f, 0x98, 
+0xbf, 0xe2, 0x98, 0xa0 )
+
 typedef struct {
 	efi_guid_t guid;
 	unsigned long table;
@@ -398,6 +401,8 @@ static inline void memrange_efi_to_native(u64 *addr, u64 *npages)
 	*addr &= PAGE_MASK;
 }
 
+extern u64 efi_kmsg_dump_kexec(int type, int part, size_t size, char 
+*buf);
+
 #if defined(CONFIG_EFI_VARS) || defined(CONFIG_EFI_VARS_MODULE)
 /*
  * EFI Variable support.
diff --git a/include/linux/kmsg_dump.h b/include/linux/kmsg_dump.h index ee0c952..d8f07e5 100644
--- a/include/linux/kmsg_dump.h
+++ b/include/linux/kmsg_dump.h
@@ -63,4 +63,12 @@ static inline int kmsg_dump_unregister(struct kmsg_dumper *dumper)  }  #endif
 
+#ifdef CONFIG_KMSG_DUMP_KEXEC
+void kmsg_dump_kexec(void);
+#else
+static inline void kmsg_dump_kexec(void) { } #endif /* 
+CONFIG_KMSG_DUMP_KEXEC */
+
 #endif /* _LINUX_KMSG_DUMP_H */
diff --git a/init/Kconfig b/init/Kconfig index 412c21b..8c410b3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -991,6 +991,12 @@ config PRINTK
 	  very difficult to diagnose system problems, saying N here is
 	  strongly discouraged.
 
+config KMSG_DUMP_KEXEC
+	bool "Enable support for kmsg_dumper in kexec path"
+	depends on PRINTK
+	help
+	  This option enables kmsg_dumper in kexec path.
+
 config BUG
 	bool "BUG() support" if EXPERT
 	default y
diff --git a/kernel/kexec.c b/kernel/kexec.c index 8d814cb..48cc64e 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1079,11 +1079,10 @@ void crash_kexec(struct pt_regs *regs)
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 
-			kmsg_dump(KMSG_DUMP_KEXEC);
-
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
+			kmsg_dump_kexec();
 			machine_kexec(kexec_crash_image);
 		}
 		mutex_unlock(&kexec_mutex);
diff --git a/kernel/printk.c b/kernel/printk.c index 3518539..34983b6 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -41,6 +41,7 @@
 #include <linux/cpu.h>
 #include <linux/notifier.h>
 #include <linux/rculist.h>
+#include <linux/efi.h>
 
 #include <asm/uaccess.h>
 
@@ -1735,4 +1736,85 @@ void kmsg_dump(enum kmsg_dump_reason reason)
 		dumper->dump(dumper, reason, s1, l1, s2, l2);
 	rcu_read_unlock();
 }
+
+#ifdef CONFIG_KMSG_DUMP_KEXEC
+#define KMSG_DUMP_KEXEC_BUF 128
+char kmsg_dump_kexec_buf[KMSG_DUMP_KEXEC_BUF];
+static unsigned long kmsg_bytes = 10240;
+
+static void do_kmsg_dump_kexec(const char *s1, unsigned long l1, const char *s2,
+			       unsigned long l2)
+{
+	unsigned long	s1_start, s2_start;
+	unsigned long	l1_cpy, l2_cpy;
+	unsigned long	size, total = 0;
+	char		*dst, *why;
+	int		hsize, part = 1;
+	int		oops_count;
+
+	why = "Kexec";
+
+	/* Don't get lock */
+
+	oops_count = 1;
+	while (total < kmsg_bytes) {
+		dst = kmsg_dump_kexec_buf;
+		hsize = sprintf(dst, "%s#%d Part%d\n", why, oops_count,
+				part);
+		size = KMSG_DUMP_KEXEC_BUF - hsize;
+		dst += hsize;
+
+		l2_cpy = min(l2, size);
+		l1_cpy = min(l1, size - l2_cpy);
+
+		if (l1_cpy + l2_cpy == 0)
+			break;
+
+		s2_start = l2 - l2_cpy;
+		s1_start = l1 - l1_cpy;
+
+		memcpy(dst, s1 + s1_start, l1_cpy);
+		memcpy(dst + l1_cpy, s2 + s2_start, l2_cpy);
+
+		efi_kmsg_dump_kexec(0, part, hsize + l1_cpy + l2_cpy,
+				    kmsg_dump_kexec_buf);
+
+		l1 -= l1_cpy;
+		l2 -= l2_cpy;
+		total += l1_cpy + l2_cpy;
+		part++;
+	}
+}
+
+void kmsg_dump_kexec(void)
+{
+	unsigned long end;
+	unsigned chars;
+	const char *s1, *s2;
+	unsigned long l1, l2;
+
+	/* Theoretically, the log could move on after we do this, but
+	   there's not a lot we can do about that. The new messages
+	   will overwrite the start of what we dump. */
+	/* Don't get lock */
+	end = log_end & LOG_BUF_MASK;
+	chars = logged_chars;
+
+	if (chars > end) {
+		s1 = log_buf + log_buf_len - chars + end;
+		l1 = chars - end;
+
+		s2 = log_buf;
+		l2 = end;
+	} else {
+		s1 = "";
+		l1 = 0;
+
+		s2 = log_buf + end - chars;
+		l2 = chars;
+	}
+	do_kmsg_dump_kexec(s1, 11, s2, l2);
+
+}
+#endif /* CONFIG_KMSG_DUMP_KEXEC */
 #endif
--
1.7.1

