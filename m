Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057Ab2ISS7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 14:59:31 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19771 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034Ab2ISSzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:55:37 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 29/40] PCI, ACPI: Add alloc_acpi_hp_work()
Date: Wed, 19 Sep 2012 11:54:43 -0700
Message-Id: <1348080894-23412-30-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348080894-23412-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com>
 <1348080894-23412-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will use it with acpiphp and pci_root_hp events handling

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/osl.c      |   21 +++++++++++++++++++++
 include/acpi/acpiosxf.h |    9 +++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 9eaf708..0719fa7 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1592,3 +1592,24 @@ void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
 {
 	__acpi_os_prepare_sleep = func;
 }
+
+void alloc_acpi_hp_work(acpi_handle handle, u32 type, void *context,
+			void (*func)(struct work_struct *work))
+{
+	struct acpi_hp_work *hp_work;
+	int ret;
+
+	hp_work = kmalloc(sizeof(*hp_work), GFP_KERNEL);
+	if (!hp_work)
+		return;
+
+	hp_work->handle = handle;
+	hp_work->type = type;
+	hp_work->context = context;
+
+	INIT_WORK(&hp_work->work, func);
+	ret = queue_work(kacpi_hotplug_wq, &hp_work->work);
+	if (!ret)
+		kfree(hp_work);
+}
+EXPORT_SYMBOL(alloc_acpi_hp_work);
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index 0650f5f..6ff92ea 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -196,6 +196,15 @@ void acpi_os_fixed_event_count(u32 fixed_event_number);
  */
 extern struct workqueue_struct *kacpi_hotplug_wq;
 
+struct acpi_hp_work {
+	struct work_struct work;
+	acpi_handle handle;
+	u32 type;
+	void *context;
+};
+void alloc_acpi_hp_work(acpi_handle handle, u32 type, void *context,
+			void (*func)(struct work_struct *work));
+
 acpi_thread_id acpi_os_get_thread_id(void);
 
 acpi_status
-- 
1.7.7

