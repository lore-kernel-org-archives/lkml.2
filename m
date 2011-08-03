Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab1HCVEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 17:04:41 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:45110 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754882Ab1HCVEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 17:04:35 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Matt Fleming <matt.fleming@linux.intel.com>,
        Jan Beulich <JBeulich@novell.com>, Matthew Garrett <mjg@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH] x86, efi: Don't recursively acquire rtc_lock
Date: Wed,  3 Aug 2011 22:04:14 +0100
Message-Id: <1312405454-29386-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@linux.intel.com>

A deadlock was introduced on x86 in commit ef68c8f87ed1 ("x86:
Serialize EFI time accesses on rtc_lock") because efi_get_time() and
friends can be called with rtc_lock already held by
read_persistent_time(), e.g.

timekeeping_init()
    read_persistent_clock()	<-- acquire rtc_lock
        efi_get_time()
            phys_efi_get_time()	<-- acquire rtc_lock <DEADLOCK>

Move the locking up into the caller of efi.get_time() and provide some
wrappers for use in other parts of the kernel instead of calling
efi.get_time(), etc directly. This way we can hide the rtc_lock dance
inside of arch/x86.

Cc: Jan Beulich <JBeulich@novell.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
---
 arch/ia64/kernel/efi.c      |   10 ++++++++
 arch/x86/platform/efi/efi.c |   49 ++++++++++++++++++++++++++----------------
 drivers/char/efirtc.c       |    6 ++--
 drivers/rtc/rtc-efi.c       |    8 +++---
 include/linux/efi.h         |    4 ++-
 5 files changed, 50 insertions(+), 27 deletions(-)

diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index 6fc03af..775e05f 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -229,6 +229,16 @@ STUB_SET_VARIABLE(virt, id)
 STUB_GET_NEXT_HIGH_MONO_COUNT(virt, id)
 STUB_RESET_SYSTEM(virt, id)
 
+efi_status_t efi_get_time(efi_time_t *tm, efi_time_cap_t *cap)
+{
+	return efi.get_time(tm, cap);
+}
+
+efi_status_t efi_set_time(efi_time_t *tm)
+{
+	return efi.set_time(tm);
+}
+
 void
 efi_gettimeofday (struct timespec *ts)
 {
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 3ae4128..735a470 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -89,24 +89,12 @@ early_param("add_efi_memmap", setup_add_efi_memmap);
 
 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 {
-	unsigned long flags;
-	efi_status_t status;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt2(get_time, tm, tc);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return status;
+	return efi_call_virt2(get_time, tm, tc);
 }
 
 static efi_status_t virt_efi_set_time(efi_time_t *tm)
 {
-	unsigned long flags;
-	efi_status_t status;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt1(set_time, tm);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return status;
+	return efi_call_virt1(set_time, tm);
 }
 
 static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
@@ -232,14 +220,11 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
 static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
 					     efi_time_cap_t *tc)
 {
-	unsigned long flags;
 	efi_status_t status;
 
-	spin_lock_irqsave(&rtc_lock, flags);
 	efi_call_phys_prelog();
 	status = efi_call_phys2(efi_phys.get_time, tm, tc);
 	efi_call_phys_epilog();
-	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
 
@@ -250,6 +235,8 @@ int efi_set_rtc_mmss(unsigned long nowtime)
 	efi_time_t 	eft;
 	efi_time_cap_t 	cap;
 
+	assert_spin_locked(&rtc_lock);
+
 	status = efi.get_time(&eft, &cap);
 	if (status != EFI_SUCCESS) {
 		printk(KERN_ERR "Oops: efitime: can't read time!\n");
@@ -272,12 +259,14 @@ int efi_set_rtc_mmss(unsigned long nowtime)
 	return 0;
 }
 
-unsigned long efi_get_time(void)
+unsigned long efi_get_time_locked(void)
 {
 	efi_status_t status;
 	efi_time_t eft;
 	efi_time_cap_t cap;
 
+	assert_spin_locked(&rtc_lock);
+
 	status = efi.get_time(&eft, &cap);
 	if (status != EFI_SUCCESS)
 		printk(KERN_ERR "Oops: efitime: can't read time!\n");
@@ -286,6 +275,28 @@ unsigned long efi_get_time(void)
 		      eft.minute, eft.second);
 }
 
+efi_status_t efi_get_time(efi_time_t *tm, efi_time_cap_t *cap)
+{
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	status = efi.get_time(tm, cap);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return status;
+}
+
+efi_status_t efi_set_time(efi_time_t *tm)
+{
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	status = efi.set_time(tm);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return status;
+}
+
 /*
  * Tell the kernel about the EFI memory map.  This might include
  * more than the max 128 entries that can fit in the e820 legacy
@@ -571,7 +582,7 @@ void __init efi_init(void)
 		do_add_efi_memmap();
 
 #ifdef CONFIG_X86_32
-	x86_platform.get_wallclock = efi_get_time;
+	x86_platform.get_wallclock = efi_get_time_locked;
 	x86_platform.set_wallclock = efi_set_rtc_mmss;
 #endif
 
diff --git a/drivers/char/efirtc.c b/drivers/char/efirtc.c
index 53c524e..cdb1bed 100644
--- a/drivers/char/efirtc.c
+++ b/drivers/char/efirtc.c
@@ -174,7 +174,7 @@ static long efi_rtc_ioctl(struct file *file, unsigned int cmd,
 		case RTC_RD_TIME:
 			spin_lock_irqsave(&efi_rtc_lock, flags);
 
-			status = efi.get_time(&eft, &cap);
+			status = efi_get_time(&eft, &cap);
 
 			spin_unlock_irqrestore(&efi_rtc_lock,flags);
 
@@ -201,7 +201,7 @@ static long efi_rtc_ioctl(struct file *file, unsigned int cmd,
 
 			spin_lock_irqsave(&efi_rtc_lock, flags);
 
-			status = efi.set_time(&eft);
+			status = efi_set_time(&eft);
 
 			spin_unlock_irqrestore(&efi_rtc_lock,flags);
 
@@ -312,7 +312,7 @@ efi_rtc_get_status(char *buf)
 
 	spin_lock_irqsave(&efi_rtc_lock, flags);
 
-	efi.get_time(&eft, &cap);
+	efi_get_time(&eft, &cap);
 	efi.get_wakeup_time(&enabled, &pending, &alm);
 
 	spin_unlock_irqrestore(&efi_rtc_lock,flags);
diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index 5502923..6307f5c 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -153,7 +153,7 @@ static int efi_read_time(struct device *dev, struct rtc_time *tm)
 	efi_time_t eft;
 	efi_time_cap_t cap;
 
-	status = efi.get_time(&eft, &cap);
+	status = efi_get_time(&eft, &cap);
 
 	if (status != EFI_SUCCESS) {
 		/* should never happen */
@@ -166,21 +166,21 @@ static int efi_read_time(struct device *dev, struct rtc_time *tm)
 	return rtc_valid_tm(tm);
 }
 
