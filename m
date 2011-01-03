Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab1ACNuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:50:22 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36659 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab1ACNuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=fYZ03VMoIs7w/xqNi5C7/DUsJu0A1badnxulm1bh9uJp4cRdLVFhMBEwUvF+7DG8V8
         SMhJUi1q70kkU6SkgMnooWIS6cDvBfLVrZ4lVu4olMNipFQ8R5uSXER2lOFOiLo2jBOV
         pMXT9gF4vAY5GxSpCY2taZbqolilFCseBGhRk=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: [PATCH 06/32] acpi: kacpi*_wq don't need WQ_MEM_RECLAIM
Date: Mon,  3 Jan 2011 14:49:29 +0100
Message-Id: <1294062595-30097-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI workqueues aren't used during memory reclaming.  Use
alloc_workqueue() to create workqueues w/o rescuers.

If the purpose of the separation between kacpid_wq and kacpi_notify_wq
was to give notifications better response time, kacpi_notify_wq can be
dropped and kacpi_wq can be created with higher @max_active.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 drivers/acpi/osl.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 055d7b7..c961e18 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1573,9 +1573,9 @@ acpi_status __init acpi_os_initialize(void)
 
 acpi_status __init acpi_os_initialize1(void)
 {
-	kacpid_wq = create_workqueue("kacpid");
-	kacpi_notify_wq = create_workqueue("kacpi_notify");
-	kacpi_hotplug_wq = create_workqueue("kacpi_hotplug");
+	kacpid_wq = alloc_workqueue("kacpid", 0, 1);
+	kacpi_notify_wq = alloc_workqueue("kacpi_notify", 0, 1);
+	kacpi_hotplug_wq = alloc_workqueue("kacpi_hotplug", 0, 1);
 	BUG_ON(!kacpid_wq);
 	BUG_ON(!kacpi_notify_wq);
 	BUG_ON(!kacpi_hotplug_wq);
-- 
1.7.1