-static int efi_set_time(struct device *dev, struct rtc_time *tm)
+static int rtc_efi_set_time(struct device *dev, struct rtc_time *tm)
 {
 	efi_status_t status;
 	efi_time_t eft;
 
 	convert_to_efi_time(tm, &eft);
 
-	status = efi.set_time(&eft);
+	status = efi_set_time(&eft);
 
 	return status == EFI_SUCCESS ? 0 : -EINVAL;
 }
 
 static const struct rtc_class_ops efi_rtc_ops = {
 	.read_time = efi_read_time,
-	.set_time = efi_set_time,
+	.set_time = rtc_efi_set_time,
 	.read_alarm = efi_read_alarm,
 	.set_alarm = efi_set_alarm,
 };
diff --git a/include/linux/efi.h b/include/linux/efi.h
index c5709ed..57cd963 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -454,7 +454,9 @@ extern u64 efi_mem_attribute (unsigned long phys_addr, unsigned long size);
 extern int __init efi_uart_console_only (void);
 extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
-extern unsigned long efi_get_time(void);
+extern unsigned long efi_get_time_locked(void);
+extern efi_status_t efi_get_time(efi_time_t *tm, efi_time_cap_t *cap);
+extern efi_status_t efi_set_time(efi_time_t *tm);
 extern int efi_set_rtc_mmss(unsigned long nowtime);
 extern void efi_reserve_boot_services(void);
 extern struct efi_memory_map memmap;
-- 
1.7.4.4

